import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/core_enums.dart';
import '../domain/models/inventory.dart';
import '../domain/models/medication.dart';
import '../domain/services/inventory_calculator.dart';
import 'medications_provider.dart';
import 'providers.dart';

/// Live stock record for a medication. Emits `null` when none exists.
final StreamProviderFamily<Inventory?, String> inventoryProvider =
    StreamProvider.family<Inventory?, String>(
  (Ref ref, String medicationId) =>
      ref.watch(inventoryRepositoryProvider).watchInventory(medicationId),
);

/// Stock movement audit trail for a medication, newest first.
final StreamProviderFamily<List<InventoryTransaction>, String>
    inventoryTransactionsProvider =
    StreamProvider.family<List<InventoryTransaction>, String>(
  (Ref ref, String medicationId) =>
      ref.watch(inventoryRepositoryProvider).watchTransactions(medicationId),
);

/// Supply projection for a medication, or `null` when there is no stock row.
///
/// The projection refuses to guess when units do not reconcile — that reason
/// is surfaced verbatim by the UI.
final FutureProviderFamily<SupplyProjection?, String>
    supplyProjectionProvider =
    FutureProvider.family<SupplyProjection?, String>(
  (Ref ref, String medicationId) async {
    final Inventory? inventory =
        await ref.watch(inventoryProvider(medicationId).future);
    if (inventory == null) return null;

    final Medication? medication =
        await ref.watch(medicationProvider(medicationId).future);
    if (medication == null) return null;

    final List<SchedulePhase> phases =
        await ref.watch(medicationRepositoryProvider).getPhases(medicationId);

    final DateTime now = DateTime.now();
    return InventoryCalculator.project(
      medication: medication,
      phases: phases,
      quantityOnHand: inventory.quantityOnHand,
      inventoryUnit: inventory.unit,
      today: DateTime(now.year, now.month, now.day),
    );
  },
);

/// Medications whose stock is at or below the refill threshold, or empty.
final Provider<List<Medication>> lowStockMedicationsProvider =
    Provider<List<Medication>>((Ref ref) {
  final List<Medication> medications = ref.watch(medicationsProvider).value ??
      const <Medication>[];
  final List<Medication> result = <Medication>[];
  for (final Medication medication in medications) {
    if (medication.status != MedicationStatus.active) continue;
    final Inventory? inventory =
        ref.watch(inventoryProvider(medication.id)).value;
    if (inventory != null && inventory.isLowStock) {
      result.add(medication);
    }
  }
  return result;
});
