import 'core_enums.dart';

/// A medicine the user is taking.
///
/// The medication record holds the *what* (identity, form, strength, dose
/// instructions). The *when* lives in [SchedulePhase] so a course can taper
/// or change over time without losing history.
class Medication {
  const Medication({
    required this.id,
    required this.name,
    this.genericName,
    this.brandName,
    this.prescribedAs,
    this.category = MedicineCategory.other,
    this.form = DosageForm.tablet,
    this.strength,
    this.strengthUnit = 'mg',
    this.route = AdministrationRoute.oral,
    this.foodInstruction = FoodInstruction.anyTime,
    this.instructions,
    this.prescriber,
    this.pharmacyName,
    this.pharmacyPhone,
    this.status = MedicationStatus.active,
    this.startDate,
    this.endDate,
    this.isAsNeeded = false,
    this.photoPath,
    this.barcode,
    this.notes,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;

  /// Display name, e.g. "Vitamin D3".
  final String name;
  final String? genericName;
  final String? brandName;

  /// The name on the prescription when what was bought is a different brand
  /// of the same salt. Null when they are the same.
  final String? prescribedAs;
  final MedicineCategory category;
  final DosageForm form;

  /// Numeric strength, e.g. 500.
  final double? strength;

  /// Strength unit, e.g. "mg", "mg/mL", "mcg".
  final String strengthUnit;
  final AdministrationRoute route;
  final FoodInstruction foodInstruction;

  /// Free-form instructions typed by the user. The original prescription
  /// wording is never rewritten by Medzee.
  final String? instructions;
  final String? prescriber;
  final String? pharmacyName;
  final String? pharmacyPhone;
  final MedicationStatus status;
  final DateTime? startDate;

  /// Null means the medication is ongoing (no forced end date).
  final DateTime? endDate;

  /// True for "take as needed" medicines. PRN doses are excluded from
  /// scheduled adherence denominators.
  final bool isAsNeeded;
  final String? photoPath;
  final String? barcode;
  final String? notes;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isOngoing => endDate == null;

  /// Human readable strength such as "500 mg".
  String? get strengthLabel {
    final double? value = strength;
    if (value == null) return null;
    final String number = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
    return '$number $strengthUnit';
  }

  /// Best available label for the active ingredient of this medicine.
  String get activeIngredientLabel => (genericName?.trim().isNotEmpty ?? false)
      ? genericName!.trim()
      : name;

  Medication copyWith({
    String? name,
    String? genericName,
    bool clearGenericName = false,
    String? brandName,
    bool clearBrandName = false,
    String? prescribedAs,
    bool clearPrescribedAs = false,
    MedicineCategory? category,
    DosageForm? form,
    double? strength,
    bool clearStrength = false,
    String? strengthUnit,
    AdministrationRoute? route,
    FoodInstruction? foodInstruction,
    String? instructions,
    bool clearInstructions = false,
    String? prescriber,
    bool clearPrescriber = false,
    String? pharmacyName,
    bool clearPharmacyName = false,
    String? pharmacyPhone,
    bool clearPharmacyPhone = false,
    MedicationStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    bool? isAsNeeded,
    String? photoPath,
    bool clearPhotoPath = false,
    String? barcode,
    bool clearBarcode = false,
    String? notes,
    bool clearNotes = false,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
      id: id,
      name: name ?? this.name,
      genericName: clearGenericName ? null : (genericName ?? this.genericName),
      brandName: clearBrandName ? null : (brandName ?? this.brandName),
      prescribedAs:
          clearPrescribedAs ? null : (prescribedAs ?? this.prescribedAs),
      category: category ?? this.category,
      form: form ?? this.form,
      strength: clearStrength ? null : (strength ?? this.strength),
      strengthUnit: strengthUnit ?? this.strengthUnit,
      route: route ?? this.route,
      foodInstruction: foodInstruction ?? this.foodInstruction,
      instructions: clearInstructions ? null : (instructions ?? this.instructions),
      prescriber: clearPrescriber ? null : (prescriber ?? this.prescriber),
      pharmacyName:
          clearPharmacyName ? null : (pharmacyName ?? this.pharmacyName),
      pharmacyPhone:
          clearPharmacyPhone ? null : (pharmacyPhone ?? this.pharmacyPhone),
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      isAsNeeded: isAsNeeded ?? this.isAsNeeded,
      photoPath: clearPhotoPath ? null : (photoPath ?? this.photoPath),
      barcode: clearBarcode ? null : (barcode ?? this.barcode),
      notes: clearNotes ? null : (notes ?? this.notes),
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Medication && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

/// One phase of a medication's schedule.
///
/// A phase is a contiguous window during which a single recurrence rule and
/// a single dose size apply. Tapering is expressed as consecutive phases
/// (e.g. 4 tablets for 3 days, then 2 tablets for 4 days) so every generated
/// dose still points at the phase that produced it.
class SchedulePhase {
  const SchedulePhase({
    required this.id,
    required this.medicationId,
    required this.order,
    required this.kind,
    required this.startDate,
    this.endDate,
    this.timesMinutes = const <int>[],
    this.weekdays = const <int>{},
    this.intervalDays = 1,
    this.intervalHours = 8,
    this.monthlyDays = const <int>[],
    this.doseQuantity = 1,
    this.unit = DoseUnit.tablet,
    this.foodInstruction,
    this.instructions,
    this.isActive = true,
  });

  final String id;
  final String medicationId;

  /// Position of this phase inside the medication's schedule.
  final int order;
  final ScheduleKind kind;

  /// Inclusive first day the phase applies (local date).
  final DateTime startDate;

  /// Inclusive last day the phase applies. Null = open ended.
  final DateTime? endDate;

  /// Local wall-clock times in minutes from midnight, e.g. 08:30 = 510.
  final List<int> timesMinutes;

  /// ISO weekdays (1 = Monday ... 7 = Sunday).
  final Set<int> weekdays;

  /// Interval used by [ScheduleKind.everyNDays] (2 = alternate days).
  final int intervalDays;

  /// Interval in hours used by [ScheduleKind.everyNHours].
  final int intervalHours;

  /// Days of the month (1-31) used by [ScheduleKind.monthly].
  final List<int> monthlyDays;

  final double doseQuantity;
  final DoseUnit unit;

  /// Overrides the medication-level food instruction when set.
  final FoodInstruction? foodInstruction;
  final String? instructions;
  final bool isActive;

  /// Whether the phase produces a fixed, schedulable reminder.
  bool get producesReminders => !kind.isAsNeeded;

  SchedulePhase copyWith({
    String? id,
    String? medicationId,
    int? order,
    ScheduleKind? kind,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    List<int>? timesMinutes,
    Set<int>? weekdays,
    int? intervalDays,
    int? intervalHours,
    List<int>? monthlyDays,
    double? doseQuantity,
    DoseUnit? unit,
    FoodInstruction? foodInstruction,
    bool clearFoodInstruction = false,
    String? instructions,
    bool clearInstructions = false,
    bool? isActive,
  }) {
    return SchedulePhase(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      order: order ?? this.order,
      kind: kind ?? this.kind,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      timesMinutes: timesMinutes ?? this.timesMinutes,
      weekdays: weekdays ?? this.weekdays,
      intervalDays: intervalDays ?? this.intervalDays,
      intervalHours: intervalHours ?? this.intervalHours,
      monthlyDays: monthlyDays ?? this.monthlyDays,
      doseQuantity: doseQuantity ?? this.doseQuantity,
      unit: unit ?? this.unit,
      foodInstruction: clearFoodInstruction
          ? null
          : (foodInstruction ?? this.foodInstruction),
      instructions: clearInstructions ? null : (instructions ?? this.instructions),
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SchedulePhase && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

/// Convenience wrapper describing how often a medication is taken.
class ScheduleSummary {
  const ScheduleSummary({
    required this.kind,
    required this.timesMinutes,
    required this.weekdays,
    required this.intervalDays,
    required this.monthlyDays,
    required this.startDate,
    required this.endDate,
    required this.doseQuantity,
    required this.unit,
  });

  final ScheduleKind kind;
  final List<int> timesMinutes;
  final Set<int> weekdays;
  final int intervalDays;
  final List<int> monthlyDays;
  final DateTime startDate;
  final DateTime? endDate;
  final double doseQuantity;
  final DoseUnit unit;

  factory ScheduleSummary.fromPhase(SchedulePhase phase) => ScheduleSummary(
        kind: phase.kind,
        timesMinutes: phase.timesMinutes,
        weekdays: phase.weekdays,
        intervalDays: phase.intervalDays,
        monthlyDays: phase.monthlyDays,
        startDate: phase.startDate,
        endDate: phase.endDate,
        doseQuantity: phase.doseQuantity,
        unit: phase.unit,
      );
}
