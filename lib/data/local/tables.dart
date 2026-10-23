import 'package:drift/drift.dart';

/// Schema version. Bump this whenever [AppDatabase.migration] changes.
const int kDatabaseSchemaVersion = 2;

@DataClassName('UserProfileRow')
class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get timezoneId => text().nullable()();
  TextColumn get timeFormat => text()();
  TextColumn get themeMode => text()();
  BoolColumn get notificationsEnabled => boolean()();
  BoolColumn get defaultReminderEnabled => boolean()();
  IntColumn get preReminderMinutes => integer().nullable()();
  BoolColumn get missedFollowUpEnabled => boolean()();
  IntColumn get missedFollowUpMinutes => integer()();
  BoolColumn get quietHoursEnabled => boolean()();
  IntColumn get quietHoursStartMinutes => integer()();
  IntColumn get quietHoursEndMinutes => integer()();
  BoolColumn get dailySummaryEnabled => boolean()();
  IntColumn get dailySummaryMinutes => integer()();
  TextColumn get notificationPrivacy => text()();
  BoolColumn get onboardingCompleted => boolean()();
  BoolColumn get demoMode => boolean()();
  BoolColumn get appLockEnabled => boolean()();
  RealColumn get textScale => real()();
  TextColumn get appearance => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('MedicationRow')
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get genericName => text().nullable()();
  TextColumn get brandName => text().nullable()();
  TextColumn get category => text()();
  TextColumn get form => text()();
  RealColumn get strength => real().nullable()();
  TextColumn get strengthUnit => text()();
  TextColumn get route => text()();
  TextColumn get foodInstruction => text()();
  TextColumn get instructions => text().nullable()();
  TextColumn get prescriber => text().nullable()();
  TextColumn get pharmacyName => text().nullable()();
  TextColumn get pharmacyPhone => text().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isAsNeeded => boolean()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isFavorite => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('SchedulePhaseRow')
class SchedulePhases extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)();
  IntColumn get phaseOrder => integer()();
  TextColumn get kind => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();

  /// Minutes-from-midnight values, serialised as a comma separated list.
  TextColumn get timesMinutes => text()();
  TextColumn get weekdays => text()();
  IntColumn get intervalDays => integer()();
  IntColumn get intervalHours => integer()();
  TextColumn get monthlyDays => text()();
  RealColumn get doseQuantity => real()();
  TextColumn get unit => text()();
  TextColumn get foodInstruction => text().nullable()();
  TextColumn get instructions => text().nullable()();
  BoolColumn get isActive => boolean()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('ScheduledDoseRow')
class ScheduledDoses extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)();
  TextColumn get phaseId => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  DateTimeColumn get localDate => dateTime()();
  IntColumn get scheduledMinutes => integer()();
  RealColumn get doseQuantity => real()();
  TextColumn get unit => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  /// A medication can never have two doses at the same instant. This makes
  /// regenerating the schedule idempotent.
  @override
  List<Set<Column>> get uniqueKeys => [
        {medicationId, scheduledAt},
      ];
}

@DataClassName('DoseLogRow')
class DoseLogs extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)();
  TextColumn get scheduledDoseId => text()();
  TextColumn get status => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  DateTimeColumn get actedAt => dateTime()();
  RealColumn get amountTaken => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get inventoryTransactionId => text().nullable()();
  TextColumn get supersedesLogId => text().nullable()();

  /// Only one log per scheduled dose is "active"; corrections deactivate the
  /// previous row instead of deleting it.
  BoolColumn get isActive => boolean()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('InventoryRow')
class Inventories extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)();
  RealColumn get quantityOnHand => real()();
  TextColumn get unit => text()();
  RealColumn get refillThreshold => real()();
  RealColumn get initialQuantity => real()();
  DateTimeColumn get lastRefillAt => dateTime().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('InventoryTransactionRow')
class InventoryTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()();
  RealColumn get quantityDelta => real()();
  RealColumn get quantityAfter => real()();
  TextColumn get unit => text()();
  DateTimeColumn get createdAt => dateTime()();

  /// Links the movement to the dose that caused it. The unique constraint is
  /// the hard guarantee that a retried dose action can never deduct twice.
  TextColumn get doseLogId => text().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {doseLogId},
      ];
}

@DataClassName('NotificationPreferenceRow')
class NotificationPreferences extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)
          .nullable()();
  BoolColumn get remindersEnabled => boolean()();
  IntColumn get preReminderMinutes => integer().nullable()();
  BoolColumn get missedFollowUpEnabled => boolean()();
  IntColumn get missedFollowUpMinutes => integer()();
  BoolColumn get soundEnabled => boolean()();
  BoolColumn get vibrationEnabled => boolean()();
  TextColumn get privacy => text()();
  BoolColumn get lowStockAlertEnabled => boolean()();
  BoolColumn get runOutAlertEnabled => boolean()();
  BoolColumn get refillAlertEnabled => boolean()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('RefillReminderRow')
class RefillReminders extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)();
  RealColumn get threshold => real()();
  BoolColumn get enabled => boolean()();
  DateTimeColumn get lastNotifiedAt => dateTime().nullable()();
  IntColumn get leadDays => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('MedicineInformationRow')
class MedicineInformationCache extends Table {
  TextColumn get medicationId => text()();
  TextColumn get sourceName => text()();
  TextColumn get sourceUrl => text()();
  DateTimeColumn get lastUpdated => dateTime()();
  TextColumn get genericName => text().nullable()();
  TextColumn get brandNames => text()();
  TextColumn get activeIngredients => text()();
  TextColumn get indications => text()();
  TextColumn get warnings => text()();
  TextColumn get contraindications => text()();
  TextColumn get sideEffects => text()();
  TextColumn get storage => text().nullable()();
  TextColumn get dosageForm => text().nullable()();
  TextColumn get strengths => text()();
  TextColumn get foodInteractions => text()();
  TextColumn get patientAdvice => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{medicationId};
}

@DataClassName('AllergyRecordRow')
class AllergyRecords extends Table {
  TextColumn get id => text()();
  TextColumn get substance => text()();
  TextColumn get reaction => text().nullable()();
  TextColumn get severity => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('InteractionAlertRow')
class InteractionAlerts extends Table {
  TextColumn get id => text()();
  TextColumn get medicationIds => text()();
  TextColumn get severity => text()();
  TextColumn get description => text()();
  TextColumn get sourceName => text()();
  TextColumn get sourceUrl => text().nullable()();
  DateTimeColumn get detectedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// A record of every local notification Medzee has scheduled.
///
/// Keeping this table in sync with the OS scheduler is what allows Medzee to
/// cancel a medicine's reminders precisely when it is paused or deleted, and
/// to rebuild them after a reboot without creating duplicates.
@DataClassName('NotificationScheduleRow')
class NotificationSchedules extends Table {
  /// The numeric notification id used on the platform.
  IntColumn get notificationId => integer()();
  TextColumn get kind => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade).nullable()();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get doseId => text().nullable()();
  TextColumn get payload => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{notificationId};
}

@DataClassName('PrescriptionAttachmentRow')
class PrescriptionAttachments extends Table {  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)();
  TextColumn get filePath => text()();
  TextColumn get type => text()();
  TextColumn get caption => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DataClassName('CaregiverAccessRow')
class CaregiverAccess extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)();
  TextColumn get caregiverName => text()();
  TextColumn get contact => text().nullable()();

  /// The caregiver may see the schedule but not change it.
  BoolColumn get canEdit => boolean()();
  DateTimeColumn get grantedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// Every change the schedule assistant applied, with what is needed to undo it.
@DataClassName('ScheduleAuditRow')
class ScheduleAuditLog extends Table {
  /// The proposal id, so a proposal can only ever be applied once.
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get medicationId => text()();
  TextColumn get summary => text()();

  /// JSON snapshot of what the change replaced (empty when nothing to restore).
  TextColumn get beforeJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get undone => boolean().withDefault(const Constant(false))();

  /// For a timed pause: when reminders should come back.
  DateTimeColumn get resumeOn => dateTime().nullable()();
  BoolColumn get resumed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
