import 'package:uuid/uuid.dart';

import '../domain/models/core_enums.dart';
import '../domain/models/dose.dart';
import '../domain/models/medication.dart';
import '../domain/models/scheduled_notification.dart';
import '../domain/repositories/dose_repository.dart';
import '../domain/repositories/medication_repository.dart';
import '../domain/repositories/notification_schedule_repository.dart';
import '../domain/services/schedule_generator.dart';
import 'notification_service.dart';

/// Materialises schedule phases into concrete dose instances and keeps the
/// operating system's notification queue in step with them.
///
/// The service is the single place that knows how to turn "a phase that says
/// 08:00 every day" into "these 42 dose instances and these 42 reminders".
class ScheduleService {
  ScheduleService({
    required MedicationRepository medicationRepository,
    required DoseRepository doseRepository,
    required NotificationScheduleRepository notificationScheduleRepository,
    required NotificationService notificationService,
  })  : _medications = medicationRepository,
        _doses = doseRepository,
        _notificationSchedules = notificationScheduleRepository,
        _notifications = notificationService;

  final MedicationRepository _medications;
  final DoseRepository _doses;
  final NotificationScheduleRepository _notificationSchedules;
  final NotificationService _notifications;

  static const Uuid _uuid = Uuid();

  /// The number of days ahead that dose instances and reminders are built.
  static const int horizonDays = NotificationService.reminderHorizonDays;

  /// Rebuilds the dose instances and reminders for a single medication.
  ///
  /// Existing resolved doses (taken, skipped, missed) are never modified, so
  /// history stays intact when a schedule is edited.
  Future<void> syncMedication(
    Medication medication,
    List<SchedulePhase> phases, {
    DateTime? now,
  }) async {
    final DateTime reference = now ?? DateTime.now();
    final DateTime from = DateTime(
      reference.year,
      reference.month,
      reference.day,
    );
    final DateTime to = from.add(Duration(days: horizonDays));

    final List<SchedulePhase> usable = _usablePhases(medication, phases);

    // 1. Cancel future pending doses that are no longer part of the plan.
    final List<ScheduledDose> existing = await _doses.getDosesInRange(
      from,
      to,
    );
    final Set<String> keep = _occurrenceKeys(usable, from, to);
    final List<ScheduledDose> stale = existing
        .where((ScheduledDose dose) =>
            dose.medicationId == medication.id &&
            dose.status == DoseStatus.pending &&
            !keep.contains(_doseKey(dose)))
        .toList(growable: false);
    for (final ScheduledDose dose in stale) {
      await _doses.setStatus(dose.id, DoseStatus.cancelled);
    }

    // 2. Insert the doses that should exist.
    final List<ScheduledDose> toInsert = <ScheduledDose>[];
    for (final DoseOccurrence occurrence
        in ScheduleGenerator.occurrences(phases: usable, from: from, to: to)) {
      toInsert.add(
        ScheduledDose(
          id: _uuid.v4(),
          medicationId: medication.id,
          phaseId: occurrence.phaseId,
          scheduledAt: occurrence.localDate.add(
            Duration(minutes: occurrence.minutes),
          ),
          localDate: occurrence.localDate,
          scheduledMinutes: occurrence.minutes,
          doseQuantity: occurrence.doseQuantity,
          unit: occurrence.unit,
          status: DoseStatus.pending,
          createdAt: DateTime.now().toUtc(),
        ),
      );
    }
    await _doses.insertDoses(toInsert);

    // 3. Rebuild the reminders.
    await rescheduleNotifications(medication, usable, now: reference);
  }

  /// Rebuilds the reminders for a medication without touching dose history.
  Future<void> rescheduleNotifications(
    Medication medication,
    List<SchedulePhase> phases, {
    DateTime? now,
  }) async {
    final List<ScheduledNotification> owned =
        await _notificationSchedules.getForMedication(medication.id);
    for (final ScheduledNotification notification in owned) {
      await _notifications.cancel(notification.notificationId);
    }
    await _notificationSchedules.deleteForMedication(medication.id);

    if (medication.status != MedicationStatus.active) return;

    final DateTime reference = now ?? DateTime.now();
    final DateTime from = DateTime(
      reference.year,
      reference.month,
      reference.day,
    );
    final DateTime to = from.add(Duration(days: horizonDays));

    final List<ScheduledNotification> created = <ScheduledNotification>[];
    final List<ScheduledDose> doses =
        await _doses.getDosesInRange(from, to);

    for (final ScheduledDose dose in doses) {
      if (dose.medicationId != medication.id) continue;
      if (dose.status != DoseStatus.pending) continue;

      final int notificationId = NotificationService.idFor(
        1000000,
        'dose:${dose.id}',
      );
      final String doseLabel = _doseLabel(dose);
      created.add(
        ScheduledNotification(
          notificationId: notificationId,
          kind: NotificationKind.doseReminder,
          scheduledAt: dose.scheduledAt,
          medicationId: medication.id,
          doseId: dose.id,
          payload: 'medicine:${medication.id}',
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await _notifications.scheduleDoseReminder(
        notificationId: notificationId,
        scheduledAt: dose.scheduledAt,
        medicationName: medication.name,
        doseLabel: doseLabel,
        payload: 'medicine:${medication.id}',
        privacy: NotificationPrivacy.detailed,
      );
    }

    await _notificationSchedules.replaceForMedication(medication.id, created);
  }

  /// Cancels every reminder belonging to a medication.
  Future<void> cancelMedicationNotifications(String medicationId) async {
    final List<ScheduledNotification> owned =
        await _notificationSchedules.getForMedication(medicationId);
    for (final ScheduledNotification notification in owned) {
      await _notifications.cancel(notification.notificationId);
    }
    await _notificationSchedules.deleteForMedication(medicationId);
  }

  /// Rebuilds every active medication's schedule and reminders.
  ///
  /// This runs at startup so that a reboot, a timezone change or a missed
  /// background execution never leaves the user without reminders.
  Future<void> reconcileAll({DateTime? now}) async {
    final DateTime reference = now ?? DateTime.now();
    final List<Medication> medications = await _medications.getAll();
    for (final Medication medication in medications) {
      if (medication.status != MedicationStatus.active) {
        await cancelMedicationNotifications(medication.id);
        continue;
      }
      final List<SchedulePhase> phases =
          await _medications.getPhases(medication.id);
      await syncMedication(medication, phases, now: reference);
    }
  }

  /// Removes every reminder Medzee owns.
  Future<void> cancelEverything() async {
    await _notifications.cancelAll();
    await _notificationSchedules.deleteAll();
  }

  /// Phases that actually produce doses for this medication, clamped to the
  /// medication's own start and end dates.
  List<SchedulePhase> _usablePhases(
    Medication medication,
    List<SchedulePhase> phases,
  ) {
    final List<SchedulePhase> result = <SchedulePhase>[];
    for (final SchedulePhase phase in phases) {
      if (!phase.isActive) continue;
      if (phase.kind.isAsNeeded) continue;

      DateTime start = phase.startDate;
      DateTime? end = phase.endDate;

      final DateTime? medicationStart = medication.startDate;
      if (medicationStart != null && start.isBefore(medicationStart)) {
        start = medicationStart;
      }
      final DateTime? medicationEnd = medication.endDate;
      if (medicationEnd != null && (end == null || end.isAfter(medicationEnd))) {
        end = medicationEnd;
      }
      if (end != null && end.isBefore(start)) continue;

      result.add(phase.copyWith(startDate: start, endDate: end));
    }
    return result;
  }

  Set<String> _occurrenceKeys(List<SchedulePhase> phases, DateTime from,
      DateTime to) {
    return ScheduleGenerator.occurrences(phases: phases, from: from, to: to)
        .map((DoseOccurrence occurrence) =>
            '${occurrence.phaseId}|${occurrence.localDate.toIso8601String()}'
            '|${occurrence.minutes}')
        .toSet();
  }

  String _doseKey(ScheduledDose dose) =>
      '${dose.phaseId}|${dose.localDate.toIso8601String()}'
      '|${dose.scheduledMinutes}';

  String _doseLabel(ScheduledDose dose) {
    final String quantity = dose.doseQuantity == dose.doseQuantity.roundToDouble()
        ? dose.doseQuantity.toInt().toString()
        : dose.doseQuantity.toStringAsFixed(1);
    return '$quantity ${dose.unit.singular}';
  }
}
