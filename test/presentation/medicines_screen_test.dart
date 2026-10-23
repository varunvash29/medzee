import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medzee/core/theme/app_theme.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/inventory.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/presentation/medicines/medicines_screen.dart';
import 'package:medzee/state/insights_provider.dart';
import 'package:medzee/state/inventory_providers.dart';
import 'package:medzee/state/medications_provider.dart';

/// Three fixture medicines across two statuses.
Medication _med(
  String id,
  String name, {
  String? genericName,
  MedicationStatus status = MedicationStatus.active,
}) =>
    Medication(
      id: id,
      name: name,
      genericName: genericName,
      status: status,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

/// Pumps [MedicinesScreen] with the medication stream, stock and adherence
/// overridden per fixture id. Every medicine in [medications] gets an
/// adherence override so no tile ever reaches the real database.
Future<void> _pumpLibrary(
  WidgetTester tester, {
  required List<Medication> medications,
  Map<String, Inventory?> stock = const <String, Inventory?>{},
}) async {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const MedicinesScreen(),
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
        medicationsProvider.overrideWith(
          (Ref ref) => Stream<List<Medication>>.value(medications),
        ),
        for (final Medication medication in medications) ...<Override>[
          inventoryProvider(medication.id).overrideWith(
            (Ref ref) => Stream<Inventory?>.value(stock[medication.id]),
          ),
          medicationAdherenceProvider(medication.id).overrideWith(
            (Ref ref) async => const MedicationAdherence(
              taken: 9,
              missed: 1,
              skipped: 0,
              pending: 2,
            ),
          ),
        ],
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.light(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

List<Medication> _fixtures() => <Medication>[
      _med('med-1', 'Metformin'),
      _med(
        'med-2',
        'Amoxicillin',
        genericName: 'amoxicillin trihydrate',
      ),
      _med('med-3', 'Lisinopril', status: MedicationStatus.paused),
    ];

void main() {
  testWidgets('shows active medicines with stock and adherence chips',
      (WidgetTester tester) async {
    await _pumpLibrary(
      tester,
      medications: _fixtures(),
      stock: <String, Inventory?>{
        'med-1': Inventory(
          id: 'inv-1',
          medicationId: 'med-1',
          quantityOnHand: 30,
          unit: DoseUnit.tablet,
          refillThreshold: 5,
          updatedAt: DateTime.utc(2026, 3, 1),
        ),
      },
    );

    expect(find.text('Medicines'), findsOneWidget);
    expect(find.text('Metformin'), findsOneWidget);
    expect(find.text('Amoxicillin'), findsOneWidget);
    expect(find.text('Lisinopril'), findsNothing); // paused: not in default tab

    expect(find.text('30 tablet'), findsOneWidget);
    expect(find.text('90% taken'), findsWidgets);
  });

  testWidgets('search narrows by name or active ingredient',
      (WidgetTester tester) async {
    await _pumpLibrary(tester, medications: _fixtures());

    await tester.enterText(find.byType(TextField), 'amox');
    await tester.pumpAndSettle();
    expect(find.text('Amoxicillin'), findsOneWidget);
    expect(find.text('Metformin'), findsNothing);

    // Generic-name match.
    await tester.enterText(find.byType(TextField), 'trihydrate');
    await tester.pumpAndSettle();
    expect(find.text('Amoxicillin'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('No matches'), findsOneWidget);
  });

  testWidgets('status chips filter the library', (WidgetTester tester) async {
    await _pumpLibrary(tester, medications: _fixtures());

    await tester.tap(find.text('Paused'));
    await tester.pumpAndSettle();

    expect(find.text('Lisinopril'), findsOneWidget);
    expect(find.text('Metformin'), findsNothing);
    expect(find.text('Amoxicillin'), findsNothing);
  });

  testWidgets('an empty library shows the guided empty state',
      (WidgetTester tester) async {
    await _pumpLibrary(tester, medications: const <Medication>[]);

    expect(find.text('No active medicines'), findsOneWidget);
  });
}
