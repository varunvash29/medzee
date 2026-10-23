import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medzee/core/theme/app_theme.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/inventory.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/models/medicine_profile.dart';
import 'package:medzee/services/ai/medicine_knowledge.dart';
import 'package:medzee/presentation/medicines/add_medicine_screen.dart';
import 'package:medzee/services/medication_service.dart';
import 'package:medzee/state/providers.dart';

/// Records what the wizard tries to persist; every other operation is unused
/// by the save path and throws loudly if reached.
class _RecordingMedicationService implements MedicationService {
  final List<Medication> savedMedications = <Medication>[];
  final List<List<SchedulePhase>> savedPhases = <List<SchedulePhase>>[];

  @override
  Future<Medication> save({
    required Medication medication,
    required List<SchedulePhase> phases,
    Inventory? inventory,
  }) async {
    savedMedications.add(medication);
    savedPhases.add(phases);
    return medication;
  }

  @override
  Future<void> pause(Medication medication) => throw UnimplementedError();

  @override
  Future<void> resume(Medication medication) => throw UnimplementedError();

  @override
  Future<void> endTreatment(Medication medication, {DateTime? endDate}) =>
      throw UnimplementedError();

  @override
  Future<void> archive(Medication medication) => throw UnimplementedError();

  @override
  Future<void> delete(Medication medication) => throw UnimplementedError();

  @override
  Future<Inventory> refill({
    required Medication medication,
    required Inventory inventory,
    required double quantity,
    String? note,
    DateTime? expiryDate,
  }) =>
      throw UnimplementedError();

  @override
  Future<Inventory> adjustStock({
    required Medication medication,
    required Inventory inventory,
    required double newQuantity,
    String? note,
  }) =>
      throw UnimplementedError();
}

/// Pretends Gemini recognised "Dolo 650" so the form fills itself in.
class _FakeKnowledge implements MedicineKnowledge {
  @override
  bool get isAvailable => true;

  @override
  Future<void> remember(String name, MedicineProfile profile) async {}

  @override
  MedicineProfile offlineGuess(String name) =>
      MedicineProfile(recognized: false, name: name);

  @override
  Future<MedicineProfile> lookup(String name) async => MedicineProfile(
        recognized: true,
        name: 'Dolo 650',
        genericName: 'Paracetamol',
        form: DosageForm.tablet,
        strength: 650,
        strengthUnit: 'mg',
        route: AdministrationRoute.oral,
        food: FoodInstruction.afterFood,
        category: MedicineCategory.painRelief,
      );
}

/// Pumps the screen as the first route, with a recording medication service.
///
/// The surface is made tall enough that the whole identity step (including
/// the PRN switch near the bottom) is on screen without scrolling.
Future<_RecordingMedicationService> _pumpWizard(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final _RecordingMedicationService service = _RecordingMedicationService();
  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const AddMedicineScreen(),
      ),
      GoRoute(
        path: '/medicines',
        builder: (BuildContext context, GoRouterState state) =>
            const Scaffold(body: Text('library')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        medicationServiceProvider.overrideWithValue(service),
        medicineKnowledgeProvider.overrideWithValue(_FakeKnowledge()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.light(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return service;
}

void main() {
  testWidgets('Add medicine stays disabled until a name is typed',
      (WidgetTester tester) async {
    final _RecordingMedicationService service = await _pumpWizard(tester);

    await tester.tap(find.text('Add medicine').last);
    await tester.pumpAndSettle();
    expect(service.savedMedications, isEmpty);

    await tester.enterText(find.byType(TextField).first, 'Metformin');
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Add medicine'))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('typing a name fills in the details automatically',
      (WidgetTester tester) async {
    await _pumpWizard(tester);

    await tester.enterText(find.byType(TextField).first, 'Dolo 650');
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    expect(find.text('Tablet'), findsOneWidget);
    expect(find.text('650 mg'), findsOneWidget);
    expect(find.text('Usually taken after food'), findsOneWidget);
  });

  testWidgets('saving uses the inferred details and the chosen schedule',
      (WidgetTester tester) async {
    final _RecordingMedicationService service = await _pumpWizard(tester);

    await tester.enterText(find.byType(TextField).first, 'Dolo 650');
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Twice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add medicine').last);
    await tester.pumpAndSettle();

    expect(service.savedMedications, hasLength(1));
    final Medication saved = service.savedMedications.single;
    expect(saved.name, 'Dolo 650');
    expect(saved.form, DosageForm.tablet);
    expect(saved.strength, 650);
    expect(saved.foodInstruction, FoodInstruction.afterFood);
    expect(service.savedPhases.single.single.timesMinutes, <int>[480, 1200]);
  });

  testWidgets('an as-needed medicine saves with no fixed reminder times',
      (WidgetTester tester) async {
    final _RecordingMedicationService service = await _pumpWizard(tester);

    await tester.enterText(find.byType(TextField).first, 'Dolo 650');
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Only when needed'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add medicine').last);
    await tester.pumpAndSettle();

    expect(service.savedMedications.single.isAsNeeded, isTrue);
    expect(service.savedPhases.single.single.timesMinutes, isEmpty);
  });
}
