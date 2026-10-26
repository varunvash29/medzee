import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/dose.dart';
import 'package:medzee/domain/models/inventory.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/services/assistant_context_builder.dart';
import 'package:medzee/domain/services/schedule_proposal_service.dart';

final DateTime _today = DateTime(2026, 10, 26);

// 09:00 on the 26th, as an instant (the builder only compares instants).
final DateTime _now = DateTime.utc(2026, 10, 26, 9);

MedicationContext _med({
  String id = 'm1',
  String name = 'Metformin',
  MedicationStatus status = MedicationStatus.active,
  Inventory? inventory,
  String? instructions,
}) {
  return MedicationContext(
    Medication(
      id: id,
      name: name,
      strength: 500,
      status: status,
      instructions: instructions,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
    <SchedulePhase>[
      SchedulePhase(
        id: 'p-$id',
        medicationId: id,
        order: 0,
        kind: ScheduleKind.daily,
        startDate: DateTime(2026, 10, 1),
        timesMinutes: const <int>[480, 1200],
      ),
    ],
    inventory: inventory,
  );
}

ScheduledDose _dose(
  String id,
  DateTime day,
  int minutes, {
  String medicationId = 'm1',
  DoseStatus status = DoseStatus.pending,
}) {
  final DateTime at = DateTime.utc(day.year, day.month, day.day)
      .add(Duration(minutes: minutes));
  return ScheduledDose(
    id: id,
    medicationId: medicationId,
    phaseId: 'p-$medicationId',
    scheduledAt: at,
    localDate: day,
    scheduledMinutes: minutes,
    doseQuantity: 1,
    unit: DoseUnit.tablet,
    status: status,
  );
}

String _build(
  List<MedicationContext> meds,
  List<ScheduledDose> doses,
) =>
    AssistantContextBuilder.build(
      medications: meds,
      doses: doses,
      today: _today,
      nowUtc: _now,
    );

void main() {
  test('says so when there are no medicines', () {
    expect(_build(<MedicationContext>[], <ScheduledDose>[]),
        contains('no medicines yet'));
  });

  test('describes each medicine, its schedule and its stock', () {
    final String text = _build(
      <MedicationContext>[
        _med(
          inventory: Inventory(
            id: 'i1',
            medicationId: 'm1',
            quantityOnHand: 4,
            unit: DoseUnit.tablet,
            refillThreshold: 5,
            updatedAt: DateTime.utc(2026),
          ),
          instructions: 'Take with "food"',
        ),
      ],
      <ScheduledDose>[],
    );
    expect(text, contains('name="Metformin"'));
    expect(text, contains('strength=500 mg'));
    expect(text, contains('1 tablet every day at 08:00, 20:00'));
    expect(text, contains('4 tablets on hand'));
    expect(text, contains('LOW'));
    // Quotes in free text must not break out of the briefing's own quoting.
    expect(text, contains("instructions=\"Take with 'food'\""));
  });

  test('untracked stock is stated, not guessed', () {
    expect(_build(<MedicationContext>[_med()], <ScheduledDose>[]),
        contains('stock: not tracked'));
  });

  test('lists today\'s doses with their real status', () {
    final String text = _build(
      <MedicationContext>[_med()],
      <ScheduledDose>[
        _dose('a', _today, 8 * 60, status: DoseStatus.taken),
        _dose('b', _today, 20 * 60),
      ],
    );
    expect(text, contains('08:00 Metformin 1 tablet — taken'));
    expect(text, contains('20:00 Metformin 1 tablet — upcoming'));
  });

  test('a dose past its grace period reads as missed, not upcoming', () {
    final String text = _build(
      <MedicationContext>[_med()],
      <ScheduledDose>[_dose('a', _today, 6 * 60)], // 06:00, now is 09:00
    );
    expect(text, contains('06:00 Metformin 1 tablet — missed'));
  });

  test('cancelled doses are left out', () {
    final String text = _build(
      <MedicationContext>[_med(status: MedicationStatus.paused)],
      <ScheduledDose>[_dose('a', _today, 8 * 60, status: DoseStatus.cancelled)],
    );
    expect(text, isNot(contains('08:00 Metformin')));
    expect(text, contains('status=paused'));
  });

  test('summarises the last week per medicine, before today', () {
    final DateTime yesterday = DateTime(2026, 10, 25);
    final String text = _build(
      <MedicationContext>[_med()],
      <ScheduledDose>[
        _dose('a', yesterday, 8 * 60, status: DoseStatus.taken),
        _dose('b', yesterday, 20 * 60, status: DoseStatus.missed),
        _dose('c', DateTime(2026, 10, 20), 8 * 60, status: DoseStatus.skipped),
        // Too old (more than 7 days back) and today: both excluded.
        _dose('d', DateTime(2026, 10, 10), 8 * 60, status: DoseStatus.taken),
        _dose('e', _today, 8 * 60, status: DoseStatus.taken),
      ],
    );
    expect(text, contains('Metformin: 1 taken, 1 missed, 1 skipped of 3'));
  });

  test('tomorrow is listed separately', () {
    final String text = _build(
      <MedicationContext>[_med()],
      <ScheduledDose>[_dose('a', DateTime(2026, 10, 27), 8 * 60)],
    );
    expect(text, contains('Doses tomorrow (2026-10-27):'));
    expect(text, contains('08:00 Metformin 1 tablet — upcoming'));
  });
}
