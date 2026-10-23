import '../models/core_enums.dart';
import '../models/dose.dart';

/// The result of an adherence calculation.
class AdherenceSummary {
  const AdherenceSummary({
    required this.taken,
    required this.missed,
    required this.skipped,
    required this.scheduled,
    required this.percent,
    required this.explanation,
  });

  final int taken;
  final int missed;
  final int skipped;

  /// Doses that were eligible to be taken in the window.
  final int scheduled;

  /// 0-100, or null when nothing was scheduled in the window.
  final double? percent;

  /// Plain-language description of how [percent] was calculated. The UI
  /// always shows this next to the number.
  final String explanation;

  bool get hasData => scheduled > 0;

  static const AdherenceSummary empty = AdherenceSummary(
    taken: 0,
    missed: 0,
    skipped: 0,
    scheduled: 0,
    percent: null,
    explanation: 'No scheduled doses in this period.',
  );
}

/// Calculates adherence from logged doses.
///
/// The denominator only counts doses that were *scheduled and due*. PRN
/// ("as needed") doses are never part of the denominator because there is no
/// scheduled dose to miss. Deliberately skipped doses are excluded from the
/// default denominator — the user made a deliberate decision, which is
/// different from forgetting — and the explanation string says so.
abstract final class AdherenceCalculator {
  /// Computes adherence over [doses].
  ///
  /// [doses] must already be filtered to the window and must exclude PRN
  /// doses. [isPrnDose] lets the caller filter PRN doses that are stored
  /// alongside scheduled ones.
  static AdherenceSummary calculate({
    required Iterable<ScheduledDose> doses,
    required DateTime now,
    bool includeSkippedInDenominator = false,
  }) {
    int taken = 0;
    int missed = 0;
    int skipped = 0;
    int scheduled = 0;

    for (final ScheduledDose dose in doses) {
      if (dose.status == DoseStatus.cancelled) continue;
      // Only doses whose time has come can be "missed" or "taken".
      if (dose.scheduledAt.isAfter(now)) continue;
      scheduled++;
      switch (dose.status) {
        case DoseStatus.taken:
          taken++;
        case DoseStatus.missed:
          missed++;
        case DoseStatus.skipped:
          skipped++;
        case DoseStatus.pending:
          // Due but still inside the grace window: not yet counted as missed.
          scheduled--;
        case DoseStatus.cancelled:
          break;
      }
    }

    final int denominator = includeSkippedInDenominator
        ? taken + missed + skipped
        : taken + missed;

    final double? percent = denominator == 0
        ? null
        : ((taken / denominator) * 100).clamp(0.0, 100.0);

    final String explanation = includeSkippedInDenominator
        ? 'Taken ÷ (taken + missed + skipped) in this period.'
        : 'Taken ÷ (taken + missed). Deliberately skipped doses are excluded.';

    return AdherenceSummary(
      taken: taken,
      missed: missed,
      skipped: skipped,
      scheduled: scheduled,
      percent: percent,
      explanation: explanation,
    );
  }
}
