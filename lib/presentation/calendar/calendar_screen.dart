import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/dose.dart';
import '../../domain/models/medication.dart';
import '../../domain/services/dose_status_resolver.dart';
import '../../state/dose_actions.dart';
import '../../state/doses_provider.dart';
import '../../state/medications_provider.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';
import '../shared/motion_widgets.dart';

const List<String> _weekdayLetters = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];
const List<String> _months = <String>[
  'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
  'September', 'October', 'November', 'December',
];
const List<String> _weekdays = <String>[
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
  'Sunday',
];

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Doses across a date range, for the rings on the day picker.
final StreamProviderFamily<List<ScheduledDose>, ({DateTime from, DateTime to})>
    dosesInRangeProvider =
    StreamProvider.family<List<ScheduledDose>, ({DateTime from, DateTime to})>(
  (Ref ref, ({DateTime from, DateTime to}) range) => ref
      .watch(doseRepositoryProvider)
      .watchDosesInRange(range.from, range.to),
);

class _DayStats {
  int total = 0;
  int taken = 0;
  int missed = 0;
}

Map<DateTime, _DayStats> _statsByDay(List<ScheduledDose> doses) {
  final DateTime now = DateTime.now();
  final Map<DateTime, _DayStats> out = <DateTime, _DayStats>{};
  for (final ScheduledDose d in doses) {
    final DoseStatus s = DoseStatusResolver.resolve(
      scheduledAt: d.scheduledAt,
      now: now,
      current: d.status,
    );
    if (s == DoseStatus.cancelled) continue;
    final _DayStats st = out.putIfAbsent(_day(d.localDate), _DayStats.new);
    st.total++;
    if (s == DoseStatus.taken) st.taken++;
    if (s == DoseStatus.missed) st.missed++;
  }
  return out;
}

/// A day picker with progress rings and a vertical timeline of what to take
/// at each time.
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  bool _month = false;

  /// First day shown by the picker.
  DateTime _rangeStart(DateTime selected) {
    if (!_month) {
      return _day(selected.subtract(Duration(days: selected.weekday - 1)));
    }
    final DateTime first = DateTime(selected.year, selected.month, 1);
    return _day(first.subtract(Duration(days: first.weekday - 1)));
  }

  int _rows(DateTime selected) {
    if (!_month) return 1;
    final DateTime first = DateTime(selected.year, selected.month, 1);
    final int days = DateUtils.getDaysInMonth(selected.year, selected.month);
    return ((first.weekday - 1 + days) / 7).ceil();
  }

  void _shift(int direction) {
    final DateTime s = ref.read(selectedDateProvider);
    final DateTime target = _month
        ? DateTime(s.year, s.month + direction, 1)
        : s.add(Duration(days: 7 * direction));
    ref.read(selectedDateProvider.notifier).select(
          _month
              ? DateTime(
                  target.year,
                  target.month,
                  s.day.clamp(
                    1,
                    DateUtils.getDaysInMonth(target.year, target.month),
                  ),
                )
              : target,
        );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime selected = ref.watch(selectedDateProvider);
    final DateTime today = _day(DateTime.now());
    final AsyncValue<List<ScheduledDose>> doses =
        ref.watch(dosesForDateProvider(selected));

    final DateTime start = _rangeStart(selected);
    final int rows = _rows(selected);
    final DateTime end = start.add(Duration(days: rows * 7 - 1));
    final Map<DateTime, _DayStats> stats = _statsByDay(
      ref.watch(dosesInRangeProvider((from: start, to: end))).value ??
          const <ScheduledDose>[],
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.md,
                AppSpacing.sm,
                0,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${_months[selected.month - 1]} ${selected.year}',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  if (!_sameDay(selected, today))
                    TextButton(
                      onPressed: () =>
                          ref.read(selectedDateProvider.notifier).goToToday(),
                      child: const Text('Today'),
                    ),
                  IconButton(
                    tooltip: _month ? 'Previous month' : 'Previous week',
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () => _shift(-1),
                  ),
                  IconButton(
                    tooltip: _month ? 'Next month' : 'Next week',
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () => _shift(1),
                  ),
                  IconButton.filledTonal(
                    tooltip: _month ? 'Show week' : 'Show month',
                    icon: Icon(
                      _month
                          ? Icons.view_week_rounded
                          : Icons.calendar_view_month_rounded,
                    ),
                    onPressed: () => setState(() => _month = !_month),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: <Widget>[
                  for (final String l in _weekdayLetters)
                    Expanded(
                      child: Center(
                        child: Text(l, style: theme.textTheme.labelSmall),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: <Widget>[
                    for (int r = 0; r < rows; r++)
                      Row(
                        children: <Widget>[
                          for (int c = 0; c < 7; c++)
                            Expanded(
                              child: _DayCell(
                                date: start.add(Duration(days: r * 7 + c)),
                                selected: selected,
                                today: today,
                                stats: stats[
                                    _day(start.add(Duration(days: r * 7 + c)))],
                                dimmed: _month &&
                                    start
                                            .add(Duration(days: r * 7 + c))
                                            .month !=
                                        selected.month,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: doses.when( skipLoadingOnReload: true,
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object e, StackTrace _) => Padding(
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  child: InfoBanner(
                    message: 'Could not load this day: $e',
                    tone: AppInfoTone.critical,
                    icon: Icons.error_outline_rounded,
                  ),
                ),
                data: (List<ScheduledDose> list) => _DayView(
                  date: selected,
                  isToday: _sameDay(selected, today),
                  doses: list,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------------- day cell

class _DayCell extends ConsumerWidget {
  const _DayCell({
    required this.date,
    required this.selected,
    required this.today,
    required this.stats,
    required this.dimmed,
  });

  final DateTime date;
  final DateTime selected;
  final DateTime today;
  final _DayStats? stats;
  final bool dimmed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final bool isSelected = _sameDay(date, selected);
    final bool isToday = _sameDay(date, today);
    final _DayStats? st = stats;
    final bool hasDoses = st != null && st.total > 0;

    final Color numberColor = isSelected
        ? theme.colorScheme.onPrimary
        : isToday
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${_weekdays[date.weekday - 1]} ${date.day}'
          '${hasDoses ? ', ${st.taken} of ${st.total} taken' : ''}',
      child: InkResponse(
        onTap: () {
          HapticFeedback.selectionClick();
          ref.read(selectedDateProvider.notifier).select(date);
        },
        radius: 28,
        child: Opacity(
          opacity: dimmed ? 0.35 : 1,
          child: SizedBox(
            height: 50,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary : null,
                      shape: BoxShape.circle,
                    ),
                    child: isSelected
                        ? Center(
                            child: Text(
                              '${date.day}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: numberColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          )
                        : ProgressRing(
                            value: hasDoses ? st.taken / st.total : 0,
                            size: 42,
                            stroke: 3.5,
                            color: status.taken,
                            trackColor: hasDoses
                                ? theme.colorScheme.primaryContainer
                                : (isToday
                                    ? theme.colorScheme.primary
                                        .withValues(alpha: 0.35)
                                    : Colors.transparent),
                            child: Text(
                              '${date.day}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: numberColor,
                                fontWeight: isToday
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                  ),
                  if (hasDoses && st.missed > 0)
                    Positioned(
                      top: 1,
                      right: 1,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: status.missed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- day view

class _DayView extends StatelessWidget {
  const _DayView({
    required this.date,
    required this.isToday,
    required this.doses,
  });

  final DateTime date;
  final bool isToday;
  final List<ScheduledDose> doses;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;

    final int taken =
        doses.where((ScheduledDose d) => d.status == DoseStatus.taken).length;
    final int missed =
        doses.where((ScheduledDose d) => d.status == DoseStatus.missed).length;
    final int skipped =
        doses.where((ScheduledDose d) => d.status == DoseStatus.skipped).length;
    final int total = doses.length;

    // Group by time of day, oldest first: a timeline of the day.
    final Map<int, List<ScheduledDose>> byTime = <int, List<ScheduledDose>>{};
    for (final ScheduledDose d in doses) {
      byTime.putIfAbsent(d.scheduledMinutes, () => <ScheduledDose>[]).add(d);
    }
    final List<int> times = byTime.keys.toList()..sort();

    final DateTime now = DateTime.now();
    final int nowMinutes = now.hour * 60 + now.minute;
    int? nowBefore; // index of the first group after "now"
    if (isToday) {
      nowBefore = times.indexWhere((int t) => t > nowMinutes);
      if (nowBefore == -1) nowBefore = times.length;
    }

    return ListView(
      key: ValueKey<DateTime>(date),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.sm,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      children: <Widget>[
        Text(
          '${_weekdays[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]}',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 2),
        Text(
          total == 0
              ? 'Nothing scheduled'
              : '$taken of $total taken'
                  '${missed > 0 ? ' · $missed missed' : ''}'
                  '${skipped > 0 ? ' · $skipped skipped' : ''}',
          style: theme.textTheme.bodySmall,
        ),
        if (total > 0) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 6,
              child: Row(
                children: <Widget>[
                  if (taken > 0)
                    Expanded(flex: taken, child: ColoredBox(color: status.taken)),
                  if (missed > 0)
                    Expanded(flex: missed, child: ColoredBox(color: status.missed)),
                  if (skipped > 0)
                    Expanded(
                      flex: skipped,
                      child: ColoredBox(color: status.skipped),
                    ),
                  if (total - taken - missed - skipped > 0)
                    Expanded(
                      flex: total - taken - missed - skipped,
                      child: ColoredBox(
                        color: theme.colorScheme.primaryContainer,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        if (total == 0)
          const EmptyState(
            icon: Icons.event_available_outlined,
            title: 'No doses on this day',
            message: 'Nothing was scheduled, or the schedule does not reach '
                'this date yet.',
          )
        else
          for (int i = 0; i < times.length; i++) ...<Widget>[
            if (nowBefore == i) const _NowMarker(),
            _TimelineGroup(
              minutes: times[i],
              doses: byTime[times[i]]!,
              isLast: i == times.length - 1 && nowBefore != times.length,
            ),
          ],
        if (isToday && nowBefore == times.length && total > 0) const _NowMarker(),
      ],
    );
  }
}

class _NowMarker extends StatelessWidget {
  const _NowMarker();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color c = theme.colorScheme.primary;
    final String time = TimeOfDay.now().format(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 64,
            child: Text(
              'Now',
              style: theme.textTheme.labelMedium?.copyWith(
                color: c,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          ),
          Expanded(child: Container(height: 2, color: c.withValues(alpha: 0.5))),
          const SizedBox(width: AppSpacing.sm),
          Text(time, style: theme.textTheme.labelSmall?.copyWith(color: c)),
        ],
      ),
    );
  }
}

/// One time on the rail: the time, a status node, and the medicines due then.
class _TimelineGroup extends StatelessWidget {
  const _TimelineGroup({
    required this.minutes,
    required this.doses,
    required this.isLast,
  });

  final int minutes;
  final List<ScheduledDose> doses;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;

    final bool allTaken =
        doses.every((ScheduledDose d) => d.status == DoseStatus.taken);
    final bool anyMissed =
        doses.any((ScheduledDose d) => d.status == DoseStatus.missed);
    final bool allSkipped =
        doses.every((ScheduledDose d) => d.status == DoseStatus.skipped);

    final Color nodeColor = allTaken
        ? status.taken
        : anyMissed
            ? status.missed
            : allSkipped
                ? status.skipped
                : theme.colorScheme.primary;
    final bool filled = allTaken || anyMissed || allSkipped;
    final IconData? nodeIcon = allTaken
        ? Icons.check_rounded
        : anyMissed
            ? Icons.close_rounded
            : allSkipped
                ? Icons.remove_rounded
                : null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: 64,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60)
                        .format(context),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 22,
            child: Column(
              children: <Widget>[
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: filled ? nodeColor : theme.scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: nodeColor, width: 2),
                  ),
                  child: nodeIcon == null
                      ? null
                      : Icon(nodeIcon, size: 12, color: Colors.white),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    for (int i = 0; i < doses.length; i++) ...<Widget>[
                      if (i > 0) const Divider(height: 1, indent: AppSpacing.lg),
                      _CalendarDoseRow(dose: doses[i]),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarDoseRow extends ConsumerWidget {
  const _CalendarDoseRow({required this.dose});

  final ScheduledDose dose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final Medication? med =
        ref.watch(medicationProvider(dose.medicationId)).value;

    final (Color accent, Color background, String label) = switch (dose.status) {
      DoseStatus.taken => (status.taken, status.takenContainer, 'Taken'),
      DoseStatus.missed => (status.missed, status.missedContainer, 'Missed'),
      DoseStatus.skipped => (status.skipped, status.skippedContainer, 'Skipped'),
      DoseStatus.cancelled => (
          theme.colorScheme.onSurfaceVariant,
          theme.colorScheme.surfaceContainerHighest,
          'Cancelled',
        ),
      DoseStatus.pending => (
          status.upcoming,
          status.upcomingContainer,
          'Upcoming',
        ),
    };

    return InkWell(
      onTap: () => _showActions(context, ref, med),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            if (med != null) DoseFormIcon(form: med.form, size: 36),
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
                  Text(
                    '${_qty(dose.doseQuantity)} ${dose.unit.singular}'
                    '${dose.doseQuantity == 1 ? '' : 's'}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            StatusChip(label: label, color: accent, containerColor: background),
          ],
        ),
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
      builder: (BuildContext ctx) => SafeArea(
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
                style: Theme.of(ctx).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline_rounded),
              title: const Text('Mark as taken'),
              enabled: dose.status != DoseStatus.taken,
              onTap: () async {
                Navigator.of(ctx).pop();
                await ref.read(doseActionsProvider).taken(dose);
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline_rounded),
              title: const Text('Mark as skipped'),
              enabled: dose.status != DoseStatus.skipped,
              onTap: () async {
                Navigator.of(ctx).pop();
                await ref.read(doseActionsProvider).skip(dose);
              },
            ),
            ListTile(
              leading: const Icon(Icons.error_outline_rounded),
              title: const Text('Mark as missed'),
              enabled: dose.status != DoseStatus.missed,
              onTap: () async {
                Navigator.of(ctx).pop();
                await ref.read(doseActionsProvider).missed(dose);
              },
            ),
            ListTile(
              leading: const Icon(Icons.undo_rounded),
              title: const Text('Undo: return to pending'),
              enabled: dose.status != DoseStatus.pending,
              onTap: () async {
                Navigator.of(ctx).pop();
                await ref.read(doseActionsProvider).undo(dose);
              },
            ),
            ListTile(
              leading: const Icon(Icons.medication_outlined),
              title: const Text('Open medicine'),
              onTap: () {
                Navigator.of(ctx).pop();
                context.push('/medicines/${medication.id}');
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  static String _qty(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
}
