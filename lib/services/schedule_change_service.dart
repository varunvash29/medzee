import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/local/app_database.dart';
import '../domain/models/core_enums.dart';
import '../domain/models/inventory.dart';
import '../domain/models/medication.dart';
import '../domain/models/schedule_proposal.dart';
import '../domain/repositories/inventory_repository.dart';
import '../domain/repositories/medication_repository.dart';
import 'medication_service.dart';

/// Why a confirmed change could not be applied.
class ScheduleChangeException implements Exception {
  const ScheduleChangeException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// What happened when a proposal was applied.
class AppliedChange {
  const AppliedChange({required this.id, required this.summary});
  final String id;
  final String summary;
}

/// Applies *validated, user-confirmed* proposals using the app's normal
/// services, keeps an audit trail, and can undo the change.
///
/// The assistant (AI) never reaches this class directly: the UI only calls it
/// after [ScheduleProposalService.check] passed and the user pressed Confirm.
class ScheduleChangeService {
  ScheduleChangeService({
    required AppDatabase database,
    required MedicationRepository medications,
    required InventoryRepository inventory,
    required MedicationService medicationService,
  })  : _db = database,
        _medications = medications,
        _inventory = inventory,
        _service = medicationService;

  final AppDatabase _db;
  final MedicationRepository _medications;
  final InventoryRepository _inventory;
  final MedicationService _service;

  Future<AppliedChange> apply(ScheduleProposal p) async {
    // A proposal applies at most once, so a double tap or a replay cannot
    // create a second stock transaction or a second schedule change.
    final ScheduleAuditRow? done = await (_db.select(_db.scheduleAuditLog)
          ..where((t) => t.id.equals(p.id)))
        .getSingleOrNull();
    if (done != null) {
      throw const ScheduleChangeException('That change was already applied.');
    }

    final Medication? med = p.medicationId == null
        ? null
        : await _medications.getById(p.medicationId!);
    if (med == null) {
      throw const ScheduleChangeException('That medicine no longer exists.');
    }
    final List<SchedulePhase> phases = await _medications.getPhases(med.id);

    switch (p.intent) {
      case ScheduleIntent.setReminderTimes:
        return _setTimes(p, med, phases);
      case ScheduleIntent.moveReminderTime:
        return _moveTime(p, med, phases);
      case ScheduleIntent.pause:
        return _pause(p, med);
      case ScheduleIntent.resume:
        return _resume(p, med);
      case ScheduleIntent.updateStock:
        return _stock(p, med);
      case ScheduleIntent.answer:
      case ScheduleIntent.clarify:
      case ScheduleIntent.unsupported:
        throw const ScheduleChangeException('Nothing to apply.');
    }
  }

  // ------------------------------------------------------------- changes

  SchedulePhase _editablePhase(List<SchedulePhase> phases) {
    final List<SchedulePhase> active = phases
        .where((SchedulePhase p) => p.isActive && p.producesReminders)
        .toList();
    if (active.length != 1) {
      throw const ScheduleChangeException(
        'This medicine has a more complex schedule. Change it from the '
        'medicine screen.',
      );
    }
    final SchedulePhase phase = active.single;
    if (phase.kind == ScheduleKind.everyNHours) {
      throw const ScheduleChangeException(
        'This medicine repeats every few hours, so it has no fixed times to '
        'change here.',
      );
    }
    return phase;
  }

  Future<AppliedChange> _setTimes(
    ScheduleProposal p,
    Medication med,
    List<SchedulePhase> phases,
  ) async {
    final SchedulePhase phase = _editablePhase(phases);
    final DateTime start = p.startDate ?? phase.startDate;
    DateTime? end = p.endDate;
    if (p.durationDays != null) {
      end = DateTime(start.year, start.month, start.day + p.durationDays! - 1);
    }
    final bool changesEnd = end != null;

    final SchedulePhase updated = phase.copyWith(
      timesMinutes: List<int>.of(p.times)..sort(),
      startDate: start,
      endDate: end,
    );
    final Medication updatedMed = changesEnd
        ? med.copyWith(endDate: end, updatedAt: DateTime.now().toUtc())
        : med;

    final String before = jsonEncode(<String, Object?>{
      'phaseId': phase.id,
      'times': phase.timesMinutes,
      'start': phase.startDate.toIso8601String(),
      'end': phase.endDate?.toIso8601String(),
      'medEnd': med.endDate?.toIso8601String(),
    });
    await _service.save(
      medication: updatedMed,
      phases: phases
          .map((SchedulePhase x) => x.id == phase.id ? updated : x)
          .toList(),
    );
    return _record(p, med, 'Reminders for ${med.name} updated', before);
  }

  Future<AppliedChange> _moveTime(
    ScheduleProposal p,
    Medication med,
    List<SchedulePhase> phases,
  ) async {
    final SchedulePhase phase = _editablePhase(phases);
    final int? to = p.moveTo;
    int? from = p.moveFrom;
    if (from == null && phase.timesMinutes.length == 1) {
      from = phase.timesMinutes.first;
    }
    if (to == null || from == null || !phase.timesMinutes.contains(from)) {
      throw const ScheduleChangeException(
        'That reminder is not set for this medicine any more.',
      );
    }
    final List<int> moved = <int>{
      for (final int t in phase.timesMinutes) t == from ? to : t,
    }.toList()
      ..sort();

    final String before = jsonEncode(<String, Object?>{
      'phaseId': phase.id,
      'times': phase.timesMinutes,
      'start': phase.startDate.toIso8601String(),
      'end': phase.endDate?.toIso8601String(),
      'medEnd': med.endDate?.toIso8601String(),
    });
    await _service.save(
      medication: med,
      phases: phases
          .map((SchedulePhase x) =>
              x.id == phase.id ? phase.copyWith(timesMinutes: moved) : x)
          .toList(),
    );
    return _record(p, med, 'Reminder for ${med.name} moved', before);
  }

  Future<AppliedChange> _pause(ScheduleProposal p, Medication med) async {
    await _service.pause(med);
    return _record(
      p,
      med,
      'Paused ${med.name}',
      jsonEncode(<String, Object?>{'status': med.status.name}),
      resumeOn: p.resumeOn,
    );
  }

  Future<AppliedChange> _resume(ScheduleProposal p, Medication med) async {
    await _service.resume(med);
    return _record(
      p,
      med,
      'Resumed ${med.name}',
      jsonEncode(<String, Object?>{'status': med.status.name}),
    );
  }

  Future<AppliedChange> _stock(ScheduleProposal p, Medication med) async {
    final Inventory? inv = await _inventory.getInventory(med.id);
    if (inv == null) {
      throw const ScheduleChangeException(
        'Stock is not tracked for this medicine. Turn it on from the medicine '
        'screen first.',
      );
    }
    final double q = p.stockQuantity ?? -1;
    if (q < 0) throw const ScheduleChangeException('No quantity was given.');

    final Inventory updated = p.stockMode == StockMode.refill
        ? await _service.refill(medication: med, inventory: inv, quantity: q)
        : await _service.adjustStock(
            medication: med,
            inventory: inv,
            newQuantity: q,
            note: 'Set from the schedule assistant',
          );
    await _inventory.saveInventory(updated);
    return _record(
      p,
      med,
      p.stockMode == StockMode.refill
          ? 'Added ${_n(q)} to ${med.name}'
          : 'Set ${med.name} stock to ${_n(q)}',
      jsonEncode(<String, Object?>{'quantity': inv.quantityOnHand}),
    );
  }

  // ------------------------------------------------------------- audit

  Future<AppliedChange> _record(
    ScheduleProposal p,
    Medication med,
    String summary,
    String before, {
    DateTime? resumeOn,
  }) async {
    await _db.into(_db.scheduleAuditLog).insert(
          ScheduleAuditLogCompanion.insert(
            id: p.id,
            kind: p.intent.name,
            medicationId: med.id,
            summary: summary,
            beforeJson: before,
            createdAt: DateTime.now().toUtc(),
            resumeOn: Value<DateTime?>(resumeOn),
          ),
        );
    return AppliedChange(id: p.id, summary: summary);
  }

  /// Reverses a change made by [apply]. Safe to call once per change.
  Future<void> undo(String changeId) async {
    final ScheduleAuditRow? row = await (_db.select(_db.scheduleAuditLog)
          ..where((t) => t.id.equals(changeId)))
        .getSingleOrNull();
    if (row == null || row.undone) {
      throw const ScheduleChangeException('Nothing to undo.');
    }
    final Medication? med = await _medications.getById(row.medicationId);
    if (med == null) {
      throw const ScheduleChangeException('That medicine no longer exists.');
    }
    final Map<String, dynamic> before =
        jsonDecode(row.beforeJson) as Map<String, dynamic>;

    switch (ScheduleIntent.fromName(row.kind)) {
      case ScheduleIntent.setReminderTimes:
      case ScheduleIntent.moveReminderTime:
        final List<SchedulePhase> phases = await _medications.getPhases(med.id);
        final String phaseId = before['phaseId'] as String;
        final DateTime? end = before['end'] == null
            ? null
            : DateTime.parse(before['end'] as String);
        final List<SchedulePhase> restored = <SchedulePhase>[
          for (final SchedulePhase x in phases)
            if (x.id == phaseId)
              x.copyWith(
                timesMinutes: (before['times'] as List<dynamic>).cast<int>(),
                startDate: DateTime.parse(before['start'] as String),
                endDate: end,
                clearEndDate: end == null,
              )
            else
              x,
        ];
        final String? medEnd = before['medEnd'] as String?;
        await _service.save(
          medication: medEnd == null
              ? med.copyWith(clearEndDate: true)
              : med.copyWith(endDate: DateTime.parse(medEnd)),
          phases: restored,
        );
      case ScheduleIntent.pause:
        await _service.resume(med);
      case ScheduleIntent.resume:
        await _service.pause(med);
      case ScheduleIntent.updateStock:
        final Inventory? inv = await _inventory.getInventory(med.id);
        if (inv != null) {
          final Inventory fixed = await _service.adjustStock(
            medication: med,
            inventory: inv,
            newQuantity: (before['quantity'] as num).toDouble(),
            note: 'Undo of a schedule assistant change',
          );
          await _inventory.saveInventory(fixed);
        }
      default:
        break;
    }

    await (_db.update(_db.scheduleAuditLog)
          ..where((t) => t.id.equals(changeId)))
        .write(const ScheduleAuditLogCompanion(undone: Value<bool>(true)));
  }

  /// Resumes medicines whose timed pause has ended. Call on app start.
  Future<int> applyDueResumes({DateTime? now}) async {
    final DateTime today = now ?? DateTime.now();
    final DateTime day = DateTime(today.year, today.month, today.day);
    final List<ScheduleAuditRow> due = await (_db.select(_db.scheduleAuditLog)
          ..where((t) =>
              t.kind.equals(ScheduleIntent.pause.name) &
              t.resumed.equals(false) &
              t.undone.equals(false) &
              t.resumeOn.isNotNull()))
        .get();
    int resumed = 0;
    for (final ScheduleAuditRow row in due) {
      final DateTime? on = row.resumeOn?.toLocal();
      if (on == null || DateTime(on.year, on.month, on.day).isAfter(day)) {
        continue;
      }
      final Medication? med = await _medications.getById(row.medicationId);
      if (med != null && med.status == MedicationStatus.paused) {
        await _service.resume(med);
        resumed++;
      }
      await (_db.update(_db.scheduleAuditLog)
            ..where((t) => t.id.equals(row.id)))
          .write(const ScheduleAuditLogCompanion(resumed: Value<bool>(true)));
    }
    return resumed;
  }

  static String _n(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
