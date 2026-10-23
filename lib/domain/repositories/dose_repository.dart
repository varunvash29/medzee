import '../models/core_enums.dart';
import '../models/dose.dart';

/// Persistence contract for scheduled dose instances and their logs.
abstract interface class DoseRepository {
  /// Doses scheduled on a specific local calendar date.
  Stream<List<ScheduledDose>> watchDosesForDate(DateTime localDate);

  /// Doses scheduled inside an inclusive date range.
  Stream<List<ScheduledDose>> watchDosesInRange(
    DateTime from,
    DateTime to,
  );

  Future<List<ScheduledDose>> getDosesInRange(DateTime from, DateTime to);

  /// Future doses for a medication, used to show the "next dose".
  Future<List<ScheduledDose>> getUpcomingDoses(
    String medicationId, {
    required DateTime after,
    int limit = 50,
  });

  /// Inserts doses, ignoring ones that already exist for the same
  /// medication and instant.
  Future<void> insertDoses(List<ScheduledDose> doses);

  /// Changes the status of a scheduled dose.
  Future<void> setStatus(String doseId, DoseStatus status);

  /// Marks every future pending dose of a medication as cancelled.
  Future<int> cancelFutureDoses(String medicationId, DateTime from);

  /// The active (non-superseded) log for a scheduled dose, if any.
  Future<DoseLog?> getActiveLog(String scheduledDoseId);

  /// All logs for a medication, newest first.
  Stream<List<DoseLog>> watchLogs(String medicationId);

  /// Logs inside a date range, newest first.
  Future<List<DoseLog>> getLogsInRange(DateTime from, DateTime to);

  /// All logs across every medication.
  Stream<List<DoseLog>> watchAllLogs();

  /// Writes a new log, deactivating the log it supersedes.
  Future<void> addLog(DoseLog log, {bool supersedeExisting = true});

  /// Count of doses in a given status for a medication.
  Future<int> countByStatus(String medicationId, DoseStatus status);
}
