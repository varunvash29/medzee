import 'core_enums.dart';

/// Verified medicine information retrieved from a trusted data source.
///
/// Every field that came from an external source is explicitly attributed and
/// dated. Information the user typed themselves lives on [Medication] and is
/// never mixed into this object.
class MedicineInformation {
  const MedicineInformation({
    required this.medicationId,
    required this.sourceName,
    required this.sourceUrl,
    required this.lastUpdated,
    this.genericName,
    this.brandNames = const <String>[],
    this.activeIngredients = const <String>[],
    this.indications = const <String>[],
    this.warnings = const <String>[],
    this.contraindications = const <String>[],
    this.sideEffects = const <String>[],
    this.storage,
    this.dosageForm,
    this.strengths = const <String>[],
    this.foodInteractions = const <String>[],
    this.patientAdvice = const <String>[],
    this.isStale = false,
  });

  final String medicationId;
  final String sourceName;
  final String sourceUrl;
  final DateTime lastUpdated;
  final String? genericName;
  final List<String> brandNames;
  final List<String> activeIngredients;
  final List<String> indications;
  final List<String> warnings;
  final List<String> contraindications;
  final List<String> sideEffects;
  final String? storage;
  final String? dosageForm;
  final List<String> strengths;
  final List<String> foodInteractions;
  final List<String> patientAdvice;

  /// True when the cached copy is older than the provider's cache window.
  final bool isStale;

  bool get hasContent =>
      genericName != null ||
      indications.isNotEmpty ||
      warnings.isNotEmpty ||
      sideEffects.isNotEmpty ||
      activeIngredients.isNotEmpty;
}

/// A medicine returned by a search.
class MedicineSearchResult {
  const MedicineSearchResult({
    required this.name,
    required this.sourceName,
    required this.sourceUrl,
    this.genericName,
    this.brandNames = const <String>[],
    this.activeIngredients = const <String>[],
    this.dosageForm,
    this.strength,
    this.route,
  });

  final String name;
  final String sourceName;
  final String sourceUrl;
  final String? genericName;
  final List<String> brandNames;
  final List<String> activeIngredients;
  final String? dosageForm;
  final String? strength;
  final String? route;
}

/// An alternative or equivalent medicine.
///
/// Medzee never states that a medicine is interchangeable. Each result
/// explains *why* it is shown and which source produced it.
class AlternativeMedicine {
  const AlternativeMedicine({
    required this.id,
    required this.name,
    required this.relation,
    required this.reason,
    required this.sourceName,
    required this.sourceUrl,
    this.brandNames = const <String>[],
    this.activeIngredients = const <String>[],
    this.strength,
    this.dosageForm,
    this.route,
    this.requiresPharmacistReview = true,
  });

  final String id;
  final String name;
  final AlternativeRelation relation;

  /// Human readable justification, e.g. "Same active ingredient: Omeprazole".
  final String reason;
  final String sourceName;
  final String sourceUrl;
  final List<String> brandNames;
  final List<String> activeIngredients;
  final String? strength;
  final String? dosageForm;
  final String? route;

  /// Always true in practice — substitution needs professional verification.
  final bool requiresPharmacistReview;
}

/// A recorded allergy or precaution.
class AllergyRecord {
  const AllergyRecord({
    required this.id,
    required this.substance,
    this.reaction,
    this.severity = ClinicalSeverity.unknown,
    this.notes,
    required this.createdAt,
  });

  final String id;
  final String substance;
  final String? reaction;
  final ClinicalSeverity severity;
  final String? notes;
  final DateTime createdAt;
}

/// A potential interaction between two of the user's medicines.
class InteractionAlert {
  const InteractionAlert({
    required this.id,
    required this.medicationIds,
    required this.severity,
    required this.description,
    required this.sourceName,
    required this.detectedAt,
    this.sourceUrl,
  });

  final String id;
  final List<String> medicationIds;
  final ClinicalSeverity severity;
  final String description;
  final String sourceName;
  final String? sourceUrl;
  final DateTime detectedAt;
}

/// A photo or document attached to a medication.
class PrescriptionAttachment {
  const PrescriptionAttachment({
    required this.id,
    required this.medicationId,
    required this.filePath,
    required this.type,
    required this.createdAt,
    this.caption,
  });

  final String id;
  final String medicationId;
  final String filePath;
  final AttachmentType type;
  final String? caption;
  final DateTime createdAt;
}

/// What kind of file an attachment is.
enum AttachmentType {
  prescription,
  packaging,
  medicineLabel,
  other;

  static AttachmentType fromName(String value) => AttachmentType.values.firstWhere(
        (AttachmentType e) => e.name == value,
        orElse: () => AttachmentType.other,
      );

  String get label => switch (this) {
        AttachmentType.prescription => 'Prescription',
        AttachmentType.packaging => 'Packaging',
        AttachmentType.medicineLabel => 'Label',
        AttachmentType.other => 'Other',
      };
}
