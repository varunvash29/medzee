import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/services/timezone_service.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Daylight-saving correctness for reminder instants.
///
/// A user takes their medicine at 08:00 local time every day. When the clock
/// changes, the UTC instant of that dose must move with it — otherwise
/// reminders drift by an hour twice a year, which is exactly the class of bug
/// that makes people stop trusting a medication app.
void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  group('TzLocalTimeConverter — Europe/Berlin across DST', () {
    late final TzLocalTimeConverter berlin =
        TzLocalTimeConverter(tz.getLocation('Europe/Berlin'));

    test('an 08:00 reminder maps to 07:00Z while CET is in force', () {
      // 2026-03-28 is the day before the spring-forward transition.
      final DateTime utc = berlin.utcFromLocal(DateTime(2026, 3, 28, 8));
      expect(utc, DateTime.utc(2026, 3, 28, 7));
    });

    test('the same 08:00 reminder maps to 06:00Z after the clock moves',
        () {
      // 2026-03-29 02:00 CET -> 03:00 CEST.
      final DateTime utc = berlin.utcFromLocal(DateTime(2026, 3, 29, 8));
      expect(utc, DateTime.utc(2026, 3, 29, 6));
    });

    test('a time inside the spring-forward gap is shifted forward, not lost',
        () {
      // 02:30 does not exist on 2026-03-29 in Berlin. A reminder scheduled
      // for it must still fire (at 03:30 CEST = 01:30Z) rather than vanish.
      final DateTime utc = berlin.utcFromLocal(DateTime(2026, 3, 29, 2, 30));
      expect(utc, DateTime.utc(2026, 3, 29, 1, 30));
    });

    test('a 08:00 reminder maps back to 07:00Z after the autumn fall-back',
        () {
      // 2026-10-25 03:00 CEST -> 02:00 CET.
      final DateTime utc = berlin.utcFromLocal(DateTime(2026, 10, 25, 8));
      expect(utc, DateTime.utc(2026, 10, 25, 7));
    });

    test('a mid-summer reminder stays on CEST', () {
      final DateTime utc = berlin.utcFromLocal(DateTime(2026, 7, 1, 8));
      expect(utc, DateTime.utc(2026, 7, 1, 6));
    });

    test('round-tripping a UTC instant restores the local wall clock', () {
      final DateTime local = berlin.localFromUtc(DateTime.utc(2026, 6, 15, 6));
      expect(
        DateTime(local.year, local.month, local.day, local.hour, local.minute),
        DateTime(2026, 6, 15, 8),
      );
    });

    test('exposes the timezone identifier it was built with', () {
      expect(berlin.timeZoneId, 'Europe/Berlin');
    });
  });

  group('TzLocalTimeConverter — northern vs southern hemisphere', () {
    test('Sydney is on standard time in January and on DST in January-free '
        'July, so the offset flips the other way from Berlin', () {
      final TzLocalTimeConverter sydney =
          TzLocalTimeConverter(tz.getLocation('Australia/Sydney'));

      // AEDT (UTC+11) in January.
      expect(
        sydney.utcFromLocal(DateTime(2026, 1, 15, 8)),
        DateTime.utc(2026, 1, 14, 21),
      );
      // AEST (UTC+10) in July.
      expect(
        sydney.utcFromLocal(DateTime(2026, 7, 15, 8)),
        DateTime.utc(2026, 7, 14, 22),
      );
    });
  });

  group('TimezoneService fallbacks', () {
    test('converterFor an unknown identifier falls back to UTC rather than '
        'throwing', () {
      final converter = TimezoneService.converterFor('Not/AZone');
      expect(converter.timeZoneId, 'UTC');
    });

    test('FixedOffsetConverter applies its offset in both directions', () {
      final FixedOffsetConverter converter = FixedOffsetConverter(
        offset: const Duration(hours: 5),
        name: 'UTC+5',
      );

      expect(
        converter.utcFromLocal(DateTime(2026, 1, 1, 12)),
        DateTime.utc(2026, 1, 1, 7),
      );
      expect(
        converter.localFromUtc(DateTime.utc(2026, 1, 1, 7)),
        DateTime(2026, 1, 1, 12),
      );
    });
  });
}
