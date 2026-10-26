import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../domain/services/local_time_converter.dart';

/// Initialises the IANA timezone database and keeps track of the user's
/// chosen timezone.
///
/// Medzee stores reminder times as local wall-clock times. The timezone
/// database is what turns "08:00 every day" into a correct instant across
/// daylight-saving transitions.
abstract final class TimezoneService {
  static bool _initialised = false;

  /// Loads the timezone database and sets the device location.
  static Future<String> initialize() async {
    if (!_initialised) {
      tz_data.initializeTimeZones();
      _initialised = true;
    }
    return refreshDevice();
  }

  /// Re-reads the phone's time zone. Call it when the app comes back to the
  /// foreground: the phone may have crossed a time zone while it was away.
  static Future<String> refreshDevice() async {
    try {
      final String identifier = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(identifier));
      return identifier;
    } catch (_) {
      // The platform channel is unavailable (for example in a unit test).
      // Keep what we had, or fall back to UTC so the app still behaves
      // deterministically.
      return deviceTimeZoneId;
    }
  }

  /// The active timezone location.
  static tz.Location get location => tz.local;

  /// The active timezone identifier, e.g. "Europe/Berlin".
  static String get timeZoneId => tz.local.name;

  /// The phone's own time zone, as reported by the platform.
  static String get deviceTimeZoneId {
    try {
      return tz.local.name;
    } catch (_) {
      // The location has never been set (no platform, e.g. a unit test).
      return tz.UTC.name;
    }
  }

  /// A converter bound to the active (device) timezone.
  static LocalTimeConverter get converter => converterFor(deviceTimeZoneId);

  /// A converter bound to a specific timezone.
  ///
  /// Before the timezone database is loaded (unit tests, a failed start) the
  /// phone's own clock is used, so the app still agrees with the device about
  /// what day it is.
  static LocalTimeConverter converterFor(String timeZoneId) {
    if (tz.timeZoneDatabase.locations.isEmpty) {
      return DeviceLocalConverter(timeZoneId);
    }
    try {
      return TzLocalTimeConverter(tz.getLocation(timeZoneId));
    } catch (_) {
      return TzLocalTimeConverter(tz.UTC);
    }
  }

  /// Every zone the picker can offer, "Region/City" names only, sorted.
  static List<String> get allTimeZones {
    if (!_initialised) {
      tz_data.initializeTimeZones();
      _initialised = true;
    }
    final List<String> ids = tz.timeZoneDatabase.locations.keys
        .where((String id) =>
            id.contains('/') &&
            !id.startsWith('Etc/') &&
            !id.startsWith('SystemV/') &&
            !id.startsWith('US/'))
        .toList()
      ..sort();
    return <String>['UTC', ...ids];
  }

  /// The UTC offset of [timeZoneId] at [at] (now when omitted).
  static Duration offsetOf(String timeZoneId, {DateTime? at}) {
    try {
      final tz.Location loc = tz.getLocation(timeZoneId);
      return tz.TZDateTime.from((at ?? DateTime.now()).toUtc(), loc)
          .timeZoneOffset;
    } catch (_) {
      return Duration.zero;
    }
  }

  /// "GMT-05:00" style offset text.
  static String offsetLabel(String timeZoneId, {DateTime? at}) {
    final int minutes = offsetOf(timeZoneId, at: at).inMinutes;
    final String sign = minutes < 0 ? '-' : '+';
    final int abs = minutes.abs();
    return 'GMT$sign${(abs ~/ 60).toString().padLeft(2, '0')}:'
        '${(abs % 60).toString().padLeft(2, '0')}';
  }

  /// "New York" from "America/New_York".
  static String cityOf(String timeZoneId) =>
      timeZoneId.split('/').last.replaceAll('_', ' ');

  /// A short, human readable list of common timezones for the picker.
  static List<String> get commonTimeZones => const <String>[
        'UTC',
        'Europe/London',
        'Europe/Dublin',
        'Europe/Lisbon',
        'Europe/Madrid',
        'Europe/Paris',
        'Europe/Berlin',
        'Europe/Rome',
        'Europe/Warsaw',
        'Europe/Athens',
        'Europe/Moscow',
        'Europe/Istanbul',
        'Africa/Lagos',
        'Africa/Cairo',
        'Africa/Nairobi',
        'Africa/Johannesburg',
        'Asia/Dubai',
        'Asia/Karachi',
        'Asia/Kolkata',
        'Asia/Dhaka',
        'Asia/Bangkok',
        'Asia/Singapore',
        'Asia/Hong_Kong',
        'Asia/Shanghai',
        'Asia/Tokyo',
        'Asia/Seoul',
        'Australia/Perth',
        'Australia/Sydney',
        'Pacific/Auckland',
        'America/Sao_Paulo',
        'America/Argentina/Buenos_Aires',
        'America/Bogota',
        'America/Mexico_City',
        'America/New_York',
        'America/Toronto',
        'America/Chicago',
        'America/Denver',
        'America/Los_Angeles',
        'America/Anchorage',
        'Pacific/Honolulu',
      ];

  /// A readable label for a timezone identifier, e.g. "Berlin (GMT+2)".
  static String describe(String timeZoneId) {
    try {
      final tz.Location loc = tz.getLocation(timeZoneId);
      final DateTime now = DateTime.now();
      final tz.TZDateTime zoned = tz.TZDateTime(loc, now.year, now.month, now.day);
      final int offsetMinutes = zoned.timeZoneOffset.inMinutes;
      final String sign = offsetMinutes < 0 ? '-' : '+';
      final int abs = offsetMinutes.abs();
      final String hours = (abs ~/ 60).toString().padLeft(2, '0');
      final String minutes = (abs % 60).toString().padLeft(2, '0');
      final String city = timeZoneId.split('/').last.replaceAll('_', ' ');
      return '$city (GMT$sign$hours:$minutes)';
    } catch (_) {
      return timeZoneId;
    }
  }
}

/// [LocalTimeConverter] backed by the IANA timezone database.
class TzLocalTimeConverter implements LocalTimeConverter {
  TzLocalTimeConverter(this._location);

  final tz.Location _location;

  @override
  String get timeZoneId => _location.name;

  @override
  DateTime utcFromLocal(DateTime local) {
    final tz.TZDateTime zoned = tz.TZDateTime(
      _location,
      local.year,
      local.month,
      local.day,
      local.hour,
      local.minute,
      local.second,
    );
    return zoned.toUtc();
  }

  @override
  DateTime localFromUtc(DateTime utc) => tz.TZDateTime.from(utc, _location);
}

/// A converter that uses the operating system's own local time. Only a
/// fallback for when the IANA database is not available.
class DeviceLocalConverter implements LocalTimeConverter {
  DeviceLocalConverter(this.timeZoneId);

  @override
  final String timeZoneId;

  @override
  DateTime utcFromLocal(DateTime local) => DateTime(
        local.year,
        local.month,
        local.day,
        local.hour,
        local.minute,
        local.second,
      ).toUtc();

  @override
  DateTime localFromUtc(DateTime utc) => utc.toUtc().toLocal();
}

/// A converter that treats local time as UTC. Used by tests and as a safe
/// fallback when the timezone database cannot be initialised.
class FixedOffsetConverter implements LocalTimeConverter {
  FixedOffsetConverter({this.offset = Duration.zero, this.name = 'UTC'});

  final Duration offset;
  final String name;

  @override
  String get timeZoneId => name;

  @override
  DateTime utcFromLocal(DateTime local) {
    // Reinterpret the wall-clock fields as UTC, then step back by the offset.
    // Never use DateTime.toUtc() here: that applies the machine's own zone on
    // top of the fixed offset.
    final DateTime asUtc = DateTime.utc(
      local.year,
      local.month,
      local.day,
      local.hour,
      local.minute,
      local.second,
      local.millisecond,
      local.microsecond,
    );
    return asUtc.subtract(offset);
  }

  @override
  DateTime localFromUtc(DateTime utc) {
    final DateTime shifted = utc.toUtc().add(offset);
    return DateTime(
      shifted.year,
      shifted.month,
      shifted.day,
      shifted.hour,
      shifted.minute,
      shifted.second,
      shifted.millisecond,
      shifted.microsecond,
    );
  }
}
