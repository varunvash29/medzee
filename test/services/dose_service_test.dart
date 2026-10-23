import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/dose.dart';
import 'package:medzee/domain/models/inventory.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/services/dose_service.dart';

import '../helpers/fakes.dart';

Medication _medication() => Medication(
      id: 'med-1',
      name: 'Metformin',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

ScheduledDose _dose({
  String id = 'dose-1',
  DoseUnit unit = DoseUnit.tablet,
  double doseQuantity = 1,
}) =>
    ScheduledDose(
      id: id,
      medicationId: 'med-1',
      phaseId: 'phase-1',
      scheduledAt: DateTime.utc(2026, 3, 10, 8),
      localDate: DateTime(2026, 3, 10),
      scheduledMinutes: 8 * 60,
      doseQuantity: doseQuantity,
      unit: unit,
      status: DoseStatus.pending,
    );

void main() {
  late FakeDoseRepository doses;
  late FakeInventoryRepository inventory;
  late DoseService service;

  setUp(() {
    doses = FakeDoseRepository();
    inventory = FakeInventoryRepository();
    service = DoseService(
      doseRepository: doses,
      inventoryRepository: inventory,
    );
  });

  group('markTaken — stock deduction', () {
    test('deducts the dose from stock exactly once', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 30,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );

      final DoseLogResult result = await service.markTaken(
        _dose(),
        _medication(),
      );

      expect(result.inventoryAdjusted, isTrue);
      expect(result.wasAlreadyRecorded, isFalse);
      expect(result.stockMessage, '29 tablet left');
      expect(inventory.inventory!.quantityOnHand, 29);
      expect(inventory.transactions, hasLength(1));
      expect(
        inventory.transactions.single.type,
        InventoryTransactionType.deduction,
      );
      expect(inventory.transactions.single.quantityDelta, -1);
      expect(doses.statuses['dose-1'], DoseStatus.taken);
    });

    test('a second markTaken on the same dose changes nothing', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 30,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );

      await service.markTaken(_dose(), _medication());
      final DoseLogResult second = await service.markTaken(
        _dose(),
        _medication(),
      );

      expect(second.wasAlreadyRecorded, isTrue);
      expect(second.inventoryAdjusted, isFalse);
      expect(inventory.inventory!.quantityOnHand, 29,
          reason: 'stock must be deducted once, not twice');
      expect(inventory.transactions, hasLength(1));
    });

    test('two concurrent taps also deduct only once', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 30,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );
      final ScheduledDose dose = _dose();

      final List<DoseLogResult> results = await Future.wait(<
          Future<DoseLogResult>>[
        service.markTaken(dose, _medication()),
        service.markTaken(dose, _medication()),
      ]);

      expect(inventory.inventory!.quantityOnHand, 29);
      expect(
        results.where((DoseLogResult r) => r.inventoryAdjusted).length,
        1,
      );
    });

    test('a half tablet is deducted as half a unit', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 10,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );

      final DoseLogResult result = await service.markTaken(
        _dose(doseQuantity: 0.5),
        _medication(),
      );

      expect(result.inventoryAdjusted, isTrue);
      expect(inventory.inventory!.quantityOnHand, 9.5);
    });

    test('stock never goes below zero', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 1,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );

      final DoseLogResult result = await service.markTaken(
        _dose(doseQuantity: 5),
        _medication(),
      );

      expect(inventory.inventory!.quantityOnHand, 0);
      expect(inventory.transactions.single.quantityAfter, 0);
      // The audit trail must stay arithmetically consistent: what was on
      // hand plus the delta equals quantityAfter.
      expect(
        1 + inventory.transactions.single.quantityDelta,
        inventory.transactions.single.quantityAfter,
      );
      expect(result.stockMessage, '0 tablet left');
    });

    test('reversing a clamped deduction restores only what was deducted',
        () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 1,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );
      final ScheduledDose dose = _dose(doseQuantity: 5);

      await service.markTaken(dose, _medication());
      await service.markMissed(
        dose.copyWith(status: DoseStatus.pending),
        _medication(),
      );

      // Only the 1 tablet that actually existed comes back, not the 5 that
      // were recorded as taken.
      expect(inventory.inventory!.quantityOnHand, 1);
    });

    test('records the amount and unit taken on the log', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 30,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );

      final DoseLogResult result = await service.markTaken(
        _dose(),
        _medication(),
        note: 'after breakfast',
      );

      expect(result.log!.amountTaken, 1);
      expect(result.log!.unit, DoseUnit.tablet);
      expect(result.log!.note, 'after breakfast');
    });
  });

  group('markTaken — refusals (never guess)', () {
    test('refuses to deduct when the stock unit differs from the dose unit',
        () async {
      // Stock counted in whole tablets, dose measured in mL: no safe
      // conversion exists, so the deduction is refused and the user is asked
      // to adjust manually. The dose is still recorded.
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 100,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );

      final DoseLogResult result = await service.markTaken(
        _dose(unit: DoseUnit.millilitre, doseQuantity: 5),
        _medication(),
      );

      expect(result.log!.status, DoseStatus.taken,
          reason: 'the dose itself must still be recorded');
      expect(result.inventoryAdjusted, isFalse);
      expect(result.stockMessage, contains('manually'));
      expect(inventory.inventory!.quantityOnHand, 100);
      expect(inventory.transactions, isEmpty);
    });

    test('refuses a fractional amount in a continuous unit', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 100,
        unit: DoseUnit.millilitre,
        updatedAt: DateTime.utc(2026, 3, 1),
      );

      final DoseLogResult result = await service.markTaken(
        _dose(unit: DoseUnit.millilitre, doseQuantity: 2.5),
        _medication(),
      );

      expect(result.inventoryAdjusted, isFalse);
      expect(result.stockMessage, contains('manually'));
      expect(inventory.inventory!.quantityOnHand, 100);
    });

    test('deducts a whole amount in a continuous unit', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 100,
        unit: DoseUnit.millilitre,
        updatedAt: DateTime.utc(2026, 3, 1),
      );

      final DoseLogResult result = await service.markTaken(
        _dose(unit: DoseUnit.millilitre, doseQuantity: 5),
        _medication(),
      );

      expect(result.inventoryAdjusted, isTrue);
      expect(inventory.inventory!.quantityOnHand, 95);
    });

    test('a medicine with no inventory row records the dose without crashing',
        () async {
      inventory.inventory = null;

      final DoseLogResult result = await service.markTaken(
        _dose(),
        _medication(),
      );

      expect(result.log!.status, DoseStatus.taken);
      expect(result.inventoryAdjusted, isFalse);
      expect(result.stockMessage, isNull);
    });
  });

  group('markSkipped / markMissed — stock is never touched', () {
    test('markSkipped leaves stock alone', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 30,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );

      final DoseLogResult result = await service.markSkipped(
        _dose(),
        _medication(),
      );

      expect(result.log!.status, DoseStatus.skipped);
      expect(result.log!.amountTaken, isNull);
      expect(result.inventoryAdjusted, isFalse);
      expect(inventory.inventory!.quantityOnHand, 30);
      expect(inventory.transactions, isEmpty);
    });

    test('markMissed leaves stock alone', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 30,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );

      final DoseLogResult result = await service.markMissed(
        _dose(),
        _medication(),
      );

      expect(result.log!.status, DoseStatus.missed);
      expect(inventory.inventory!.quantityOnHand, 30);
      expect(inventory.transactions, isEmpty);
    });
  });

  group('corrections — reversal is exact and happens once', () {
    test('correcting a taken dose back to pending restores the stock', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 30,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );
      final ScheduledDose dose = _dose();

      await service.markTaken(dose, _medication());
      // The user changes the scheduled dose back to pending and logs again.
      final DoseLogResult corrected = await service.markMissed(
        dose.copyWith(status: DoseStatus.pending),
        _medication(),
      );

      expect(corrected.inventoryAdjusted, isTrue);
      expect(inventory.inventory!.quantityOnHand, 30);
      final List<InventoryTransaction> reversals = inventory.transactions
          .where((InventoryTransaction t) =>
              t.type == InventoryTransactionType.reversal)
          .toList();
      expect(reversals, hasLength(1));
      expect(reversals.single.quantityDelta, 1);
      expect(reversals.single.doseLogId, isNull,
          reason: 'a reversal is not tied to a new dose log');
    });

    test('correcting a taken dose to skipped restores the stock once',
        () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 30,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );
      final ScheduledDose dose = _dose();

      await service.markTaken(dose, _medication());
      await service.markSkipped(dose.copyWith(status: DoseStatus.pending),
          _medication());
      // A repeat skip must not reverse the stock a second time.
      final DoseLogResult repeat = await service.markSkipped(
        dose.copyWith(status: DoseStatus.pending),
        _medication(),
      );

      expect(repeat.wasAlreadyRecorded, isTrue);
      expect(inventory.inventory!.quantityOnHand, 30);
      expect(
        inventory.transactions
            .where((InventoryTransaction t) =>
                t.type == InventoryTransactionType.reversal)
            .length,
        1,
      );
    });

    test('correcting a skipped dose to taken deducts stock', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 30,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );
      final ScheduledDose dose = _dose();

      await service.markSkipped(dose, _medication());
      final DoseLogResult corrected = await service.markTaken(
        dose.copyWith(status: DoseStatus.pending),
        _medication(),
      );

      expect(corrected.inventoryAdjusted, isTrue);
      expect(inventory.inventory!.quantityOnHand, 29);
    });

    test('the audit trail keeps every superseded log', () async {
      inventory.inventory = Inventory(
        id: 'inv-1',
        medicationId: 'med-1',
        quantityOnHand: 30,
        unit: DoseUnit.tablet,
        updatedAt: DateTime.utc(2026, 3, 1),
      );
      final ScheduledDose dose = _dose();

      final DoseLog first = (await service.markTaken(dose, _medication())).log!;
      final DoseLog second =
          (await service.markSkipped(dose.copyWith(status: DoseStatus.pending),
                  _medication()))
              .log!;

      expect(doses.logs, hasLength(2));
      expect(second.supersedesLogId, first.id);
    });
  });
}
