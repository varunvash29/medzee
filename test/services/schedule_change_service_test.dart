import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/data/local/app_database.dart';
import 'package:medzee/data/repositories/inventory_repository_impl.dart';
import 'package:medzee/data/repositories/medication_repository_impl.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/inventory.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/models/schedule_proposal.dart';
import 'package:medzee/services/medication_service.dart';
import 'package:medzee/services/schedule_change_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockMedicationService extends Mock implements MedicationService {}

class _FakeMedication extends Fake implements Medication {}

class _FakeInventory extends Fake implements Inventory {}

void main() {
  late AppDatabase db;
  late MedicationRepositoryImpl meds;
  late InventoryRepositoryImpl inventory;
  late _MockMedicationService service;
  late ScheduleChangeService changes;

  final Medication med = Medication(
    id: 'm1',
    name: 'Metformin',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );

  setUpAll(() {
    registerFallbackValue(_FakeMedication());
    registerFallbackValue(_FakeInventory());
    registerFallbackValue(<SchedulePhase>[]);
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    meds = MedicationRepositoryImpl(db);
    inventory = InventoryRepositoryImpl(db);
    service = _MockMedicationService();
    changes = ScheduleChangeService(
      database: db,
      medications: meds,
      inventory: inventory,
      medicationService: service,
    );
    await meds.save(med);
    await meds.replacePhases('m1', <SchedulePhase>[
      SchedulePhase(
        id: 'p1',
        medicationId: 'm1',
        order: 0,
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 10, 1),
        timesMinutes: const <int>[480, 1200],
        weekdays: <int>{1, 2, 3, 4, 5, 6, 7},
      ),
    ]);
    when(() => service.pause(any())).thenAnswer((_) async {});
    when(() => service.resume(any())).thenAnswer((_) async {});
    when(() => service.save(
          medication: any(named: 'medication'),
          phases: any(named: 'phases'),
          inventory: any(named: 'inventory'),
        )).thenAnswer((_) async => med);
  });

  tearDown(() => db.close());

  test('a proposal can only be applied once', () async {
    const ScheduleProposal p = ScheduleProposal(
      id: 'a1',
      intent: ScheduleIntent.pause,
      medicationId: 'm1',
    );
    await changes.apply(p);
    await expectLater(
      changes.apply(p),
      throwsA(isA<ScheduleChangeException>()),
    );
    verify(() => service.pause(any())).called(1);
  });

  test('moving a reminder saves the new times and can be undone', () async {
    const ScheduleProposal p = ScheduleProposal(
      id: 'a2',
      intent: ScheduleIntent.moveReminderTime,
      medicationId: 'm1',
      moveFrom: 1200,
      moveTo: 1260,
    );
    await changes.apply(p);

    final List<SchedulePhase> saved = verify(() => service.save(
          medication: any(named: 'medication'),
          phases: captureAny(named: 'phases'),
          inventory: any(named: 'inventory'),
        )).captured.single as List<SchedulePhase>;
    expect(saved.single.timesMinutes, <int>[480, 1260]);

    await changes.undo('a2');
    final List<SchedulePhase> restored = verify(() => service.save(
          medication: any(named: 'medication'),
          phases: captureAny(named: 'phases'),
          inventory: any(named: 'inventory'),
        )).captured.single as List<SchedulePhase>;
    expect(restored.single.timesMinutes, <int>[480, 1200]);

    await expectLater(
      changes.undo('a2'),
      throwsA(isA<ScheduleChangeException>()),
    );
  });

  test('moving a reminder that no longer exists is refused', () async {
    await expectLater(
      changes.apply(const ScheduleProposal(
        id: 'a3',
        intent: ScheduleIntent.moveReminderTime,
        medicationId: 'm1',
        moveFrom: 600,
        moveTo: 700,
      )),
      throwsA(isA<ScheduleChangeException>()),
    );
  });

  test('stock needs tracked inventory', () async {
    await expectLater(
      changes.apply(const ScheduleProposal(
        id: 'a4',
        intent: ScheduleIntent.updateStock,
        medicationId: 'm1',
        stockQuantity: 20,
        stockMode: StockMode.correction,
      )),
      throwsA(isA<ScheduleChangeException>()),
    );
  });

  test('a timed pause resumes once the day arrives', () async {
    await changes.apply(ScheduleProposal(
      id: 'a5',
      intent: ScheduleIntent.pause,
      medicationId: 'm1',
      resumeOn: DateTime(2026, 11, 2),
    ));
    await meds.setStatus('m1', MedicationStatus.paused);

    expect(await changes.applyDueResumes(now: DateTime(2026, 11, 1)), 0);
    expect(await changes.applyDueResumes(now: DateTime(2026, 11, 2)), 1);
    verify(() => service.resume(any())).called(1);
    // Only once.
    expect(await changes.applyDueResumes(now: DateTime(2026, 11, 3)), 0);
  });
}
