import 'package:drift/drift.dart';

import '../../domain/models/inventory.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../local/app_database.dart';
import '../mappers.dart';

/// Drift-backed implementation of [InventoryRepository].
class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<Inventory?> watchInventory(String medicationId) {
    final SimpleSelectStatement<$InventoriesTable, InventoryRow> query =
        _db.select(_db.inventories)
          ..where(($InventoriesTable t) => t.medicationId.equals(medicationId));
    return query.watchSingleOrNull().map((InventoryRow? row) => row?.toDomain());
  }

  @override
  Future<Inventory?> getInventory(String medicationId) async {
    final InventoryRow? row = await (_db.select(_db.inventories)
          ..where(($InventoriesTable t) => t.medicationId.equals(medicationId)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> saveInventory(Inventory inventory) async {
    await _db
        .into(_db.inventories)
        .insertOnConflictUpdate(inventory.toCompanion());
  }

  @override
  Future<void> deleteInventory(String medicationId) async {
    await (_db.delete(_db.inventories)
          ..where(($InventoriesTable t) => t.medicationId.equals(medicationId)))
        .go();
  }

  @override
  Stream<List<InventoryTransaction>> watchTransactions(
    String medicationId,
  ) {
    final SimpleSelectStatement<$InventoryTransactionsTable,
        InventoryTransactionRow> query = _db.select(_db.inventoryTransactions)
      ..where(($InventoryTransactionsTable t) =>
          t.medicationId.equals(medicationId))
      ..orderBy(<OrderClauseGenerator<$InventoryTransactionsTable>>[
        ($InventoryTransactionsTable t) => OrderingTerm.desc(t.createdAt),
      ]);
    return query.watch().map(
          (List<InventoryTransactionRow> rows) => rows
              .map((InventoryTransactionRow row) => row.toDomain())
              .toList(growable: false),
        );
  }

  @override
  Future<List<InventoryTransaction>> getTransactions(
    String medicationId,
  ) async {
    final List<InventoryTransactionRow> rows =
        await (_db.select(_db.inventoryTransactions)
              ..where(($InventoryTransactionsTable t) =>
                  t.medicationId.equals(medicationId))
              ..orderBy(<OrderClauseGenerator<$InventoryTransactionsTable>>[
                ($InventoryTransactionsTable t) => OrderingTerm.desc(t.createdAt),
              ]))
            .get();
    return rows
        .map((InventoryTransactionRow row) => row.toDomain())
        .toList(growable: false);
  }

  @override
  Future<void> addTransaction(InventoryTransaction transaction) async {
    await _db
        .into(_db.inventoryTransactions)
        .insert(transaction.toCompanion());
  }

  @override
  Future<InventoryTransaction?> findTransactionByDoseLog(
    String doseLogId,
  ) async {
    final InventoryTransactionRow? row =
        await (_db.select(_db.inventoryTransactions)
              ..where(($InventoryTransactionsTable t) =>
                  t.doseLogId.equals(doseLogId)))
            .getSingleOrNull();
    return row?.toDomain();
  }
}
