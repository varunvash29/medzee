import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/dose.dart';
import '../../domain/models/medication.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/services/dose_grouping.dart';
import '../../domain/models/inventory.dart';
import '../../routing/app_router.dart';
import '../../state/dose_actions.dart';
import '../../state/doses_provider.dart';
import '../../state/inventory_providers.dart';
import '../../state/medications_provider.dart';
import '../../state/profile_providers.dart';
import '../../state/timezone_providers.dart';
import '../profile/people_card.dart';
import '../shared/app_widgets.dart';
import '../shared/medzee_logo.dart';
import '../shared/motion_widgets.dart';
import '../shared/travel_widgets.dart';

/// Home: what to take next, how today is going, and the main shortcuts.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<TodayEntry>> timeline =
        ref.watch(todayTimelineProvider);
    final UserProfile profile = ref.watch(activeProfileProvider);
    final bool noMedicines =
        ref.watch(medicationsProvider).value?.isEmpty ?? false;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(todayTimelineProvider),
          child: ListView(
            key: const PageStorageKey<String>('home-scroll'),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.md,
              AppSpacing.gutter,
              AppSpacing.xxl,
            ),
            children: <Widget>[
              _Header(profile: profile),
              const SizedBox(height: AppSpacing.xl),
              ...timeline.when( skipLoadingOnReload: true,
                loading: () => const <Widget>[_Skeleton()],
                error: (Object e, StackTrace _) => <Widget>[
                  InfoBanner(
                    message: "Could not load today's doses: $e",
                    tone: AppInfoTone.critical,
                    icon: Icons.error_outline_rounded,
                  ),
                ],
                data: (List<TodayEntry> entries) => noMedicines
                    ? const <Widget>[_FirstUse()]
                    : _content(context, ref, entries),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _content(
    BuildContext context,
    WidgetRef ref,
    List<TodayEntry> entries,
  ) {
    final TodayEntry? next = entries
        .where((TodayEntry e) => e.dose.status == DoseStatus.pending)
        .cast<TodayEntry?>()
        .firstWhere((_) => true, orElse: () => null);

    // Cancelled doses (a paused or stopped medicine) are not part of the day.
    final int missed = entries
        .where((TodayEntry e) => e.dose.status == DoseStatus.missed)
        .length;
    final bool hasLiveDoses = entries
        .any((TodayEntry e) => e.dose.status != DoseStatus.cancelled);

    return <Widget>[
      const TravelBanner(),
      if (hasLiveDoses) ...<Widget>[
        _NextDoseCard(next: next, missed: missed),
        const SizedBox(height: AppSpacing.lg),
      ],
      const _RefillBanner(),
      if (entries.isEmpty)
        const _QuietDay()
      else ...<Widget>[
        // What to take, by time, comes first; stats and shortcuts follow.
        _ScheduleSections(entries: entries),
        const SizedBox(height: AppSpacing.lg),
        _ProgressCard(entries: entries),
      ],
      const SizedBox(height: AppSpacing.lg),
      const _QuickActions(),
    ];
  }
}

// ------------------------------------------------------------------ header

class _Header extends ConsumerWidget {
  const _Header({required this.profile});

  final UserProfile profile;

  String get _greeting {
    final int h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final String? name = profile.displayName?.trim();
    const List<String> months = <String>[
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December',
    ];
    const List<String> days = <String>[
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
      'Sunday',
    ];
    // The date the person's doses are filed under, which in travel mode is the
    // reminder zone's, not the phone's.
    final DateTime now = ref.watch(reminderClockProvider).now();

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_greeting, style: theme.textTheme.bodyMedium),
              Text(
                (name == null || name.isEmpty) ? 'Welcome' : name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const PersonChip(),
        MedzeeMark.tile(size: 44),
      ],
    );
  }
}

// --------------------------------------------------------------- next dose

class _NextDoseCard extends ConsumerWidget {
  const _NextDoseCard({required this.next, this.missed = 0});

  final TodayEntry? next;

  /// Doses today whose time and grace period have passed without a log.
  final int missed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final TodayEntry? e = next;

    // Nothing left to take, but some doses were missed: that is not "all done".
    if (e == null && missed > 0) {
      return AppCard(
        color: status.warningContainer,
        borderColor: Colors.transparent,
        child: Row(
          children: <Widget>[
            Icon(Icons.error_outline_rounded, color: status.warning, size: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    missed == 1
                        ? '1 dose missed today'
                        : '$missed doses missed today',
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    'Nothing else is due. If you did take it, tap it below '
                    'to log it.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (e == null) {
      return AppCard(
        color: status.takenContainer,
        borderColor: Colors.transparent,
        child: Row(
          children: <Widget>[
            Icon(Icons.check_circle_rounded, color: status.taken, size: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('All done for today',
                      style: theme.textTheme.titleMedium),
                  Text(
                    'Every dose is logged. See you tomorrow.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final Medication m = e.medication;
    return AppCard(
      color: theme.colorScheme.primaryContainer,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () => context.push('/medicines/${m.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'NEXT DOSE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              DoseFormIcon(
                form: m.form,
                size: 48,
                background: theme.colorScheme.surface,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      m.name,
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${_doseLabel(e.dose, m)} · ${_time(context, e.dose)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    DeviceTimeNote(scheduledAt: e.dose.scheduledAt),
                    if (m.prescribedAs != null) ...<Widget>[
                      const SizedBox(height: 4),
                      PrescribedAsTag(m.prescribedAs!),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _take(context, ref, e.dose),
                  icon: const Icon(Icons.check_rounded, size: 20),
                  label: const Text('Take now'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(
                onPressed: () => ref.read(doseActionsProvider).skip(e.dose),
                child: const Text('Skip'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _take(
  BuildContext context,
  WidgetRef ref,
  ScheduledDose dose,
) async {
  HapticFeedback.mediumImpact();
  final DoseActions actions = ref.read(doseActionsProvider);
  await actions.taken(dose);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(actions.lastMessage ?? 'Dose recorded'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => actions.undo(dose),
        ),
      ),
    );
}

String _time(BuildContext context, ScheduledDose d) => TimeOfDay(
      hour: d.scheduledMinutes ~/ 60,
      minute: d.scheduledMinutes % 60,
    ).format(context);

String _doseLabel(ScheduledDose d, Medication m) {
  final String q = d.doseQuantity == d.doseQuantity.roundToDouble()
      ? d.doseQuantity.toInt().toString()
      : d.doseQuantity.toString();
  final String strength = m.strengthLabel == null ? '' : ' · ${m.strengthLabel}';
  return '$q ${d.unit.singular}${d.doseQuantity == 1 ? '' : 's'}$strength';
}

// ---------------------------------------------------------------- progress

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.entries});

  final List<TodayEntry> entries;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    int taken = 0, missed = 0, upcoming = 0;
    for (final TodayEntry e in entries) {
      switch (e.dose.status) {
        case DoseStatus.taken:
          taken++;
        case DoseStatus.missed:
          missed++;
        case DoseStatus.pending:
          upcoming++;
        default:
          break;
      }
    }
    // Cancelled doses (paused or stopped medicines) are not part of the day.
    final int total = entries
        .where((TodayEntry e) => e.dose.status != DoseStatus.cancelled)
        .length;

    Widget legend(String label, int n, Color color) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
              Text('$n', style: theme.textTheme.titleSmall),
            ],
          ),
        );

    return AppCard(
      child: Row(
        children: <Widget>[
          ProgressRing(
            value: total == 0 ? 0 : taken / total,
            size: 96,
            stroke: 10,
            color: status.taken,
            trackColor: theme.colorScheme.primaryContainer,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('$taken/$total', style: theme.textTheme.titleLarge),
                Text('doses', style: theme.textTheme.labelSmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              children: <Widget>[
                legend('Taken', taken, status.taken),
                legend('Upcoming', upcoming, theme.colorScheme.primary),
                legend('Missed', missed, status.missed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------- refill banner

class _RefillBanner extends ConsumerWidget {
  const _RefillBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Medication> low = ref.watch(lowStockMedicationsProvider);
    if (low.isEmpty) return const SizedBox.shrink();
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: AppCard(
        color: status.warningContainer,
        borderColor: Colors.transparent,
        onTap: () => low.length == 1
            ? context.push('/medicines/${low.first.id}')
            : _showLowStock(context, low),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.inventory_2_outlined, color: status.warning),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                low.length == 1
                    ? '${low.first.name} is running low'
                    : '${low.length} medicines are running low',
                style: theme.textTheme.titleSmall,
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------- quick actions

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 2.3,
      children: <Widget>[
        _Action(
          icon: Icons.document_scanner_outlined,
          label: 'Scan prescription',
          onTap: () => context.push(AppRoutes.scanPrescription),
        ),
        _Action(
          icon: Icons.auto_awesome_outlined,
          label: 'Ask AI',
          onTap: () => context.go(AppRoutes.assistant),
        ),
        _Action(
          icon: Icons.add_circle_outline_rounded,
          label: 'Add medicine',
          onTap: () => context.push(AppRoutes.addMedicine),
        ),
        _Action(
          icon: Icons.insights_outlined,
          label: 'Insights',
          onTap: () => context.push(AppRoutes.insights),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.labelLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- dose row

class _DoseRow extends ConsumerWidget {
  const _DoseRow({required this.entry});

  final TodayEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final ScheduledDose d = entry.dose;
    final Medication m = entry.medication;
    final bool done =
        d.status == DoseStatus.taken || d.status == DoseStatus.skipped;

    Widget trailing;
    switch (d.status) {
      case DoseStatus.taken:
        trailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.check_circle_rounded, size: 18, color: status.taken),
            const SizedBox(width: 4),
            Text('Taken',
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: status.taken)),
          ],
        );
      case DoseStatus.skipped:
        trailing = Text('Skipped', style: theme.textTheme.labelMedium);
      case DoseStatus.missed:
        trailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Missed',
              style: theme.textTheme.labelMedium?.copyWith(color: status.missed),
            ),
            const SizedBox(width: AppSpacing.sm),
            OutlinedButton(
              onPressed: () => _take(context, ref, d),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(64, 36),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              child: const Text('Take'),
            ),
          ],
        );
      default:
        trailing = OutlinedButton(
          onPressed: () => _take(context, ref, d),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(64, 36),
            padding: const EdgeInsets.symmetric(horizontal: 14),
          ),
          child: const Text('Take'),
        );
    }

    return InkWell(
      onTap: () => context.push('/medicines/${m.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            DoseFormIcon(form: m.form, size: 40),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Opacity(
                opacity: done ? 0.6 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      m.name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      m.prescribedAs == null
                          ? _doseLabel(d, m)
                          : '${_doseLabel(d, m)} · Rx: ${m.prescribedAs}',
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            trailing,
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------- empty states

class _FirstUse extends StatelessWidget {
  const _FirstUse();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxxl),
      child: Column(
        children: <Widget>[
          MedzeeMark.tile(size: 96),
          const SizedBox(height: AppSpacing.xl),
          Text('Add your first medicine',
              style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Type a name or scan a prescription. Medzee fills in the rest and '
            'reminds you on time.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.addMedicine),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add medicine'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.scanPrescription),
            icon: const Icon(Icons.document_scanner_outlined),
            label: const Text('Scan a prescription'),
          ),
        ],
      ),
    );
  }
}

class _QuietDay extends StatelessWidget {
  const _QuietDay();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Icon(Icons.spa_outlined,
            size: 40, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
        const SizedBox(height: AppSpacing.md),
        Text('Nothing scheduled today', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Add a medicine with a schedule and its doses will appear here.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final Color c = Theme.of(context).colorScheme.surfaceContainerHigh;
    Widget block(double h) => Container(
          height: h,
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(20),
          ),
        );
    return Column(children: <Widget>[block(150), block(120), block(160)]);
  }
}


// ------------------------------------------------------- grouped schedule

class _ScheduleSections extends ConsumerWidget {
  const _ScheduleSections({required this.entries});

  final List<TodayEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final int nowMinutes = ref.watch(reminderClockProvider).minutesOfDay;

    final GroupedSchedule<TodayEntry> g = groupSchedule<TodayEntry>(
      entries,
      minutes: (TodayEntry e) => e.dose.scheduledMinutes,
      status: (TodayEntry e) => e.dose.status,
      tieBreak: (TodayEntry e) => e.medication.name.toLowerCase(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (g.open.isNotEmpty) ...<Widget>[
          Text('Up next', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          for (final TimeGroup<TodayEntry> group in g.open)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _TimeGroupCard(
                group: group,
                overdue: group.minutes < nowMinutes,
              ),
            ),
        ],
        if (g.done.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          Text(
            'Done · ${g.done.fold<int>(0, (int n, TimeGroup<TodayEntry> t) => n + t.items.length)}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final TimeGroup<TodayEntry> group in g.done)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _TimeGroupCard(group: group, overdue: false),
            ),
        ],
      ],
    );
  }
}

/// Every medicine due at one time, under a clear time heading.
class _TimeGroupCard extends ConsumerWidget {
  const _TimeGroupCard({required this.group, required this.overdue});

  final TimeGroup<TodayEntry> group;
  final bool overdue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final List<TodayEntry> open = group.items
        .where((TodayEntry e) =>
            e.dose.status == DoseStatus.pending ||
            e.dose.status == DoseStatus.missed)
        .toList();
    final String time = TimeOfDay(
      hour: group.minutes ~/ 60,
      minute: group.minutes % 60,
    ).format(context);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.xs,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: overdue ? status.warning : theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(time, style: theme.textTheme.titleSmall),
                const SizedBox(width: AppSpacing.sm),
                DeviceTimeNote(scheduledAt: group.items.first.dose.scheduledAt),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${group.items.length} ${group.items.length == 1 ? 'medicine' : 'medicines'}',
                  style: theme.textTheme.bodySmall,
                ),
                if (overdue) ...<Widget>[
                  const SizedBox(width: AppSpacing.sm),
                  StatusChip(
                    label: 'Overdue',
                    color: status.warning,
                    containerColor: status.warningContainer,
                  ),
                ],
                const Spacer(),
                if (open.length > 1)
                  TextButton(
                    onPressed: () => _takeAll(context, ref, open),
                    child: const Text('Take all'),
                  ),
              ],
            ),
          ),
          for (final TodayEntry e in group.items) ...<Widget>[
            const Divider(height: 1, indent: AppSpacing.lg),
            _DoseRow(entry: e),
          ],
        ],
      ),
    );
  }

  Future<void> _takeAll(
    BuildContext context,
    WidgetRef ref,
    List<TodayEntry> open,
  ) async {
    HapticFeedback.mediumImpact();
    final DoseActions actions = ref.read(doseActionsProvider);
    for (final TodayEntry e in open) {
      await actions.taken(e.dose);
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Logged ${open.length} doses as taken'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              for (final TodayEntry e in open) {
                await actions.undo(e.dose);
              }
            },
          ),
        ),
      );
  }
}

// --------------------------------------------------------- low stock sheet

void _showLowStock(BuildContext context, List<Medication> low) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          0,
          AppSpacing.gutter,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Running low',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${low.length} medicines need a refill soon.',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Flexible(
              child: AppCard(
                padding: EdgeInsets.zero,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: low.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (BuildContext c, int i) =>
                      _LowStockRow(medication: low[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _LowStockRow extends ConsumerWidget {
  const _LowStockRow({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final Inventory? inv = ref.watch(inventoryProvider(medication.id)).value;
    final String left = inv == null
        ? ''
        : (inv.isEmpty
            ? 'Out of stock'
            : '${inv.quantityOnHand == inv.quantityOnHand.roundToDouble() ? inv.quantityOnHand.toInt() : inv.quantityOnHand} left');
    return ListTile(
      leading: DoseFormIcon(form: medication.form, size: 40),
      title: Text(medication.name, style: theme.textTheme.titleSmall),
      subtitle: Text(
        left,
        style: theme.textTheme.bodySmall?.copyWith(color: status.warning),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        Navigator.of(context).pop();
        context.push('/medicines/${medication.id}');
      },
    );
  }
}
