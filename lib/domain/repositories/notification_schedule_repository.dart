import '../models/scheduled_notification.dart';

/// Persistence contract for the list of notifications Medzee owns.
abstract interface class NotificationScheduleRepository {
  Future<List<ScheduledNotification>> getAll();

  Future<List<ScheduledNotification>> getForMedication(String medicationId);

  /// Removes every row for a medication and inserts the supplied ones.
  Future<void> replaceForMedication(
    String medicationId,
    List<ScheduledNotification> notifications,
  );

  /// Removes every row for a medication.
  Future<void> deleteForMedication(String medicationId);

  /// Removes every row (used when the user signs out or resets the app).
  Future<void> deleteAll();
}
