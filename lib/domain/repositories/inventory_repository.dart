import '../models/inventory.dart';

/// Persistence contract for inventory and its audit trail.
abstract interface class InventoryRepository {
  Stream<Inventory?> watchInventory(String medicationId);

  Future<Inventory?> getInventory(String medicationId);

  Future<void> saveInventory(Inventory inventory);

  Future<void> deleteInventory(String medicationId);

  Stream<List<InventoryTransaction>> watchTransactions(String medicationId);

  Future<List<InventoryTransaction>> getTransactions(String medicationId);

  Future<void> addTransaction(InventoryTransaction transaction);

  /// Looks up the movement created for a given dose log. Used to make dose
  /// logging idempotent.
  Future<InventoryTransaction?> findTransactionByDoseLog(String doseLogId);
}
