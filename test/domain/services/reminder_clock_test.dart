import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/services/reminder_clock.dart';
import 'package:medzee/services/timezone_service.dart';

void main() {
  group('ReminderZone.effectiveId', () {
    test('follows the phone when travel mode is off', () {
      expect(
        ReminderZone.effectiveId(
          deviceId: 'Asia/Kolkata',
          homeId: 'America/New_York',
          travelMode: false,
        ),
        'Asia/Kolkata',
      );
    });

    test('holds the home zone when travel mode is on', () {
      expect(
        ReminderZone.effectiveId(
          deviceId: 'Asia/Kolkata',
          homeId: 'America/New_York',
          travelMode: true,
        ),
        'America/New_York',
      );
    });

    test('travel mode with no home zone has nothing to hold: uses the phone',
        () {
      expect(
        ReminderZone.effectiveId(
          deviceId: 'Asia/Kolkata',
          homeId: null,
          travelMode: true,
        ),
        'Asia/Kolkata',
      );
      expect(
        ReminderZone.effectiveId(
          deviceId: 'Asia/Kolkata',
          homeId: '',
          travelMode: true,
        ),
        'Asia/Kolkata',
      );
    });
  });

  group('ReminderZone.isHolding', () {
    test('only when travel mode keeps reminders off the phone\'s zone', () {
      expect(
        ReminderZone.isHolding(
          deviceId: 'Asia/Kolkata',
          homeId: 'America/New_York',
          travelMode: true,
        ),
        isTrue,
      );
      expect(
        ReminderZone.isHolding(
          deviceId: 'America/New_York',
          homeId: 'America/New_York',
          travelMode: true,
        ),
        isFalse,
        reason: 'at home there is nothing to show',
      );
      expect(
        ReminderZone.isHolding(
          deviceId: 'Asia/Kolkata',
          homeId: 'America/New_York',
          travelMode: false,
        ),
        isFalse,
      );
    });
  });

  group('ReminderClock', () {
    test('reads the wall clock and the date in its own zone', () {
      // 23:30 UTC on 25 Oct is 05:00 on the 26th in India (+5:30) and 19:30
      // on the 25th in New York (-4, EDT).
      final DateTime instant = DateTime.utc(2026, 10, 25, 23, 30);
      final ReminderClock india = ReminderClock(
        FixedOffsetConverter(offset: const Duration(hours: 5, minutes: 30)),
        nowUtc: () => instant,
      );
      final ReminderClock newYork = ReminderClock(
        FixedOffsetConverter(offset: const Duration(hours: -4)),
        nowUtc: () => instant,
      );

      expect(india.today(), DateTime(2026, 10, 26));
      expect(india.minutesOfDay, 5 * 60);
      expect(newYork.today(), DateTime(2026, 10, 25));
      expect(newYork.minutesOfDay, 19 * 60 + 30);
    });

    test('wallClock converts any instant', () {
      final ReminderClock clock = ReminderClock(
        FixedOffsetConverter(offset: const Duration(hours: 2)),
        nowUtc: () => DateTime.utc(2026, 1, 1),
      );
      final DateTime w = clock.wallClock(DateTime.utc(2026, 6, 1, 22));
      expect(w, DateTime(2026, 6, 2, 0));
    });
  });
}
