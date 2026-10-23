import 'package:drift/drift.dart';

import '../../domain/models/core_enums.dart';
import '../../domain/models/medication.dart';
import '../../domain/repositories/medication_repository.dart';
import '../local/app_database.dart';
import '../mappers.dart';

/// Drift-backed implementation of [MedicationRepository].
class MedicationRepositoryImpl implements MedicationRepository {
  MedicationRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Medication>> watchAll() {
    final SimpleSelectStatement<$MedicationsTable, MedicationRow> query =
        _db.select(_db.medications);
    return query.watch().map(
          (List<MedicationRow> rows) => rows
              .map((MedicationRow row) => row.toDomain())
              .toList(growable: false),
        );
  }

  @override
  Stream<List<Medication>> watchByStatus(MedicationStatus status) {
    final SimpleSelectStatement<$MedicationsTable, MedicationRow> query =
        _db.select(_db.medications)
          ..where(($MedicationsTable t) => t.status.equals(status.name));
    return query.watch().map(
          (List<MedicationRow> rows) => rows
              .map((MedicationRow row) => row.toDomain())
              .toList(growable: false),
        );
  }

  @override
  Stream<Medication?> watchById(String id) {
    final SimpleSelectStatement<$MedicationsTable, MedicationRow> query =
        _db.select(_db.medications)
          ..where(($MedicationsTable t) => t.id.equals(id));
    return query.watchSingleOrNull().map((MedicationRow? row) => row?.toDomain());
  }

  @override
  Future<Medication?> getById(String id) async {
    final MedicationRow? row = await (_db.select(_db.medications)
          ..where(($MedicationsTable t) => t.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<List<Medication>> getAll() async {
    final List<MedicationRow> rows = await _db.select(_db.medications).get();
    return rows
        .map((MedicationRow row) => row.toDomain())
        .toList(growable: false);
  }

  @override
  Future<void> save(Medication medication) async {
    await _db
        .into(_db.medications)
        .insertOnConflictUpdate(medication.toCompanion());
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.medications)
          ..where(($MedicationsTable t) => t.id.equals(id)))
        .go();
  }

  @override
  Future<void> setStatus(String id, MedicationStatus status) async {
    await (_db.update(_db.medications)
          ..where(($MedicationsTable t) => t.id.equals(id)))
        .write(MedicationsCompanion(
      status: Value<String>(status.name),
      updatedAt: Value<DateTime>(DateTime.now().toUtc()),
    ));
  }

  @override
  Stream<List<SchedulePhase>> watchPhases(String medicationId) {
    final SimpleSelectStatement<$SchedulePhasesTable, SchedulePhaseRow> query =
        _db.select(_db.schedulePhases)
          ..where(($SchedulePhasesTable t) =>
              t.medicationId.equals(medicationId))
          ..orderBy(<OrderClauseGenerator<$SchedulePhasesTable>>[
            ($SchedulePhasesTable t) => OrderingTerm.asc(t.phaseOrder),
          ]);
    return query.watch().map(
          (List<SchedulePhaseRow> rows) => rows
              .map((SchedulePhaseRow row) => row.toDomain())
              .toList(growable: false),
        );
  }

  @override
  Future<List<SchedulePhase>> getPhases(String medicationId) async {
    final List<SchedulePhaseRow> rows = await (_db.select(_db.schedulePhases)
          ..where(($SchedulePhasesTable t) =>
              t.medicationId.equals(medicationId))
          ..orderBy(<OrderClauseGenerator<$SchedulePhasesTable>>[
            ($SchedulePhasesTable t) => OrderingTerm.asc(t.phaseOrder),
          ]))
        .get();
    return rows
        .map((SchedulePhaseRow row) => row.toDomain())
        .toList(growable: false);
  }

  @override
  Future<void> replacePhases(
    String medicationId,
    List<SchedulePhase> phases,
  ) async {
    await _db.transaction(() async {
      await (_db.delete(_db.schedulePhases)
            ..where(($SchedulePhasesTable t) =>
                t.medicationId.equals(medicationId)))
          .go();
      if (phases.isEmpty) return;
      await _db.batch((Batch batch) {
        batch.insertAll(
          _db.schedulePhases,
          phases.map((SchedulePhase phase) => phase.toCompanion()).toList(),
        );
      });
    });
  }

  @override
  Future<List<SchedulePhase>> getAllPhases() async {
    final List<SchedulePhaseRow> rows = await (_db.select(_db.schedulePhases)
          ..orderBy(<OrderClauseGenerator<$SchedulePhasesTable>>[
            ($SchedulePhasesTable t) => OrderingTerm.asc(t.medicationId),
            ($SchedulePhasesTable t) => OrderingTerm.asc(t.phaseOrder),
          ]))
        .get();
    return rows
        .map((SchedulePhaseRow row) => row.toDomain())
        .toList(growable: false);
  }
}
