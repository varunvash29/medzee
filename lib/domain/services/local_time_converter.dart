/// Converts between local wall-clock time and absolute UTC instants.
///
/// Schedules are stored as local wall-clock times (a user takes a tablet at
/// 08:00 every morning whether or not the clock changes), while dose records
/// are stored as UTC instants. This abstraction keeps the scheduling rules
/// testable without pulling a timezone database into the domain layer.
abstract interface class LocalTimeConverter {
  /// Converts a local wall-clock [DateTime] into the corresponding UTC
  /// instant. For a time that does not exist (spring-forward gap) the
  /// implementation must shift forward; for an ambiguous time (fall-back)
  /// it must pick a single deterministic instance.
  DateTime utcFromLocal(DateTime local);

  /// Converts a UTC instant into the local wall-clock time.
  DateTime localFromUtc(DateTime utc);

  /// The timezone identifier this converter represents.
  String get timeZoneId;
}

/// Builds a local [DateTime] from a date and minutes-from-midnight,
/// allowing the minutes value to overflow past midnight.
DateTime localDateTimeAt(DateTime date, int minutesFromMidnight) {
  final int dayOffset = minutesFromMidnight ~/ 1440;
  final int minuteOfDay = minutesFromMidnight % 1440;
  final DateTime base = DateTime(date.year, date.month, date.day);
  return base.add(Duration(days: dayOffset, minutes: minuteOfDay));
}

/// Strips the time component from a [DateTime], keeping the calendar date.
DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
