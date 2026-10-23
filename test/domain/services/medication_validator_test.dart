import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/services/medication_validator.dart';

Medication _medication({
  String name = 'Metformin',
  double? strength = 500,
  DateTime? startDate,
  DateTime? endDate,
}) {
  return Medication(
    id: 'med-1',
    name: name,
    strength: strength,
    startDate: startDate,
    endDate: endDate,
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}

SchedulePhase _phase({
  ScheduleKind kind = ScheduleKind.daily,
  DateTime? startDate,
  DateTime? endDate,
  List<int> times = const <int>[8 * 60],
  Set<int> weekdays = const <int>{1},
  List<int> monthlyDays = const <int>[1],
  int intervalDays = 1,
  int intervalHours = 8,
  double doseQuantity = 1,
  int order = 0,
}) {
  return SchedulePhase(
    id: 'phase-$order',
    medicationId: 'med-1',
    order: order,
    kind: kind,
    startDate: startDate ?? DateTime(2026, 1, 1),
    endDate: endDate,
    timesMinutes: times,
    weekdays: weekdays,
    monthlyDays: monthlyDays,
    intervalDays: intervalDays,
    intervalHours: intervalHours,
    doseQuantity: doseQuantity,
  );
}

void main() {
  group('MedicationValidator — identity', () {
    test('rejects an empty or blank name', () {
      expect(
        MedicationValidator.validate(
          medication: _medication(name: '   '),
          phases: <SchedulePhase>[_phase()],
        ).errors,
        contains('name'),
      );
    });

    test('rejects a name longer than 80 characters', () {
      expect(
        MedicationValidator.validate(
          medication: _medication(name: 'a' * 81),
          phases: <SchedulePhase>[_phase()],
        ).errors,
        contains('name'),
      );
    });

    test('rejects a negative strength', () {
      expect(
        MedicationValidator.validate(
          medication: _medication(strength: -1),
          phases: <SchedulePhase>[_phase()],
        ).errors,
        contains('strength'),
      );
    });

    test('rejects an end date before the start date', () {
      expect(
        MedicationValidator.validate(
          medication: _medication(
            startDate: DateTime(2026, 2, 1),
            endDate: DateTime(2026, 1, 1),
          ),
          phases: <SchedulePhase>[_phase()],
        ).errors,
        contains('endDate'),
      );
    });

    test('accepts a valid medicine with one daily phase', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[_phase()],
      );
      expect(result.isValid, isTrue, reason: result.errors.toString());
    });
  });

  group('MedicationValidator — schedules', () {
    test('requires at least one schedule', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: const <SchedulePhase>[],
      );
      expect(result.errors, contains('schedule'));
    });

    test('requires a reminder time for scheduled kinds', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[_phase(times: const <int>[])],
      );
      expect(result.errors, contains('phase0.times'));
    });

    test('rejects reminder times outside a single day', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[_phase(times: const <int>[1440])],
      );
      expect(result.errors, contains('phase0.times'));
    });

    test('rejects an as-needed phase that has fixed times', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(kind: ScheduleKind.asNeeded, times: const <int>[480]),
        ],
      );
      expect(result.errors, contains('phase0.times'));
    });

    test('accepts an as-needed phase with no times', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(kind: ScheduleKind.asNeeded, times: const <int>[]),
        ],
      );
      expect(result.isValid, isTrue, reason: result.errors.toString());
    });

    test('requires weekdays for a weekly phase', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(kind: ScheduleKind.weekly, weekdays: const <int>{}),
        ],
      );
      expect(result.errors, contains('phase0.weekdays'));
    });

    test('rejects an invalid weekday number', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(kind: ScheduleKind.weekly, weekdays: const <int>{0}),
        ],
      );
      expect(result.errors, contains('phase0.weekdays'));
    });

    test('requires a positive interval for every-N-days', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(kind: ScheduleKind.everyNDays, intervalDays: 0),
        ],
      );
      expect(result.errors, contains('phase0.intervalDays'));
    });

    test('requires an interval between 1 and 24 hours for every-N-hours', () {
      final ValidationResult tooLong = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(kind: ScheduleKind.everyNHours, intervalHours: 25),
        ],
      );
      expect(tooLong.errors, contains('phase0.intervalHours'));

      final ValidationResult ok = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(kind: ScheduleKind.everyNHours, intervalHours: 24),
        ],
      );
      expect(ok.isValid, isTrue, reason: ok.errors.toString());
    });

    test('requires at least one day of the month for monthly phases', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(kind: ScheduleKind.monthly, monthlyDays: const <int>[]),
        ],
      );
      expect(result.errors, contains('phase0.monthlyDays'));
    });

    test('rejects a non-positive dose quantity', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[_phase(doseQuantity: 0)],
      );
      expect(result.errors, contains('phase0.quantity'));
    });

    test('rejects a phase that ends before it starts', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(
            startDate: DateTime(2026, 2, 1),
            endDate: DateTime(2026, 1, 1),
          ),
        ],
      );
      expect(result.errors, contains('phase0.endDate'));
    });

    test('rejects overlapping phases', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(
            order: 0,
            startDate: DateTime(2026, 1, 1),
            endDate: DateTime(2026, 1, 10),
          ),
          _phase(
            order: 1,
            startDate: DateTime(2026, 1, 5),
            endDate: DateTime(2026, 1, 20),
          ),
        ],
      );
      expect(result.errors, contains('phase1.startDate'));
    });

    test('accepts back-to-back phases that touch but do not overlap', () {
      final ValidationResult result = MedicationValidator.validate(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(
            order: 0,
            startDate: DateTime(2026, 1, 1),
            endDate: DateTime(2026, 1, 10),
          ),
          _phase(
            order: 1,
            startDate: DateTime(2026, 1, 11),
            endDate: DateTime(2026, 1, 20),
          ),
        ],
      );
      expect(result.isValid, isTrue, reason: result.errors.toString());
    });
  });

  group('MedicationValidator.normalise', () {
    test('drops out-of-range times, sorts and de-duplicates', () {
      final SchedulePhase normalised = MedicationValidator.normalise(
        _phase(times: const <int>[1200, 480, -5, 480, 2000]),
      );
      expect(normalised.timesMinutes, <int>[480, 1200]);
    });

    test('clamps an impossible interval and a non-positive quantity', () {
      final SchedulePhase normalised = MedicationValidator.normalise(
        _phase(intervalDays: 0, intervalHours: 99, doseQuantity: -3),
      );
      expect(normalised.intervalDays, 1);
      expect(normalised.intervalHours, 24);
      expect(normalised.doseQuantity, 1);
    });

    test('filters invalid weekdays and month days', () {
      final SchedulePhase normalised = MedicationValidator.normalise(
        _phase(weekdays: const <int>{0, 1, 8}, monthlyDays: const <int>[0, 5, 32]),
      );
      expect(normalised.weekdays, <int>{1});
      expect(normalised.monthlyDays, <int>[5]);
    });
  });

  group('MedicationValidator.summarise', () {
    test('renders 24 hour times in two-digit form', () {
      expect(
        MedicationValidator.summarise(
          _phase(kind: ScheduleKind.daily, times: const <int>[8 * 60, 20 * 60 + 30]),
        ),
        'Every day at 08:00, 20:30',
      );
    });
  });
}
