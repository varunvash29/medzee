import 'package:uuid/uuid.dart';

import '../domain/models/core_enums.dart';
import '../domain/models/dose.dart';
import '../domain/models/inventory.dart';
import '../domain/models/medication.dart';
import '../domain/repositories/dose_repository.dart';
import '../domain/repositories/inventory_repository.dart';

/// The outcome of logging a dose.
class DoseLogResult {
  const DoseLogResult({
    required this.log,
    required this.inventoryAdjusted,
    this.stockMessage,
    this.wasAlreadyRecorded = false,
  });

  final DoseLog? log;

  /// Whether stock was changed by this action.
  final bool inventoryAdjusted;

  /// A short explanation shown to the user, e.g. "28 tablets left".
  final String? stockMessage;

  /// True when the dose had already been recorded and nothing changed.
  final bool wasAlreadyRecorded;
}

/// Records what the user did with a dose and keeps stock in step.
///
/// Every action is idempotent: tapping "Mark as taken" twice deducts the
/// stock once. Corrections never delete history — the previous log is kept
/// and a reversing stock movement is written.
class DoseService {
  DoseService({
    required DoseRepository doseRepository,
    required InventoryRepository inventoryRepository,
  })  : _doses = doseRepository,
        _inventory = inventoryRepository;

  final DoseRepository _doses;
  final InventoryRepository _inventory;

  static const Uuid _uuid = Uuid();

  /// Guards against two concurrent taps on the same dose.
  final Set<String> _inFlight = <String>{};

  /// Marks a dose as taken, deducting stock when that is safe to do.
  Future<DoseLogResult> markTaken(
    ScheduledDose dose,
    Medication medication, {
    double? amount,
    String? note,
  }) {
    return _record(
      dose,
      medication,
      DoseStatus.taken,
      amount: amount ?? dose.doseQuantity,
      note: note,
    );
  }

  /// Marks a dose as intentionally skipped. Stock is not changed.
  Future<DoseLogResult> markSkipped(
    ScheduledDose dose,
    Medication medication, {
    String? note,
  }) {
    return _record(
      dose,
      medication,
      DoseStatus.skipped,
      amount: null,
      note: note,
    );
  }

  /// Marks a dose as missed. Stock is not changed.
  Future<DoseLogResult> markMissed(
    ScheduledDose dose,
    Medication medication, {
    String? note,
  }) {
    return _record(
      dose,
      medication,
      DoseStatus.missed,
      amount: null,
      note: note,
    );
  }

  /// Returns a dose to the pending state and reverses any stock movement.
  Future<DoseLogResult> undo(ScheduledDose dose, Medication medication) async {
    final DoseLog? existing = await _doses.getActiveLog(dose.id);
    if (existing == null) {
      await _doses.setStatus(dose.id, DoseStatus.pending);
      return const DoseLogResult(
        log: null,
        inventoryAdjusted: false,
        wasAlreadyRecorded: true,
      );
    }
    final bool reversed = await _reverseStock(existing);
    await _doses.addLog(
      existing.copyWith(
        id: _uuid.v4(),
        status: DoseStatus.pending,
        actedAt: DateTime.now().toUtc(),
        amountTaken: null,
        clearAmountTaken: true,
        clearNote: true,
        clearInventoryTransactionId: true,
        supersedesLogId: existing.id,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    await _doses.setStatus(dose.id, DoseStatus.pending);
    return DoseLogResult(
      log: existing,
      inventoryAdjusted: reversed,
      stockMessage: reversed ? 'Stock adjusted' : null,
    );
  }

  Future<DoseLogResult> _record(
    ScheduledDose dose,
    Medication medication,
    DoseStatus status, {
    double? amount,
    String? note,
  }) async {
    final String key = dose.id;
    if (_inFlight.contains(key)) {
      // A second tap arrived while the first is still being written.
      final DoseLog? current = await _doses.getActiveLog(dose.id);
      if (current != null) {
        return DoseLogResult(
          log: current,
          inventoryAdjusted: false,
          wasAlreadyRecorded: true,
        );
      }
    }
    _inFlight.add(key);
    try {
      final DoseLog? existing = await _doses.getActiveLog(dose.id);
      if (existing != null && existing.status == status) {
        // Already recorded with the same outcome: nothing to do.
        return DoseLogResult(
          log: existing,
          inventoryAdjusted: false,
          wasAlreadyRecorded: true,
        );
      }

      // If the previous log consumed stock, put it back before recording
      // the new outcome.
      bool reversed = false;
      if (existing != null && existing.status == DoseStatus.taken) {
        reversed = await _reverseStock(existing);
      }

      final DoseLog log = DoseLog(
        id: _uuid.v4(),
        medicationId: medication.id,
        scheduledDoseId: dose.id,
        status: status,
        scheduledAt: dose.scheduledAt,
        actedAt: DateTime.now().toUtc(),
        amountTaken: status == DoseStatus.taken ? amount : null,
        unit: status == DoseStatus.taken ? dose.unit : null,
        note: note,
        supersedesLogId: existing?.id,
        createdAt: DateTime.now().toUtc(),
      );

      await _doses.addLog(log);
      await _doses.setStatus(dose.id, status);

      bool adjusted = false;
      String? stockMessage;
      if (status == DoseStatus.taken) {
        final _StockOutcome outcome = await _deductStock(log, dose);
        adjusted = outcome.adjusted;
        stockMessage = outcome.message;
      }

      return DoseLogResult(
        log: log,
        inventoryAdjusted: adjusted || reversed,
        stockMessage: stockMessage,
      );
    } finally {
      _inFlight.remove(key);
    }
  }

  /// Deducts the dose from stock.
  ///
  /// The deduction is skipped (rather than guessed) when the inventory unit
  /// does not match the dosing unit, or when the amount is not a whole
  /// countable unit. The user is then asked to adjust the stock manually.
  Future<_StockOutcome> _deductStock(DoseLog log, ScheduledDose dose) async {
    final Inventory? inventory =
        await _inventory.getInventory(log.medicationId);
    if (inventory == null) {
      return const _StockOutcome(false, null);
    }
    if (inventory.unit != log.unit) {
      return const _StockOutcome(
        false,
        'Stock is in different units — adjust it manually.',
      );
    }
    final double amount = log.amountTaken ?? dose.doseQuantity;
    if (amount <= 0) {
      return const _StockOutcome(false, null);
    }
    if (!inventory.unit.isDiscrete && amount % 1 != 0) {
      return const _StockOutcome(
        false,
        'Partial dose — adjust the stock manually.',
      );
    }

    // Idempotency guard: a movement for this log already exists.
    final InventoryTransaction? existing =
        await _inventory.findTransactionByDoseLog(log.id);
    if (existing != null) {
      return _StockOutcome(false, null);
    }

    // Stock cannot go below zero. Clamp once, up front, so the saved stock,
    // the transaction's quantityAfter and its delta always agree with each
    // other (the dose log still records what was actually taken).
    final double newQuantity = inventory.quantityOnHand - amount;
    final double clampedQuantity = newQuantity < 0 ? 0 : newQuantity;
    final InventoryTransaction transaction = InventoryTransaction(
      id: _uuid.v4(),
      medicationId: log.medicationId,
      type: InventoryTransactionType.deduction,
      quantityDelta: clampedQuantity - inventory.quantityOnHand,
      quantityAfter: clampedQuantity,
      unit: inventory.unit,
      doseLogId: log.id,
      note: 'Dose recorded',
      createdAt: DateTime.now().toUtc(),
    );
    await _inventory.addTransaction(transaction);
    await _inventory.saveInventory(
      inventory.copyWith(
        quantityOnHand: clampedQuantity,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    return _StockOutcome(
      true,
      '${_formatQuantity(clampedQuantity)} '
      '${inventory.unit.singular} left',
    );
  }

  /// Puts stock back when a taken dose is corrected.
  Future<bool> _reverseStock(DoseLog log) async {
    if (log.id.isEmpty) return false;
    final InventoryTransaction? original =
        await _inventory.findTransactionByDoseLog(log.id);
    if (original == null) return false;

    final Inventory? inventory = await _inventory.getInventory(log.medicationId);
    if (inventory == null) return false;

    final double amount = -original.quantityDelta;
    final double newQuantity = inventory.quantityOnHand + amount;
    final InventoryTransaction reversal = InventoryTransaction(
      id: _uuid.v4(),
      medicationId: log.medicationId,
      type: InventoryTransactionType.reversal,
      quantityDelta: amount,
      quantityAfter: newQuantity,
      unit: inventory.unit,
      note: 'Dose record corrected',
      createdAt: DateTime.now().toUtc(),
    );
    await _inventory.addTransaction(reversal);
    await _inventory.saveInventory(
      inventory.copyWith(
        quantityOnHand: newQuantity,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    return true;
  }

  String _formatQuantity(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toStringAsFixed(1);
}

class _StockOutcome {
  const _StockOutcome(this.adjusted, this.message);
  final bool adjusted;
  final String? message;
}
