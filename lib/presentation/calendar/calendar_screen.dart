import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/dose.dart';
import '../../domain/models/medication.dart';
import '../../state/dose_actions.dart';
import '../../state/doses_provider.dart';
import '../../state/medications_provider.dart';
import '../shared/app_widgets.dart';

/// Month-style day navigator plus the full dose list for the selected day.
///
/// The calendar is intentionally not a grid: what matters here is reviewing
/// one day at a time and correcting records, which a scrolling list does
/// better than a dense month view.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final DateTime selected = ref.watch(selectedDateProvider);
    final AsyncValue<List<ScheduledDose>> doses =
        ref.watch(dosesForDateProvider(selected));

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.lg,
                AppSpacing.gutter,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('History', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  _DayNavigator(selected: selected),
                ],
              ),
            ),
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
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      AppSpacing.lg,
                      AppSpacing.gutter,
                      AppSpacing.huge,
                    ),
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int index) =>
                        _HistoryTile(dose: list[index], index: index),
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

class _DayNavigator extends ConsumerWidget {
  const _DayNavigator({required this.selected});

  final DateTime selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final DateTime today = ref.watch(todayProvider);
    final bool isToday = selected.year == today.year &&
        selected.month == today.month &&
        selected.day == today.day;

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: 'Previous day',
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () =>
                ref.read(selectedDateProvider.notifier).goToPrevious(),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  _formatFull(selected),
                  style: theme.textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                if (!isToday)
                  TextButton(
                    onPressed: () =>
                        ref.read(selectedDateProvider.notifier).goToToday(),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 24),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Back to today'),
                  )
                else
                  SizedBox(height: theme.textTheme.labelSmall?.height ?? 14),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Next day',
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: () => ref.read(selectedDateProvider.notifier).goToNext(),
          ),
        ],
      ),
    );
  }

  String _formatFull(DateTime date) {
    const List<String> weekdays = <String>[
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
      'Sunday',
    ];
    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
      'Nov', 'Dec',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} '
        '${months[date.month - 1]} ${date.year}';
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

    return AppCard(
      onTap: () => _showActions(context, ref, med),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  med?.name ?? 'Medicine',
                  style: theme.textTheme.titleSmall,
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
    );
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
