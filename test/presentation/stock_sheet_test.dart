import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/core/theme/app_theme.dart';
import 'package:medzee/data/local/app_database.dart';
import 'package:medzee/data/repositories/dose_repository_impl.dart';
import 'package:medzee/data/repositories/inventory_repository_impl.dart';
import 'package:medzee/data/repositories/medication_repository_impl.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/inventory.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/presentation/medicines/stock_sheet.dart';
import 'package:medzee/services/medication_service.dart';
import 'package:medzee/services/schedule_service.dart';
import 'package:medzee/state/providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockSchedule extends Mock implements ScheduleService {}

final Medication _med = Medication(
  id: 'm1',
  name: 'Metformin',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

Future<InventoryRepositoryImpl> _open(
  WidgetTester tester, {
  required Inventory? inventory,
  required StockMode mode,
}) async {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(db.close);
  final InventoryRepositoryImpl invRepo = InventoryRepositoryImpl(db);
  final MedicationRepositoryImpl medRepo = MedicationRepositoryImpl(db);
  await tester.runAsync(() async {
    await medRepo.save(_med);
    if (inventory != null) await invRepo.saveInventory(inventory);
  });

  final MedicationService service = MedicationService(
    medicationRepository: medRepo,
    inventoryRepository: invRepo,
    doseRepository: DoseRepositoryImpl(db),
    scheduleService: _MockSchedule(),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        appDatabaseProvider.overrideWithValue(db),
        medicationServiceProvider.overrideWithValue(service),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Consumer(
          builder: (BuildContext context, WidgetRef ref, _) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => showStockSheet(
                  context,
                  ref,
                  medication: _med,
                  inventory: inventory,
                  mode: mode,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return invRepo;
}

Inventory _inv(double qty) => Inventory(
      id: 'i1',
      medicationId: 'm1',
      quantityOnHand: qty,
      unit: DoseUnit.tablet,
      refillThreshold: 5,
      initialQuantity: 30,
      updatedAt: DateTime.utc(2026),
    );

void main() {
  testWidgets('adding stock adds to what is there and shows the new total',
      (WidgetTester tester) async {
    final InventoryRepositoryImpl repo =
        await _open(tester, inventory: _inv(4), mode: StockMode.refill);

    await tester.enterText(find.byType(TextField).first, '30');
    await tester.pump();
    expect(find.text('New total: 34 tablet(s)'), findsOneWidget);

    await tester.tap(find.text('Add to stock'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pumpAndSettle();

    final Inventory? saved = await tester.runAsync<Inventory?>(() => repo.getInventory('m1'));
    expect(saved!.quantityOnHand, 34);
  });

  testWidgets('setting the count replaces the number', (WidgetTester tester) async {
    final InventoryRepositoryImpl repo =
        await _open(tester, inventory: _inv(4), mode: StockMode.count);

    await tester.enterText(find.byType(TextField).first, '12');
    await tester.tap(find.text('Save'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pumpAndSettle();

    final Inventory? saved = await tester.runAsync<Inventory?>(() => repo.getInventory('m1'));
    expect(saved!.quantityOnHand, 12);
  });

  testWidgets('tracking can be started for a medicine with no stock',
      (WidgetTester tester) async {
    final InventoryRepositoryImpl repo =
        await _open(tester, inventory: null, mode: StockMode.start);

    await tester.enterText(find.byType(TextField).first, '20');
    await tester.tap(find.text('Save'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pumpAndSettle();

    final Inventory? saved = await tester.runAsync<Inventory?>(() => repo.getInventory('m1'));
    expect(saved!.quantityOnHand, 20);
    expect(saved.refillThreshold, 5);
  });

  testWidgets('an empty or refill-of-zero entry is refused',
      (WidgetTester tester) async {
    final InventoryRepositoryImpl repo =
        await _open(tester, inventory: _inv(4), mode: StockMode.refill);

    await tester.enterText(find.byType(TextField).first, '0');
    await tester.tap(find.text('Add to stock'));
    await tester.pumpAndSettle();

    expect(find.text('Enter how many you added.'), findsOneWidget);
    final Inventory? saved = await tester.runAsync<Inventory?>(() => repo.getInventory('m1'));
    expect(saved!.quantityOnHand, 4);
  });
}
