import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/medicine_profile.dart';
import 'package:medzee/services/ai/medicine_knowledge.dart';
import 'package:shared_preferences/shared_preferences.dart';

MedicineProfile _profile({DateTime? at}) => MedicineProfile(
      recognized: true,
      name: 'Dolo 650',
      genericName: 'Paracetamol',
      fetchedAt: at ?? DateTime.now(),
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  // `available: false` means any real AI request would be impossible, so a
  // successful answer here proves it came from the cache.
  test('a remembered profile is served without any AI call', () async {
    final GeminiMedicineKnowledge k = GeminiMedicineKnowledge(available: false);
    await k.remember('Dolo 650', _profile());
    final MedicineProfile p = await k.lookup('Dolo 650');
    expect(p.recognized, isTrue);
    expect(p.genericName, 'Paracetamol');
  });

  test('spelling and unit variants share one cache entry', () async {
    final GeminiMedicineKnowledge k = GeminiMedicineKnowledge(available: false);
    await k.remember('Dolo 650', _profile());
    for (final String variant in <String>[
      'dolo650',
      'DOLO 650',
      'Dolo 650 mg',
      'dolo-650',
    ]) {
      expect((await k.lookup(variant)).recognized, isTrue, reason: variant);
    }
    expect((await k.lookup('Crocin 650')).recognized, isFalse);
  });

  test('an old entry is still used when it cannot be refreshed', () async {
    final GeminiMedicineKnowledge k = GeminiMedicineKnowledge(available: false);
    await k.remember(
      'Dolo 650',
      _profile(at: DateTime.now().subtract(const Duration(days: 400))),
    );
    expect((await k.lookup('Dolo 650')).recognized, isTrue);
  });

  test('a recent "not recognised" answer is remembered briefly', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'medicine_profile_v1:zzzz': jsonEncode(<String, Object?>{
        'recognized': false,
        'name': '',
        'fetchedAt': DateTime.now().toIso8601String(),
      }),
    });
    final GeminiMedicineKnowledge k = GeminiMedicineKnowledge(available: false);
    expect((await k.lookup('zzzz')).recognized, isFalse);
  });
}
