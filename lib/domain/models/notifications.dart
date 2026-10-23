import 'core_enums.dart';

/// Notification preferences for a single medication (or globally when
/// [medicationId] is null).
class NotificationPreference {
  const NotificationPreference({
    required this.id,
    this.medicationId,
    this.remindersEnabled = true,
    this.preReminderMinutes,
    this.missedFollowUpEnabled = false,
    this.missedFollowUpMinutes = 60,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.privacy = NotificationPrivacy.detailed,
    this.lowStockAlertEnabled = true,
    this.runOutAlertEnabled = true,
    this.refillAlertEnabled = true,
  });

  final String id;
  final String? medicationId;
  final bool remindersEnabled;

  /// Minutes before the scheduled time to fire an early reminder.
  final int? preReminderMinutes;
  final bool missedFollowUpEnabled;
  final int missedFollowUpMinutes;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final NotificationPrivacy privacy;
  final bool lowStockAlertEnabled;
  final bool runOutAlertEnabled;
  final bool refillAlertEnabled;

  NotificationPreference copyWith({
    String? id,
    String? medicationId,
    bool? remindersEnabled,
    int? preReminderMinutes,
    bool clearPreReminderMinutes = false,
    bool? missedFollowUpEnabled,
    int? missedFollowUpMinutes,
    bool? soundEnabled,
    bool? vibrationEnabled,
    NotificationPrivacy? privacy,
    bool? lowStockAlertEnabled,
    bool? runOutAlertEnabled,
    bool? refillAlertEnabled,
  }) {
    return NotificationPreference(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      preReminderMinutes: clearPreReminderMinutes
          ? null
          : (preReminderMinutes ?? this.preReminderMinutes),
      missedFollowUpEnabled:
          missedFollowUpEnabled ?? this.missedFollowUpEnabled,
      missedFollowUpMinutes:
          missedFollowUpMinutes ?? this.missedFollowUpMinutes,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      privacy: privacy ?? this.privacy,
      lowStockAlertEnabled: lowStockAlertEnabled ?? this.lowStockAlertEnabled,
      runOutAlertEnabled: runOutAlertEnabled ?? this.runOutAlertEnabled,
      refillAlertEnabled: refillAlertEnabled ?? this.refillAlertEnabled,
    );
  }
}

/// A standing request to be warned when a medication's stock runs low.
class RefillReminder {
  const RefillReminder({
    required this.id,
    required this.medicationId,
    required this.threshold,
    this.enabled = true,
    this.lastNotifiedAt,
    this.leadDays = 3,
  });

  final String id;
  final String medicationId;

  /// Stock level (in the medication's inventory unit) that triggers a warning.
  final double threshold;
  final bool enabled;
  final DateTime? lastNotifiedAt;

  /// How many days ahead of the estimated run-out date to warn the user.
  final int leadDays;

  RefillReminder copyWith({
    String? id,
    String? medicationId,
    double? threshold,
    bool? enabled,
    DateTime? lastNotifiedAt,
    bool clearLastNotifiedAt = false,
    int? leadDays,
  }) {
    return RefillReminder(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      threshold: threshold ?? this.threshold,
      enabled: enabled ?? this.enabled,
      lastNotifiedAt:
          clearLastNotifiedAt ? null : (lastNotifiedAt ?? this.lastNotifiedAt),
      leadDays: leadDays ?? this.leadDays,
    );
  }
}
