import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/data/local/app_database.dart';
import 'package:medzee/data/repositories/medication_repository_impl.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/models/prescription_draft.dart';

void main() {
  test('the prescribed-as tag survives saving and reading back', () async {
    final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final MedicationRepositoryImpl repo = MedicationRepositoryImpl(db);

    await repo.save(Medication(
      id: 'm1',
      name: 'Glucophage',
      prescribedAs: 'Glycomet 500',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ));
    expect((await repo.getById('m1'))!.prescribedAs, 'Glycomet 500');

    // Clearing it works too.
    final Medication m = (await repo.getById('m1'))!;
    await repo.save(m.copyWith(clearPrescribedAs: true));
    expect((await repo.getById('m1'))!.prescribedAs, isNull);
  });

  test('renaming a scanned medicine keeps the prescription name as the tag', () {
    final MedicineDraft d = MedicineDraft(name: 'Glycomet 500');
    expect(d.prescribedAsTag, isNull);

    d.name = 'Glucophage 500';
    expect(d.prescribedAsTag, 'Glycomet 500');

    d.name = 'glycomet 500'; // same name, different case: no tag
    expect(d.prescribedAsTag, isNull);
  });
}
