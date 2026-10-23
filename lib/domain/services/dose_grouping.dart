import '../models/core_enums.dart';

/// Doses (or anything with a time) that share the same time of day.
class TimeGroup<T> {
  const TimeGroup(this.minutes, this.items);

  /// Minutes after midnight.
  final int minutes;
  final List<T> items;
}

/// A day's doses split into what still needs attention and what is finished.
class GroupedSchedule<T> {
  const GroupedSchedule({required this.open, required this.done});

  /// Pending and missed doses, grouped by time, earliest first. These are the
  /// ones to act on, so they come first.
  final List<TimeGroup<T>> open;

  /// Taken and skipped doses, grouped by time. Shown below, quieter.
  final List<TimeGroup<T>> done;

  bool get isEmpty => open.isEmpty && done.isEmpty;
}

/// Groups [items] by time of day.
///
/// A dose that is still to be taken or was missed goes in [open]; once it is
/// taken or skipped it moves to [done], so the next medicines to take are
/// always at the top. Two medicines at the same time share one group, and a
/// time where some are done and some are not appears in both lists.
GroupedSchedule<T> groupSchedule<T>(
  Iterable<T> items, {
  required int Function(T) minutes,
  required DoseStatus Function(T) status,
  String Function(T)? tieBreak,
}) {
  final Map<int, List<T>> open = <int, List<T>>{};
  final Map<int, List<T>> done = <int, List<T>>{};

  for (final T item in items) {
    final DoseStatus s = status(item);
    final bool isOpen = s == DoseStatus.pending || s == DoseStatus.missed;
    final bool isFinished = s == DoseStatus.taken || s == DoseStatus.skipped;
    if (!isOpen && !isFinished) continue; // cancelled doses are not shown
    (isOpen ? open : done).putIfAbsent(minutes(item), () => <T>[]).add(item);
  }

  List<TimeGroup<T>> build(Map<int, List<T>> map) {
    final List<int> times = map.keys.toList()..sort();
    return <TimeGroup<T>>[
      for (final int t in times)
        TimeGroup<T>(
          t,
          tieBreak == null
              ? map[t]!
              : (map[t]!..sort((T a, T b) => tieBreak(a).compareTo(tieBreak(b)))),
        ),
    ];
  }

  return GroupedSchedule<T>(open: build(open), done: build(done));
}
