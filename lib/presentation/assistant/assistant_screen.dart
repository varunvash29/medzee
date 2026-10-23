import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/medication.dart';
import '../../domain/models/schedule_proposal.dart';
import '../../domain/services/schedule_proposal_service.dart';
import '../../services/ai/schedule_assistant.dart';
import '../../services/schedule_change_service.dart';
import '../../state/medications_provider.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';

enum _Phase { pending, applying, applied, cancelled, failed, undone }

sealed class _Msg {}

class _Text extends _Msg {
  _Text(this.text, {required this.fromUser});
  final String text;
  final bool fromUser;
}

class _Proposal extends _Msg {
  _Proposal(this.proposal, this.check);
  ScheduleProposal proposal;
  ProposalCheck check;
  _Phase phase = _Phase.pending;
  String? note;
  AppliedChange? applied;
}

/// A chat where plain-language requests become *suggested* schedule changes
/// that only take effect after the person confirms them.
class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_Msg> _messages = <_Msg>[
    _Text(
      'Hi! Tell me what to change, like “remind me at 8 AM every day” or '
      '“pause my vitamin until Monday”. I\'ll show you the change first. '
      'Nothing happens until you confirm.',
      fromUser: false,
    ),
  ];
  bool _thinking = false;

  static const List<String> _suggestions = <String>[
    'Add a daily reminder',
    'Change a reminder time',
    'Pause a medicine',
    'Update my stock',
  ];

  static const Map<String, String> _starters = <String, String>{
    'Add a daily reminder': 'Remind me at 8 AM every day for ',
    'Change a reminder time': 'Move my evening reminder for ',
    'Pause a medicine': 'Pause reminders for ',
    'Update my stock': 'I have 20 left of ',
  };

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _toEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<List<MedicationContext>> _contexts() async {
    final repo = ref.read(medicationRepositoryProvider);
    final List<Medication> all = await repo.getAll();
    return <MedicationContext>[
      for (final Medication m in all)
        MedicationContext(m, await repo.getPhases(m.id)),
    ];
  }

  Future<void> _send() async {
    final String text = _input.text.trim();
    if (text.isEmpty || _thinking) return;
    final List<ChatTurn> history = <ChatTurn>[
      for (final _Msg m in _messages)
        if (m is _Text) ChatTurn(fromUser: m.fromUser, text: m.text),
    ];
    setState(() {
      _messages.add(_Text(text, fromUser: true));
      _thinking = true;
      _input.clear();
    });
    _toEnd();

    try {
      final List<MedicationContext> meds = await _contexts();
      final ScheduleProposal proposal =
          await ref.read(scheduleAssistantProvider).interpret(
                text,
                medications: meds,
                history: history,
                now: DateTime.now(),
              );
      final ProposalCheck check = ScheduleProposalService.check(
        proposal,
        meds,
        today: DateTime.now(),
      );
      if (!mounted) return;
      setState(() {
        if (check.clarification != null) {
          _messages.add(_Text(check.clarification!, fromUser: false));
        } else if (check.errors.isNotEmpty && check.lines.isEmpty) {
          _messages.add(_Text(check.errors.first, fromUser: false));
        } else {
          _messages.add(_Proposal(proposal, check));
        }
      });
    } on AssistantException catch (e) {
      if (mounted) setState(() => _messages.add(_Text(e.message, fromUser: false)));
    } finally {
      if (mounted) setState(() => _thinking = false);
      _toEnd();
    }
  }

  Future<void> _confirm(_Proposal m) async {
    // Re-validate against today's data: things may have changed since the
    // suggestion was made.
    final List<MedicationContext> meds = await _contexts();
    final ProposalCheck fresh = ScheduleProposalService.check(
      m.proposal,
      meds,
      today: DateTime.now(),
    );
    if (!fresh.canApply) {
      setState(() {
        m.check = fresh;
        m.phase = _Phase.failed;
        m.note = fresh.errors.isNotEmpty
            ? fresh.errors.first
            : (fresh.clarification ?? 'This change is no longer possible.');
      });
      return;
    }
    setState(() => m.phase = _Phase.applying);
    try {
      final AppliedChange done =
          await ref.read(scheduleChangeServiceProvider).apply(m.proposal);
      ref.invalidate(medicationsProvider);
      if (!mounted) return;
      setState(() {
        m.applied = done;
        m.phase = _Phase.applied;
      });
    } on ScheduleChangeException catch (e) {
      if (!mounted) return;
      setState(() {
        m.phase = _Phase.failed;
        m.note = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        m.phase = _Phase.failed;
        m.note = 'Something went wrong, so nothing was changed.';
      });
    }
    _toEnd();
  }

  Future<void> _undo(_Proposal m) async {
    try {
      await ref.read(scheduleChangeServiceProvider).undo(m.applied!.id);
      ref.invalidate(medicationsProvider);
      if (mounted) setState(() => m.phase = _Phase.undone);
    } on ScheduleChangeException catch (e) {
      if (mounted) setState(() => m.note = e.message);
    }
  }

  Future<void> _edit(_Proposal m) async {
    final ScheduleProposal p = m.proposal;
    ScheduleProposal? changed;

    switch (p.intent) {
      case ScheduleIntent.setReminderTimes:
        final List<int>? times = await showDialog<List<int>>(
          context: context,
          builder: (_) => _TimesDialog(initial: p.times),
        );
        if (times != null && times.isNotEmpty) changed = p.copyWith(times: times);
      case ScheduleIntent.moveReminderTime:
        final TimeOfDay? t = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: (p.moveTo ?? 480) ~/ 60,
            minute: (p.moveTo ?? 480) % 60,
          ),
          helpText: 'Move the reminder to',
        );
        if (t != null) changed = p.copyWith(moveTo: t.hour * 60 + t.minute);
      case ScheduleIntent.updateStock:
        final ({double qty, StockMode mode})? r =
            await showDialog<({double qty, StockMode mode})>(
          context: context,
          builder: (_) => _StockDialog(
            qty: p.stockQuantity ?? 0,
            mode: p.stockMode ?? StockMode.correction,
          ),
        );
        if (r != null) {
          changed = p.copyWith(stockQuantity: r.qty, stockMode: r.mode);
        }
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Type a new message to change this suggestion.'),
          ),
        );
        return;
    }
    if (changed == null) return;
    final List<MedicationContext> meds = await _contexts();
    final ProposalCheck check = ScheduleProposalService.check(
      changed,
      meds,
      today: DateTime.now(),
    );
    if (!mounted) return;
    setState(() {
      m.proposal = changed!;
      m.check = check;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool available = ref.watch(scheduleAssistantProvider).isAvailable;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Close',
          onPressed: () => context.pop(),
        ),
        title: const Text('Schedule assistant'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.all(AppSpacing.gutter),
                itemCount: _messages.length + (_thinking ? 1 : 0),
                itemBuilder: (BuildContext context, int i) {
                  if (i >= _messages.length) return const _Typing();
                  final _Msg m = _messages[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: switch (m) {
                      _Text t => _Bubble(text: t.text, fromUser: t.fromUser),
                      _Proposal p => _ProposalCard(
                          msg: p,
                          onConfirm: () => _confirm(p),
                          onCancel: () => setState(() {
                            p.phase = _Phase.cancelled;
                          }),
                          onEdit: () => _edit(p),
                          onUndo: () => _undo(p),
                        ),
                    },
                  );
                },
              ),
            ),
            if (!available)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
                child: InfoBanner(
                  message: 'The assistant needs Firebase, which is not '
                      'available on this device.',
                  tone: AppInfoTone.warning,
                  icon: Icons.cloud_off_outlined,
                ),
              ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (BuildContext context, int i) => ActionChip(
                  label: Text(_suggestions[i]),
                  onPressed: () {
                    _input.text = _starters[_suggestions[i]]!;
                    _input.selection =
                        TextSelection.collapsed(offset: _input.text.length);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _input,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Describe the change…',
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    tooltip: 'Send',
                    onPressed: (_thinking || !available) ? null : _send,
                    icon: const Icon(Icons.arrow_upward_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(48, 48),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------- widgets

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.fromUser});
  final String text;
  final bool fromUser;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: fromUser
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(fromUser ? 18 : 4),
              bottomRight: Radius.circular(fromUser ? 4 : 18),
            ),
          ),
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: fromUser
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    ).animate();
  }
}

extension on Widget {
  Widget animate() => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        builder: (BuildContext context, double v, Widget? child) => Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * 8),
            child: child,
          ),
        ),
        child: this,
      );
}

class _Typing extends StatelessWidget {
  const _Typing();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({
    required this.msg,
    required this.onConfirm,
    required this.onCancel,
    required this.onEdit,
    required this.onUndo,
  });

  final _Proposal msg;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onEdit;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final bool pending = msg.phase == _Phase.pending;
    final bool done = msg.phase == _Phase.applied;
    final bool dim = msg.phase == _Phase.cancelled || msg.phase == _Phase.undone;

    final String label = switch (msg.phase) {
      _Phase.pending || _Phase.applying => 'Suggested change · not saved yet',
      _Phase.applied => 'Saved',
      _Phase.cancelled => 'Cancelled · nothing changed',
      _Phase.failed => 'Not applied · nothing changed',
      _Phase.undone => 'Undone',
    };

    return Opacity(
      opacity: dim ? 0.6 : 1,
      child: AppCard(
        borderColor: pending
            ? status.warning.withValues(alpha: 0.5)
            : (done ? theme.colorScheme.primary.withValues(alpha: 0.5) : null),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  done
                      ? Icons.check_circle_rounded
                      : Icons.edit_note_rounded,
                  size: 18,
                  color: done ? theme.colorScheme.primary : status.warning,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: done ? theme.colorScheme.primary : status.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (msg.check.medicationName != null)
              Text(msg.check.medicationName!, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            for (final String line in msg.check.lines)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('• $line', style: theme.textTheme.bodyMedium),
              ),
            for (final String e in msg.check.errors)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  e,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            if (msg.note != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(msg.note!, style: theme.textTheme.bodySmall),
              ),
            if (pending) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  TextButton(onPressed: onCancel, child: const Text('Cancel')),
                  TextButton(onPressed: onEdit, child: const Text('Edit')),
                  const Spacer(),
                  FilledButton(
                    onPressed: msg.check.canApply ? onConfirm : null,
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
            if (msg.phase == _Phase.applying)
              const Padding(
                padding: EdgeInsets.only(top: AppSpacing.md),
                child: LinearProgressIndicator(),
              ),
            if (done) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text(msg.applied!.summary, style: theme.textTheme.bodySmall),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onUndo,
                  icon: const Icon(Icons.undo_rounded, size: 18),
                  label: const Text('Undo'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimesDialog extends StatefulWidget {
  const _TimesDialog({required this.initial});
  final List<int> initial;

  @override
  State<_TimesDialog> createState() => _TimesDialogState();
}

class _TimesDialogState extends State<_TimesDialog> {
  late List<int> _times = List<int>.of(widget.initial);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reminder times'),
      content: Wrap(
        spacing: AppSpacing.sm,
        children: <Widget>[
          for (final int m in _times)
            InputChip(
              label: Text(
                TimeOfDay(hour: m ~/ 60, minute: m % 60).format(context),
              ),
              onDeleted: () => setState(() => _times.remove(m)),
            ),
          ActionChip(
            avatar: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add'),
            onPressed: () async {
              final TimeOfDay? t = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 8, minute: 0),
              );
              if (t == null) return;
              setState(() {
                final int m = t.hour * 60 + t.minute;
                if (!_times.contains(m)) _times = (_times..add(m))..sort();
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _times.isEmpty ? null : () => Navigator.pop(context, _times),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class _StockDialog extends StatefulWidget {
  const _StockDialog({required this.qty, required this.mode});
  final double qty;
  final StockMode mode;

  @override
  State<_StockDialog> createState() => _StockDialogState();
}

class _StockDialogState extends State<_StockDialog> {
  late final TextEditingController _q = TextEditingController(
    text: widget.qty == widget.qty.roundToDouble()
        ? widget.qty.toInt().toString()
        : widget.qty.toString(),
  );
  late StockMode _mode = widget.mode;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update stock'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SegmentedButton<StockMode>(
            segments: const <ButtonSegment<StockMode>>[
              ButtonSegment<StockMode>(
                value: StockMode.correction,
                label: Text('I counted'),
              ),
              ButtonSegment<StockMode>(
                value: StockMode.refill,
                label: Text('Refill'),
              ),
            ],
            selected: <StockMode>{_mode},
            onSelectionChanged: (Set<StockMode> s) =>
                setState(() => _mode = s.first),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _q,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: _mode == StockMode.correction
                  ? 'How many are left'
                  : 'How many did you add',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final double? v = double.tryParse(_q.text.trim());
            if (v == null || v < 0) return;
            Navigator.pop(context, (qty: v, mode: _mode));
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
