import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medzee/core/theme/app_theme.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/inventory.dart';
import 'package:medzee/domain/models/medication.dart';
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

/// Pumps the wizard as the first route, with a recording medication service.
///
/// The surface is made tall enough that the whole identity step (including
/// the PRN switch near the bottom) is on screen without scrolling.
Future<_RecordingMedicationService> _pumpWizard(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1400);
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

/// Fills the name field and advances past step 1 (About the medicine).
Future<void> _advancePastIdentity(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).first, 'Metformin');
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Continue stays disabled until the medicine name is entered',
      (WidgetTester tester) async {
    await _pumpWizard(tester);
    expect(find.text('About the medicine'), findsOneWidget);

    // Empty name: the tap is ignored and the wizard stays put.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('About the medicine'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Metformin');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('How and when'), findsOneWidget);
  });

  testWidgets('the close button steps back instead of leaving mid-wizard',
      (WidgetTester tester) async {
    await _pumpWizard(tester);
    await _advancePastIdentity(tester);
    expect(find.text('How and when'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('About the medicine'), findsOneWidget);
  });

  testWidgets('the schedule step offers fixed-schedule kinds by default',
      (WidgetTester tester) async {
    await _pumpWizard(tester);
    await _advancePastIdentity(tester);

    // No PRN: the schedule kind chooser is visible on step 2.
    expect(find.text('How and when'), findsOneWidget);
    expect(find.text('Every day'), findsOneWidget);
  });

  testWidgets('enabling PRN hides the fixed-schedule choices',
      (WidgetTester tester) async {
    await _pumpWizard(tester);

    // The PRN toggle lives on the identity step.
    await tester.enterText(find.byType(TextField).first, 'Metformin');
    await tester.tap(find.text('Take as needed (PRN)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('How and when'), findsOneWidget);
    expect(find.text('Every day'), findsNothing);
    // The time editor is hidden too — PRN has no reminder times to edit.
    expect(find.text('Add time'), findsNothing);
  });

  testWidgets('an as-needed medicine saves with no fixed reminder times',
      (WidgetTester tester) async {
    final _RecordingMedicationService service = await _pumpWizard(tester);

    // Turn on PRN on the identity step, then walk through the schedule and
    // Stock (prefilled) steps to Review.
    await tester.enterText(find.byType(TextField).first, 'Metformin');
    await tester.tap(find.text('Take as needed (PRN)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue')); // -> How and when
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue')); // -> Stock
    await tester.pumpAndSettle();
    expect(find.text('Stock'), findsWidgets);

    await tester.tap(find.text('Continue')); // -> Review
    await tester.pumpAndSettle();
    expect(find.text('Review'), findsOneWidget);

    await tester.tap(find.text('Save medicine'));
    await tester.pumpAndSettle();

    // Regression: the wizard used to keep the default 08:00 time on the PRN
    // phase, which the validator (rightly) rejected — with no way for the
    // user to fix it, since the time editor is hidden for PRN.
    expect(
      find.text('As-needed medicines do not have fixed reminder times.'),
      findsNothing,
    );
    expect(service.savedMedications, hasLength(1));
    expect(service.savedMedications.single.isAsNeeded, isTrue);
    expect(service.savedPhases.single.single.timesMinutes, isEmpty);
    expect(service.savedPhases.single.single.kind, ScheduleKind.asNeeded);
  });
}
