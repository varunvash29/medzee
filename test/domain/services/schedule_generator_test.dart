import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/services/schedule_generator.dart';

/// Helpers for building phases tersely in tests.
SchedulePhase _phase({
  required ScheduleKind kind,
  required DateTime startDate,
  DateTime? endDate,
  List<int> times = const <int>[8 * 60],
  Set<int> weekdays = const <int>{},
  List<int> monthlyDays = const <int>[],
  int intervalDays = 1,
  int intervalHours = 8,
  double doseQuantity = 1,
  DoseUnit unit = DoseUnit.tablet,
  bool isActive = true,
  String id = 'phase-1',
}) {
  return SchedulePhase(
    id: id,
    medicationId: 'med-1',
    order: 0,
    kind: kind,
    startDate: startDate,
    endDate: endDate,
    timesMinutes: times,
    weekdays: weekdays,
    monthlyDays: monthlyDays,
    intervalDays: intervalDays,
    intervalHours: intervalHours,
    doseQuantity: doseQuantity,
    unit: unit,
    isActive: isActive,
  );
}

String _at(DoseOccurrence occurrence) =>
    '${occurrence.localDate.year}-${occurrence.localDate.month.toString().padLeft(2, '0')}-'
    '${occurrence.localDate.day.toString().padLeft(2, '0')} '
    '${(occurrence.minutes ~/ 60).toString().padLeft(2, '0')}:'
    '${(occurrence.minutes % 60).toString().padLeft(2, '0')}';

void main() {
  group('ScheduleGenerator — daily', () {
    test('expands every day at every listed time, inclusive of both ends',
        () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 1, 1),
        times: const <int>[8 * 60, 20 * 60],
      );

      final List<DoseOccurrence> result = ScheduleGenerator.occurrencesForPhase(
        phase,
        from: DateTime(2026, 1, 1),
        to: DateTime(2026, 1, 3),
      );

      expect(
        result.map(_at).toList(),
        <String>[
          '2026-01-01 08:00',
          '2026-01-01 20:00',
          '2026-01-02 08:00',
          '2026-01-02 20:00',
          '2026-01-03 08:00',
          '2026-01-03 20:00',
        ],
      );
    });

    test('never schedules before the phase start date', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 1, 5),
      );

      final List<DoseOccurrence> result = ScheduleGenerator.occurrencesForPhase(
        phase,
        from: DateTime(2026, 1, 1),
        to: DateTime(2026, 1, 10),
      );

      expect(result.first.localDate, DateTime(2026, 1, 5));
      expect(result, hasLength(6)); // 5th..10th inclusive.
    });

    test('stops at an inclusive end date', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 3),
      );

      final List<DoseOccurrence> result = ScheduleGenerator.occurrencesForPhase(
        phase,
        from: DateTime(2026, 1, 1),
        to: DateTime(2026, 1, 31),
      );

      expect(result, hasLength(3));
      expect(result.last.localDate, DateTime(2026, 1, 3));
    });

    test('returns nothing when the range lies entirely outside the phase',
        () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 2, 1),
        endDate: DateTime(2026, 2, 10),
      );

      expect(
        ScheduleGenerator.occurrencesForPhase(
          phase,
          from: DateTime(2026, 1, 1),
          to: DateTime(2026, 1, 31),
        ),
        isEmpty,
      );
    });
  });

  group('ScheduleGenerator — weekly / custom', () {
    test('only fires on the selected weekdays', () {
      // 2026-01-05 is a Monday; weekdays 1 = Mon, 3 = Wed.
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.weekly,
        startDate: DateTime(2026, 1, 5),
        weekdays: const <int>{1, 3},
        times: const <int>[9 * 60],
      );

      final List<DoseOccurrence> result = ScheduleGenerator.occurrencesForPhase(
        phase,
        from: DateTime(2026, 1, 5),
        to: DateTime(2026, 1, 11),
      );

      expect(
        result.map(_at).toList(),
        <String>['2026-01-05 09:00', '2026-01-07 09:00'],
      );
    });

    test('an empty weekday set means every day (documented fallback)', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.custom,
        startDate: DateTime(2026, 1, 5),
        weekdays: const <int>{},
      );

      expect(
        ScheduleGenerator.occurrencesForPhase(
          phase,
          from: DateTime(2026, 1, 5),
          to: DateTime(2026, 1, 7),
        ),
        hasLength(3),
      );
    });
  });

  group('ScheduleGenerator — every N days', () {
    test('anchors the interval on the phase start date', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.everyNDays,
        startDate: DateTime(2026, 1, 1),
        intervalDays: 2,
      );

      final List<DoseOccurrence> result = ScheduleGenerator.occurrencesForPhase(
        phase,
        from: DateTime(2026, 1, 1),
        to: DateTime(2026, 1, 6),
      );

      expect(
        result.map((DoseOccurrence o) => o.localDate.day).toList(),
        <int>[1, 3, 5],
      );
    });

    test('a zero interval is treated as one day, never crashes', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.everyNDays,
        startDate: DateTime(2026, 1, 1),
        intervalDays: 0,
      );

      expect(
        ScheduleGenerator.occurrencesForPhase(
          phase,
          from: DateTime(2026, 1, 1),
          to: DateTime(2026, 1, 3),
        ),
        hasLength(3),
      );
    });
  });

  group('ScheduleGenerator — every N hours', () {
    test('rolls continuously across midnight from the anchor time', () {
      // 08:00 anchor, every 8 hours: 08:00, 16:00, 00:00, 08:00, ...
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.everyNHours,
        startDate: DateTime(2026, 1, 1),
        times: const <int>[8 * 60],
        intervalHours: 8,
      );

      final List<String> result = ScheduleGenerator.occurrencesForPhase(
        phase,
        from: DateTime(2026, 1, 1),
        to: DateTime(2026, 1, 2),
      ).map(_at).toList();

      expect(
        result.take(5).toList(),
        <String>[
          '2026-01-01 08:00',
          '2026-01-01 16:00',
          '2026-01-02 00:00',
          '2026-01-02 08:00',
          '2026-01-02 16:00',
        ],
      );
    });

    test('a 24 hour interval produces one dose per day at the anchor', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.everyNHours,
        startDate: DateTime(2026, 1, 1),
        times: const <int>[22 * 60],
        intervalHours: 24,
      );

      expect(
        ScheduleGenerator.occurrencesForPhase(
          phase,
          from: DateTime(2026, 1, 1),
          to: DateTime(2026, 1, 3),
        ).map(_at).toList(),
        <String>[
          '2026-01-01 22:00',
          '2026-01-02 22:00',
          '2026-01-03 22:00',
        ],
      );
    });

    test('an out-of-range interval is clamped to 24 hours', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.everyNHours,
        startDate: DateTime(2026, 1, 1),
        times: const <int>[8 * 60],
        intervalHours: 48,
      );

      expect(
        ScheduleGenerator.occurrencesForPhase(
          phase,
          from: DateTime(2026, 1, 1),
          to: DateTime(2026, 1, 2),
        ).map(_at).toList(),
        <String>['2026-01-01 08:00', '2026-01-02 08:00'],
      );
    });
  });

  group('ScheduleGenerator — monthly', () {
    test('fires only on the chosen days of the month', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.monthly,
        startDate: DateTime(2026, 1, 1),
        monthlyDays: const <int>[1, 15],
      );

      final List<int> days = ScheduleGenerator.occurrencesForPhase(
        phase,
        from: DateTime(2026, 1, 1),
        to: DateTime(2026, 3, 31),
      ).map((DoseOccurrence o) => o.localDate.day).toList();

      expect(days, <int>[1, 15, 1, 15, 1, 15]);
    });

    test('skips months that do not contain the chosen day', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.monthly,
        startDate: DateTime(2026, 1, 31),
        monthlyDays: const <int>[31],
      );

      final List<DateTime> dates = ScheduleGenerator.occurrencesForPhase(
        phase,
        from: DateTime(2026, 1, 1),
        to: DateTime(2026, 4, 30),
      ).map((DoseOccurrence o) => o.localDate).toList();

      // February and April 2026 have no 31st, so only January and March fire.
      expect(
        dates,
        <DateTime>[DateTime(2026, 1, 31), DateTime(2026, 3, 31)],
      );
    });
  });

  group('ScheduleGenerator — exclusions and edge cases', () {
    test('as-needed phases never materialise scheduled doses', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.asNeeded,
        startDate: DateTime(2026, 1, 1),
      );

      expect(
        ScheduleGenerator.occurrencesForPhase(
          phase,
          from: DateTime(2026, 1, 1),
          to: DateTime(2026, 1, 31),
        ),
        isEmpty,
      );
    });

    test('inactive phases never materialise scheduled doses', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 1, 1),
        isActive: false,
      );

      expect(
        ScheduleGenerator.occurrencesForPhase(
          phase,
          from: DateTime(2026, 1, 1),
          to: DateTime(2026, 1, 31),
        ),
        isEmpty,
      );
    });

    test('a phase that ends before it starts yields nothing', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 1, 10),
        endDate: DateTime(2026, 1, 1),
      );

      expect(
        ScheduleGenerator.occurrencesForPhase(
          phase,
          from: DateTime(2026, 1, 1),
          to: DateTime(2026, 1, 31),
        ),
        isEmpty,
      );
    });

    test('dose quantity and unit are carried onto every occurrence', () {
      final SchedulePhase phase = _phase(
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 1, 1),
        doseQuantity: 2.5,
        unit: DoseUnit.capsule,
      );

      final DoseOccurrence first = ScheduleGenerator.occurrencesForPhase(
        phase,
        from: DateTime(2026, 1, 1),
        to: DateTime(2026, 1, 1),
      ).single;

      expect(first.doseQuantity, 2.5);
      expect(first.unit, DoseUnit.capsule);
    });
  });

  group('ScheduleGenerator — multiple phases', () {
    test('merges and sorts all phases chronologically', () {
      final SchedulePhase morning = _phase(
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 1, 1),
        times: const <int>[8 * 60],
        id: 'morning',
      );
      final SchedulePhase evening = _phase(
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 1, 2),
        times: const <int>[22 * 60],
        id: 'evening',
      );

      final List<DoseOccurrence> result = ScheduleGenerator.occurrences(
        phases: <SchedulePhase>[evening, morning],
        from: DateTime(2026, 1, 1),
        to: DateTime(2026, 1, 2),
      );

      expect(
        result.map(_at).toList(),
        <String>[
          '2026-01-01 08:00',
          '2026-01-02 08:00',
          '2026-01-02 22:00',
        ],
      );
    });
  });

  group('ScheduleGenerator.describe', () {
    test('describes the common kinds in plain language', () {
      expect(
        ScheduleGenerator.describe(
          _phase(kind: ScheduleKind.daily, startDate: DateTime(2026, 1, 1)),
        ),
        'Every day at 8:00 AM',
      );
      expect(
        ScheduleGenerator.describe(
          _phase(
            kind: ScheduleKind.everyNDays,
            startDate: DateTime(2026, 1, 1),
            intervalDays: 2,
          ),
        ),
        'Every other day at 8:00 AM',
      );
      expect(
        ScheduleGenerator.describe(
          _phase(
            kind: ScheduleKind.weekly,
            startDate: DateTime(2026, 1, 5),
            weekdays: const <int>{1, 5},
          ),
        ),
        'Mon, Fri at 8:00 AM',
      );
      expect(
        ScheduleGenerator.describe(
          _phase(kind: ScheduleKind.asNeeded, startDate: DateTime(2026, 1, 1)),
        ),
        'Take as needed',
      );
    });

    test('a custom time formatter is honoured', () {
      expect(
        ScheduleGenerator.describe(
          _phase(kind: ScheduleKind.daily, startDate: DateTime(2026, 1, 1)),
          formatTime: (int minutes) => '${minutes ~/ 60}h',
        ),
        'Every day at 8h',
      );
    });
  });
}
