// Renders the real app to PNGs for visual review: `flutter test test/render`.
// Output goes to build/shots/. Not an assertion test; it only needs to run.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medzee/core/theme/app_theme.dart';
import 'package:medzee/data/local/app_database.dart';
import 'package:medzee/data/repositories/dose_repository_impl.dart';
import 'package:medzee/data/repositories/inventory_repository_impl.dart';
import 'package:medzee/data/repositories/medication_repository_impl.dart';
import 'package:medzee/data/repositories/profile_repository_impl.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/dose.dart';
import 'package:medzee/domain/models/inventory.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/models/medicine_profile.dart';
import 'package:medzee/services/ai/medicine_knowledge.dart';
import 'package:medzee/services/firebase_service.dart';
import 'package:medzee/domain/models/user_profile.dart';
import 'package:medzee/routing/app_router.dart';
import 'package:medzee/state/providers.dart';

class _FakeKnowledge implements MedicineKnowledge {
  @override
  bool get isAvailable => true;

  @override
  MedicineProfile offlineGuess(String name) =>
      MedicineProfile(recognized: false, name: name);

  @override
  Future<MedicineProfile> lookup(String name) async => MedicineProfile(
        recognized: true,
        name: 'Dolo 650',
        genericName: 'Paracetamol',
        ingredients: const <Ingredient>[
          Ingredient('Paracetamol', value: 650, unit: 'mg'),
        ],
        form: DosageForm.tablet,
        strength: 650,
        strengthUnit: 'mg',
        route: AdministrationRoute.oral,
        food: FoodInstruction.afterFood,
        typicalUse: 'Relieves fever and mild to moderate pain such as headache, muscle ache and toothache.',
        howItWorks: 'Reduces fever and pain by acting on the brain.',
        sideEffects: const <String>['Nausea', 'Rash (rare)'],
        warnings: const <String>[
          'Liver disease or heavy alcohol use',
          'Do not combine with other paracetamol products',
        ],
        storage: 'Store below 30 C, away from moisture.',
        prescriptionStatus: 'OTC',
        alternatives: const <IndianAlternative>[
          IndianAlternative(brand: 'Calpol 650', manufacturer: 'GlaxoSmithKline', composition: 'Paracetamol 650 mg', match: AlternativeMatch.same),
          IndianAlternative(brand: 'Crocin 650', manufacturer: 'GlaxoSmithKline', composition: 'Paracetamol 650 mg', match: AlternativeMatch.same),
          IndianAlternative(brand: 'Crocin Advance 500', manufacturer: 'GlaxoSmithKline', composition: 'Paracetamol 500 mg', match: AlternativeMatch.similar, note: 'Lower strength'),
        ],
        confidence: 'high',
        fetchedAt: DateTime.now(),
      );
}

Future<void> _loadFonts() async {
  final FontLoader inter = FontLoader('Inter');
  for (final String w in <String>['Regular', 'Medium', 'SemiBold', 'Bold']) {
    inter.addFont(rootBundle.load('assets/fonts/Inter-$w.ttf'));
  }
  await inter.load();
  final String root = Platform.environment['FLUTTER_ROOT'] ?? 'C:/src/flutter';
  final File icons = File(
    '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (icons.existsSync()) {
    final FontLoader mi = FontLoader('MaterialIcons')
      ..addFont(Future<ByteData>.value(
        ByteData.sublistView(icons.readAsBytesSync()),
      ));
    await mi.load();
  }
}

Medication _med(String id, String name, double s, DosageForm f) => Medication(
      id: id,
      name: name,
      genericName: name,
      strength: s,
      form: f,
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

Future<AppDatabase> _seed() async {
  final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
  await ProfileRepositoryImpl(db).saveProfile(UserProfile(
    id: 'p',
    displayName: 'Asha',
    onboardingCompleted: true,
    createdAt: DateTime.utc(2026),
  ));
  final MedicationRepositoryImpl meds = MedicationRepositoryImpl(db);
  final DoseRepositoryImpl doses = DoseRepositoryImpl(db);
  final InventoryRepositoryImpl inv = InventoryRepositoryImpl(db);
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);

  final List<(Medication, List<int>, double)> rows =
      <(Medication, List<int>, double)>[
    (_med('m1', 'Metformin', 500, DosageForm.tablet), <int>[480, 1200], 4),
    (_med('m2', 'Vitamin D3', 1000, DosageForm.capsule), <int>[600], 40),
    (_med('m3', 'Amoxicillin', 500, DosageForm.capsule), <int>[480, 840, 1200], 18),
    (_med('m4', 'Atorvastatin', 20, DosageForm.tablet), <int>[1320], 25),
  ];
  for (final (Medication m, List<int> times, double stock) in rows) {
    await meds.save(m);
    await meds.replacePhases(m.id, <SchedulePhase>[
      SchedulePhase(
        id: 'ph-${m.id}',
        medicationId: m.id,
        order: 0,
        kind: ScheduleKind.daily,
        startDate: today.subtract(const Duration(days: 10)),
        timesMinutes: times,
        weekdays: <int>{1, 2, 3, 4, 5, 6, 7},
        unit: m.form == DosageForm.capsule ? DoseUnit.capsule : DoseUnit.tablet,
      ),
    ]);
    await inv.saveInventory(Inventory(
      id: 'inv-${m.id}',
      medicationId: m.id,
      quantityOnHand: stock,
      unit: DoseUnit.tablet,
      refillThreshold: 6,
      initialQuantity: 60,
      updatedAt: DateTime.utc(2026),
    ));
    await doses.insertDoses(<ScheduledDose>[
      for (final int t in times)
        ScheduledDose(
          id: 'd-${m.id}-$t',
          medicationId: m.id,
          phaseId: 'ph-${m.id}',
          scheduledAt: today.add(Duration(minutes: t)).toUtc(),
          localDate: today,
          scheduledMinutes: t,
          doseQuantity: 1,
          unit: m.form == DosageForm.capsule ? DoseUnit.capsule : DoseUnit.tablet,
          status: t < 540 ? DoseStatus.taken : DoseStatus.pending,
        ),
    ]);
  }
  return db;
}

void main() {
  final GlobalKey shotKey = GlobalKey();

  Future<void> shoot(WidgetTester t, String name) async {
    await t.runAsync(() async {
      final RenderRepaintBoundary b =
          shotKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final ui.Image img = await b.toImage(pixelRatio: 2);
      final ByteData? data = await img.toByteData(format: ui.ImageByteFormat.png);
      final File f = File('build/shots/$name.png');
      await f.parent.create(recursive: true);
      await f.writeAsBytes(data!.buffer.asUint8List());
    });
  }

  testWidgets('render main screens', skip: Platform.environment['RENDER'] != '1', (WidgetTester t) async {
    await t.runAsync(_loadFonts);
    t.view.physicalSize = const Size(390 * 2, 844 * 2);
    t.view.devicePixelRatio = 2;
    addTearDown(t.view.reset);

    final AppDatabase db = await t.runAsync(_seed) as AppDatabase;
    final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();
    final GoRouter router = createAppRouter(
      rootNavigatorKey: nav,
      initialLocation: AppRoutes.home,
    );

    await t.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          appDatabaseProvider.overrideWithValue(db),
          medicineKnowledgeProvider.overrideWithValue(_FakeKnowledge()),
          firebaseGatewayProvider
              .overrideWithValue(const FirebaseGateway.unavailable()),
        ],
        child: RepaintBoundary(
          key: shotKey,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            routerConfig: router,
          ),
        ),
      ),
    );

    Future<void> visit(String route, String name) async {
      router.go(route);
      for (int i = 0; i < 12; i++) {
        await t.pump(const Duration(milliseconds: 120));
      }
      await shoot(t, name);
    }

    await visit(AppRoutes.home, 'home');
    await visit(AppRoutes.medicines, 'medicines');
    await visit(AppRoutes.addMedicine, 'add');
    await t.enterText(find.byType(TextField).first, 'Dolo 650');
    for (int i = 0; i < 20; i++) {
      await t.pump(const Duration(milliseconds: 100));
    }
    await shoot(t, 'add_filled');
    await visit('/medicines/m1', 'detail');
    await t.tap(find.text('Info'));
    for (int i = 0; i < 12; i++) {
      await t.pump(const Duration(milliseconds: 100));
    }
    await shoot(t, 'detail_info');
    await t.tap(find.text('Alternatives'));
    for (int i = 0; i < 12; i++) {
      await t.pump(const Duration(milliseconds: 100));
    }
    await shoot(t, 'detail_alts');
    await visit(AppRoutes.calendar, 'calendar');
    await visit(AppRoutes.assistant, 'assistant');
    await visit(AppRoutes.profile, 'profile');
    await visit(AppRoutes.insights, 'insights');
    await visit(AppRoutes.scanPrescription, 'scan');
    await visit(AppRoutes.onboarding, 'onboarding');
  });
}
