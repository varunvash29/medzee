import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/services/dose_status_resolver.dart';

void main() {
  final DateTime scheduledAt = DateTime(2026, 3, 10, 8);

  group('DoseStatusResolver.resolve', () {
    test('keeps a dose pending while it is still in the future', () {
      expect(
        DoseStatusResolver.resolve(
          scheduledAt: scheduledAt,
          now: scheduledAt.subtract(const Duration(minutes: 10)),
          current: DoseStatus.pending,
        ),
        DoseStatus.pending,
      );
    });

    test('keeps a dose pending exactly at its scheduled time', () {
      expect(
        DoseStatusResolver.resolve(
          scheduledAt: scheduledAt,
          now: scheduledAt,
          current: DoseStatus.pending,
        ),
        DoseStatus.pending,
      );
    });

    test('keeps a dose pending one minute before the grace window ends', () {
      expect(
        DoseStatusResolver.resolve(
          scheduledAt: scheduledAt,
          now: scheduledAt.add(const Duration(minutes: 59)),
          current: DoseStatus.pending,
        ),
        DoseStatus.pending,
      );
    });

    test('marks a dose missed once the grace window has elapsed', () {
      expect(
        DoseStatusResolver.resolve(
          scheduledAt: scheduledAt,
          now: scheduledAt.add(DoseStatusResolver.defaultGracePeriod),
          current: DoseStatus.pending,
        ),
        DoseStatus.missed,
      );
    });

    test('accepts a custom grace period', () {
      expect(
        DoseStatusResolver.resolve(
          scheduledAt: scheduledAt,
          now: scheduledAt.add(const Duration(minutes: 10)),
          current: DoseStatus.pending,
          gracePeriod: const Duration(minutes: 5),
        ),
        DoseStatus.missed,
      );
    });

    test('never downgrades a dose that already has a recorded status', () {
      for (final DoseStatus status in <DoseStatus>[
        DoseStatus.taken,
        DoseStatus.skipped,
        DoseStatus.missed,
        DoseStatus.cancelled,
      ]) {
        expect(
          DoseStatusResolver.resolve(
            scheduledAt: scheduledAt,
            now: scheduledAt.add(const Duration(days: 3)),
            current: status,
          ),
          status,
          reason: 'a $status dose must keep its status forever',
        );
      }
    });
  });

  group('DoseStatusResolver.isOverdue / isWithinGrace', () {
    test('a future dose is neither overdue nor within grace', () {
      final DateTime now = scheduledAt.subtract(const Duration(minutes: 1));
      expect(
        DoseStatusResolver.isOverdue(scheduledAt: scheduledAt, now: now),
        isFalse,
      );
      expect(
        DoseStatusResolver.isWithinGrace(scheduledAt: scheduledAt, now: now),
        isFalse,
      );
    });

    test('the two predicates are exact complements once due', () {
      for (int minutes = 0; minutes <= 120; minutes += 15) {
        final DateTime now = scheduledAt.add(Duration(minutes: minutes));
        expect(
          DoseStatusResolver.isOverdue(scheduledAt: scheduledAt, now: now),
          isNot(DoseStatusResolver.isWithinGrace(
            scheduledAt: scheduledAt,
            now: now,
          )),
          reason: 'at +$minutes minutes the two must disagree',
        );
      }
    });
  });
}
