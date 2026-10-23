import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medzee/core/theme/app_theme.dart';
import 'package:medzee/data/local/app_database.dart';
import 'package:medzee/data/repositories/medication_repository_impl.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/inventory.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/presentation/medicines/edit_medicine_screen.dart';
import 'package:medzee/services/medication_service.dart';
import 'package:medzee/state/providers.dart';

class _Recording implements MedicationService {
  final List<Medication> meds = <Medication>[];
  final List<List<SchedulePhase>> phases = <List<SchedulePhase>>[];

  @override
  Future<Medication> save({
    required Medication medication,
    required List<SchedulePhase> phases,
    Inventory? inventory,
  }) async {
    meds.add(medication);
    this.phases.add(phases);
    return medication;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<_Recording> _pump(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(db.close);
  final MedicationRepositoryImpl repo = MedicationRepositoryImpl(db);
  await tester.runAsync(() async {
    await repo.save(Medication(
      id: 'm1',
      name: 'Metformin',
      strength: 500,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ));
    await repo.replacePhases('m1', <SchedulePhase>[
      SchedulePhase(
        id: 'p1',
        medicationId: 'm1',
        order: 0,
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 1, 1),
        timesMinutes: const <int>[480, 1200],
        weekdays: <int>{1, 2, 3, 4, 5, 6, 7},
      ),
    ]);
  });

  final _Recording service = _Recording();
  final GoRouter router = GoRouter(
    initialLocation: '/edit',
    routes: <RouteBase>[
      GoRoute(
        path: '/edit',
        builder: (BuildContext c, GoRouterState s) =>
            const EditMedicineScreen(medicationId: 'm1'),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        appDatabaseProvider.overrideWithValue(db),
        medicationServiceProvider.overrideWithValue(service),
      ],
      child: MaterialApp.router(routerConfig: router, theme: AppTheme.light()),
    ),
  );
  for (int i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  return service;
}

void main() {
  testWidgets('shows the current times and details to edit',
      (WidgetTester tester) async {
    await _pump(tester);
    expect(find.text('Metformin'), findsOneWidget);
    expect(find.text('8:00 AM'), findsOneWidget);
    expect(find.text('8:00 PM'), findsOneWidget);
    expect(find.text('500'), findsOneWidget);
  });

  testWidgets('removing a time and renaming saves through the service',
      (WidgetTester tester) async {
    final _Recording service = await _pump(tester);

    await tester.enterText(find.byType(TextField).first, 'Metformin XR');
    // Delete the 8:00 PM chip.
    final Finder pm = find.widgetWithText(InputChip, '8:00 PM');
    await tester.tap(
      find.descendant(of: pm, matching: find.byType(Icon)).last,
    );
    await tester.pump();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(service.meds.single.name, 'Metformin XR');
    expect(service.phases.single.single.timesMinutes, <int>[480]);
  });

  testWidgets('switching to only-when-needed clears the reminder times',
      (WidgetTester tester) async {
    final _Recording service = await _pump(tester);

    await tester.tap(find.text('Only when needed'));
    await tester.pump();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(service.meds.single.isAsNeeded, isTrue);
    expect(service.phases.single.single.kind, ScheduleKind.asNeeded);
    expect(service.phases.single.single.timesMinutes, isEmpty);
  });
}
