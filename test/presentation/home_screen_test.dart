import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medzee/core/theme/app_theme.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/dose.dart';
import 'package:medzee/domain/models/inventory.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/models/user_profile.dart';
import 'package:medzee/presentation/home/home_screen.dart';
import 'package:medzee/services/dose_service.dart';
import 'package:medzee/state/dose_actions.dart';
import 'package:medzee/state/doses_provider.dart';
import 'package:medzee/state/inventory_providers.dart';
import 'package:medzee/state/medications_provider.dart';
import 'package:medzee/state/profile_providers.dart';

import '../helpers/fakes.dart';

/// A single Metformin medication used across the timeline fixtures.
Medication _medication() => Medication(
      id: 'med-1',
      name: 'Metformin',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

/// One scheduled dose at [minutes] past midnight, in the given status.
ScheduledDose _dose({
  String id = 'dose-1',
  String medicationId = 'med-1',
  DoseStatus status = DoseStatus.pending,
  int minutes = 8 * 60,
}) {
  final DateTime scheduledAt = DateTime.utc(2026, 3, 10, 0, 0)
      .add(Duration(minutes: minutes));
  return ScheduledDose(
    id: id,
    medicationId: medicationId,
    phaseId: 'phase-1',
    scheduledAt: scheduledAt,
    localDate: DateTime.utc(2026, 3, 10),
    scheduledMinutes: minutes,
    doseQuantity: 1,
    unit: DoseUnit.tablet,
    status: status,
  );
}

/// Pumps [HomeScreen] under a real [GoRouter] and a real [DoseService] backed
/// by the in-memory fakes, with the timeline, profile and actions overridden.
Future<void> _pumpHome(
  WidgetTester tester, {
  required List<TodayEntry> entries,
  FakeDoseRepository? doses,
  FakeInventoryRepository? inventory,
  UserProfile profile = const UserProfile(id: 'local', displayName: 'Asha'),
  bool noMedicines = false,
  bool settle = true,
}) async {
  tester.view.physicalSize = const Size(800, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  doses ??= FakeDoseRepository();
  inventory ??= FakeInventoryRepository();
  final Medication medication = _medication();
  final DoseActions actions = DoseActions(
    DoseService(doseRepository: doses, inventoryRepository: inventory),
    (String medicationId) async => medication,
  );

  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: '/medicines/:id',
        builder: (BuildContext context, GoRouterState state) =>
            Scaffold(body: Text('detail:${state.pathParameters['id']}')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        todayTimelineProvider
            .overrideWith((Ref ref) => Stream<List<TodayEntry>>.value(entries)),
        medicationsProvider.overrideWith(
          (Ref ref) => Stream<List<Medication>>.value(
            noMedicines ? const <Medication>[] : <Medication>[medication],
          ),
        ),
        lowStockMedicationsProvider.overrideWithValue(const <Medication>[]),
        activeProfileProvider.overrideWithValue(profile),
        doseActionsProvider.overrideWithValue(actions),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.light(),
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }
  }
}

void main() {
  testWidgets('renders the greeting, progress and today\'s doses',
      (WidgetTester tester) async {
    final Medication medication = _medication();
    await _pumpHome(
      tester,
      entries: <TodayEntry>[
        TodayEntry(dose: _dose(), medication: medication, isNext: true),
        TodayEntry(
          dose: _dose(
            id: 'dose-2',
            status: DoseStatus.taken,
            minutes: 14 * 60,
          ),
          medication: medication,
          isNext: false,
        ),
      ],
    );

    expect(find.text('Asha'), findsOneWidget);
    expect(find.text('Up next'), findsOneWidget);
    expect(find.text('Done · 1'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('NEXT DOSE'), findsOneWidget);

    // The next pending dose offers the quick actions.
    expect(find.text('Take now'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('shows the empty state when nothing is scheduled',
      (WidgetTester tester) async {
    await _pumpHome(tester, entries: const <TodayEntry>[]);

    expect(find.text('Nothing scheduled today'), findsOneWidget);
  });

  testWidgets('tapping "Mark as taken" records the dose and confirms with a snackbar',
      (WidgetTester tester) async {
    final FakeDoseRepository doses = FakeDoseRepository();
    await _pumpHome(
      tester,
      doses: doses,
      entries: <TodayEntry>[
        TodayEntry(dose: _dose(), medication: _medication(), isNext: true),
      ],
    );

    await tester.tap(find.text('Take now'));
    await tester.pumpAndSettle();

    expect(find.text('Dose recorded'), findsOneWidget);
    expect(doses.statuses['dose-1'], DoseStatus.taken);
  });

  testWidgets('the taken snackbar reports the remaining stock',
      (WidgetTester tester) async {
    final FakeInventoryRepository inventory = FakeInventoryRepository()
      ..inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 30,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );
    await _pumpHome(
      tester,
      inventory: inventory,
      entries: <TodayEntry>[
        TodayEntry(dose: _dose(), medication: _medication(), isNext: true),
      ],
    );

    await tester.tap(find.text('Take now'));
    await tester.pumpAndSettle();

    expect(find.text('29 tablet left'), findsOneWidget);
    expect(inventory.inventory!.quantityOnHand, 29);
  });

  testWidgets('tapping a dose tile opens the medicine detail route',
      (WidgetTester tester) async {
    await _pumpHome(
      tester,
      entries: <TodayEntry>[
        TodayEntry(
          dose: _dose(id: 'dose-2', status: DoseStatus.taken),
          medication: _medication(),
          isNext: false,
        ),
      ],
    );

    await tester.tap(find.text('Metformin').first);
    await tester.pumpAndSettle();

    expect(find.text('detail:med-1'), findsOneWidget);
  });

  testWidgets('shows the first-use state when there are no medicines',
      (WidgetTester tester) async {
    await _pumpHome(
      tester,
      entries: const <TodayEntry>[],
      noMedicines: true,
      settle: false,
    );

    expect(find.text('Nothing scheduled today'), findsNothing);
    expect(find.text('Add your first medicine'), findsOneWidget);
  });
}
