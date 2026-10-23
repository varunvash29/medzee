import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/dose.dart';
import 'package:medzee/domain/services/adherence_calculator.dart';

final DateTime _now = DateTime(2026, 3, 10, 12);

ScheduledDose _dose({
  required DoseStatus status,
  required DateTime scheduledAt,
  String id = 'dose-1',
}) {
  return ScheduledDose(
    id: id,
    medicationId: 'med-1',
    phaseId: 'phase-1',
    scheduledAt: scheduledAt,
    localDate: DateTime(
      scheduledAt.year,
      scheduledAt.month,
      scheduledAt.day,
    ),
    scheduledMinutes: scheduledAt.hour * 60 + scheduledAt.minute,
    doseQuantity: 1,
    unit: DoseUnit.tablet,
    status: status,
  );
}

void main() {
  group('AdherenceCalculator.calculate', () {
    test('an empty window reports no data rather than 100%', () {
      final AdherenceSummary summary = AdherenceCalculator.calculate(
        doses: const <ScheduledDose>[],
        now: _now,
      );

      expect(summary.hasData, isFalse);
      expect(summary.percent, isNull);
      expect(summary.taken, 0);
    });

    test('a perfect day reports 100%', () {
      // Both doses are already due by noon, and both were taken.
      final AdherenceSummary summary = AdherenceCalculator.calculate(
        doses: <ScheduledDose>[
          _dose(status: DoseStatus.taken, scheduledAt: DateTime(2026, 3, 10, 8)),
          _dose(status: DoseStatus.taken, scheduledAt: DateTime(2026, 3, 10, 11), id: 'dose-2'),
        ],
        now: _now,
      );

      expect(summary.percent, 100);
      expect(summary.taken, 2);
      expect(summary.missed, 0);
    });

    test('one missed of two due doses reports 50%', () {
      final AdherenceSummary summary = AdherenceCalculator.calculate(
        doses: <ScheduledDose>[
          _dose(status: DoseStatus.taken, scheduledAt: DateTime(2026, 3, 10, 8)),
          _dose(status: DoseStatus.missed, scheduledAt: DateTime(2026, 3, 9, 8), id: 'dose-2'),
        ],
        now: _now,
      );

      expect(summary.percent, 50);
    });

    test('doses still in the future never enter the denominator', () {
      final AdherenceSummary summary = AdherenceCalculator.calculate(
        doses: <ScheduledDose>[
          _dose(status: DoseStatus.taken, scheduledAt: DateTime(2026, 3, 10, 8)),
          _dose(
            status: DoseStatus.pending,
            scheduledAt: _now.add(const Duration(hours: 6)),
            id: 'dose-2',
          ),
        ],
        now: _now,
      );

      expect(summary.percent, 100);
      expect(summary.scheduled, 1);
    });

    test('a pending dose inside its grace window is not yet counted at all',
        () {
      final AdherenceSummary summary = AdherenceCalculator.calculate(
        doses: <ScheduledDose>[
          _dose(
            status: DoseStatus.pending,
            scheduledAt: _now.subtract(const Duration(minutes: 10)),
          ),
        ],
        now: _now,
      );

      expect(summary.percent, isNull);
      expect(summary.scheduled, 0);
    });

    test('cancelled doses are excluded entirely', () {
      final AdherenceSummary summary = AdherenceCalculator.calculate(
        doses: <ScheduledDose>[
          _dose(status: DoseStatus.taken, scheduledAt: DateTime(2026, 3, 10, 8)),
          _dose(status: DoseStatus.cancelled, scheduledAt: DateTime(2026, 3, 9, 8), id: 'dose-2'),
        ],
        now: _now,
      );

      expect(summary.scheduled, 1);
      expect(summary.percent, 100);
    });

    test('skipped doses are excluded from the denominator by default', () {
      final AdherenceSummary summary = AdherenceCalculator.calculate(
        doses: <ScheduledDose>[
          _dose(status: DoseStatus.taken, scheduledAt: DateTime(2026, 3, 10, 8)),
          _dose(status: DoseStatus.skipped, scheduledAt: DateTime(2026, 3, 9, 8), id: 'dose-2'),
        ],
        now: _now,
      );

      expect(summary.percent, 100);
      expect(summary.skipped, 1);
      expect(
        summary.explanation,
        contains('skipped doses are excluded'),
      );
    });

    test('skipped doses can be included on request', () {
      final AdherenceSummary summary = AdherenceCalculator.calculate(
        doses: <ScheduledDose>[
          _dose(status: DoseStatus.taken, scheduledAt: DateTime(2026, 3, 10, 8)),
          _dose(status: DoseStatus.skipped, scheduledAt: DateTime(2026, 3, 9, 8), id: 'dose-2'),
        ],
        now: _now,
        includeSkippedInDenominator: true,
      );

      expect(summary.percent, 50);
    });

    test('only missed doses reports 0%, never an error', () {
      final AdherenceSummary summary = AdherenceCalculator.calculate(
        doses: <ScheduledDose>[
          _dose(status: DoseStatus.missed, scheduledAt: DateTime(2026, 3, 9, 8)),
        ],
        now: _now,
      );

      expect(summary.percent, 0);
    });
  });
}
