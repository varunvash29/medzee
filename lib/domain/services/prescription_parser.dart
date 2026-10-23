import 'dart:convert';

import '../models/core_enums.dart';
import '../models/prescription_draft.dart';

/// Turns the model's JSON into [ParsedPrescription], strictly.
///
/// The model output is untrusted input: anything malformed is rejected,
/// unknown values become null (never guessed), and every gap is flagged so the
/// review screen can ask the user. Nothing is ever filled in on the user's
/// behalf.
class PrescriptionParser {
  const PrescriptionParser._();

  /// Below this the whole entry is shown as uncertain.
  static const double lowConfidence = 0.6;

  static ParsedPrescription parse(String raw) {
    final Object? decoded;
    try {
      decoded = jsonDecode(_stripFences(raw));
    } on FormatException {
      throw const FormatException('The response was not valid JSON.');
    }
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('The response had an unexpected shape.');
    }
    final Object? list = decoded['medicines'];
    if (list is! List) {
      throw const FormatException('The response had no medicine list.');
    }

    final List<String> warnings = <String>[];
    if (decoded['legible'] == false) {
      warnings.add('Parts of this document were hard to read. Check every '
          'detail against the original.');
    }

    final List<MedicineDraft> drafts = <MedicineDraft>[];
    for (final Object? entry in list) {
      if (entry is! Map<String, dynamic>) {
        warnings.add('One entry could not be understood and was skipped.');
        continue;
      }
      final MedicineDraft? draft = _draft(entry);
      if (draft == null) {
        warnings.add('An entry without a readable medicine name was skipped.');
      } else {
        drafts.add(draft);
      }
    }

    return ParsedPrescription(
      medicines: drafts,
      prescriber: _text(decoded['prescriber']),
      prescriptionDate: _text(decoded['prescriptionDate']),
      notes: _text(decoded['notes']),
      warnings: warnings,
    );
  }

  static MedicineDraft? _draft(Map<String, dynamic> m) {
    final String? name = _text(m['name']);
    if (name == null) return null;

    final Map<DraftField, String> flags = <DraftField, String>{};

    // Fields the model itself said it was unsure about.
    final Object? unsure = m['uncertainFields'];
    if (unsure is List) {
      for (final Object? f in unsure) {
        final DraftField? field = _fieldFromName(f);
        if (field != null) {
          flags[field] = 'Hard to read. Please check against the document.';
        }
      }
    }

    final double? confidence = _number(m['confidence']);
    if (confidence != null && confidence < lowConfidence) {
      flags.putIfAbsent(
        DraftField.name,
        () => 'Low confidence in this entry. Check all details.',
      );
    }

    final double? strength = _positive(_number(m['strengthValue']));
    final String? strengthUnit = _strengthUnit(_text(m['strengthUnit']));
    if (strength == null || strengthUnit == null) {
      flags.putIfAbsent(DraftField.strength, () => 'No strength was readable.');
    }

    final DosageForm? form = _form(_text(m['form']));
    if (form == null) {
      flags.putIfAbsent(DraftField.form, () => 'Form not stated.');
    }

    final bool asNeeded = m['asNeeded'] == true;

    final double? dose = _positive(_number(m['doseQuantity']));
    final DoseUnit? doseUnit = _doseUnit(_text(m['doseUnit']));
    if (!asNeeded && (dose == null || doseUnit == null)) {
      flags[DraftField.dose] = 'The dose per intake was not stated clearly.';
    }

    final int? perDay = _wholeInRange(m['timesPerDay'], 1, 12);
    final List<int> times = _times(m['explicitTimes']);
    if (!asNeeded) {
      if (perDay == null && times.isEmpty) {
        flags[DraftField.frequency] = 'How often was not stated clearly.';
      }
      if (times.isEmpty) {
        flags[DraftField.times] = perDay == null
            ? 'Choose when you want to be reminded.'
            : 'The document does not give clock times. Choose reminder times '
                'that suit your day.';
      }
    }

    final int? duration = _wholeInRange(m['durationDays'], 1, 3650);

    return MedicineDraft(
      name: name,
      brandName: _text(m['brandName']),
      genericName: _text(m['genericName']),
      strength: strength,
      strengthUnit: strengthUnit,
      form: form,
      doseQuantity: dose,
      doseUnit: doseUnit,
      timesPerDay: perDay,
      times: times,
      asNeeded: asNeeded,
      durationDays: duration,
      food: _food(_text(m['food'])),
      instructions: _text(m['instructions']),
      sourceText: _text(m['sourceText']),
      confidence: confidence,
      flags: flags,
    );
  }

  // ------------------------------------------------------------- helpers

  static String _stripFences(String s) {
    String t = s.trim();
    if (t.startsWith('```')) {
      t = t.replaceFirst(RegExp(r'^```[a-zA-Z]*\s*'), '');
      t = t.replaceFirst(RegExp(r'\s*```$'), '');
    }
    return t;
  }

  static String? _text(Object? v) {
    if (v is! String) return null;
    final String t = v.trim();
    if (t.isEmpty || t.toLowerCase() == 'null') return null;
    return t;
  }

  static double? _number(Object? v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v.trim());
    return null;
  }

  static double? _positive(double? v) => (v != null && v > 0) ? v : null;

  static int? _wholeInRange(Object? v, int min, int max) {
    final double? n = _number(v);
    if (n == null || n != n.roundToDouble()) return null;
    final int i = n.toInt();
    return (i >= min && i <= max) ? i : null;
  }

  /// "08:00" / "8:30" -> minutes. Anything else is dropped, not guessed.
  static List<int> _times(Object? v) {
    if (v is! List) return <int>[];
    final Set<int> out = <int>{};
    for (final Object? t in v) {
      if (t is! String) continue;
      final RegExpMatch? m = RegExp(r'^\s*(\d{1,2}):(\d{2})\s*$').firstMatch(t);
      if (m == null) continue;
      final int h = int.parse(m.group(1)!);
      final int min = int.parse(m.group(2)!);
      if (h > 23 || min > 59) continue;
      out.add(h * 60 + min);
    }
    return out.toList()..sort();
  }

  static DraftField? _fieldFromName(Object? f) {
    if (f is! String) return null;
    for (final DraftField d in DraftField.values) {
      if (d.name == f) return d;
    }
    return null;
  }

  static String? _strengthUnit(String? u) {
    if (u == null) return null;
    switch (u.toLowerCase()) {
      case 'mg':
        return 'mg';
      case 'mcg':
      case 'µg':
      case 'ug':
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
    if (f == null) return null;
    for (final DosageForm d in DosageForm.values) {
      if (d.name == f.toLowerCase() && d != DosageForm.other) return d;
    }
    return null;
  }

  static DoseUnit? _doseUnit(String? u) {
    if (u == null) return null;
    for (final DoseUnit d in DoseUnit.values) {
      if (d.name == u.toLowerCase()) return d;
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
    }
    return null; // "unspecified" and anything else: leave unset
  }
}
