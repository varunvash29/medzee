import '../models/core_enums.dart';

/// What could be read out of a free-typed medicine name.
class InferredMedicine {
  const InferredMedicine({
    required this.name,
    this.strength,
    this.strengthUnit,
    this.form,
  });

  /// The name with strength and form words removed ("Metformin").
  final String name;
  final double? strength;
  final String? strengthUnit;
  final DosageForm? form;

  bool get hasInference => strength != null || form != null;
}

/// Reads strength and dosage form from text the user typed, e.g.
/// "Metformin 500mg tablet" or "Amoxicillin Syrup 125 mg/5 mL".
///
/// Only tokens that are literally present in the input are used; nothing is
/// guessed from a partial drug name. Anything not found stays null so the
/// caller can leave the field for the user.
class MedicineNameInference {
  const MedicineNameInference._();

  static final RegExp _strength = RegExp(
    r'(\d+(?:\.\d+)?)\s*(mcg|µg|ug|mg|g|iu|ml|%)(?:\s*/\s*\d*\s*(?:ml|g))?',
    caseSensitive: false,
  );

  static const Map<String, DosageForm> _forms = <String, DosageForm>{
    'tablet': DosageForm.tablet,
    'tablets': DosageForm.tablet,
    'tab': DosageForm.tablet,
    'tabs': DosageForm.tablet,
    'capsule': DosageForm.capsule,
    'capsules': DosageForm.capsule,
    'cap': DosageForm.capsule,
    'caps': DosageForm.capsule,
    'syrup': DosageForm.liquid,
    'suspension': DosageForm.liquid,
    'solution': DosageForm.liquid,
    'liquid': DosageForm.liquid,
    'injection': DosageForm.injection,
    'inj': DosageForm.injection,
    'inhaler': DosageForm.inhaler,
    'drops': DosageForm.drops,
    'drop': DosageForm.drops,
    'cream': DosageForm.cream,
    'ointment': DosageForm.cream,
    'gel': DosageForm.cream,
    'patch': DosageForm.patch,
  };

  static InferredMedicine parse(String input) {
    String rest = input.trim();
    if (rest.isEmpty) return const InferredMedicine(name: '');

    double? strength;
    String? unit;
    final RegExpMatch? match = _strength.firstMatch(rest);
    if (match != null) {
      strength = double.tryParse(match.group(1)!);
      unit = _normaliseUnit(match.group(2)!);
      rest = rest.replaceRange(match.start, match.end, ' ');
    }

    DosageForm? form;
    final List<String> kept = <String>[];
    for (final String word in rest.split(RegExp(r'\s+'))) {
      if (word.isEmpty) continue;
      final DosageForm? f = _forms[word.toLowerCase()];
      if (f != null && form == null && kept.isNotEmpty) {
        form = f;
      } else {
        kept.add(word);
      }
    }
    return InferredMedicine(
      name: kept.join(' '),
      strength: strength,
      strengthUnit: unit,
      form: form,
    );
  }

  /// The dose unit that normally goes with [form].
  static DoseUnit defaultUnit(DosageForm form) => switch (form) {
        DosageForm.tablet => DoseUnit.tablet,
        DosageForm.capsule => DoseUnit.capsule,
        DosageForm.liquid => DoseUnit.millilitre,
        DosageForm.injection => DoseUnit.unit,
        DosageForm.inhaler => DoseUnit.puff,
        DosageForm.drops => DoseUnit.drop,
        DosageForm.cream => DoseUnit.application,
        DosageForm.patch => DoseUnit.patch,
        DosageForm.other => DoseUnit.unit,
      };

  static String _normaliseUnit(String raw) {
    final String u = raw.toLowerCase();
    return switch (u) {
      'ug' || 'µg' => 'mcg',
      'iu' => 'IU',
      'ml' => 'mL',
      _ => u,
    };
  }
}
