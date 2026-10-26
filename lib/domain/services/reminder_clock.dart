import 'local_time_converter.dart';

/// Decides which time zone a person's reminders run on.
///
/// Normally that is wherever the phone is. With travel mode on it stays on the
/// person's own ("home") zone, so someone who set up their medicines in New
/// York is still reminded on New York time after landing in India.
abstract final class ReminderZone {
  /// The zone reminders use right now.
  ///
  /// [deviceId] is where the phone is. [homeId] is the zone the person chose
  /// for their schedule, if any. Travel mode without a home zone has nothing
  /// to hold on to, so the phone's zone is used.
  static String effectiveId({
    required String deviceId,
    String? homeId,
    required bool travelMode,
  }) {
    if (travelMode && homeId != null && homeId.isNotEmpty) return homeId;
    return deviceId;
  }

  /// True when travel mode is holding reminders on a zone other than the
  /// phone's, so the app should show both clocks.
  static bool isHolding({
    required String deviceId,
    String? homeId,
    required bool travelMode,
  }) =>
      travelMode && homeId != null && homeId.isNotEmpty && homeId != deviceId;
}

/// "Now" and "today" as the person's reminders see them.
///
/// Doses are filed under a calendar day in the reminder zone, so the day
/// boundary and the "now" marker must use that zone too, not the phone's.
class ReminderClock {
  ReminderClock(this.converter, {DateTime Function()? nowUtc})
      : _nowUtc = nowUtc ?? (() => DateTime.now().toUtc());

  final LocalTimeConverter converter;
  final DateTime Function() _nowUtc;

  /// The current instant.
  DateTime nowUtc() => _nowUtc().toUtc();

  /// The wall-clock reading in the reminder zone, as a plain [DateTime].
  DateTime now() => wallClock(nowUtc());

  /// The wall-clock reading of [utc] in the reminder zone.
  DateTime wallClock(DateTime utc) {
    final DateTime z = converter.localFromUtc(utc.toUtc());
    return DateTime(z.year, z.month, z.day, z.hour, z.minute, z.second);
  }

  /// Today's calendar date in the reminder zone, at midnight.
  DateTime today() => dateOnly(now());

  /// Minutes since midnight in the reminder zone.
  int get minutesOfDay {
    final DateTime n = now();
    return n.hour * 60 + n.minute;
  }
}
