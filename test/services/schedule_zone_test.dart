import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/data/local/app_database.dart';
import 'package:medzee/data/repositories/dose_repository_impl.dart';
import 'package:medzee/data/repositories/medication_repository_impl.dart';
import 'package:medzee/data/repositories/notification_schedule_repository_impl.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/dose.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/services/local_time_converter.dart';
import 'package:medzee/services/notification_service.dart';
import 'package:medzee/services/schedule_service.dart';
import 'package:medzee/services/timezone_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class _MockNotifications extends Mock implements NotificationService {}

/// Reminders must follow the *reminder* time zone, not the phone's: a person
/// whose schedule is on New York time keeps getting it on New York time after
/// landing in India (travel mode), and follows the phone when it is off.
void main() {
  late LocalTimeConverter newYork;
  late LocalTimeConverter kolkata;

  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    tz_data.initializeTimeZones();
    newYork = TzLocalTimeConverter(tz.getLocation('America/New_York'));
    kolkata = TzLocalTimeConverter(tz.getLocation('Asia/Kolkata'));
    registerFallbackValue(NotificationPrivacy.detailed);
    registerFallbackValue(DateTime.utc(2026));
  });

  late AppDatabase db;
  late MedicationRepositoryImpl meds;
  late DoseRepositoryImpl doses;
  late ScheduleService service;
  late _MockNotifications notifications;
  late LocalTimeConverter zone;


  // Monday 26 Oct 2026, 05:00 in Kolkata = Sunday 25 Oct, 19:30 in New York
  // (clocks change in New York only on 1 Nov, so it is still EDT, UTC-4).
  final DateTime now = DateTime.utc(2026, 10, 25, 23, 30);
  final DateTime from = DateTime(2026, 10, 20);
  final DateTime to = DateTime(2026, 11, 30);

  late Medication med;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    meds = MedicationRepositoryImpl(db);
    doses = DoseRepositoryImpl(db);
    notifications = _MockNotifications();
    when(() => notifications.cancel(any())).thenAnswer((_) async {});
    when(() => notifications.scheduleDoseReminder(
          notificationId: any(named: 'notificationId'),
          scheduledAt: any(named: 'scheduledAt'),
          medicationName: any(named: 'medicationName'),
          doseLabel: any(named: 'doseLabel'),
          payload: any(named: 'payload'),
          privacy: any(named: 'privacy'),
          personLabel: any(named: 'personLabel'),
        )).thenAnswer((_) async {});

    zone = newYork;
    service = ScheduleService(
      medicationRepository: meds,
      doseRepository: doses,
      notificationScheduleRepository: NotificationScheduleRepositoryImpl(db),
      notificationService: notifications,
      reminderConverter: () => zone,
    );

    med = Medication(
      id: 'm1',
      name: 'Metformin',
      status: MedicationStatus.active,
      startDate: DateTime(2026, 10, 13),
      createdAt: DateTime.utc(2026, 10, 13),
      updatedAt: DateTime.utc(2026, 10, 13),
    );
    await meds.save(med);
    await meds.replacePhases('m1', <SchedulePhase>[
      SchedulePhase(
        id: 'p1',
        medicationId: 'm1',
        order: 0,
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 10, 13),
        timesMinutes: const <int>[480, 1200], // 08:00 and 20:00
      ),
    ]);
  });

  tearDown(() => db.close());

  Future<void> sync() async => service.syncMedication(
        (await meds.getById('m1'))!,
        await meds.getPhases('m1'),
        now: now,
      );

  Future<List<ScheduledDose>> all() => doses.getDosesInRange(from, to);

  ScheduledDose at(List<ScheduledDose> l, DateTime day, int minutes) =>
      l.firstWhere((ScheduledDose d) =>
          d.localDate.year == day.year &&
          d.localDate.month == day.month &&
          d.localDate.day == day.day &&
          d.scheduledMinutes == minutes);

  test('doses are placed on the reminder zone, not the phone\'s', () async {
    zone = newYork;
    await sync();
    final List<ScheduledDose> list = await all();

    // 08:00 on 26 Oct in New York (EDT, UTC-4) is 12:00 UTC.
    expect(
      at(list, DateTime(2026, 10, 26), 480).scheduledAt.toUtc(),
      DateTime.utc(2026, 10, 26, 12),
    );
    // The same wall-clock time in Kolkata is a different instant.
    zone = kolkata;
    await service.syncMedication(
      (await meds.getById('m1'))!,
      await meds.getPhases('m1'),
      now: now,
    );
    expect(
      at(await all(), DateTime(2026, 10, 26), 480).scheduledAt.toUtc(),
      DateTime.utc(2026, 10, 26, 2, 30),
    );
  });

  test('today is the day in the reminder zone', () async {
    zone = newYork; // still Sunday 25 Oct there
    await sync();
    final List<ScheduledDose> ny = await all();
    expect(ny.any((ScheduledDose d) => d.localDate.day == 25), isTrue);

    zone = kolkata; // already Monday 26 Oct there
    final AppDatabase other = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(other.close);
    final MedicationRepositoryImpl m2 = MedicationRepositoryImpl(other);
    final DoseRepositoryImpl d2 = DoseRepositoryImpl(other);
    final ScheduleService s2 = ScheduleService(
      medicationRepository: m2,
      doseRepository: d2,
      notificationScheduleRepository: NotificationScheduleRepositoryImpl(other),
      notificationService: notifications,
      reminderConverter: () => kolkata,
    );
    await m2.save(med);
    await m2.replacePhases('m1', await meds.getPhases('m1'));
    await s2.syncMedication(med, await m2.getPhases('m1'), now: now);
    final List<ScheduledDose> ist = await d2.getDosesInRange(from, to);
    expect(ist.any((ScheduledDose d) => d.localDate.day == 25), isFalse);
    expect(ist.any((ScheduledDose d) => d.localDate.day == 26), isTrue);
  });

  test('changing the reminder zone moves open doses to the new instants',
      () async {
    zone = kolkata;
    await sync();
    final int before = (await all()).length;

    zone = newYork; // travel mode switched on: reminders go back to New York
    await sync();
    final List<ScheduledDose> list = await all();

    expect(
      at(list, DateTime(2026, 10, 27), 1200).scheduledAt.toUtc(),
      DateTime.utc(2026, 10, 28, 0), // 20:00 EDT
    );
    // No duplicates: one dose per wall-clock slot per day.
    final Set<String> keys = <String>{
      for (final ScheduledDose d in list)
        '${d.localDate.toIso8601String()}|${d.scheduledMinutes}',
    };
    expect(keys.length, list.length);
    expect(list.length, greaterThanOrEqualTo(before - 4));
    expect(
      list.where((ScheduledDose d) => d.status == DoseStatus.cancelled),
      isEmpty,
    );
  });

  test('a dose already taken keeps its status and instant when the zone moves',
      () async {
    zone = kolkata;
    await sync();
    final ScheduledDose target = at(await all(), DateTime(2026, 10, 27), 480);
    await doses.setStatus(target.id, DoseStatus.taken);

    zone = newYork;
    await sync();

    final ScheduledDose again = (await all())
        .firstWhere((ScheduledDose d) => d.id == target.id);
    expect(again.status, DoseStatus.taken);
    expect(again.scheduledAt.toUtc(), target.scheduledAt.toUtc());
  });

  test('moving west does not invent past doses that were never due', () async {
    zone = kolkata; // 05:00 Monday: planning starts on the 26th
    await sync();
    expect(
      (await all()).any((ScheduledDose d) => d.localDate.day == 25),
      isFalse,
    );

    zone = newYork; // the same moment is still Sunday evening in New York
    await sync();
    final List<ScheduledDose> list = await all();

    // 08:00 Sunday in New York is already over: not created (it would show up
    // as a missed dose the person never had).
    expect(
      list.where((ScheduledDose d) =>
          d.localDate.day == 25 && d.scheduledMinutes == 480),
      isEmpty,
    );
    // 20:00 Sunday in New York is still ahead: it must exist.
    expect(at(list, DateTime(2026, 10, 25), 1200).status, DoseStatus.pending);
  });

  test('syncing again in the same zone changes nothing', () async {
    zone = newYork;
    await sync();
    final List<ScheduledDose> first = await all();
    await sync();
    await sync();
    final List<ScheduledDose> second = await all();

    expect(second.length, first.length);
    expect(
      <String>{for (final ScheduledDose d in second) d.id},
      <String>{for (final ScheduledDose d in first) d.id},
      reason: 'rows must not be rebuilt when nothing moved',
    );
  });

  test('every reminder is scheduled for the person it belongs to', () async {
    service = ScheduleService(
      medicationRepository: meds,
      doseRepository: doses,
      notificationScheduleRepository: NotificationScheduleRepositoryImpl(db),
      notificationService: notifications,
      reminderConverter: () => newYork,
      personLabel: () => 'Dad',
    );
    await sync();

    verify(() => notifications.scheduleDoseReminder(
          notificationId: any(named: 'notificationId'),
          scheduledAt: any(named: 'scheduledAt'),
          medicationName: 'Metformin',
          doseLabel: any(named: 'doseLabel'),
          payload: any(named: 'payload'),
          privacy: any(named: 'privacy'),
          personLabel: 'Dad',
        )).called(greaterThan(0));
  });
}
