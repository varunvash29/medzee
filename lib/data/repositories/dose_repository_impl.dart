import 'package:drift/drift.dart';

import '../../domain/models/core_enums.dart';
import '../../domain/models/dose.dart';
import '../../domain/repositories/dose_repository.dart';
import '../local/app_database.dart';
import '../mappers.dart';

/// Drift-backed implementation of [DoseRepository].
class DoseRepositoryImpl implements DoseRepository {
  DoseRepositoryImpl(this._db);

  final AppDatabase _db;

  /// `local_date` stores midnight UTC of the calendar day, so range queries
  /// have to use the same normalisation on both ends of the comparison.
  DateTime _dayStart(DateTime date) => Mappers.dateOnlyUtc(date);

  DateTime _dayEndExclusive(DateTime date) =>
      Mappers.dateOnlyUtc(date).add(const Duration(days: 1));

  @override
  Stream<List<ScheduledDose>> watchDosesForDate(DateTime localDate) {
    final DateTime start = _dayStart(localDate);
    final DateTime end = _dayEndExclusive(localDate);
    final SimpleSelectStatement<$ScheduledDosesTable, ScheduledDoseRow> query =
        _db.select(_db.scheduledDoses)
          ..where(($ScheduledDosesTable t) =>
              t.localDate.isBiggerOrEqualValue(start) &
              t.localDate.isSmallerThanValue(end))
          ..orderBy(<OrderClauseGenerator<$ScheduledDosesTable>>[
            ($ScheduledDosesTable t) => OrderingTerm.asc(t.scheduledAt),
          ]);
    return query.watch().map(
          (List<ScheduledDoseRow> rows) => rows
              .map((ScheduledDoseRow row) => row.toDomain())
              .toList(growable: false),
        );
  }

  @override
  Stream<List<ScheduledDose>> watchDosesInRange(DateTime from, DateTime to) {
    final DateTime start = _dayStart(from);
    final DateTime end = _dayEndExclusive(to);
    final SimpleSelectStatement<$ScheduledDosesTable, ScheduledDoseRow> query =
        _db.select(_db.scheduledDoses)
          ..where(($ScheduledDosesTable t) =>
              t.localDate.isBiggerOrEqualValue(start) &
              t.localDate.isSmallerThanValue(end))
          ..orderBy(<OrderClauseGenerator<$ScheduledDosesTable>>[
            ($ScheduledDosesTable t) => OrderingTerm.asc(t.scheduledAt),
          ]);
    return query.watch().map(
          (List<ScheduledDoseRow> rows) => rows
              .map((ScheduledDoseRow row) => row.toDomain())
              .toList(growable: false),
        );
  }

  @override
  Future<List<ScheduledDose>> getDosesInRange(DateTime from, DateTime to) async {
    final DateTime start = _dayStart(from);
    final DateTime end = _dayEndExclusive(to);
    final List<ScheduledDoseRow> rows = await (_db.select(_db.scheduledDoses)
          ..where(($ScheduledDosesTable t) =>
              t.localDate.isBiggerOrEqualValue(start) &
              t.localDate.isSmallerThanValue(end))
          ..orderBy(<OrderClauseGenerator<$ScheduledDosesTable>>[
            ($ScheduledDosesTable t) => OrderingTerm.asc(t.scheduledAt),
          ]))
        .get();
    return rows
        .map((ScheduledDoseRow row) => row.toDomain())
        .toList(growable: false);
  }

  @override
  Future<List<ScheduledDose>> getUpcomingDoses(
    String medicationId, {
    required DateTime after,
    int limit = 50,
  }) async {
    final DateTime threshold = after.toUtc();
    final List<ScheduledDoseRow> rows = await (_db.select(_db.scheduledDoses)
          ..where(($ScheduledDosesTable t) =>
              t.medicationId.equals(medicationId) &
              t.scheduledAt.isBiggerThanValue(threshold) &
              t.status.equals(DoseStatus.pending.name))
          ..orderBy(<OrderClauseGenerator<$ScheduledDosesTable>>[
            ($ScheduledDosesTable t) => OrderingTerm.asc(t.scheduledAt),
          ])
          ..limit(limit))
        .get();
    return rows
        .map((ScheduledDoseRow row) => row.toDomain())
        .toList(growable: false);
  }

  @override
  Future<void> insertDoses(List<ScheduledDose> doses) async {
    if (doses.isEmpty) return;
    await _db.batch((Batch batch) {
      batch.insertAll(
        _db.scheduledDoses,
        doses.map((ScheduledDose dose) => dose.toCompanion()).toList(),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  @override
  Future<void> setStatus(String doseId, DoseStatus status) async {
    await (_db.update(_db.scheduledDoses)
          ..where(($ScheduledDosesTable t) => t.id.equals(doseId)))
        .write(ScheduledDosesCompanion(status: Value<String>(status.name)));
  }

  @override
  Future<int> deleteDoses(Iterable<String> doseIds) async {
    final List<String> ids = doseIds.toList(growable: false);
    if (ids.isEmpty) return 0;
    return (_db.delete(_db.scheduledDoses)
          ..where(($ScheduledDosesTable t) => t.id.isIn(ids)))
        .go();
  }

  @override
  Future<bool> hasPastActivity(String medicationId, DateTime now) async {
    final DateTime threshold = now.toUtc();
    final ScheduledDoseRow? past = await (_db.select(_db.scheduledDoses)
          ..where(($ScheduledDosesTable t) =>
              t.medicationId.equals(medicationId) &
              t.status.equals(DoseStatus.cancelled.name).not() &
              t.scheduledAt.isSmallerOrEqualValue(threshold))
          ..limit(1))
        .getSingleOrNull();
    if (past != null) return true;
    final DoseLogRow? log = await (_db.select(_db.doseLogs)
          ..where(($DoseLogsTable t) => t.medicationId.equals(medicationId))
          ..limit(1))
        .getSingleOrNull();
    return log != null;
  }

  @override
  Future<int> deleteOpenFutureDoses(String medicationId, DateTime from) {
    final DateTime threshold = from.toUtc();
    return (_db.delete(_db.scheduledDoses)
          ..where(($ScheduledDosesTable t) =>
              t.medicationId.equals(medicationId) &
              (t.status.equals(DoseStatus.cancelled.name) |
                  (t.status.equals(DoseStatus.pending.name) &
                      t.scheduledAt.isBiggerThanValue(threshold)))))
        .go();
  }

  @override
  Future<int> cancelFutureDoses(String medicationId, DateTime from) async {
    final DateTime threshold = from.toUtc();
    return (_db.update(_db.scheduledDoses)
          ..where(($ScheduledDosesTable t) =>
              t.medicationId.equals(medicationId) &
              t.scheduledAt.isBiggerThanValue(threshold) &
              t.status.equals(DoseStatus.pending.name)))
        .write(ScheduledDosesCompanion(status: Value<String>(DoseStatus.cancelled.name)));
  }

  @override
  Future<DoseLog?> getActiveLog(String scheduledDoseId) async {
    final DoseLogRow? row = await (_db.select(_db.doseLogs)
          ..where(($DoseLogsTable t) =>
              t.scheduledDoseId.equals(scheduledDoseId) & t.isActive.equals(true))
          ..orderBy(<OrderClauseGenerator<$DoseLogsTable>>[
            ($DoseLogsTable t) => OrderingTerm.desc(t.actedAt),
          ])
          ..limit(1))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Stream<List<DoseLog>> watchLogs(String medicationId) {
    final SimpleSelectStatement<$DoseLogsTable, DoseLogRow> query =
        _db.select(_db.doseLogs)
          ..where(($DoseLogsTable t) =>
              t.medicationId.equals(medicationId) & t.isActive.equals(true))
          ..orderBy(<OrderClauseGenerator<$DoseLogsTable>>[
            ($DoseLogsTable t) => OrderingTerm.desc(t.scheduledAt),
          ]);
    return query.watch().map(
          (List<DoseLogRow> rows) => rows
              .map((DoseLogRow row) => row.toDomain())
              .toList(growable: false),
        );
  }

  @override
  Future<List<DoseLog>> getLogsInRange(DateTime from, DateTime to) async {
    final DateTime start = from.toUtc();
    final DateTime end = to.toUtc();
    final List<DoseLogRow> rows = await (_db.select(_db.doseLogs)
          ..where(($DoseLogsTable t) =>
              t.scheduledAt.isBiggerOrEqualValue(start) &
              t.scheduledAt.isSmallerThanValue(end))
          ..orderBy(<OrderClauseGenerator<$DoseLogsTable>>[
            ($DoseLogsTable t) => OrderingTerm.desc(t.scheduledAt),
          ]))
        .get();
    return rows
        .map((DoseLogRow row) => row.toDomain())
        .toList(growable: false);
  }

  @override
  Stream<List<DoseLog>> watchAllLogs() {
    final SimpleSelectStatement<$DoseLogsTable, DoseLogRow> query =
        _db.select(_db.doseLogs)
          ..where(($DoseLogsTable t) => t.isActive.equals(true))
          ..orderBy(<OrderClauseGenerator<$DoseLogsTable>>[
            ($DoseLogsTable t) => OrderingTerm.desc(t.scheduledAt),
          ]);
    return query.watch().map(
          (List<DoseLogRow> rows) => rows
              .map((DoseLogRow row) => row.toDomain())
              .toList(growable: false),
        );
  }

  @override
  Future<void> addLog(DoseLog log, {bool supersedeExisting = true}) async {
    await _db.transaction(() async {
      if (supersedeExisting) {
        await (_db.update(_db.doseLogs)
              ..where(($DoseLogsTable t) =>
                  t.scheduledDoseId.equals(log.scheduledDoseId) &
                  t.isActive.equals(true)))
            .write(const DoseLogsCompanion(isActive: Value<bool>(false)));
      }
      await _db.into(_db.doseLogs).insert(log.toCompanion());
    });
  }

  @override
  Future<int> countByStatus(String medicationId, DoseStatus status) async {
    final Expression<int> count = _db.doseLogs.id.count();
    final JoinedSelectStatement<$DoseLogsTable, DoseLogRow> query =
        _db.selectOnly(_db.doseLogs)
          ..addColumns(<Expression<Object>>[count])
          ..where(_db.doseLogs.medicationId.equals(medicationId) &
              _db.doseLogs.status.equals(status.name) &
              _db.doseLogs.isActive.equals(true));
    final List<TypedResult> rows = await query.get();
    if (rows.isEmpty) return 0;
    return rows.first.read(count) ?? 0;
  }
}
