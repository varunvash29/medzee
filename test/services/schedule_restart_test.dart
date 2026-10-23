import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/data/local/app_database.dart';
import 'package:medzee/data/mappers.dart';
import 'package:medzee/data/repositories/dose_repository_impl.dart';
import 'package:medzee/data/repositories/medication_repository_impl.dart';
import 'package:medzee/data/repositories/notification_schedule_repository_impl.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/dose.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/services/notification_service.dart';
import 'package:medzee/services/schedule_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotifications extends Mock implements NotificationService {}

void main() {
  setUpAll(() {
    registerFallbackValue(NotificationPrivacy.detailed);
    registerFallbackValue(DateTime.utc(2026));
  });

  group('stored dates read back as the same calendar day', () {
    test('a dose date stored as UTC midnight is local midnight of that day', () {
      final DateTime stored = DateTime.utc(2026, 10, 23);
      final DateTime read = Mappers.dateOnlyLocal(stored);
      expect(read, DateTime(2026, 10, 23));
      expect(read.hour, 0);
      expect(read.isUtc, isFalse);
    });

    test('round trip through the stored form keeps the day', () {
      final DateTime local = DateTime(2026, 1, 31);
      expect(Mappers.dateOnlyLocal(Mappers.dateOnlyUtc(local)), local);
    });
  });

  group('restarting the app does not change doses', () {
    late AppDatabase db;
    late MedicationRepositoryImpl meds;
    late DoseRepositoryImpl doses;
    late ScheduleService service;

    // Fixed "now" so the test is stable: Friday 23 Oct 2026, 09:00 local.
    final DateTime now = DateTime(2026, 10, 23, 9);
    final DateTime from = DateTime(2026, 10, 1);
    final DateTime to = DateTime(2026, 11, 30);

    late Medication med;
    late List<SchedulePhase> phases;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      meds = MedicationRepositoryImpl(db);
      doses = DoseRepositoryImpl(db);

      final _MockNotifications notifications = _MockNotifications();
      when(() => notifications.cancel(any())).thenAnswer((_) async {});
      when(() => notifications.cancelAll()).thenAnswer((_) async {});
      when(() => notifications.scheduleDoseReminder(
            notificationId: any(named: 'notificationId'),
            scheduledAt: any(named: 'scheduledAt'),
            medicationName: any(named: 'medicationName'),
            doseLabel: any(named: 'doseLabel'),
            payload: any(named: 'payload'),
            privacy: any(named: 'privacy'),
            soundEnabled: any(named: 'soundEnabled'),
            vibrationEnabled: any(named: 'vibrationEnabled'),
          )).thenAnswer((_) async {});

      service = ScheduleService(
        medicationRepository: meds,
        doseRepository: doses,
        notificationScheduleRepository: NotificationScheduleRepositoryImpl(db),
        notificationService: notifications,
      );

      med = Medication(
        id: 'm1',
        name: 'Metformin',
        status: MedicationStatus.active,
        startDate: DateTime(2026, 10, 13),
        createdAt: DateTime.utc(2026, 10, 13),
        updatedAt: DateTime.utc(2026, 10, 13),
      );
      phases = <SchedulePhase>[
        SchedulePhase(
          id: 'p1',
          medicationId: 'm1',
          order: 0,
          kind: ScheduleKind.daily,
          startDate: DateTime(2026, 10, 13),
          timesMinutes: const <int>[480, 1200],
          weekdays: <int>{1, 2, 3, 4, 5, 6, 7},
        ),
      ];
      await meds.save(med);
      await meds.replacePhases('m1', phases);
    });

    tearDown(() => db.close());

    Future<List<ScheduledDose>> all() => doses.getDosesInRange(from, to);

    int count(List<ScheduledDose> l, DoseStatus s) =>
        l.where((ScheduledDose d) => d.status == s).length;

    test('pending doses stay pending after repeated app starts', () async {
      // The phases the app reads back from the database (as on a real start).
      Future<void> startApp() async => service.syncMedication(
            (await meds.getById('m1'))!,
            await meds.getPhases('m1'),
            now: now,
          );

      await startApp();
      final List<ScheduledDose> first = await all();
      final int pending = count(first, DoseStatus.pending);
      expect(pending, greaterThan(10));
      expect(count(first, DoseStatus.cancelled), 0);

      for (int i = 0; i < 3; i++) {
        await startApp();
      }

      final List<ScheduledDose> after = await all();
      expect(count(after, DoseStatus.cancelled), 0,
          reason: 'a restart must never cancel planned doses');
      expect(count(after, DoseStatus.pending), pending);
      expect(after.length, first.length, reason: 'no duplicates either');
    });

    test('a restart with nothing to change writes nothing (no screen refresh)',
        () async {
      await service.syncMedication(med, phases, now: now);

      int emissions = 0;
      final sub = doses.watchDosesInRange(from, to).listen((_) => emissions++);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final int afterInitial = emissions;

      await service.syncMedication(
        (await meds.getById('m1'))!,
        await meds.getPhases('m1'),
        now: now,
      );
      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(emissions, afterInitial,
          reason: 'unchanged doses must not notify the UI again');
      await sub.cancel();
    });

    test('a dose that was taken stays taken after a restart', () async {
      await service.syncMedication(med, phases, now: now);
      final ScheduledDose target = (await all()).firstWhere(
        (ScheduledDose d) => d.status == DoseStatus.pending,
      );
      await doses.setStatus(target.id, DoseStatus.taken);

      await service.syncMedication(
        (await meds.getById('m1'))!,
        await meds.getPhases('m1'),
        now: now,
      );

      final ScheduledDose again =
          (await all()).firstWhere((ScheduledDose d) => d.id == target.id);
      expect(again.status, DoseStatus.taken);
    });

    test('doses cancelled earlier come back when the schedule is rebuilt',
        () async {
      await service.syncMedication(med, phases, now: now);
      final int pending = count(await all(), DoseStatus.pending);

      // What pausing does (or what the old date bug did).
      await doses.cancelFutureDoses('m1', now.toUtc());
      expect(count(await all(), DoseStatus.pending), lessThan(pending));

      await service.syncMedication(
        (await meds.getById('m1'))!,
        await meds.getPhases('m1'),
        now: now,
      );

      expect(count(await all(), DoseStatus.pending), pending);
    });
  });
}
