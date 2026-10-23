/// Shared domain enumerations.
///
/// These are plain Dart enums (not database enums) so the domain layer stays
/// independent of Drift. Storage encoding lives in the data layer.
library;

/// Lifecycle state of a medication.
enum MedicationStatus {
  /// Doses are being scheduled and reminders are active.
  active,

  /// Temporarily stopped by the user; reminders are cancelled but history
  /// and stock are preserved.
  paused,

  /// The course finished; no further reminders, kept for history.
  completed,

  /// Removed from the main library but fully retained.
  archived;

  static MedicationStatus fromName(String value) => MedicationStatus.values
      .firstWhere((MedicationStatus e) => e.name == value, orElse: () => MedicationStatus.active);

  String get label => switch (this) {
        MedicationStatus.active => 'Active',
        MedicationStatus.paused => 'Paused',
        MedicationStatus.completed => 'Completed',
        MedicationStatus.archived => 'Archived',
      };
}

/// Physical form of the medicine.
enum DosageForm {
  tablet,
  capsule,
  liquid,
  injection,
  inhaler,
  drops,
  cream,
  patch,
  other;

  static DosageForm fromName(String value) => DosageForm.values.firstWhere(
        (DosageForm e) => e.name == value,
        orElse: () => DosageForm.other,
      );

  String get label => switch (this) {
        DosageForm.tablet => 'Tablet',
        DosageForm.capsule => 'Capsule',
        DosageForm.liquid => 'Liquid',
        DosageForm.injection => 'Injection',
        DosageForm.inhaler => 'Inhaler',
        DosageForm.drops => 'Drops',
        DosageForm.cream => 'Cream',
        DosageForm.patch => 'Patch',
        DosageForm.other => 'Other',
      };

  /// Whether the unit of this form is a discrete countable unit, which is
  /// what makes automated inventory deduction safe.
  bool get isCountable => switch (this) {
        DosageForm.tablet || DosageForm.capsule => true,
        DosageForm.injection || DosageForm.patch => true,
        DosageForm.liquid || DosageForm.inhaler || DosageForm.drops => false,
        DosageForm.cream || DosageForm.other => false,
      };
}

/// Unit used for a single dose and for inventory.
enum DoseUnit {
  tablet,
  capsule,
  millilitre,
  drop,
  puff,
  patch,
  application,
  sachet,
  ampoule,
  unit;

  static DoseUnit fromName(String value) => DoseUnit.values.firstWhere(
        (DoseUnit e) => e.name == value,
        orElse: () => DoseUnit.unit,
      );

  String get label => switch (this) {
        DoseUnit.tablet => 'tablet(s)',
        DoseUnit.capsule => 'capsule(s)',
        DoseUnit.millilitre => 'mL',
        DoseUnit.drop => 'drop(s)',
        DoseUnit.puff => 'puff(s)',
        DoseUnit.patch => 'patch(es)',
        DoseUnit.application => 'application(s)',
        DoseUnit.sachet => 'sachet(s)',
        DoseUnit.ampoule => 'ampoule(s)',
        DoseUnit.unit => 'unit(s)',
      };

  String get singular => switch (this) {
        DoseUnit.tablet => 'tablet',
        DoseUnit.capsule => 'capsule',
        DoseUnit.millilitre => 'mL',
        DoseUnit.drop => 'drop',
        DoseUnit.puff => 'puff',
        DoseUnit.patch => 'patch',
        DoseUnit.application => 'application',
        DoseUnit.sachet => 'sachet',
        DoseUnit.ampoule => 'ampoule',
        DoseUnit.unit => 'unit',
      };

  /// Continuous units cannot be safely deducted as a whole-unit count, so the
  /// inventory engine treats them as manually reconcilable.
  bool get isDiscrete => switch (this) {
        DoseUnit.tablet ||
        DoseUnit.capsule ||
        DoseUnit.puff ||
        DoseUnit.patch ||
        DoseUnit.application ||
        DoseUnit.sachet ||
        DoseUnit.ampoule =>
          true,
        DoseUnit.millilitre || DoseUnit.drop || DoseUnit.unit => false,
      };

  /// Units that must be measured in volume.
  bool get isVolume => this == DoseUnit.millilitre || this == DoseUnit.drop;
}

/// Food-related instruction.
enum FoodInstruction {
  beforeFood,
  afterFood,
  withFood,
  emptyStomach,
  anyTime,
  custom;

  static FoodInstruction fromName(String value) =>
      FoodInstruction.values.firstWhere(
        (FoodInstruction e) => e.name == value,
        orElse: () => FoodInstruction.anyTime,
      );

  String get label => switch (this) {
        FoodInstruction.beforeFood => 'Before food',
        FoodInstruction.afterFood => 'After food',
        FoodInstruction.withFood => 'With food',
        FoodInstruction.emptyStomach => 'Empty stomach',
        FoodInstruction.anyTime => 'No food instruction',
        FoodInstruction.custom => 'Custom',
      };

  String get shortLabel => switch (this) {
        FoodInstruction.beforeFood => 'Before food',
        FoodInstruction.afterFood => 'After food',
        FoodInstruction.withFood => 'With food',
        FoodInstruction.emptyStomach => 'Empty stomach',
        FoodInstruction.anyTime => 'Any time',
        FoodInstruction.custom => 'Custom',
      };
}

/// Route of administration.
enum AdministrationRoute {
  oral,
  sublingual,
  topical,
  inhaled,
  injected,
  rectal,
  ophthalmic,
  otic,
  other;

  static AdministrationRoute fromName(String value) =>
      AdministrationRoute.values.firstWhere(
        (AdministrationRoute e) => e.name == value,
        orElse: () => AdministrationRoute.other,
      );

  String get label => switch (this) {
        AdministrationRoute.oral => 'Oral',
        AdministrationRoute.sublingual => 'Sublingual',
        AdministrationRoute.topical => 'Topical',
        AdministrationRoute.inhaled => 'Inhaled',
        AdministrationRoute.injected => 'Injected',
        AdministrationRoute.rectal => 'Rectal',
        AdministrationRoute.ophthalmic => 'Ophthalmic',
        AdministrationRoute.otic => 'Otic',
        AdministrationRoute.other => 'Other',
      };
}

/// Therapeutic category of the medicine.
enum MedicineCategory {
  painRelief,
  antibiotic,
  cardiovascular,
  diabetes,
  respiratory,
  gastrointestinal,
  allergy,
  vitaminSupplement,
  mentalHealth,
  hormonal,
  sleep,
  skin,
  eyeEar,
  bloodThinner,
  other;

  static MedicineCategory fromName(String value) =>
      MedicineCategory.values.firstWhere(
        (MedicineCategory e) => e.name == value,
        orElse: () => MedicineCategory.other,
      );

  String get label => switch (this) {
        MedicineCategory.painRelief => 'Pain relief',
        MedicineCategory.antibiotic => 'Antibiotic',
        MedicineCategory.cardiovascular => 'Cardiovascular',
        MedicineCategory.diabetes => 'Diabetes',
        MedicineCategory.respiratory => 'Respiratory',
        MedicineCategory.gastrointestinal => 'Digestive',
        MedicineCategory.allergy => 'Allergy',
        MedicineCategory.vitaminSupplement => 'Vitamins & supplements',
        MedicineCategory.mentalHealth => 'Mental health',
        MedicineCategory.hormonal => 'Hormonal',
        MedicineCategory.sleep => 'Sleep',
        MedicineCategory.skin => 'Skin',
        MedicineCategory.eyeEar => 'Eyes & ears',
        MedicineCategory.bloodThinner => 'Blood thinner',
        MedicineCategory.other => 'Other',
      };
}

/// How a schedule phase repeats.
enum ScheduleKind {
  /// Every day at the configured times.
  daily,

  /// On the selected weekdays at the configured times.
  weekly,

  /// Every N hours from a start time, rolling through the day.
  everyNHours,

  /// Every N days (N = 2 means alternate days) at the configured times.
  everyNDays,

  /// On the selected days of the month.
  monthly,

  /// Take as needed. No fixed reminders are created.
  asNeeded,

  /// Fully custom set of weekdays + times.
  custom;

  static ScheduleKind fromName(String value) => ScheduleKind.values.firstWhere(
        (ScheduleKind e) => e.name == value,
        orElse: () => ScheduleKind.daily,
      );

  String get label => switch (this) {
        ScheduleKind.daily => 'Every day',
        ScheduleKind.weekly => 'Specific days',
        ScheduleKind.everyNHours => 'Every N hours',
        ScheduleKind.everyNDays => 'Every N days',
        ScheduleKind.monthly => 'Days of the month',
        ScheduleKind.asNeeded => 'As needed (PRN)',
        ScheduleKind.custom => 'Custom',
      };

  bool get isAsNeeded => this == ScheduleKind.asNeeded;
}

/// Status of a single scheduled dose instance.
enum DoseStatus {
  /// Not yet logged and still in the future.
  pending,

  /// The user confirmed the dose was taken.
  taken,

  /// The user intentionally skipped this dose.
  skipped,

  /// The scheduled time passed and the grace window elapsed without a log.
  missed,

  /// The dose no longer applies (schedule changed, medication paused/ended).
  cancelled;

  static DoseStatus fromName(String value) => DoseStatus.values.firstWhere(
        (DoseStatus e) => e.name == value,
        orElse: () => DoseStatus.pending,
      );

  bool get isResolved =>
      this == DoseStatus.taken ||
      this == DoseStatus.skipped ||
      this == DoseStatus.missed;
}

/// Type of inventory movement.
enum InventoryTransactionType {
  initial,
  refill,
  deduction,
  adjustment,
  expiry,
  reversal;

  static InventoryTransactionType fromName(String value) =>
      InventoryTransactionType.values.firstWhere(
        (InventoryTransactionType e) => e.name == value,
        orElse: () => InventoryTransactionType.adjustment,
      );

  String get label => switch (this) {
        InventoryTransactionType.initial => 'Opening stock',
        InventoryTransactionType.refill => 'Refill',
        InventoryTransactionType.deduction => 'Dose used',
        InventoryTransactionType.adjustment => 'Manual adjustment',
        InventoryTransactionType.expiry => 'Expired / discarded',
        InventoryTransactionType.reversal => 'Reversed',
      };
}

/// How much medicine detail a notification reveals.
enum NotificationPrivacy {
  /// Show the medicine name and dose.
  detailed,

  /// Show only that a reminder is due ("Time for your medicine").
  private;

  static NotificationPrivacy fromName(String value) =>
      NotificationPrivacy.values.firstWhere(
        (NotificationPrivacy e) => e.name == value,
        orElse: () => NotificationPrivacy.detailed,
      );
}

/// User's preferred clock format.
enum TimeFormat {
  h12,
  h24;

  static TimeFormat fromName(String value) => TimeFormat.values.firstWhere(
        (TimeFormat e) => e.name == value,
        orElse: () => TimeFormat.h12,
      );
}

/// Sort options for the medicine library.
enum MedicineSort {
  nextDose,
  name,
  lowStock,
  recentlyAdded;

  static MedicineSort fromName(String value) => MedicineSort.values.firstWhere(
        (MedicineSort e) => e.name == value,
        orElse: () => MedicineSort.nextDose,
      );

  String get label => switch (this) {
        MedicineSort.nextDose => 'Next dose',
        MedicineSort.name => 'Name',
        MedicineSort.lowStock => 'Low stock',
        MedicineSort.recentlyAdded => 'Recently added',
      };
}

/// How closely an alternative medicine matches the original.
enum AlternativeRelation {
  /// Same active ingredient, matching strength and dosage form.
  genericEquivalent,

  /// Same active ingredient, different brand presentation.
  brandEquivalent,

  /// Different active ingredient used for a related purpose. Never a
  /// substitute — always flagged for professional verification.
  therapeuticAlternative,

  /// Same brand family, different strength or form.
  sameBrandVariant;

  static AlternativeRelation fromName(String value) =>
      AlternativeRelation.values.firstWhere(
        (AlternativeRelation e) => e.name == value,
        orElse: () => AlternativeRelation.therapeuticAlternative,
      );

  String get label => switch (this) {
        AlternativeRelation.genericEquivalent => 'Generic equivalent',
        AlternativeRelation.brandEquivalent => 'Brand equivalent',
        AlternativeRelation.therapeuticAlternative => 'Therapeutic alternative',
        AlternativeRelation.sameBrandVariant => 'Brand variant',
      };
}

/// What a scheduled notification is for.
enum NotificationKind {
  doseReminder,
  preReminder,
  missedFollowUp,
  lowStock,
  runOut,
  refill,
  dailySummary,
  courseComplete;

  static NotificationKind fromName(String value) =>
      NotificationKind.values.firstWhere(
        (NotificationKind e) => e.name == value,
        orElse: () => NotificationKind.doseReminder,
      );
}

/// Severity of a recorded interaction or allergy.
enum ClinicalSeverity {  low,
  moderate,
  high,
  unknown;

  static ClinicalSeverity fromName(String value) =>
      ClinicalSeverity.values.firstWhere(
        (ClinicalSeverity e) => e.name == value,
        orElse: () => ClinicalSeverity.unknown,
      );

  String get label => switch (this) {
        ClinicalSeverity.low => 'Low',
        ClinicalSeverity.moderate => 'Moderate',
        ClinicalSeverity.high => 'High',
        ClinicalSeverity.unknown => 'Unknown',
      };
}
