import 'app_database.dart';

/// Removes everything a person has stored in [db]: profile, medicines,
/// schedules, history, stock and reminders.
///
/// Used by "Delete all data" and when someone is taken off a shared device.
Future<void> wipeAllData(AppDatabase db) async {
  await db.transaction(() async {
    await db.delete(db.userProfiles).go();
    await db.delete(db.medications).go();
    await db.delete(db.doseLogs).go();
    await db.delete(db.scheduledDoses).go();
    await db.delete(db.schedulePhases).go();
    await db.delete(db.inventories).go();
    await db.delete(db.inventoryTransactions).go();
    await db.delete(db.notificationPreferences).go();
    await db.delete(db.refillReminders).go();
    await db.delete(db.notificationSchedules).go();
    await db.delete(db.scheduleAuditLog).go();
  });
}
