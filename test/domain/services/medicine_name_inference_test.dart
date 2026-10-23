import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/services/medicine_name_inference.dart';

void main() {
  test('reads strength and form from a typed name', () {
    final InferredMedicine r = MedicineNameInference.parse('Metformin 500mg Tablet');
    expect(r.name, 'Metformin');
    expect(r.strength, 500);
    expect(r.strengthUnit, 'mg');
    expect(r.form, DosageForm.tablet);
  });

  test('handles decimals and unit casing', () {
    final InferredMedicine r = MedicineNameInference.parse('Levothyroxine 12.5 MCG');
    expect(r.strength, 12.5);
    expect(r.strengthUnit, 'mcg');
    expect(r.form, isNull);
  });

  test('plain names infer nothing', () {
    final InferredMedicine r = MedicineNameInference.parse('Dolo');
    expect(r.name, 'Dolo');
    expect(r.hasInference, isFalse);
  });

  test('a form word alone is not stripped from the name', () {
    expect(MedicineNameInference.parse('Tablet').name, 'Tablet');
  });

  test('syrup maps to liquid', () {
    final InferredMedicine r = MedicineNameInference.parse('Amoxicillin syrup 125mg/5ml');
    expect(r.form, DosageForm.liquid);
    expect(r.strength, 125);
  });
}
