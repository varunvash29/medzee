import 'package:drift/drift.dart';

import '../../domain/models/core_enums.dart';
import '../../domain/models/scheduled_notification.dart';
import '../../domain/repositories/notification_schedule_repository.dart';
import '../local/app_database.dart';

/// Drift-backed implementation of [NotificationScheduleRepository].
class NotificationScheduleRepositoryImpl
    implements NotificationScheduleRepository {
  NotificationScheduleRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<ScheduledNotification>> getAll() async {
    final List<NotificationScheduleRow> rows =
        await _db.select(_db.notificationSchedules).get();
    return rows
        .map((NotificationScheduleRow row) => _toDomain(row))
        .toList(growable: false);
  }

  @override
  Future<List<ScheduledNotification>> getForMedication(
    String medicationId,
  ) async {
    final List<NotificationScheduleRow> rows =
        await (_db.select(_db.notificationSchedules)
              ..where(($NotificationSchedulesTable t) =>
                  t.medicationId.equals(medicationId)))
            .get();
    return rows
        .map((NotificationScheduleRow row) => _toDomain(row))
        .toList(growable: false);
  }

  @override
  Future<void> replaceForMedication(
    String medicationId,
    List<ScheduledNotification> notifications,
  ) async {
    await _db.transaction(() async {
      await (_db.delete(_db.notificationSchedules)
            ..where(($NotificationSchedulesTable t) =>
                t.medicationId.equals(medicationId)))
          .go();
      if (notifications.isEmpty) return;
      await _db.batch((Batch batch) {
        batch.insertAll(
          _db.notificationSchedules,
          notifications
              .map((ScheduledNotification notification) =>
                  NotificationSchedulesCompanion(
                    notificationId: Value<int>(notification.notificationId),
                    kind: Value<String>(notification.kind.name),
                    medicationId: Value<String?>(notification.medicationId),
                    scheduledAt:
                        Value<DateTime>(notification.scheduledAt.toUtc()),
                    doseId: Value<String?>(notification.doseId),
                    payload: Value<String?>(notification.payload),
                    createdAt: Value<DateTime>(notification.createdAt.toUtc()),
                  ))
              .toList(),
          mode: InsertMode.insertOrIgnore,
        );
      });
    });
  }

  @override
  Future<void> deleteForMedication(String medicationId) async {
    await (_db.delete(_db.notificationSchedules)
          ..where(($NotificationSchedulesTable t) =>
              t.medicationId.equals(medicationId)))
        .go();
  }

  @override
  Future<void> deleteAll() async {
    await _db.delete(_db.notificationSchedules).go();
  }

  ScheduledNotification _toDomain(NotificationScheduleRow row) =>
      ScheduledNotification(
        notificationId: row.notificationId,
        kind: NotificationKind.fromName(row.kind),
        scheduledAt: row.scheduledAt.toUtc(),
        medicationId: row.medicationId,
        doseId: row.doseId,
        payload: row.payload,
        createdAt: row.createdAt.toUtc(),
      );
}
