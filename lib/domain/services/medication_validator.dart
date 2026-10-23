import '../models/core_enums.dart';
import '../models/medication.dart';

/// The result of validating a medication before it is saved.
class ValidationResult {
  const ValidationResult(this.errors);

  /// Field path -> human readable problem.
  final Map<String, String> errors;

  bool get isValid => errors.isEmpty;

  String? operator [](String field) => errors[field];
}

/// Validates a medication and its schedule.
///
/// Medzee never saves an incomplete or contradictory schedule. Every rule
/// here exists because getting it wrong would either mis-time a dose or
/// corrupt the stock count.
abstract final class MedicationValidator {
  static ValidationResult validate({
    required Medication medication,
    required List<SchedulePhase> phases,
  }) {
    final Map<String, String> errors = <String, String>{};

    if (medication.name.trim().isEmpty) {
      errors['name'] = 'Give the medicine a name so you can recognise it.';
    }
    if (medication.name.trim().length > 80) {
      errors['name'] = 'Keep the name under 80 characters.';
    }
    final double? strength = medication.strength;
    if (strength != null && strength < 0) {
      errors['strength'] = 'Strength cannot be negative.';
    }
    if (medication.startDate != null && medication.endDate != null) {
      if (medication.endDate!.isBefore(medication.startDate!)) {
        errors['endDate'] = 'The end date must be after the start date.';
      }
    }

    if (phases.isEmpty) {
      errors['schedule'] = 'Add at least one schedule.';
      return ValidationResult(errors);
    }

    final List<SchedulePhase> ordered = List<SchedulePhase>.from(phases)
      ..sort((SchedulePhase a, SchedulePhase b) => a.order.compareTo(b.order));

    DateTime? previousEnd;
    for (int i = 0; i < ordered.length; i++) {
      final SchedulePhase phase = ordered[i];
      final String prefix = 'phase$i';

      if (phase.kind.isAsNeeded) {
        if (phase.timesMinutes.isNotEmpty) {
          errors['$prefix.times'] =
              'As-needed medicines do not have fixed reminder times.';
        }
      } else {
        if (phase.timesMinutes.isEmpty) {
          errors['$prefix.times'] = 'Add at least one reminder time.';
        }
        for (final int minutes in phase.timesMinutes) {
          if (minutes < 0 || minutes > 1439) {
            errors['$prefix.times'] = 'Reminder times must be within a day.';
            break;
          }
        }
        if (phase.kind == ScheduleKind.weekly ||
            phase.kind == ScheduleKind.custom) {
          if (phase.weekdays.isEmpty) {
            errors['$prefix.weekdays'] = 'Choose at least one day of the week.';
          }
          for (final int day in phase.weekdays) {
            if (day < 1 || day > 7) {
              errors['$prefix.weekdays'] = 'Invalid day of the week.';
              break;
            }
          }
        }
        if (phase.kind == ScheduleKind.everyNDays && phase.intervalDays < 1) {
          errors['$prefix.intervalDays'] = 'The interval must be at least 1 day.';
        }
        if (phase.kind == ScheduleKind.everyNHours) {
          if (phase.intervalHours < 1 || phase.intervalHours > 24) {
            errors['$prefix.intervalHours'] =
                'The interval must be between 1 and 24 hours.';
          }
        }
        if (phase.kind == ScheduleKind.monthly) {
          if (phase.monthlyDays.isEmpty) {
            errors['$prefix.monthlyDays'] = 'Choose at least one day of the month.';
          }
          for (final int day in phase.monthlyDays) {
            if (day < 1 || day > 31) {
              errors['$prefix.monthlyDays'] = 'Days must be between 1 and 31.';
              break;
            }
          }
        }
      }

      if (phase.doseQuantity <= 0) {
        errors['$prefix.quantity'] = 'The dose amount must be greater than zero.';
      }
      if (phase.endDate != null && phase.endDate!.isBefore(phase.startDate)) {
        errors['$prefix.endDate'] = 'The phase ends before it starts.';
      }
      if (previousEnd != null && phase.startDate.isBefore(previousEnd)) {
        errors['$prefix.startDate'] =
            'Schedule phases must not overlap. This one starts before the '
            'previous one ends.';
      }
      previousEnd = phase.endDate;
    }

    return ValidationResult(errors);
  }

  /// Clamps and normalises a phase so that the schedule can never be stored
  /// in a contradictory state.
  static SchedulePhase normalise(SchedulePhase phase) {
    final List<int> times = phase.timesMinutes
        .where((int m) => m >= 0 && m <= 1439)
        .toSet()
        .toList()
      ..sort();
    final Set<int> weekdays = phase.weekdays.where((int d) => d >= 1 && d <= 7).toSet();
    final List<int> monthlyDays =
        phase.monthlyDays.where((int d) => d >= 1 && d <= 31).toSet().toList()
          ..sort();

    return phase.copyWith(
      timesMinutes: times,
      weekdays: weekdays,
      monthlyDays: monthlyDays,
      intervalDays: phase.intervalDays < 1 ? 1 : phase.intervalDays,
      intervalHours: phase.intervalHours < 1
          ? 1
          : (phase.intervalHours > 24 ? 24 : phase.intervalHours),
      doseQuantity: phase.doseQuantity <= 0 ? 1 : phase.doseQuantity,
    );
  }

  /// A readable summary of a schedule, used on the review screen.
  static String summarise(SchedulePhase phase) {
    if (phase.kind.isAsNeeded) return 'Take as needed';
    final List<int> times = phase.timesMinutes.toList()..sort();
    final String timeList = times
        .map((int m) =>
            '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}')
        .join(', ');
    switch (phase.kind) {
      case ScheduleKind.daily:
        return 'Every day at $timeList';
      case ScheduleKind.weekly:
      case ScheduleKind.custom:
        const List<String> names = <String>[
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
          'Sun',
        ];
        final List<int> days = phase.weekdays.toList()..sort();
        return '${days.map((int d) => names[d - 1]).join(', ')} at $timeList';
      case ScheduleKind.everyNDays:
        return phase.intervalDays == 2
            ? 'Every other day at $timeList'
            : 'Every ${phase.intervalDays} days at $timeList';
      case ScheduleKind.everyNHours:
        return 'Every ${phase.intervalHours} hours from $timeList';
      case ScheduleKind.monthly:
        return 'On day ${phase.monthlyDays.join(', ')} at $timeList';
      case ScheduleKind.asNeeded:
        return 'Take as needed';
    }
  }
}
