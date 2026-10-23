import '../models/core_enums.dart';
import '../models/medication.dart';
import 'local_time_converter.dart';

/// A single scheduled occurrence before it is persisted.
class DoseOccurrence {
  const DoseOccurrence({
    required this.phaseId,
    required this.localDate,
    required this.minutes,
    required this.doseQuantity,
    required this.unit,
  });

  final String phaseId;

  /// Calendar date the occurrence belongs to.
  final DateTime localDate;

  /// Minutes from local midnight.
  final int minutes;
  final double doseQuantity;
  final DoseUnit unit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoseOccurrence &&
          other.phaseId == phaseId &&
          other.localDate == localDate &&
          other.minutes == minutes;

  @override
  int get hashCode => Object.hash(phaseId, localDate, minutes);
}

/// Deterministic expansion of schedule phases into concrete dose instances.
///
/// The generator is pure: the same phases and range always produce the same
/// occurrences. That property is what makes the schedule unit-testable and
/// lets the app re-derive future doses after a timezone change without
/// losing history.
abstract final class ScheduleGenerator {
  /// Expands all [phases] into occurrences between [from] and [to]
  /// (both inclusive, interpreted as local calendar dates).
  static List<DoseOccurrence> occurrences({
    required Iterable<SchedulePhase> phases,
    required DateTime from,
    required DateTime to,
  }) {
    final List<DoseOccurrence> results = <DoseOccurrence>[];
    for (final SchedulePhase phase in phases) {
      results.addAll(occurrencesForPhase(phase, from: from, to: to));
    }
    results.sort((DoseOccurrence a, DoseOccurrence b) {
      final int byDate = a.localDate.compareTo(b.localDate);
      if (byDate != 0) return byDate;
      return a.minutes.compareTo(b.minutes);
    });
    return results;
  }

  /// Expands a single phase into occurrences between [from] and [to].
  static List<DoseOccurrence> occurrencesForPhase(
    SchedulePhase phase, {
    required DateTime from,
    required DateTime to,
  }) {
    if (!phase.isActive) return const <DoseOccurrence>[];
    if (phase.kind.isAsNeeded) return const <DoseOccurrence>[];
    if (phase.timesMinutes.isEmpty && phase.kind != ScheduleKind.everyNHours) {
      return const <DoseOccurrence>[];
    }

    final DateTime rangeStart = dateOnly(from);
    final DateTime rangeEnd = dateOnly(to);
    final DateTime phaseStart = dateOnly(phase.startDate);
    final DateTime? phaseEnd = phase.endDate == null ? null : dateOnly(phase.endDate!);

    if (phaseEnd != null && phaseEnd.isBefore(phaseStart)) {
      return const <DoseOccurrence>[];
    }

    final DateTime effectiveStart = phaseStart.isAfter(rangeStart) ? phaseStart : rangeStart;
    final DateTime effectiveEnd = phaseEnd != null && phaseEnd.isBefore(rangeEnd)
        ? phaseEnd
        : rangeEnd;

    if (effectiveStart.isAfter(effectiveEnd)) {
      return const <DoseOccurrence>[];
    }

    if (phase.kind == ScheduleKind.everyNHours) {
      return _everyNHours(phase, effectiveStart, effectiveEnd);
    }

    final List<int> times = phase.timesMinutes.toList()..sort();
    final List<DoseOccurrence> result = <DoseOccurrence>[];

    DateTime day = effectiveStart;
    while (!day.isAfter(effectiveEnd)) {
      if (_matchesDay(phase, day)) {
        for (final int minutes in times) {
          result.add(
            DoseOccurrence(
              phaseId: phase.id,
              localDate: day,
              minutes: minutes,
              doseQuantity: phase.doseQuantity,
              unit: phase.unit,
            ),
          );
        }
      }
      day = day.add(const Duration(days: 1));
    }
    return result;
  }

  /// True when [phase] has an occurrence on the calendar day [day].
  static bool _matchesDay(SchedulePhase phase, DateTime day) {
    switch (phase.kind) {
      case ScheduleKind.daily:
        return true;
      case ScheduleKind.everyNDays:
        final int interval = phase.intervalDays < 1 ? 1 : phase.intervalDays;
        final int daysSinceStart = dateOnly(day).difference(dateOnly(phase.startDate)).inDays;
        // Negative only if the day predates the phase, which is filtered out
        // before this point, but guard anyway.
        return daysSinceStart >= 0 && daysSinceStart % interval == 0;
      case ScheduleKind.weekly:
      case ScheduleKind.custom:
        if (phase.weekdays.isEmpty) return true;
        return phase.weekdays.contains(day.weekday);
      case ScheduleKind.monthly:
        if (phase.monthlyDays.isEmpty) return false;
        return phase.monthlyDays.contains(day.day);
      case ScheduleKind.asNeeded:
      case ScheduleKind.everyNHours:
        return false;
    }
  }

  /// Expands a rolling "every N hours" phase.
  ///
  /// The interval is measured in *wall-clock* hours so that a dose stays at
  /// the same local time across daylight-saving transitions. The sequence is
  /// anchored at the phase's first time and rolls continuously across
  /// midnight, so an 8-hour interval started at 08:00 yields 08:00, 16:00
  /// and 00:00 on each following day.
  static List<DoseOccurrence> _everyNHours(
    SchedulePhase phase,
    DateTime effectiveStart,
    DateTime effectiveEnd,
  ) {
    final int hours = phase.intervalHours < 1 ? 1 : (phase.intervalHours > 24 ? 24 : phase.intervalHours);
    final int stepMinutes = hours * 60;
    final int anchorMinutes = phase.timesMinutes.isEmpty
        ? (8 * 60)
        : phase.timesMinutes.reduce((int a, int b) => a < b ? a : b);

    final DateTime anchorDate = dateOnly(phase.startDate);
    final int anchorTotal = anchorDate
            .difference(DateTime(anchorDate.year - 1, 12, 31))
            .inDays *
            1440 +
        anchorMinutes;

    // Bound the iteration: from the anchor to the end of the range.
    final int endTotal = effectiveEnd
            .difference(DateTime(anchorDate.year - 1, 12, 31))
            .inDays *
            1440 +
        1440;
    final int startTotal = effectiveStart
            .difference(DateTime(anchorDate.year - 1, 12, 31))
            .inDays *
            1440;

    final List<DoseOccurrence> result = <DoseOccurrence>[];
    int total = anchorTotal;
    while (total <= endTotal) {
      if (total >= startTotal) {
        final int dayOffset = total ~/ 1440;
        final int minuteOfDay = total % 1440;
        final DateTime day = DateTime(anchorDate.year - 1, 12, 31)
            .add(Duration(days: dayOffset));
        result.add(
          DoseOccurrence(
            phaseId: phase.id,
            localDate: DateTime(day.year, day.month, day.day),
            minutes: minuteOfDay,
            doseQuantity: phase.doseQuantity,
            unit: phase.unit,
          ),
        );
      }
      total += stepMinutes;
    }
    return result;
  }

  /// A concise, human readable description of a phase, e.g.
  /// "Every day at 08:00, 20:00" or "Every 2 days at 09:00".
  static String describe(SchedulePhase phase, {String Function(int)? formatTime}) {
    final String Function(int) fmt =
        formatTime ?? ((int minutes) => _defaultTimeFormat(minutes));
    if (phase.kind.isAsNeeded) return 'Take as needed';

    final List<int> sortedTimes = phase.timesMinutes.toList()..sort();
    final List<String> times = sortedTimes.map(fmt).toList(growable: false);

    switch (phase.kind) {
      case ScheduleKind.daily:
        return 'Every day at ${times.join(', ')}';
      case ScheduleKind.weekly:
      case ScheduleKind.custom:
        if (phase.weekdays.isEmpty) {
          return 'Every day at ${times.join(', ')}';
        }
        const List<String> names = <String>[
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
          'Sun',
        ];
        final List<int> days = phase.weekdays.toList()..sort();
        final String dayList = days.map((int d) => names[d - 1]).join(', ');
        return '$dayList at ${times.join(', ')}';
      case ScheduleKind.everyNDays:
        final int interval = phase.intervalDays < 1 ? 1 : phase.intervalDays;
        if (interval == 1) return 'Every day at ${times.join(', ')}';
        if (interval == 2) return 'Every other day at ${times.join(', ')}';
        return 'Every $interval days at ${times.join(', ')}';
      case ScheduleKind.everyNHours:
        final int hours = phase.intervalHours < 1 ? 1 : phase.intervalHours;
        return 'Every $hours hour${hours == 1 ? '' : 's'} from ${fmt(phase.timesMinutes.isEmpty ? 480 : phase.timesMinutes.first)}';
      case ScheduleKind.monthly:
        if (phase.monthlyDays.isEmpty) return 'Monthly';
        final List<int> days = phase.monthlyDays.toList()..sort();
        return 'Day${days.length == 1 ? '' : 's'} ${days.join(', ')} at ${times.join(', ')}';
      case ScheduleKind.asNeeded:
        return 'Take as needed';
    }
  }

  static String _defaultTimeFormat(int minutes) {
    final int h = (minutes ~/ 60) % 24;
    final int m = minutes % 60;
    final String suffix = h < 12 ? 'AM' : 'PM';
    final int hour12 = h % 12 == 0 ? 12 : h % 12;
    return '$hour12:${m.toString().padLeft(2, '0')} $suffix';
  }
}
