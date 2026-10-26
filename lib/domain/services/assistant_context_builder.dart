import '../models/core_enums.dart';
import '../models/dose.dart';
import '../models/inventory.dart';
import '../models/medication.dart';
import 'dose_status_resolver.dart';
import 'schedule_proposal_service.dart';

/// Turns the person's own data into a plain-text briefing for the assistant,
/// so it can answer questions about their medicines, schedule and stock.
///
/// Pure and deterministic: the same data always gives the same text. Only
/// facts the app already holds are included; the assistant is told to answer
/// from this and nothing else.
abstract final class AssistantContextBuilder {
  /// Longest list of medicines described in full. A guard, not a real limit.
  static const int maxMedicines = 40;

  /// [today] is the calendar date in the person's reminder time zone and
  /// [nowUtc] the current instant. [doses] may cover any range; only the past
  /// week, today and tomorrow are used.
  static String build({
    required List<MedicationContext> medications,
    required List<ScheduledDose> doses,
    required DateTime today,
    required DateTime nowUtc,
  }) {
    final DateTime day = DateTime(today.year, today.month, today.day);
    final StringBuffer out = StringBuffer();

    final List<MedicationContext> meds = medications.take(maxMedicines).toList();
    if (meds.isEmpty) {
      out.writeln('The person has no medicines yet.');
      return out.toString();
    }
    final Map<String, String> names = <String, String>{
      for (final MedicationContext m in meds) m.medication.id: m.medication.name,
    };

    out.writeln('Medicines, with their schedules and stock:');
    for (final MedicationContext m in meds) {
      out.writeln(_medicine(m));
    }

    final List<ScheduledDose> live = doses
        .where((ScheduledDose d) =>
            d.status != DoseStatus.cancelled &&
            names.containsKey(d.medicationId))
        .toList()
      ..sort((ScheduledDose a, ScheduledDose b) =>
          a.scheduledAt.compareTo(b.scheduledAt));

    final DateTime tomorrow = DateTime(day.year, day.month, day.day + 1);
    final List<ScheduledDose> todays = _onDay(live, day);
    final List<ScheduledDose> tomorrows = _onDay(live, tomorrow);

    out.writeln('Doses today (${_date(day)}):');
    out.write(_doseLines(todays, names, nowUtc));
    out.writeln('Doses tomorrow (${_date(tomorrow)}):');
    out.write(_doseLines(tomorrows, names, nowUtc));

    final String week = _lastWeek(live, names, day, nowUtc);
    if (week.isNotEmpty) {
      out.writeln('Last 7 days (before today), per medicine:');
      out.write(week);
    }
    return out.toString();
  }

  // ------------------------------------------------------------- medicines

  static String _medicine(MedicationContext c) {
    final Medication m = c.medication;
    final List<String> parts = <String>[
      'id=${m.id}',
      'name="${m.name}"',
      if (m.genericName != null && m.genericName!.trim().isNotEmpty)
        'generic="${m.genericName}"',
      if (m.strengthLabel != null) 'strength=${m.strengthLabel}',
      'form=${m.form.name}',
      'status=${m.status.name}',
      if (m.isAsNeeded) 'asNeeded=true',
      if (m.foodInstruction != FoodInstruction.anyTime)
        'food="${m.foodInstruction.name}"',
      if (m.instructions != null && m.instructions!.trim().isNotEmpty)
        'instructions="${_oneLine(m.instructions!)}"',
      if (m.endDate != null) 'courseEnds=${_date(m.endDate!)}',
    ];
    final StringBuffer line = StringBuffer('- ${parts.join(' ')}');
    final List<String> schedules = <String>[
      for (final SchedulePhase p in c.phases)
        if (p.isActive) _phase(p),
    ];
    line.write('\n    schedule: ');
    line.write(schedules.isEmpty ? 'none' : schedules.join('; then '));
    line.write('\n    stock: ${_stock(c.inventory)}');
    return line.toString();
  }

  static String _phase(SchedulePhase p) {
    final String qty = '${_n(p.doseQuantity)} ${p.unit.singular}'
        '${p.doseQuantity == 1 ? '' : 's'}';
    final String times = p.timesMinutes.map(_hhmm).join(', ');
    final String when = switch (p.kind) {
      ScheduleKind.daily => 'every day at $times',
      ScheduleKind.weekly || ScheduleKind.custom =>
        '${_weekdays(p.weekdays)} at $times',
      ScheduleKind.everyNDays => 'every ${p.intervalDays} days at $times',
      ScheduleKind.everyNHours => 'every ${p.intervalHours} hours',
      ScheduleKind.monthly =>
        'on day ${p.monthlyDays.join(', ')} of the month at $times',
      ScheduleKind.asNeeded => 'only as needed',
    };
    final String range = p.endDate == null
        ? 'from ${_date(p.startDate)}'
        : '${_date(p.startDate)} to ${_date(p.endDate!)}';
    return '$qty $when ($range)';
  }

  static String _stock(Inventory? i) {
    if (i == null) return 'not tracked';
    final String unit = i.unit.singular;
    final StringBuffer s = StringBuffer(
      '${_n(i.quantityOnHand)} ${unit}s on hand',
    );
    if (i.refillThreshold > 0) {
      s.write(', warn at ${_n(i.refillThreshold)}');
    }
    if (i.isEmpty) {
      s.write(', EMPTY');
    } else if (i.isLowStock) {
      s.write(', LOW');
    }
    return s.toString();
  }

  // ----------------------------------------------------------------- doses

  static List<ScheduledDose> _onDay(List<ScheduledDose> doses, DateTime day) =>
      doses
          .where((ScheduledDose d) =>
              d.localDate.year == day.year &&
              d.localDate.month == day.month &&
              d.localDate.day == day.day)
          .toList(growable: false);

  static String _doseLines(
    List<ScheduledDose> doses,
    Map<String, String> names,
    DateTime nowUtc,
  ) {
    if (doses.isEmpty) return '- none\n';
    final StringBuffer out = StringBuffer();
    for (final ScheduledDose d in doses) {
      out.writeln(
        '- ${_hhmm(d.scheduledMinutes)} ${names[d.medicationId]} '
        '${_n(d.doseQuantity)} ${d.unit.singular}'
        '${d.doseQuantity == 1 ? '' : 's'} — ${_status(d, nowUtc)}',
      );
    }
    return out.toString();
  }

  static String _status(ScheduledDose d, DateTime nowUtc) {
    final DoseStatus s = DoseStatusResolver.resolve(
      scheduledAt: d.scheduledAt,
      now: nowUtc,
      current: d.status,
    );
    return switch (s) {
      DoseStatus.pending =>
        d.scheduledAt.toUtc().isAfter(nowUtc) ? 'upcoming' : 'due now',
      DoseStatus.taken => 'taken',
      DoseStatus.skipped => 'skipped',
      DoseStatus.missed => 'missed',
      DoseStatus.cancelled => 'cancelled',
    };
  }

  static String _lastWeek(
    List<ScheduledDose> doses,
    Map<String, String> names,
    DateTime day,
    DateTime nowUtc,
  ) {
    final DateTime from = DateTime(day.year, day.month, day.day - 7);
    final Map<String, List<int>> counts = <String, List<int>>{};
    for (final ScheduledDose d in doses) {
      final DateTime date =
          DateTime(d.localDate.year, d.localDate.month, d.localDate.day);
      if (date.isBefore(from) || !date.isBefore(day)) continue;
      final DoseStatus s = DoseStatusResolver.resolve(
        scheduledAt: d.scheduledAt,
        now: nowUtc,
        current: d.status,
      );
      final List<int> c =
          counts.putIfAbsent(d.medicationId, () => <int>[0, 0, 0, 0]);
      switch (s) {
        case DoseStatus.taken:
          c[0]++;
        case DoseStatus.missed:
          c[1]++;
        case DoseStatus.skipped:
          c[2]++;
        case DoseStatus.pending:
        case DoseStatus.cancelled:
          break;
      }
      c[3]++;
    }
    final StringBuffer out = StringBuffer();
    for (final MapEntry<String, List<int>> e in counts.entries) {
      final List<int> c = e.value;
      out.writeln(
        '- ${names[e.key]}: ${c[0]} taken, ${c[1]} missed, ${c[2]} skipped '
        'of ${c[3]} scheduled',
      );
    }
    return out.toString();
  }

  // --------------------------------------------------------------- helpers

  static String _hhmm(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
      '${(minutes % 60).toString().padLeft(2, '0')}';

  static String _date(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static String _n(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

  static String _oneLine(String s) =>
      s.replaceAll(RegExp(r'\s+'), ' ').replaceAll('"', "'").trim();

  static String _weekdays(Set<int> days) {
    if (days.isEmpty) return 'on no days';
    const List<String> names = <String>[
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
    ];
    final List<int> sorted = days.toList()..sort();
    return 'on ${sorted.map((int d) => names[d - 1]).join(', ')}';
  }
}
