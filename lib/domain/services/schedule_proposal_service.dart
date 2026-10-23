import 'dart:convert';

import '../models/core_enums.dart';
import '../models/medication.dart';
import '../models/schedule_proposal.dart';

/// A medicine as the assistant sees it: identity plus its current schedule.
class MedicationContext {
  const MedicationContext(this.medication, this.phases);

  final Medication medication;
  final List<SchedulePhase> phases;

  /// Every reminder time currently set, sorted.
  List<int> get times {
    final Set<int> all = <int>{};
    for (final SchedulePhase p in phases) {
      all.addAll(p.timesMinutes);
    }
    return all.toList()..sort();
  }
}

/// The outcome of checking a proposal against the user's real data.
class ProposalCheck {
  const ProposalCheck({
    this.errors = const <String>[],
    this.clarification,
    this.lines = const <String>[],
    this.medicationName,
  });

  /// Reasons the change cannot be made.
  final List<String> errors;

  /// A question to ask instead of proposing anything.
  final String? clarification;

  /// Human-readable description of what would change.
  final List<String> lines;
  final String? medicationName;

  bool get canApply => errors.isEmpty && clarification == null;
}

/// Parses the assistant's JSON and validates it with plain code.
///
/// The language model is never trusted to decide what is allowed: ids must
/// exist, times must be real, dates must make sense, and only the operations
/// listed in [ScheduleIntent] can happen.
class ScheduleProposalService {
  const ScheduleProposalService._();

  static ScheduleProposal parse(String raw, {required String id}) {
    String t = raw.trim();
    if (t.startsWith('```')) {
      t = t.replaceFirst(RegExp(r'^```[a-zA-Z]*\s*'), '');
      t = t.replaceFirst(RegExp(r'\s*```$'), '');
    }
    final Object? decoded;
    try {
      decoded = jsonDecode(t);
    } on FormatException {
      throw const FormatException('The response was not valid JSON.');
    }
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('The response had an unexpected shape.');
    }
    final ScheduleIntent? intent =
        ScheduleIntent.fromName(decoded['intent'] as String?);
    if (intent == null) {
      throw const FormatException('The response had no valid intent.');
    }
    return ScheduleProposal(
      id: id,
      intent: intent,
      medicationId: _str(decoded['medicationId']),
      times: _times(decoded['times']),
      moveFrom: _time(decoded['moveFrom']),
      moveTo: _time(decoded['moveTo']),
      startDate: _date(decoded['startDate']),
      endDate: _date(decoded['endDate']),
      durationDays: _int(decoded['durationDays']),
      resumeOn: _date(decoded['resumeOn']),
      stockQuantity: _num(decoded['stockQuantity']),
      stockMode: StockMode.fromName(_str(decoded['stockMode'])),
      clarification: _str(decoded['clarification']),
      summary: _str(decoded['summary']),
    );
  }

  // ------------------------------------------------------------- validate

  static ProposalCheck check(
    ScheduleProposal p,
    List<MedicationContext> meds, {
    required DateTime today,
  }) {
    if (p.intent == ScheduleIntent.clarify) {
      return ProposalCheck(
        clarification: p.clarification ?? 'Could you tell me a bit more?',
      );
    }
    if (p.intent == ScheduleIntent.unsupported) {
      return const ProposalCheck(
        errors: <String>[
          'I can change reminder times, pause or resume a medicine, and '
              'update stock. Doses and medicines themselves are changed from '
              'the medicine screen.',
        ],
      );
    }

    final List<MedicationContext> candidates = meds
        .where((MedicationContext m) =>
            m.medication.status != MedicationStatus.archived)
        .toList();
    MedicationContext? target;
    for (final MedicationContext m in candidates) {
      if (m.medication.id == p.medicationId) target = m;
    }
    if (target == null) {
      return ProposalCheck(
        clarification: candidates.isEmpty
            ? 'You have no medicines yet. Add one first.'
            : 'Which medicine do you mean? (${candidates.map((MedicationContext m) => m.medication.name).join(', ')})',
      );
    }

    final Medication med = target.medication;
    final String name = med.name;
    final DateTime day = DateTime(today.year, today.month, today.day);

    switch (p.intent) {
      case ScheduleIntent.setReminderTimes:
        if (p.times.isEmpty) {
          return ProposalCheck(
            medicationName: name,
            clarification: 'What time should I remind you for $name?',
          );
        }
        if (p.times.length > 12) {
          return ProposalCheck(
            medicationName: name,
            errors: const <String>['That is too many reminders in a day.'],
          );
        }
        final List<String> errors = _dateErrors(p, day);
        DateTime? end = p.endDate;
        if (p.durationDays != null) {
          final DateTime start = p.startDate ?? day;
          end = DateTime(start.year, start.month, start.day + p.durationDays! - 1);
        }
        return ProposalCheck(
          medicationName: name,
          errors: errors,
          lines: <String>[
            'Remind at ${_list(p.times)}',
            'Starting ${_day(p.startDate ?? day, day)}',
            end == null ? 'Ongoing' : 'Until ${_day(end, day)}',
            'Doses stay as they are',
          ],
        );

      case ScheduleIntent.moveReminderTime:
        final int? from = p.moveFrom;
        final int? to = p.moveTo;
        if (to == null) {
          return ProposalCheck(
            medicationName: name,
            clarification: 'What time should the reminder move to?',
          );
        }
        final List<int> current = target.times;
        if (current.isEmpty) {
          return ProposalCheck(
            medicationName: name,
            errors: <String>['$name has no reminders to move.'],
          );
        }
        int? source = from;
        if (source == null && current.length == 1) source = current.first;
        if (source == null || !current.contains(source)) {
          return ProposalCheck(
            medicationName: name,
            clarification: 'Which reminder should move? $name is set for '
                '${_list(current)}.',
          );
        }
        if (source != to && current.contains(to)) {
          return ProposalCheck(
            medicationName: name,
            errors: <String>['$name already has a reminder at ${_fmt(to)}.'],
          );
        }
        return ProposalCheck(
          medicationName: name,
          lines: <String>[
            'Move the ${_fmt(source)} reminder to ${_fmt(to)}',
            'Doses stay as they are',
          ],
        );

      case ScheduleIntent.pause:
        if (med.status != MedicationStatus.active) {
          return ProposalCheck(
            medicationName: name,
            errors: <String>['$name is not active, so there is nothing to pause.'],
          );
        }
        final DateTime? back = p.resumeOn;
        if (back != null &&
            (!back.isAfter(day) || back.difference(day).inDays > 365)) {
          return ProposalCheck(
            medicationName: name,
            errors: const <String>[
              'The restart date must be in the future, within a year.',
            ],
          );
        }
        return ProposalCheck(
          medicationName: name,
          lines: <String>[
            'Pause reminders for $name',
            back == null
                ? 'Until you resume it'
                : 'Resume on ${_day(back, day)}',
            'History is kept',
          ],
        );

      case ScheduleIntent.resume:
        if (med.status != MedicationStatus.paused) {
          return ProposalCheck(
            medicationName: name,
            errors: <String>['$name is not paused.'],
          );
        }
        return ProposalCheck(
          medicationName: name,
          lines: <String>['Resume reminders for $name'],
        );

      case ScheduleIntent.updateStock:
        final double? q = p.stockQuantity;
        if (q == null || q.isNaN || q.isInfinite || q < 0 || q > 100000) {
          return ProposalCheck(
            medicationName: name,
            clarification: 'How many do you have?',
          );
        }
        if (p.stockMode == null) {
          return ProposalCheck(
            medicationName: name,
            clarification: 'Did you count ${_n(q)} left in the box, or did '
                'you pick up ${_n(q)} more?',
          );
        }
        return ProposalCheck(
          medicationName: name,
          lines: <String>[
            p.stockMode == StockMode.correction
                ? 'Set stock to ${_n(q)} (a correction)'
                : 'Add ${_n(q)} to your stock (a refill)',
          ],
        );

      case ScheduleIntent.clarify:
      case ScheduleIntent.unsupported:
        return const ProposalCheck();
    }
  }

  // ------------------------------------------------------------- helpers

  static List<String> _dateErrors(ScheduleProposal p, DateTime day) {
    final List<String> e = <String>[];
    final DateTime? s = p.startDate;
    if (s != null && s.isBefore(day.subtract(const Duration(days: 1)))) {
      e.add('The start date is in the past.');
    }
    if (p.endDate != null && p.endDate!.isBefore(s ?? day)) {
      e.add('The end date is before the start date.');
    }
    if (p.durationDays != null &&
        (p.durationDays! < 1 || p.durationDays! > 3650)) {
      e.add('The number of days is not valid.');
    }
    return e;
  }

  static String _fmt(int minutes) {
    final int h = minutes ~/ 60;
    final int m = minutes % 60;
    final String suffix = h >= 12 ? 'PM' : 'AM';
    final int h12 = h % 12 == 0 ? 12 : h % 12;
    return '$h12:${m.toString().padLeft(2, '0')} $suffix';
  }

  static String _list(List<int> times) => times.map(_fmt).join(', ');

  static String _day(DateTime d, DateTime today) {
    if (d == today) return 'today';
    if (d == DateTime(today.year, today.month, today.day + 1)) return 'tomorrow';
    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]}';
  }

  static String _n(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  static String? _str(Object? v) {
    if (v is! String) return null;
    final String t = v.trim();
    return (t.isEmpty || t.toLowerCase() == 'null') ? null : t;
  }

  static double? _num(Object? v) => v is num ? v.toDouble() : null;

  static int? _int(Object? v) =>
      (v is num && v == v.roundToDouble()) ? v.toInt() : null;

  static int? _time(Object? v) {
    if (v is! String) return null;
    final RegExpMatch? m = RegExp(r'^\s*(\d{1,2}):(\d{2})\s*$').firstMatch(v);
    if (m == null) return null;
    final int h = int.parse(m.group(1)!);
    final int min = int.parse(m.group(2)!);
    if (h > 23 || min > 59) return null;
    return h * 60 + min;
  }

  static List<int> _times(Object? v) {
    if (v is! List) return const <int>[];
    final Set<int> out = <int>{};
    for (final Object? t in v) {
      final int? m = _time(t);
      if (m != null) out.add(m);
    }
    return out.toList()..sort();
  }

  static DateTime? _date(Object? v) {
    if (v is! String) return null;
    final RegExpMatch? m =
        RegExp(r'^\s*(\d{4})-(\d{2})-(\d{2})\s*$').firstMatch(v);
    if (m == null) return null;
    final int y = int.parse(m.group(1)!);
    final int mo = int.parse(m.group(2)!);
    final int d = int.parse(m.group(3)!);
    final DateTime date = DateTime(y, mo, d);
    // Reject overflowed dates such as 2026-02-31.
    return (date.month == mo && date.day == d) ? date : null;
  }
}
