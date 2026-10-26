import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/dose.dart';
import 'package:medzee/domain/models/inventory.dart';
import 'package:medzee/domain/repositories/dose_repository.dart';
import 'package:medzee/domain/repositories/inventory_repository.dart';

/// In-memory [DoseRepository] that keeps only what [DoseService] touches,
/// with real supersede semantics so idempotency can be observed.
class FakeDoseRepository implements DoseRepository {
  final List<DoseLog> logs = <DoseLog>[];
  final Map<String, DoseStatus> statuses = <String, DoseStatus>{};

  @override
  Future<DoseLog?> getActiveLog(String scheduledDoseId) async {
    for (final DoseLog log in logs.reversed) {
      if (log.scheduledDoseId == scheduledDoseId) return log;
    }
    return null;
  }

  @override
  Future<void> addLog(DoseLog log, {bool supersedeExisting = true}) async {
    logs.add(log);
  }

  @override
  Future<void> setStatus(String doseId, DoseStatus status) async {
    statuses[doseId] = status;
  }

  @override
  Stream<List<ScheduledDose>> watchDosesForDate(DateTime localDate) =>
      const Stream<List<ScheduledDose>>.empty();

  @override
  Stream<List<ScheduledDose>> watchDosesInRange(DateTime from, DateTime to) =>
      const Stream<List<ScheduledDose>>.empty();

  @override
  Future<List<ScheduledDose>> getDosesInRange(DateTime from, DateTime to) =>
      Future<List<ScheduledDose>>.value(const <ScheduledDose>[]);

  @override
  Future<List<ScheduledDose>> getUpcomingDoses(
    String medicationId, {
    required DateTime after,
    int limit = 50,
  }) =>
      Future<List<ScheduledDose>>.value(const <ScheduledDose>[]);

  @override
  Future<void> insertDoses(List<ScheduledDose> doses) async {}

  @override
  Future<bool> hasPastActivity(String medicationId, DateTime now) async =>
      logs.isNotEmpty;

  @override
  Future<int> deleteOpenFutureDoses(String medicationId, DateTime from) async =>
      0;

  @override
  Future<int> deleteDoses(Iterable<String> doseIds) async => doseIds.length;

  @override
  Future<int> cancelFutureDoses(String medicationId, DateTime from) async => 0;

  @override
  Stream<List<DoseLog>> watchLogs(String medicationId) =>
      const Stream<List<DoseLog>>.empty();

  @override
  Future<List<DoseLog>> getLogsInRange(DateTime from, DateTime to) =>
      Future<List<DoseLog>>.value(logs);

  @override
  Stream<List<DoseLog>> watchAllLogs() => Stream<List<DoseLog>>.value(logs);

  @override
  Future<int> countByStatus(String medicationId, DoseStatus status) async =>
      logs.where((DoseLog l) => l.status == status).length;
}

/// In-memory [InventoryRepository] with the unique-doseLogId behaviour the
/// idempotency guard relies on.
class FakeInventoryRepository implements InventoryRepository {
  Inventory? inventory;
  final List<InventoryTransaction> transactions = <InventoryTransaction>[];

  @override
  Future<Inventory?> getInventory(String medicationId) async => inventory;

  @override
  Future<void> saveInventory(Inventory value) async => inventory = value;

  @override
  Future<void> addTransaction(InventoryTransaction transaction) async {
    transactions.add(transaction);
  }

  @override
  Future<InventoryTransaction?> findTransactionByDoseLog(
    String doseLogId,
  ) async {
    for (final InventoryTransaction t in transactions) {
      if (t.doseLogId == doseLogId) return t;
    }
    return null;
  }

  @override
  Stream<Inventory?> watchInventory(String medicationId) =>
      Stream<Inventory?>.value(inventory);

  @override
  Future<void> deleteInventory(String medicationId) async => inventory = null;

  @override
  Stream<List<InventoryTransaction>> watchTransactions(String medicationId) =>
      Stream<List<InventoryTransaction>>.value(transactions);

  @override
  Future<List<InventoryTransaction>> getTransactions(String medicationId) async =>
      transactions;
}
