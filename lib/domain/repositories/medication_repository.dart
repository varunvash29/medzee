import '../models/core_enums.dart';
import '../models/medication.dart';

/// Persistence contract for medications and their schedules.
abstract interface class MedicationRepository {
  /// All medications, newest first.
  Stream<List<Medication>> watchAll();

  /// Medications filtered by lifecycle status.
  Stream<List<Medication>> watchByStatus(MedicationStatus status);

  /// A single medication, or null when it no longer exists.
  Stream<Medication?> watchById(String id);

  Future<Medication?> getById(String id);

  Future<List<Medication>> getAll();

  /// Creates or updates a medication.
  Future<void> save(Medication medication);

  /// Removes a medication and everything attached to it.
  Future<void> delete(String id);

  /// Updates the lifecycle status without touching history.
  Future<void> setStatus(String id, MedicationStatus status);

  /// Phases of a medication, ordered by phase order.
  Stream<List<SchedulePhase>> watchPhases(String medicationId);

  Future<List<SchedulePhase>> getPhases(String medicationId);

  /// Replaces every phase of a medication in a single transaction.
  Future<void> replacePhases(String medicationId, List<SchedulePhase> phases);

  /// All phases for every medication (used by the scheduler and insights).
  Future<List<SchedulePhase>> getAllPhases();
}
