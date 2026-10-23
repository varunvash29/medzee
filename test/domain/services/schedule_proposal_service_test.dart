import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/models/schedule_proposal.dart';
import 'package:medzee/domain/services/schedule_proposal_service.dart';

final DateTime _today = DateTime(2026, 10, 23);

MedicationContext _med({
  String id = 'm1',
  String name = 'Metformin',
  MedicationStatus status = MedicationStatus.active,
  List<int> times = const <int>[480, 1200],
}) {
  return MedicationContext(
    Medication(
      id: id,
      name: name,
      status: status,
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
        timesMinutes: times,
        weekdays: <int>{1, 2, 3, 4, 5, 6, 7},
      ),
    ],
  );
}

ScheduleProposal _p(Map<String, Object?> json) =>
    ScheduleProposalService.parse(jsonEncode(json), id: 'x');

ProposalCheck _check(Map<String, Object?> json, [List<MedicationContext>? m]) =>
    ScheduleProposalService.check(_p(json), m ?? <MedicationContext>[_med()],
        today: _today);

void main() {
  group('parse', () {
    test('rejects junk and unknown intents', () {
      expect(() => ScheduleProposalService.parse('nope', id: 'x'),
          throwsFormatException);
      expect(() => _p(<String, Object?>{'intent': 'deleteEverything'}),
          throwsFormatException);
    });

    test('drops malformed times and impossible dates', () {
      final ScheduleProposal p = _p(<String, Object?>{
        'intent': 'setReminderTimes',
        'times': <String>['08:00', '25:00', 'noon'],
        'startDate': '2026-02-31',
      });
      expect(p.times, <int>[480]);
      expect(p.startDate, isNull);
    });
  });

  group('check', () {
    test('an unknown medicine id asks which medicine', () {
      final ProposalCheck c = _check(<String, Object?>{
        'intent': 'pause',
        'medicationId': 'ghost',
      });
      expect(c.canApply, isFalse);
      expect(c.clarification, contains('Which medicine'));
    });

    test('reminder times with no times asks for them', () {
      final ProposalCheck c = _check(<String, Object?>{
        'intent': 'setReminderTimes',
        'medicationId': 'm1',
      });
      expect(c.clarification, isNotNull);
    });

    test('a good set-times request previews and can apply', () {
      final ProposalCheck c = _check(<String, Object?>{
        'intent': 'setReminderTimes',
        'medicationId': 'm1',
        'times': <String>['08:00'],
        'durationDays': 7,
        'startDate': '2026-10-24',
      });
      expect(c.canApply, isTrue);
      expect(c.lines.join(' '), contains('8:00 AM'));
      expect(c.lines.join(' '), contains('tomorrow'));
      expect(c.lines.join(' '), contains('Doses stay'));
    });

    test('an end date before the start is an error', () {
      final ProposalCheck c = _check(<String, Object?>{
        'intent': 'setReminderTimes',
        'medicationId': 'm1',
        'times': <String>['08:00'],
        'startDate': '2026-10-30',
        'endDate': '2026-10-25',
      });
      expect(c.canApply, isFalse);
      expect(c.errors, isNotEmpty);
    });

    test('moving an unspecified reminder asks which one', () {
      final ProposalCheck c = _check(<String, Object?>{
        'intent': 'moveReminderTime',
        'medicationId': 'm1',
        'moveTo': '21:00',
      });
      expect(c.clarification, contains('Which reminder'));
    });

    test('moving the evening reminder previews the move', () {
      final ProposalCheck c = _check(<String, Object?>{
        'intent': 'moveReminderTime',
        'medicationId': 'm1',
        'moveFrom': '20:00',
        'moveTo': '21:00',
      });
      expect(c.canApply, isTrue);
      expect(c.lines.first, contains('8:00 PM'));
      expect(c.lines.first, contains('9:00 PM'));
    });

    test('moving onto an existing reminder is an error', () {
      final ProposalCheck c = _check(<String, Object?>{
        'intent': 'moveReminderTime',
        'medicationId': 'm1',
        'moveFrom': '20:00',
        'moveTo': '08:00',
      });
      expect(c.canApply, isFalse);
    });

    test('pausing a paused medicine is rejected; past restart date too', () {
      expect(
        _check(<String, Object?>{'intent': 'pause', 'medicationId': 'm1'},
                <MedicationContext>[_med(status: MedicationStatus.paused)])
            .canApply,
        isFalse,
      );
      expect(
        _check(<String, Object?>{
          'intent': 'pause',
          'medicationId': 'm1',
          'resumeOn': '2026-10-01',
        }).canApply,
        isFalse,
      );
      expect(
        _check(<String, Object?>{
          'intent': 'pause',
          'medicationId': 'm1',
          'resumeOn': '2026-10-26',
        }).canApply,
        isTrue,
      );
    });

    test('resume needs a paused medicine', () {
      expect(
        _check(<String, Object?>{'intent': 'resume', 'medicationId': 'm1'})
            .canApply,
        isFalse,
      );
    });

    test('stock without a mode asks whether it is a count or a refill', () {
      final ProposalCheck c = _check(<String, Object?>{
        'intent': 'updateStock',
        'medicationId': 'm1',
        'stockQuantity': 20,
      });
      expect(c.clarification, contains('count'));
    });

    test('stock with a mode previews; negatives are not accepted', () {
      expect(
        _check(<String, Object?>{
          'intent': 'updateStock',
          'medicationId': 'm1',
          'stockQuantity': 20,
          'stockMode': 'correction',
        }).canApply,
        isTrue,
      );
      expect(
        _check(<String, Object?>{
          'intent': 'updateStock',
          'medicationId': 'm1',
          'stockQuantity': -3,
          'stockMode': 'refill',
        }).canApply,
        isFalse,
      );
    });

    test('archived medicines cannot be targeted', () {
      final ProposalCheck c = _check(
        <String, Object?>{'intent': 'pause', 'medicationId': 'm1'},
        <MedicationContext>[_med(status: MedicationStatus.archived)],
      );
      expect(c.canApply, isFalse);
    });

    test('unsupported requests are refused with guidance', () {
      final ProposalCheck c = _check(<String, Object?>{'intent': 'unsupported'});
      expect(c.canApply, isFalse);
      expect(c.errors.single, contains('medicine screen'));
    });
  });
}
