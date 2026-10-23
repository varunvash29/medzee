import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/dose.dart';
import '../../domain/models/medication.dart';
import '../../state/dose_actions.dart';
import '../../state/doses_provider.dart';
import '../../state/medications_provider.dart';
import '../shared/app_widgets.dart';
import '../shared/motion_widgets.dart';

const List<String> _weekdayShort = <String>[
  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
];
const List<String> _months = <String>[
  'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
  'September', 'October', 'November', 'December',
];

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Week strip plus the full dose list for the selected day.
///
/// The strip keeps the screen calm; a date picker is one tap away for jumping
/// to any month.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime selected = ref.watch(selectedDateProvider);
    final AsyncValue<List<ScheduledDose>> doses =
        ref.watch(dosesForDateProvider(selected));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.md,
                AppSpacing.gutter,
                0,
              ),
              child: _Header(selected: selected),
            ),
            const SizedBox(height: AppSpacing.lg),
            _WeekStrip(selected: selected),
            Expanded(
              child: doses.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (Object error, StackTrace _) => Padding(
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  child: InfoBanner(
                    message: 'Could not load this day: $error',
                    tone: AppInfoTone.critical,
                    icon: Icons.error_outline_rounded,
                  ),
                ),
                data: (List<ScheduledDose> list) {
                  if (list.isEmpty) {
                    return const EmptyState(
                      icon: Icons.event_available_outlined,
                      title: 'No doses on this day',
                      message:
                          'Nothing was scheduled, or the schedule did not '
                          'reach this date yet.',
                    );
                  }
                  return AnimatedSwitcher(
                    duration: AppMotion.medium,
                    switchInCurve: AppMotion.enter,
                    child: ListView(
                      key: ValueKey<DateTime>(selected),
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.gutter,
                        AppSpacing.lg,
                        AppSpacing.gutter,
                        150,
                      ),
                      children: <Widget>[
                        _DaySummary(doses: list),
                        const SizedBox(height: AppSpacing.lg),
                        for (int i = 0; i < list.length; i++)
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: _HistoryTile(dose: list[i], index: i),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.selected});

  final DateTime selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final DateTime today = ref.watch(todayProvider);
    final bool isToday = _sameDay(selected, today);

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${_months[selected.month - 1]} ${selected.year}',
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                isToday
                    ? 'Today'
                    : '${_weekdayShort[selected.weekday - 1]}, ${selected.day} '
                        '${_months[selected.month - 1].substring(0, 3)}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: AppMotion.fast,
          child: isToday
              ? const SizedBox.shrink()
              : TextButton(
                  key: const ValueKey<String>('today'),
                  onPressed: () =>
                      ref.read(selectedDateProvider.notifier).goToToday(),
                  child: const Text('Today'),
                ),
        ),
        IconButton.filledTonal(
          tooltip: 'Pick a date',
          icon: const Icon(Icons.calendar_month_rounded),
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selected,
              firstDate: DateTime(today.year - 3),
              lastDate: DateTime(today.year + 2),
            );
            if (picked != null) {
              ref.read(selectedDateProvider.notifier).select(picked);
            }
          },
        ),
      ],
    );
  }
}

class _WeekStrip extends ConsumerWidget {
  const _WeekStrip({required this.selected});

  final DateTime selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final DateTime today = ref.watch(todayProvider);
    final DateTime monday =
        selected.subtract(Duration(days: selected.weekday - 1));
    final List<DateTime> days = List<DateTime>.generate(
      7,
      (int i) => DateTime(monday.year, monday.month, monday.day + i),
    );

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails d) {
        final double v = d.primaryVelocity ?? 0;
        if (v.abs() < 200) return;
        HapticFeedback.selectionClick();
        ref.read(selectedDateProvider.notifier).select(
              selected.add(Duration(days: v < 0 ? 7 : -7)),
            );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: <Widget>[
            for (final DateTime day in days)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: _sameDay(day, selected),
                  label: '${_weekdayShort[day.weekday - 1]} ${day.day}'
                      '${_sameDay(day, today) ? ', today' : ''}',
                  child: Pressable(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref.read(selectedDateProvider.notifier).select(day);
                    },
                    child: _DayCell(
                      day: day,
                      selected: _sameDay(day, selected),
                      isToday: _sameDay(day, today),
                      theme: theme,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.isToday,
    required this.theme,
  });

  final DateTime day;
  final bool selected;
  final bool isToday;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final ColorScheme c = theme.colorScheme;
    return AnimatedContainer(
      duration: AppMotion.medium,
      curve: AppMotion.emphasized,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: selected ? c.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: !selected && isToday
            ? Border.all(color: c.primary.withValues(alpha: 0.5))
            : null,
      ),
      child: Column(
        children: <Widget>[
          Text(
            _weekdayShort[day.weekday - 1].substring(0, 1),
            style: theme.textTheme.labelSmall?.copyWith(
              color: selected
                  ? c.onPrimary.withValues(alpha: 0.8)
                  : c.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${day.day}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: selected ? c.onPrimary : c.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// One-line proportional summary of the day, with text counts so colour is
/// never the only signal.
class _DaySummary extends StatelessWidget {
  const _DaySummary({required this.doses});

  final List<ScheduledDose> doses;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    int count(DoseStatus s) =>
        doses.where((ScheduledDose d) => d.status == s).length;
    final int taken = count(DoseStatus.taken);
    final int missed = count(DoseStatus.missed);
    final int skipped = count(DoseStatus.skipped);
    final int pending = count(DoseStatus.pending);
    final int total = taken + missed + skipped + pending;
    if (total == 0) return const SizedBox.shrink();

    Widget seg(int n, Color color) => n == 0
        ? const SizedBox.shrink()
        : Expanded(
            flex: n,
            child: Container(
              height: 8,
              margin: const EdgeInsets.only(right: 3),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            seg(taken, status.taken),
            seg(skipped, status.skipped),
            seg(missed, status.missed),
            seg(pending, theme.colorScheme.outlineVariant),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          <String>[
            '$taken taken',
            if (missed > 0) '$missed missed',
            if (skipped > 0) '$skipped skipped',
            if (pending > 0) '$pending upcoming',
          ].join('  ·  '),
          style: theme.textTheme.labelMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _HistoryTile extends ConsumerWidget {
  const _HistoryTile({required this.dose, required this.index});

  final ScheduledDose dose;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final AsyncValue<Medication?> medication =
        ref.watch(medicationProvider(dose.medicationId));
    final Medication? med = medication.value;

    final (Color accent, Color background, String label, IconData icon) =
        switch (dose.status) {
      DoseStatus.taken => (status.taken, status.takenContainer, 'Taken', Icons.check_rounded),
      DoseStatus.missed => (status.missed, status.missedContainer, 'Missed', Icons.close_rounded),
      DoseStatus.skipped =>
        (status.skipped, status.skippedContainer, 'Skipped', Icons.remove_rounded),
      DoseStatus.cancelled => (
          theme.colorScheme.onSurfaceVariant,
          theme.colorScheme.surfaceContainerHighest,
          'Cancelled',
          Icons.remove_rounded,
        ),
      DoseStatus.pending =>
        (status.upcoming, status.upcomingContainer, 'Pending', Icons.schedule_rounded),
    };

    return Pressable(
      scale: 0.98,
      onTap: () => _showActions(context, ref, med),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    med?.name ?? 'Medicine',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_hhmm(dose.scheduledMinutes)} · '
                    '${_qty(dose.doseQuantity)} ${dose.unit.singular}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            StatusChip(label: label, color: accent, containerColor: background),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: AppMotion.medium,
          delay: (index.clamp(0, 8) * 30).ms,
        )
        .slideY(begin: 0.05, curve: AppMotion.enter);
  }

  Future<void> _showActions(
    BuildContext context,
    WidgetRef ref,
    Medication? medication,
  ) async {
    if (medication == null) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                0,
                AppSpacing.gutter,
                AppSpacing.md,
              ),
              child: Text(
                medication.name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline_rounded),
              title: const Text('Mark as taken'),
              enabled: dose.status != DoseStatus.taken,
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(doseActionsProvider).taken(dose);
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline_rounded),
              title: const Text('Mark as skipped'),
              enabled: dose.status != DoseStatus.skipped,
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(doseActionsProvider).skip(dose);
              },
            ),
            ListTile(
              leading: const Icon(Icons.error_outline_rounded),
              title: const Text('Mark as missed'),
              enabled: dose.status != DoseStatus.missed,
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(doseActionsProvider).missed(dose);
              },
            ),
            ListTile(
              leading: const Icon(Icons.undo_rounded),
              title: const Text('Undo — return to pending'),
              enabled: dose.status != DoseStatus.pending,
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(doseActionsProvider).undo(dose);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  String _hhmm(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
      '${(minutes % 60).toString().padLeft(2, '0')}';

  String _qty(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}
