import '../data/local/app_database.dart';
import '../data/local/wipe.dart';
import '../data/repositories/dose_repository_impl.dart';
import '../data/repositories/medication_repository_impl.dart';
import '../data/repositories/notification_schedule_repository_impl.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/models/medication.dart';
import '../domain/models/user_profile.dart';
import '../domain/services/local_time_converter.dart';
import '../domain/services/reminder_clock.dart';
import '../services/notification_service.dart';
import '../services/people/people_controller.dart';
import '../services/schedule_service.dart';
import '../services/timezone_service.dart';

/// Looks after the reminders of people who share the phone but are not the one
/// currently open.
///
/// Reminders are scheduled two weeks ahead from each person's own database.
/// Without this, someone who is not opened for a while would run out of
/// reminders, so every person's are topped up whenever the app starts or the
/// open person changes.
abstract final class OtherPeople {
  /// Rebuilds the reminders of everyone except [active].
  static Future<void> reconcile({
    required List<Person> people,
    required Person active,
    required NotificationService notifications,
  }) async {
    for (final Person person in people) {
      if (person.id == active.id) continue;
      await _withDatabase(person, (AppDatabase db) async {
        final UserProfile? profile = await ProfileRepositoryImpl(db).getProfile();
        // Nobody has set this person up yet: nothing to remind about.
        if (profile == null || !profile.onboardingCompleted) return;
        final String zone = ReminderZone.effectiveId(
          deviceId: TimezoneService.deviceTimeZoneId,
          homeId: profile.timezoneId,
          travelMode: profile.travelMode,
        );
        final converter = TimezoneService.converterFor(zone);
        final String label = profile.displayName?.trim().isNotEmpty ?? false
            ? profile.displayName!.trim()
            : person.label;
        await _scheduleService(db, notifications, () => converter, label)
            .reconcileAll();
      });
    }
  }

  /// Cancels [person]'s reminders and erases their data from this device.
  static Future<void> forget({
    required Person person,
    required NotificationService notifications,
  }) {
    return _withDatabase(person, (AppDatabase db) async {
      final ScheduleService schedule =
          _scheduleService(db, notifications, null, null);
      final List<Medication> medications =
          await MedicationRepositoryImpl(db).getAll();
      for (final Medication m in medications) {
        await schedule.cancelMedicationNotifications(m.id);
      }
      await wipeAllData(db);
    });
  }

  static ScheduleService _scheduleService(
    AppDatabase db,
    NotificationService notifications,
    LocalTimeConverter Function()? reminderConverter,
    String? label,
  ) {
    return ScheduleService(
      medicationRepository: MedicationRepositoryImpl(db),
      doseRepository: DoseRepositoryImpl(db),
      notificationScheduleRepository: NotificationScheduleRepositoryImpl(db),
      notificationService: notifications,
      reminderConverter: reminderConverter,
      personLabel: () => label,
    );
  }

  static Future<void> _withDatabase(
    Person person,
    Future<void> Function(AppDatabase db) body,
  ) async {
    final AppDatabase db = AppDatabase(name: person.databaseName);
    try {
      await body(db);
    } finally {
      await db.close();
    }
  }
}
