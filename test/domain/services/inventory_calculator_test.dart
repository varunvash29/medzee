import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/services/inventory_calculator.dart';

Medication _medication({bool isAsNeeded = false}) {
  return Medication(
    id: 'med-1',
    name: 'Metformin',
    isAsNeeded: isAsNeeded,
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}

SchedulePhase _phase({
  ScheduleKind kind = ScheduleKind.daily,
  List<int> times = const <int>[8 * 60, 20 * 60],
  Set<int> weekdays = const <int>{},
  int intervalDays = 1,
  int intervalHours = 8,
  List<int> monthlyDays = const <int>[1],
  double doseQuantity = 1,
  DoseUnit unit = DoseUnit.tablet,
}) {
  return SchedulePhase(
    id: 'phase-1',
    medicationId: 'med-1',
    order: 0,
    kind: kind,
    startDate: DateTime(2026, 1, 1),
    timesMinutes: times,
    weekdays: weekdays,
    intervalDays: intervalDays,
    intervalHours: intervalHours,
    monthlyDays: monthlyDays,
    doseQuantity: doseQuantity,
    unit: unit,
  );
}

void main() {
  group('InventoryCalculator.dosesPerDay', () {
    test('daily counts the listed times', () {
      expect(InventoryCalculator.dosesPerDay(<SchedulePhase>[_phase()]), 2);
    });

    test('weekly scales the daily count by the fraction of days chosen', () {
      // 2 times on 3 of 7 days.
      expect(
        InventoryCalculator.dosesPerDay(<SchedulePhase>[
          _phase(
            kind: ScheduleKind.weekly,
            weekdays: const <int>{1, 3, 5},
          ),
        ]),
        closeTo(2 * 3 / 7, 1e-9),
      );
    });

    test('every-N-days divides the daily count by the interval', () {
      expect(
        InventoryCalculator.dosesPerDay(<SchedulePhase>[
          _phase(kind: ScheduleKind.everyNDays, intervalDays: 2),
        ]),
        1,
      );
    });

    test('every-N-hours is 24 divided by the interval', () {
      expect(
        InventoryCalculator.dosesPerDay(<SchedulePhase>[
          _phase(kind: ScheduleKind.everyNHours, intervalHours: 6),
        ]),
        4,
      );
    });

    test('monthly scales by the number of chosen days over 30', () {
      expect(
        InventoryCalculator.dosesPerDay(<SchedulePhase>[
          _phase(kind: ScheduleKind.monthly, monthlyDays: const <int>[1, 15]),
        ]),
        closeTo(2 * 2 / 30, 1e-9),
      );
    });

    test('as-needed phases contribute nothing', () {
      expect(
        InventoryCalculator.dosesPerDay(<SchedulePhase>[
          _phase(kind: ScheduleKind.asNeeded),
        ]),
        0,
      );
    });

    test('inactive phases contribute nothing', () {
      expect(
        InventoryCalculator.dosesPerDay(<SchedulePhase>[
          _phase().copyWith(isActive: false),
        ]),
        0,
      );
    });

    test('an empty phase list is zero, not an error', () {
      expect(InventoryCalculator.dosesPerDay(const <SchedulePhase>[]), 0);
    });
  });

  group('InventoryCalculator.project', () {
    final DateTime today = DateTime(2026, 3, 1);

    test('projects days remaining from daily consumption', () {
      // 2 doses/day of 1 tablet = 2/day; 30 on hand = 15 days.
      final SupplyProjection projection = InventoryCalculator.project(
        medication: _medication(),
        phases: <SchedulePhase>[_phase()],
        quantityOnHand: 30,
        inventoryUnit: DoseUnit.tablet,
        today: today,
      );

      expect(projection.canCalculate, isTrue);
      expect(projection.dailyConsumption, 2);
      expect(projection.daysRemaining, 15);
      expect(projection.runOutDate, DateTime(2026, 3, 16));
    });

    test('multiplies by the dose size, not just the dose count', () {
      final SupplyProjection projection = InventoryCalculator.project(
        medication: _medication(),
        phases: <SchedulePhase>[_phase(doseQuantity: 2)],
        quantityOnHand: 20,
        inventoryUnit: DoseUnit.tablet,
        today: today,
      );

      expect(projection.dailyConsumption, 4);
      expect(projection.daysRemaining, 5);
    });

    test('refuses to guess when the stock unit and the dose unit differ', () {
      // Stock counted in whole tablets, doses measured in mL: no safe
      // conversion exists, so the calculator must decline rather than invent
      // one.
      final SupplyProjection projection = InventoryCalculator.project(
        medication: _medication(),
        phases: <SchedulePhase>[_phase(unit: DoseUnit.millilitre)],
        quantityOnHand: 30,
        inventoryUnit: DoseUnit.tablet,
        today: today,
      );

      expect(projection.canCalculate, isFalse);
      expect(projection.reason, contains('will not convert'));
      expect(projection.daysRemaining, isNull);
    });

    test('refuses to estimate as-needed consumption', () {
      final SupplyProjection projection = InventoryCalculator.project(
        medication: _medication(isAsNeeded: true),
        phases: <SchedulePhase>[
          _phase(kind: ScheduleKind.asNeeded, times: const <int>[]),
        ],
        quantityOnHand: 30,
        inventoryUnit: DoseUnit.tablet,
        today: today,
      );

      expect(projection.canCalculate, isFalse);
      expect(projection.reason, contains('As-needed'));
    });

    test('reports no stock rather than dividing by zero', () {
      final SupplyProjection projection = InventoryCalculator.project(
        medication: _medication(),
        phases: <SchedulePhase>[_phase()],
        quantityOnHand: 0,
        inventoryUnit: DoseUnit.tablet,
        today: today,
      );

      expect(projection.canCalculate, isFalse);
      expect(projection.reason, contains('No stock recorded'));
    });

    test('refuses when there is no fixed schedule to measure against', () {
      final SupplyProjection projection = InventoryCalculator.project(
        medication: _medication(),
        phases: const <SchedulePhase>[],
        quantityOnHand: 30,
        inventoryUnit: DoseUnit.tablet,
        today: today,
      );

      expect(projection.canCalculate, isFalse);
      expect(projection.reason, contains('no fixed schedule'));
    });

    test('floors a fractional day count instead of rounding up', () {
      // 3 doses/day, 10 on hand = 3.33 days -> 3 whole days.
      final SupplyProjection projection = InventoryCalculator.project(
        medication: _medication(),
        phases: <SchedulePhase>[
          _phase(times: const <int>[8 * 60, 14 * 60, 20 * 60]),
        ],
        quantityOnHand: 10,
        inventoryUnit: DoseUnit.tablet,
        today: today,
      );

      expect(projection.daysRemaining, 3);
    });
  });
}
