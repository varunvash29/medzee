import 'core_enums.dart';

/// How closely an alternative matches the medicine it is offered for.
enum AlternativeMatch {
  /// Same active ingredient(s) at the same strength.
  same,

  /// Same ingredient but a different strength, or a related medicine.
  similar;

  static AlternativeMatch fromName(String? n) =>
      n == 'same' ? AlternativeMatch.same : AlternativeMatch.similar;
}

/// One active ingredient with its amount, e.g. Paracetamol 650 mg.
class Ingredient {
  const Ingredient(this.name, {this.value, this.unit});

  final String name;
  final double? value;
  final String? unit;

  String get label {
    if (value == null) return name;
    final String n =
        value == value!.roundToDouble() ? value!.toInt().toString() : '$value';
    return '$name $n${unit == null ? '' : ' $unit'}';
  }

  Map<String, Object?> toJson() =>
      <String, Object?>{'name': name, 'value': value, 'unit': unit};

  factory Ingredient.fromJson(Map<String, dynamic> j) => Ingredient(
        j['name'] as String,
        value: (j['value'] as num?)?.toDouble(),
        unit: j['unit'] as String?,
      );
}

/// A brand sold in India with the same or similar composition.
class IndianAlternative {
  const IndianAlternative({
    required this.brand,
    required this.composition,
    required this.match,
    this.manufacturer,
    this.note,
  });

  final String brand;
  final String? manufacturer;
  final String composition;
  final AlternativeMatch match;
  final String? note;

  Map<String, Object?> toJson() => <String, Object?>{
        'brand': brand,
        'manufacturer': manufacturer,
        'composition': composition,
        'match': match.name,
        'note': note,
      };

  factory IndianAlternative.fromJson(Map<String, dynamic> j) =>
      IndianAlternative(
        brand: j['brand'] as String,
        manufacturer: j['manufacturer'] as String?,
        composition: (j['composition'] as String?) ?? '',
        match: AlternativeMatch.fromName(j['match'] as String?),
        note: j['note'] as String?,
      );
}

/// What Medzee knows about a medicine, inferred from its name.
///
/// This is AI-generated reference information, not a prescription: it is
/// always shown with that label, and the user's own doctor's instructions
/// override it.
class MedicineProfile {
  const MedicineProfile({
    required this.recognized,
    required this.name,
    this.genericName,
    this.ingredients = const <Ingredient>[],
    this.form,
    this.strength,
    this.strengthUnit,
    this.route,
    this.category,
    this.food,
    this.typicalUse,
    this.howItWorks,
    this.sideEffects = const <String>[],
    this.warnings = const <String>[],
    this.storage,
    this.prescriptionStatus,
    this.alternatives = const <IndianAlternative>[],
    this.confidence = 'medium',
    this.fetchedAt,
  });

  /// False when the name could not be identified as a medicine.
  final bool recognized;
  final String name;
  final String? genericName;
  final List<Ingredient> ingredients;
  final DosageForm? form;
  final double? strength;
  final String? strengthUnit;
  final AdministrationRoute? route;
  final MedicineCategory? category;
  final FoodInstruction? food;
  final String? typicalUse;
  final String? howItWorks;
  final List<String> sideEffects;
  final List<String> warnings;
  final String? storage;

  /// "OTC" or "Prescription" as sold in India, when known.
  final String? prescriptionStatus;
  final List<IndianAlternative> alternatives;

  /// "high", "medium" or "low".
  final String confidence;
  final DateTime? fetchedAt;

  static const MedicineProfile unknown =
      MedicineProfile(recognized: false, name: '');

  String? get strengthLabel {
    if (strength == null) return null;
    final String n = strength == strength!.roundToDouble()
        ? strength!.toInt().toString()
        : '$strength';
    return '$n ${strengthUnit ?? 'mg'}';
  }

  Map<String, Object?> toJson() => <String, Object?>{
        'recognized': recognized,
        'name': name,
        'genericName': genericName,
        'ingredients': ingredients.map((Ingredient i) => i.toJson()).toList(),
        'form': form?.name,
        'strength': strength,
        'strengthUnit': strengthUnit,
        'route': route?.name,
        'category': category?.name,
        'food': food?.name,
        'typicalUse': typicalUse,
        'howItWorks': howItWorks,
        'sideEffects': sideEffects,
        'warnings': warnings,
        'storage': storage,
        'prescriptionStatus': prescriptionStatus,
        'alternatives':
            alternatives.map((IndianAlternative a) => a.toJson()).toList(),
        'confidence': confidence,
        'fetchedAt': (fetchedAt ?? DateTime.now()).toIso8601String(),
      };

  factory MedicineProfile.fromJson(Map<String, dynamic> j) {
    List<String> strings(Object? v) =>
        v is List ? v.whereType<String>().toList() : const <String>[];
    return MedicineProfile(
      recognized: j['recognized'] == true,
      name: (j['name'] as String?) ?? '',
      genericName: j['genericName'] as String?,
      ingredients: (j['ingredients'] is List)
          ? (j['ingredients'] as List)
              .whereType<Map<String, dynamic>>()
              .map(Ingredient.fromJson)
              .toList()
          : const <Ingredient>[],
      form: j['form'] == null ? null : DosageForm.fromName(j['form'] as String),
      strength: (j['strength'] as num?)?.toDouble(),
      strengthUnit: j['strengthUnit'] as String?,
      route: j['route'] == null
          ? null
          : AdministrationRoute.fromName(j['route'] as String),
      category: j['category'] == null
          ? null
          : MedicineCategory.fromName(j['category'] as String),
      food: j['food'] == null
          ? null
          : FoodInstruction.fromName(j['food'] as String),
      typicalUse: j['typicalUse'] as String?,
      howItWorks: j['howItWorks'] as String?,
      sideEffects: strings(j['sideEffects']),
      warnings: strings(j['warnings']),
      storage: j['storage'] as String?,
      prescriptionStatus: j['prescriptionStatus'] as String?,
      alternatives: (j['alternatives'] is List)
          ? (j['alternatives'] as List)
              .whereType<Map<String, dynamic>>()
              .map(IndianAlternative.fromJson)
              .toList()
          : const <IndianAlternative>[],
      confidence: (j['confidence'] as String?) ?? 'medium',
      fetchedAt: j['fetchedAt'] == null
          ? null
          : DateTime.tryParse(j['fetchedAt'] as String),
    );
  }
}
