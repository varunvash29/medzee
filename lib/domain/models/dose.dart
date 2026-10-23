import 'core_enums.dart';

/// A concrete dose instance produced by expanding a [SchedulePhase].
///
/// Scheduled doses are materialised so that history is stable: if the user
/// later edits a schedule, past instances keep their original times.
class ScheduledDose {
  const ScheduledDose({
    required this.id,
    required this.medicationId,
    required this.phaseId,
    required this.scheduledAt,
    required this.localDate,
    required this.scheduledMinutes,
    required this.doseQuantity,
    required this.unit,
    this.status = DoseStatus.pending,
    this.createdAt,
  });

  final String id;
  final String medicationId;
  final String phaseId;

  /// The exact instant the dose is due, stored in UTC.
  final DateTime scheduledAt;

  /// The local calendar date the dose belongs to.
  final DateTime localDate;

  /// Local wall-clock minutes-from-midnight of [scheduledAt].
  final int scheduledMinutes;

  final double doseQuantity;
  final DoseUnit unit;
  final DoseStatus status;
  final DateTime? createdAt;

  bool get isResolved => status.isResolved;

  ScheduledDose copyWith({
    String? id,
    String? medicationId,
    String? phaseId,
    DateTime? scheduledAt,
    DateTime? localDate,
    int? scheduledMinutes,
    double? doseQuantity,
    DoseUnit? unit,
    DoseStatus? status,
    DateTime? createdAt,
  }) {
    return ScheduledDose(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      phaseId: phaseId ?? this.phaseId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      localDate: localDate ?? this.localDate,
      scheduledMinutes: scheduledMinutes ?? this.scheduledMinutes,
      doseQuantity: doseQuantity ?? this.doseQuantity,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// An immutable record of a user action on a dose.
///
/// Dose logs are append-only in spirit: correcting a dose writes a new log
/// that supersedes the previous one, and the audit trail is preserved.
class DoseLog {
  const DoseLog({
    required this.id,
    required this.medicationId,
    required this.scheduledDoseId,
    required this.status,
    required this.scheduledAt,
    required this.actedAt,
    this.amountTaken,
    this.unit,
    this.note,
    this.inventoryTransactionId,
    this.supersedesLogId,
    this.createdAt,
  });

  final String id;
  final String medicationId;
  final String scheduledDoseId;

  /// [DoseStatus.taken], [DoseStatus.skipped] or [DoseStatus.missed].
  final DoseStatus status;

  /// The instant the dose was originally due.
  final DateTime scheduledAt;

  /// The instant the user recorded the action.
  final DateTime actedAt;

  /// Amount actually consumed. Null for skipped/missed doses.
  final double? amountTaken;
  final DoseUnit? unit;
  final String? note;

  /// Links the log to the inventory movement it caused.
  final String? inventoryTransactionId;

  /// Set when this log corrects an earlier one.
  final String? supersedesLogId;
  final DateTime? createdAt;

  /// Delay between the scheduled time and the user action.
  Duration get delay => actedAt.difference(scheduledAt);

  DoseLog copyWith({
    String? id,
    String? medicationId,
    String? scheduledDoseId,
    DoseStatus? status,
    DateTime? scheduledAt,
    DateTime? actedAt,
    double? amountTaken,
    bool clearAmountTaken = false,
    DoseUnit? unit,
    String? note,
    bool clearNote = false,
    String? inventoryTransactionId,
    bool clearInventoryTransactionId = false,
    String? supersedesLogId,
    DateTime? createdAt,
  }) {
    return DoseLog(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduledDoseId: scheduledDoseId ?? this.scheduledDoseId,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      actedAt: actedAt ?? this.actedAt,
      amountTaken: clearAmountTaken ? null : (amountTaken ?? this.amountTaken),
      unit: unit ?? this.unit,
      note: clearNote ? null : (note ?? this.note),
      inventoryTransactionId: clearInventoryTransactionId
          ? null
          : (inventoryTransactionId ?? this.inventoryTransactionId),
      supersedesLogId: supersedesLogId ?? this.supersedesLogId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
