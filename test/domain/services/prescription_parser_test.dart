import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/prescription_draft.dart';
import 'package:medzee/domain/services/prescription_parser.dart';

String _json(List<Map<String, Object?>> meds, {bool legible = true}) =>
    jsonEncode(<String, Object?>{'legible': legible, 'medicines': meds});

void main() {
  test('a fully stated medicine parses without flags on dose and times', () {
    final ParsedPrescription p = PrescriptionParser.parse(_json(<Map<String, Object?>>[
      <String, Object?>{
        'name': 'Metformin',
        'strengthValue': 500,
        'strengthUnit': 'mg',
        'form': 'tablet',
        'doseQuantity': 1,
        'doseUnit': 'tablet',
        'timesPerDay': 2,
        'explicitTimes': <String>['08:00', '20:00'],
        'durationDays': 30,
        'food': 'afterFood',
        'instructions': 'Take after meals',
        'confidence': 0.95,
      },
    ]));
    final MedicineDraft m = p.medicines.single;
    expect(m.times, <int>[480, 1200]);
    expect(m.food, FoodInstruction.afterFood);
    expect(m.isFlagged(DraftField.dose), isFalse);
    expect(m.isFlagged(DraftField.times), isFalse);
    m.reviewed = true;
    expect(m.canImport, isTrue);
  });

  test('missing clock times are flagged and block import, never invented', () {
    final MedicineDraft m = PrescriptionParser.parse(_json(<Map<String, Object?>>[
      <String, Object?>{
        'name': 'Amoxicillin',
        'doseQuantity': 1,
        'doseUnit': 'capsule',
        'timesPerDay': 3,
      },
    ])).medicines.single;
    expect(m.times, isEmpty);
    expect(m.isFlagged(DraftField.times), isTrue);
    expect(m.isFlagged(DraftField.strength), isTrue);
    expect(m.canImport, isFalse);
  });

  test('a missing dose is flagged and blocks import', () {
    final MedicineDraft m = PrescriptionParser.parse(_json(<Map<String, Object?>>[
      <String, Object?>{
        'name': 'Aspirin',
        'explicitTimes': <String>['09:00'],
      },
    ])).medicines.single;
    expect(m.doseQuantity, isNull);
    expect(m.isFlagged(DraftField.dose), isTrue);
    expect(m.blockingProblems, contains('Enter the dose per intake.'));
  });

  test('as-needed medicines need no times or dose to import', () {
    final MedicineDraft m = PrescriptionParser.parse(_json(<Map<String, Object?>>[
      <String, Object?>{'name': 'Paracetamol', 'asNeeded': true},
    ])).medicines.single;
    expect(m.blockingProblems, isEmpty);
    expect(m.canImport, isFalse, reason: 'open flags need a review tick');
    m.reviewed = true;
    expect(m.canImport, isTrue);
  });

  test('entries without a name are skipped with a warning', () {
    final ParsedPrescription p = PrescriptionParser.parse(_json(<Map<String, Object?>>[
      <String, Object?>{'name': '  '},
      <String, Object?>{'name': 'Ibuprofen', 'asNeeded': true},
    ]));
    expect(p.medicines, hasLength(1));
    expect(p.warnings, isNotEmpty);
  });

  test('unknown enums and bad values become null, not guesses', () {
    final MedicineDraft m = PrescriptionParser.parse(_json(<Map<String, Object?>>[
      <String, Object?>{
        'name': 'X',
        'form': 'wafer',
        'strengthValue': -5,
        'strengthUnit': 'stone',
        'timesPerDay': 99,
        'explicitTimes': <String>['25:00', 'morning', '7:05'],
        'durationDays': 0,
      },
    ])).medicines.single;
    expect(m.form, isNull);
    expect(m.strength, isNull);
    expect(m.timesPerDay, isNull);
    expect(m.times, <int>[425]);
    expect(m.durationDays, isNull);
  });

  test('model-reported uncertain fields and low confidence are flagged', () {
    final MedicineDraft m = PrescriptionParser.parse(_json(<Map<String, Object?>>[
      <String, Object?>{
        'name': 'Atenolol',
        'uncertainFields': <String>['strength', 'bogus'],
        'confidence': 0.3,
      },
    ])).medicines.single;
    expect(m.isFlagged(DraftField.strength), isTrue);
    expect(m.isFlagged(DraftField.name), isTrue);
  });

  test('illegible documents add a document-level warning', () {
    final ParsedPrescription p =
        PrescriptionParser.parse(_json(<Map<String, Object?>>[], legible: false));
    expect(p.warnings, isNotEmpty);
  });

  test('code fences are tolerated', () {
    final ParsedPrescription p = PrescriptionParser.parse(
      '```json\n${_json(<Map<String, Object?>>[
        <String, Object?>{'name': 'A', 'asNeeded': true},
      ])}\n```',
    );
    expect(p.medicines, hasLength(1));
  });

  test('malformed responses throw', () {
    expect(() => PrescriptionParser.parse('not json'), throwsFormatException);
    expect(() => PrescriptionParser.parse('[]'), throwsFormatException);
    expect(() => PrescriptionParser.parse('{"x":1}'), throwsFormatException);
  });
}
