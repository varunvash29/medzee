import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/medicine_profile.dart';
import 'package:medzee/domain/services/medicine_profile_parser.dart';

String _j(Map<String, Object?> m) => jsonEncode(m);

MedicineProfile _parse(Map<String, Object?> m, [String q = 'Dolo 650']) =>
    MedicineProfileParser.parse(_j(m), queriedName: q);

void main() {
  test('an unrecognised medicine returns the unknown profile', () {
    expect(_parse(<String, Object?>{'recognized': false}).recognized, isFalse);
  });

  test('a full answer maps to typed values', () {
    final MedicineProfile p = _parse(<String, Object?>{
      'recognized': true,
      'canonicalName': 'Dolo 650',
      'genericName': 'Paracetamol',
      'form': 'tablet',
      'strengthValue': 650,
      'strengthUnit': 'MG',
      'route': 'oral',
      'foodAdvice': 'afterFood',
      'category': 'painRelief',
      'prescriptionStatus': 'otc',
      'ingredients': <Object?>[
        <String, Object?>{
          'name': 'Paracetamol',
          'strengthValue': 650,
          'strengthUnit': 'mg',
        },
      ],
    });
    expect(p.form, DosageForm.tablet);
    expect(p.strength, 650);
    expect(p.strengthUnit, 'mg');
    expect(p.food, FoodInstruction.afterFood);
    expect(p.category, MedicineCategory.painRelief);
    expect(p.prescriptionStatus, 'OTC');
    expect(p.ingredients.single.label, 'Paracetamol 650 mg');
  });

  test('bad enum values become null rather than a guess', () {
    final MedicineProfile p = _parse(<String, Object?>{
      'recognized': true,
      'form': 'wafer',
      'route': 'telepathy',
      'foodAdvice': 'sometimes',
      'strengthValue': -1,
      'strengthUnit': 'stone',
    });
    expect(p.form, isNull);
    expect(p.route, isNull);
    expect(p.food, isNull);
    expect(p.strength, isNull);
    expect(p.strengthUnit, isNull);
  });

  test('alternatives are de-duplicated, capped, and never the medicine itself',
      () {
    final MedicineProfile p = _parse(<String, Object?>{
      'recognized': true,
      'canonicalName': 'Dolo 650',
      'indianAlternatives': <Object?>[
        <String, Object?>{'brand': 'Dolo 650', 'composition': 'x', 'match': 'same'},
        <String, Object?>{'brand': 'Calpol 650', 'composition': 'Paracetamol 650 mg', 'match': 'same'},
        <String, Object?>{'brand': 'calpol 650', 'composition': 'Paracetamol 650 mg', 'match': 'same'},
        for (int i = 0; i < 10; i++)
          <String, Object?>{'brand': 'Brand$i', 'composition': 'c', 'match': 'similar'},
      ],
    });
    expect(p.alternatives.length, MedicineProfileParser.maxAlternatives);
    expect(p.alternatives.first.brand, 'Calpol 650');
    expect(
      p.alternatives.where((IndianAlternative a) => a.brand.toLowerCase() == 'dolo 650'),
      isEmpty,
    );
  });

  test('"same" without a stated composition is downgraded to similar', () {
    final MedicineProfile p = _parse(<String, Object?>{
      'recognized': true,
      'indianAlternatives': <Object?>[
        <String, Object?>{'brand': 'Mystery', 'composition': '', 'match': 'same'},
      ],
    });
    expect(p.alternatives.single.match, AlternativeMatch.similar);
  });

  test('a profile survives a JSON round trip (cache)', () {
    final MedicineProfile p = _parse(<String, Object?>{
      'recognized': true,
      'canonicalName': 'Dolo 650',
      'form': 'tablet',
      'strengthValue': 650,
      'strengthUnit': 'mg',
      'commonSideEffects': <String>['Nausea'],
      'indianAlternatives': <Object?>[
        <String, Object?>{'brand': 'Calpol', 'composition': 'Paracetamol', 'match': 'same'},
      ],
    });
    final MedicineProfile back = MedicineProfile.fromJson(
      jsonDecode(jsonEncode(p.toJson())) as Map<String, dynamic>,
    );
    expect(back.name, 'Dolo 650');
    expect(back.form, DosageForm.tablet);
    expect(back.sideEffects, <String>['Nausea']);
    expect(back.alternatives.single.match, AlternativeMatch.same);
  });

  test('malformed responses throw', () {
    expect(
      () => MedicineProfileParser.parse('nope', queriedName: 'x'),
      throwsFormatException,
    );
    expect(
      () => MedicineProfileParser.parse('[]', queriedName: 'x'),
      throwsFormatException,
    );
  });
}
