import 'dart:convert';

import '../models/core_enums.dart';
import '../models/medicine_profile.dart';

/// Validates the model's JSON about a medicine. Anything malformed is
/// dropped, and the result never claims more than the data supports.
class MedicineProfileParser {
  const MedicineProfileParser._();

  static const int maxAlternatives = 6;
  static const int maxListItems = 8;

  static MedicineProfile parse(String raw, {required String queriedName}) {
    String t = raw.trim();
    if (t.startsWith('```')) {
      t = t.replaceFirst(RegExp(r'^```[a-zA-Z]*\s*'), '');
      t = t.replaceFirst(RegExp(r'\s*```$'), '');
    }
    final Object? decoded;
    try {
      decoded = jsonDecode(t);
    } on FormatException {
      throw const FormatException('Not valid JSON.');
    }
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected shape.');
    }
    if (decoded['recognized'] != true) return MedicineProfile.unknown;

    final String name = _text(decoded['canonicalName'], 80) ?? queriedName;
    final String queried = queriedName.trim().toLowerCase();

    // Alternatives: real brand names only, no duplicates, never the medicine
    // itself.
    final List<IndianAlternative> alts = <IndianAlternative>[];
    final Set<String> seen = <String>{name.toLowerCase(), queried};
    final Object? rawAlts = decoded['indianAlternatives'];
    if (rawAlts is List) {
      for (final Object? a in rawAlts) {
        if (a is! Map<String, dynamic>) continue;
        final String? brand = _text(a['brand'], 60);
        if (brand == null || !seen.add(brand.toLowerCase())) continue;
        final String composition = _text(a['composition'], 160) ?? '';
        // "Same" is only believable when a composition is stated.
        final AlternativeMatch match = composition.isEmpty
            ? AlternativeMatch.similar
            : AlternativeMatch.fromName(a['match'] as String?);
        alts.add(IndianAlternative(
          brand: brand,
          manufacturer: _text(a['manufacturer'], 60),
          composition: composition,
          match: match,
          note: _text(a['note'], 160),
        ));
        if (alts.length == maxAlternatives) break;
      }
    }

    final List<Ingredient> ingredients = <Ingredient>[];
    final Object? rawIng = decoded['ingredients'];
    if (rawIng is List) {
      for (final Object? i in rawIng) {
        if (i is! Map<String, dynamic>) continue;
        final String? n = _text(i['name'], 60);
        if (n == null) continue;
        final double? v = (i['strengthValue'] as num?)?.toDouble();
        ingredients.add(Ingredient(
          n,
          value: (v != null && v > 0) ? v : null,
          unit: _unit(_text(i['strengthUnit'], 8)),
        ));
      }
    }

    final double? strength = (decoded['strengthValue'] as num?)?.toDouble();

    return MedicineProfile(
      recognized: true,
      name: name,
      genericName: _text(decoded['genericName'], 120),
      ingredients: ingredients,
      form: _form(_text(decoded['form'], 20)),
      strength: (strength != null && strength > 0) ? strength : null,
      strengthUnit: _unit(_text(decoded['strengthUnit'], 8)),
      route: _route(_text(decoded['route'], 20)),
      category: _category(_text(decoded['category'], 30)),
      food: _food(_text(decoded['foodAdvice'], 20)),
      typicalUse: _text(decoded['typicalUse'], 300),
      howItWorks: _text(decoded['howItWorks'], 300),
      sideEffects: _list(decoded['commonSideEffects']),
      warnings: _list(decoded['warnings']),
      storage: _text(decoded['storage'], 200),
      prescriptionStatus: switch (_text(decoded['prescriptionStatus'], 20)) {
        'otc' => 'OTC',
        'prescription' => 'Prescription',
        _ => null,
      },
      alternatives: alts,
      confidence: switch (_text(decoded['confidence'], 10)) {
        'high' => 'high',
        'low' => 'low',
        _ => 'medium',
      },
      fetchedAt: DateTime.now(),
    );
  }

  static String? _text(Object? v, int max) {
    if (v is! String) return null;
    final String t = v.trim();
    if (t.isEmpty || t.toLowerCase() == 'null' || t.toLowerCase() == 'unknown') {
      return null;
    }
    return t.length > max ? t.substring(0, max) : t;
  }

  static List<String> _list(Object? v) {
    if (v is! List) return const <String>[];
    final List<String> out = <String>[];
    for (final Object? e in v) {
      final String? s = _text(e, 200);
      if (s != null) out.add(s);
      if (out.length == maxListItems) break;
    }
    return out;
  }

  static String? _unit(String? u) {
    switch (u?.toLowerCase()) {
      case 'mg':
        return 'mg';
      case 'mcg':
      case 'µg':
        return 'mcg';
      case 'g':
        return 'g';
      case 'ml':
        return 'mL';
      case 'iu':
        return 'IU';
      case '%':
        return '%';
    }
    return null;
  }

  static DosageForm? _form(String? f) {
    for (final DosageForm d in DosageForm.values) {
      if (d.name == f && d != DosageForm.other) return d;
    }
    return null;
  }

  static AdministrationRoute? _route(String? r) {
    for (final AdministrationRoute d in AdministrationRoute.values) {
      if (d.name == r) return d;
    }
    return null;
  }

  static MedicineCategory? _category(String? c) {
    for (final MedicineCategory d in MedicineCategory.values) {
      if (d.name == c && d != MedicineCategory.other) return d;
    }
    return null;
  }

  static FoodInstruction? _food(String? f) {
    switch (f) {
      case 'beforeFood':
        return FoodInstruction.beforeFood;
      case 'afterFood':
        return FoodInstruction.afterFood;
      case 'withFood':
        return FoodInstruction.withFood;
      case 'emptyStomach':
        return FoodInstruction.emptyStomach;
      case 'anyTime':
        return FoodInstruction.anyTime;
    }
    return null;
  }
}
