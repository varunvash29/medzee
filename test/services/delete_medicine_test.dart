import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/data/local/app_database.dart';
import 'package:medzee/data/repositories/dose_repository_impl.dart';
import 'package:medzee/data/repositories/inventory_repository_impl.dart';
import 'package:medzee/data/repositories/medication_repository_impl.dart';
import 'package:medzee/data/repositories/notification_schedule_repository_impl.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/dose.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/services/dose_service.dart';
import 'package:medzee/services/medication_service.dart';
import 'package:medzee/services/notification_service.dart';
import 'package:medzee/services/schedule_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotifications extends Mock implements NotificationService {}

ScheduledDose _dose(String id, String medId, DateTime at, DoseStatus s) =>
    ScheduledDose(
      id: id,
      medicationId: medId,
      phaseId: 'p',
      scheduledAt: at.toUtc(),
      localDate: DateTime(at.year, at.month, at.day),
      scheduledMinutes: at.hour * 60 + at.minute,
      doseQuantity: 1,
      unit: DoseUnit.tablet,
      status: s,
    );

void main() {
  late AppDatabase db;
  late DoseRepositoryImpl doses;
  late MedicationRepositoryImpl meds;
  late MedicationService service;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    doses = DoseRepositoryImpl(db);
    meds = MedicationRepositoryImpl(db);
    final _MockNotifications n = _MockNotifications();
    when(() => n.cancel(any())).thenAnswer((_) async {});
    service = MedicationService(
      medicationRepository: meds,
      inventoryRepository: InventoryRepositoryImpl(db),
      doseRepository: doses,
      scheduleService: ScheduleService(
        medicationRepository: meds,
        doseRepository: doses,
        notificationScheduleRepository: NotificationScheduleRepositoryImpl(db),
        notificationService: n,
      ),
    );
    for (final String id in <String>['used', 'unused']) {
      await meds.save(Medication(
        id: id,
        name: id,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ));
    }
  });

  tearDown(() => db.close());

  Future<List<ScheduledDose>> all() =>
      doses.getDosesInRange(DateTime(2020), DateTime(2030));

  test('deleting a medicine keeps what was taken and clears what is ahead',
      () async {
    final DateTime past = DateTime.now().subtract(const Duration(days: 2));
    final DateTime future = DateTime.now().add(const Duration(days: 2));
    await doses.insertDoses(<ScheduledDose>[
      _dose('taken', 'used', past, DoseStatus.taken),
      _dose('missed', 'used', past.add(const Duration(hours: 5)),
          DoseStatus.pending),
      _dose('later', 'used', future, DoseStatus.pending),
      _dose('cancelled', 'used', future.add(const Duration(days: 1)),
          DoseStatus.cancelled),
    ]);

    await service.delete((await meds.getById('used'))!);

    final List<String> left =
        (await all()).map((ScheduledDose d) => d.id).toList()..sort();
    expect(left, <String>['missed', 'taken']);
    final Medication? kept = await meds.getById('used');
    expect(kept, isNotNull, reason: 'its history still points at it');
    expect(kept!.status, MedicationStatus.archived);
  });

  test('a medicine that was never taken is removed completely', () async {
    await doses.insertDoses(<ScheduledDose>[
      _dose('later', 'unused', DateTime.now().add(const Duration(days: 1)),
          DoseStatus.pending),
    ]);

    await service.delete((await meds.getById('unused'))!);

    expect(await meds.getById('unused'), isNull);
    expect(await all(), isEmpty);
  });

  test('removing cancelled doses never touches taken ones', () async {
    final DateTime day = DateTime.now().add(const Duration(days: 1));
    await doses.insertDoses(<ScheduledDose>[
      _dose('c', 'used', day, DoseStatus.cancelled),
      _dose('t', 'used', day.add(const Duration(hours: 1)), DoseStatus.taken),
    ]);
    final List<ScheduledDose> list = await all();
    await DoseService(
      doseRepository: doses,
      inventoryRepository: InventoryRepositoryImpl(db),
    ).removeCancelled(list);

    expect((await all()).map((ScheduledDose d) => d.id), <String>['t']);
  });
}

