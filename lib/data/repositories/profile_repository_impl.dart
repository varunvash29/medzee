import 'package:drift/drift.dart';

import '../../domain/models/medicine_info.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/medicine_info_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../local/app_database.dart';
import '../mappers.dart';

/// Drift-backed implementation of [ProfileRepository].
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<UserProfile?> watchProfile() {
    // Medzee is single-profile. `watchSingleOrNull()` throws if an older
    // build ever wrote a second row, so order and limit to the canonical row.
    final SimpleSelectStatement<$UserProfilesTable, UserProfileRow> query =
        _db.select(_db.userProfiles)
          ..orderBy(<OrderClauseGenerator<$UserProfilesTable>>[
            ($UserProfilesTable t) => OrderingTerm.asc(t.createdAt),
            ($UserProfilesTable t) => OrderingTerm.asc(t.id),
          ])
          ..limit(1);
    return query.watchSingleOrNull().map((UserProfileRow? row) => row?.toDomain());
  }

  @override
  Future<UserProfile?> getProfile() async {
    final UserProfileRow? row = await (_db.select(_db.userProfiles)
          ..orderBy(<OrderClauseGenerator<$UserProfilesTable>>[
            ($UserProfilesTable t) => OrderingTerm.asc(t.createdAt),
            ($UserProfilesTable t) => OrderingTerm.asc(t.id),
          ])
          ..limit(1))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _db
        .into(_db.userProfiles)
        .insertOnConflictUpdate(profile.toCompanion());
    // Enforce the single-profile invariant: drop any stale duplicate rows left
    // behind by older builds that created a fresh id on every onboarding run.
    await (_db.delete(_db.userProfiles)
          ..where(($UserProfilesTable t) => t.id.equals(profile.id).not()))
        .go();
  }

  @override
  Future<void> deleteProfile() async {
    await _db.delete(_db.userProfiles).go();
  }
}

/// Drift-backed implementation of [MedicineInfoRepository].
class MedicineInfoRepositoryImpl implements MedicineInfoRepository {
  MedicineInfoRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<MedicineInformation?> get(String medicationId) async {
    final MedicineInformationRow? row =
        await (_db.select(_db.medicineInformationCache)
              ..where(($MedicineInformationCacheTable t) =>
                  t.medicationId.equals(medicationId)))
            .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> cache(MedicineInformation information) async {
    await _db
        .into(_db.medicineInformationCache)
        .insertOnConflictUpdate(information.toCompanion());
  }

  @override
  Stream<List<AllergyRecord>> watchAllergies() {
    final SimpleSelectStatement<$AllergyRecordsTable, AllergyRecordRow> query =
        _db.select(_db.allergyRecords)
          ..orderBy(<OrderClauseGenerator<$AllergyRecordsTable>>[
            ($AllergyRecordsTable t) => OrderingTerm.desc(t.createdAt),
          ]);
    return query.watch().map(
          (List<AllergyRecordRow> rows) => rows
              .map((AllergyRecordRow row) => row.toDomain())
              .toList(growable: false),
        );
  }

  @override
  Future<void> addAllergy(AllergyRecord allergy) async {
    await _db.into(_db.allergyRecords).insert(allergy.toCompanion());
  }

  @override
  Future<void> deleteAllergy(String id) async {
    await (_db.delete(_db.allergyRecords)
          ..where(($AllergyRecordsTable t) => t.id.equals(id)))
        .go();
  }

  @override
  Stream<List<InteractionAlert>> watchAlerts() {
    final SimpleSelectStatement<$InteractionAlertsTable, InteractionAlertRow>
        query = _db.select(_db.interactionAlerts)
      ..orderBy(<OrderClauseGenerator<$InteractionAlertsTable>>[
        ($InteractionAlertsTable t) => OrderingTerm.desc(t.detectedAt),
      ]);
    return query.watch().map(
          (List<InteractionAlertRow> rows) => rows
              .map((InteractionAlertRow row) => row.toDomain())
              .toList(growable: false),
        );
  }

  @override
  Future<void> addAlert(InteractionAlert alert) async {
    await _db.into(_db.interactionAlerts).insert(alert.toCompanion());
  }

  @override
  Stream<List<PrescriptionAttachment>> watchAttachments(
    String medicationId,
  ) {
    final SimpleSelectStatement<$PrescriptionAttachmentsTable,
        PrescriptionAttachmentRow> query = _db.select(_db.prescriptionAttachments)
      ..where(($PrescriptionAttachmentsTable t) =>
          t.medicationId.equals(medicationId))
      ..orderBy(<OrderClauseGenerator<$PrescriptionAttachmentsTable>>[
        ($PrescriptionAttachmentsTable t) => OrderingTerm.desc(t.createdAt),
      ]);
    return query.watch().map(
          (List<PrescriptionAttachmentRow> rows) => rows
              .map((PrescriptionAttachmentRow row) => row.toDomain())
              .toList(growable: false),
        );
  }

  @override
  Future<void> addAttachment(PrescriptionAttachment attachment) async {
    await _db
        .into(_db.prescriptionAttachments)
        .insert(attachment.toCompanion());
  }

  @override
  Future<void> deleteAttachment(String id) async {
    await (_db.delete(_db.prescriptionAttachments)
          ..where(($PrescriptionAttachmentsTable t) => t.id.equals(id)))
        .go();
  }
}
