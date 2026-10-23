import 'core_enums.dart';

/// A local notification that Medzee has registered with the operating
/// system.
///
/// Persisting this list is what makes reminders cancellable and idempotent:
/// after a restart or a reboot Medzee knows exactly which notifications it
/// owns and can rebuild them without creating duplicates.
class ScheduledNotification {
  const ScheduledNotification({
    required this.notificationId,
    required this.kind,
    required this.scheduledAt,
    this.medicationId,
    this.doseId,
    this.payload,
    required this.createdAt,
  });

  final int notificationId;
  final NotificationKind kind;
  final DateTime scheduledAt;
  final String? medicationId;
  final String? doseId;

  /// Deep link payload, e.g. `medicine:{id}`.
  final String? payload;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledNotification &&
          other.notificationId == notificationId;

  @override
  int get hashCode => notificationId.hashCode;
}
