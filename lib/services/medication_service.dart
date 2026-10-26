import 'package:uuid/uuid.dart';

import '../domain/models/core_enums.dart';
import '../domain/models/inventory.dart';
import '../domain/models/medication.dart';
import '../domain/repositories/dose_repository.dart';
import '../domain/repositories/inventory_repository.dart';
import '../domain/repositories/medication_repository.dart';
import '../domain/services/medication_validator.dart';
import 'schedule_service.dart';

/// Creates, updates and retires medications.
///
/// All writes go through this service so that a medication, its schedule,
/// its stock and its reminders always move together.
class MedicationService {
  MedicationService({
    required MedicationRepository medicationRepository,
    required InventoryRepository inventoryRepository,
    required DoseRepository doseRepository,
    required ScheduleService scheduleService,
  })  : _medications = medicationRepository,
        _inventory = inventoryRepository,
        _doses = doseRepository,
        _schedule = scheduleService;

  final MedicationRepository _medications;
  final InventoryRepository _inventory;
  final DoseRepository _doses;
  final ScheduleService _schedule;

  static const Uuid _uuid = Uuid();

  /// Saves a new or existing medication together with its schedule and stock.
  ///
  /// Throws [ValidationException] when the data is invalid so that an
  /// incomplete schedule can never reach the database.
  Future<Medication> save({
    required Medication medication,
    required List<SchedulePhase> phases,
    Inventory? inventory,
  }) async {
    final List<SchedulePhase> normalised =
        phases.map(MedicationValidator.normalise).toList(growable: false);

    final ValidationResult result = MedicationValidator.validate(
      medication: medication,
      phases: normalised,
    );
    if (!result.isValid) {
      throw ValidationException(result.errors);
    }

    await _medications.save(medication);
    await _medications.replacePhases(medication.id, normalised);

    if (inventory != null) {
      final Inventory? existing =
          await _inventory.getInventory(medication.id);
      final Inventory saved = existing == null
          ? inventory
          : inventory.copyWith(id: existing.id);
      await _inventory.saveInventory(saved);
    }

    await _schedule.syncMedication(medication, normalised);
    return medication;
  }

  /// Pauses a medication: reminders are cancelled, history is kept.
  Future<void> pause(Medication medication) async {
    await _medications.setStatus(medication.id, MedicationStatus.paused);
    await _schedule.cancelMedicationNotifications(medication.id);
    await _doses.cancelFutureDoses(medication.id, DateTime.now().toUtc());
  }

  /// Resumes a paused medication and rebuilds its reminders.
  Future<void> resume(Medication medication) async {
    await _medications.setStatus(medication.id, MedicationStatus.active);
    final List<SchedulePhase> phases =
        await _medications.getPhases(medication.id);
    await _schedule.syncMedication(
      medication.copyWith(status: MedicationStatus.active),
      phases,
    );
  }

  /// Ends a course. The medication stays in the library as completed.
  Future<void> endTreatment(Medication medication, {DateTime? endDate}) async {
    final DateTime end = endDate ?? DateTime.now();
    await _medications.save(
      medication.copyWith(
        status: MedicationStatus.completed,
        endDate: end,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await _schedule.cancelMedicationNotifications(medication.id);
    await _doses.cancelFutureDoses(medication.id, DateTime.now().toUtc());
  }

  /// Archives a medication without deleting any history.
  Future<void> archive(Medication medication) async {
    await _medications.setStatus(medication.id, MedicationStatus.archived);
    await _schedule.cancelMedicationNotifications(medication.id);
    await _doses.cancelFutureDoses(medication.id, DateTime.now().toUtc());
  }

  /// Deletes a medication.
  ///
  /// Whatever is still ahead (future doses, cancelled doses, reminders, stock)
  /// goes. If the medicine has any history, the medicine itself stays as an
  /// archived record so its past doses remain in the calendar and insights;
  /// removing the row would wipe them with it. A medicine that was never
  /// taken is removed outright.
  Future<void> delete(Medication medication) async {
    await _schedule.cancelMedicationNotifications(medication.id);
    final bool hasHistory =
        await _doses.hasPastActivity(medication.id, DateTime.now());
    if (!hasHistory) {
      await _inventory.deleteInventory(medication.id);
      await _medications.delete(medication.id);
      return;
    }
    await _doses.deleteOpenFutureDoses(medication.id, DateTime.now());
    await _inventory.deleteInventory(medication.id);
    await _medications.setStatus(medication.id, MedicationStatus.archived);
  }

  /// Adds stock to a medication and records the movement.
  ///
  /// Stock is only added when the user confirms the received quantity.
  Future<Inventory> refill({
    required Medication medication,
    required Inventory inventory,
    required double quantity,
    String? note,
    DateTime? expiryDate,
  }) async {
    final double amount = quantity <= 0 ? 0 : quantity;
    final double newQuantity = inventory.quantityOnHand + amount;
    final DateTime now = DateTime.now().toUtc();

    final InventoryTransaction transaction = InventoryTransaction(
      id: _uuid.v4(),
      medicationId: medication.id,
      type: InventoryTransactionType.refill,
      quantityDelta: amount,
      quantityAfter: newQuantity,
      unit: inventory.unit,
      note: note,
      createdAt: now,
    );
    await _inventory.addTransaction(transaction);
    return inventory.copyWith(
      quantityOnHand: newQuantity,
      initialQuantity: amount > 0 && inventory.initialQuantity == 0
          ? newQuantity
          : inventory.initialQuantity,
      lastRefillAt: now,
      expiryDate: expiryDate ?? inventory.expiryDate,
      updatedAt: now,
    );
  }

  /// Manually corrects the stock level and records the adjustment.
  Future<Inventory> adjustStock({
    required Medication medication,
    required Inventory inventory,
    required double newQuantity,
    String? note,
  }) async {
    final double target = newQuantity < 0 ? 0 : newQuantity;
    final double delta = target - inventory.quantityOnHand;
    final DateTime now = DateTime.now().toUtc();

    final InventoryTransaction transaction = InventoryTransaction(
      id: _uuid.v4(),
      medicationId: medication.id,
      type: InventoryTransactionType.adjustment,
      quantityDelta: delta,
      quantityAfter: target,
      unit: inventory.unit,
      note: note,
      createdAt: now,
    );
    await _inventory.addTransaction(transaction);
    return inventory.copyWith(
      quantityOnHand: target,
      initialQuantity: inventory.initialQuantity == 0 && delta > 0
          ? target
          : inventory.initialQuantity,
      updatedAt: now,
    );
  }
}

/// Raised when a medication cannot be saved because it is invalid.
class ValidationException implements Exception {
  ValidationException(this.errors);

  final Map<String, String> errors;

  @override
  String toString() =>
      'ValidationException: ${errors.values.join(' ')}';
}
