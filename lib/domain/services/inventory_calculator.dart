import '../models/core_enums.dart';
import '../models/medication.dart';

/// A projection of how long the current stock will last.
class SupplyProjection {
  const SupplyProjection({
    required this.canCalculate,
    required this.quantityOnHand,
    required this.unit,
    required this.dailyConsumption,
    required this.daysRemaining,
    required this.runOutDate,
    this.reason,
  });

  /// False when the schedule and the inventory unit cannot be reconciled.
  final bool canCalculate;
  final double quantityOnHand;
  final DoseUnit unit;

  /// Average quantity consumed per day according to the schedule.
  final double dailyConsumption;

  /// Whole days of supply left, or null when it cannot be calculated.
  final int? daysRemaining;

  /// The date the stock is expected to run out, or null.
  final DateTime? runOutDate;

  /// Why the projection is unavailable.
  final String? reason;

  static SupplyProjection unavailable({
    required double quantityOnHand,
    required DoseUnit unit,
    required String reason,
  }) =>
      SupplyProjection(
        canCalculate: false,
        quantityOnHand: quantityOnHand,
        unit: unit,
        dailyConsumption: 0,
        daysRemaining: null,
        runOutDate: null,
        reason: reason,
      );
}

/// Estimates how long a medicine's stock will last.
///
/// The projection is only produced when the inventory unit and the dosing
/// unit genuinely reconcile. When they do not — for example a liquid tracked
/// in "bottles" but dosed in "mL" — Medzee refuses to guess and asks the
/// user for a manual adjustment instead.
abstract final class InventoryCalculator {
  /// Average number of doses scheduled per day for the supplied phases.
  static double dosesPerDay(List<SchedulePhase> phases) {
    if (phases.isEmpty) return 0;
    double total = 0;
    for (final SchedulePhase phase in phases) {
      if (!phase.isActive || phase.kind.isAsNeeded) continue;
      switch (phase.kind) {
        case ScheduleKind.daily:
          total += phase.timesMinutes.length;
        case ScheduleKind.weekly:
        case ScheduleKind.custom:
          final int days = phase.weekdays.isEmpty ? 7 : phase.weekdays.length;
          total += phase.timesMinutes.length * (days / 7);
        case ScheduleKind.everyNDays:
          final int interval = phase.intervalDays < 1 ? 1 : phase.intervalDays;
          total += phase.timesMinutes.length / interval;
        case ScheduleKind.everyNHours:
          final int hours = phase.intervalHours < 1 ? 1 : phase.intervalHours;
          total += 24 / hours;
        case ScheduleKind.monthly:
          total += phase.timesMinutes.length * (phase.monthlyDays.length / 30);
        case ScheduleKind.asNeeded:
          break;
      }
    }
    return total;
  }

  /// Builds a supply projection for [medication] given its [phases].
  static SupplyProjection project({
    required Medication medication,
    required List<SchedulePhase> phases,
    required double quantityOnHand,
    required DoseUnit inventoryUnit,
    required DateTime today,
  }) {
    if (quantityOnHand <= 0) {
      return SupplyProjection.unavailable(
        quantityOnHand: quantityOnHand,
        unit: inventoryUnit,
        reason: 'No stock recorded. Add a refill to see how long it will last.',
      );
    }

    if (medication.isAsNeeded) {
      return SupplyProjection.unavailable(
        quantityOnHand: quantityOnHand,
        unit: inventoryUnit,
        reason: 'As-needed medicines are used unpredictably, so the remaining '
            'supply cannot be estimated automatically.',
      );
    }

    final double perDay = dosesPerDay(phases);
    if (perDay <= 0) {
      return SupplyProjection.unavailable(
        quantityOnHand: quantityOnHand,
        unit: inventoryUnit,
        reason: 'This medicine has no fixed schedule, so consumption cannot be '
            'estimated.',
      );
    }

    final SchedulePhase? reference = phases.where((SchedulePhase p) {
      return p.isActive && !p.kind.isAsNeeded;
    }).firstOrNull;
    final DoseUnit doseUnit = reference?.unit ?? inventoryUnit;

    if (doseUnit != inventoryUnit) {
      return SupplyProjection.unavailable(
        quantityOnHand: quantityOnHand,
        unit: inventoryUnit,
        reason: 'Stock is tracked in ${inventoryUnit.singular} but doses are '
            'measured in ${doseUnit.singular}. Medzee will not convert between '
            'them automatically — adjust the stock manually instead.',
      );
    }

    final double dailyConsumption = perDay * (reference?.doseQuantity ?? 1);
    if (dailyConsumption <= 0) {
      return SupplyProjection.unavailable(
        quantityOnHand: quantityOnHand,
        unit: inventoryUnit,
        reason: 'Dose size is unknown, so consumption cannot be estimated.',
      );
    }

    final double rawDays = quantityOnHand / dailyConsumption;
    final int days = rawDays.floor();
    final DateTime runOut = DateTime(
      today.year,
      today.month,
      today.day + days,
    );

    return SupplyProjection(
      canCalculate: true,
      quantityOnHand: quantityOnHand,
      unit: inventoryUnit,
      dailyConsumption: dailyConsumption,
      daysRemaining: days,
      runOutDate: runOut,
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final Iterator<T> it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
