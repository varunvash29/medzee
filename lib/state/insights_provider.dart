import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/core_enums.dart';
import '../domain/models/dose.dart';
import '../domain/models/medication.dart';
import '../domain/repositories/dose_repository.dart';
import '../domain/services/adherence_calculator.dart';
import 'doses_provider.dart';
import 'medications_provider.dart';
import 'providers.dart';

/// Window used by the insights screen.
enum InsightsWindow {
  sevenDays(7, 'Last 7 days'),
  thirtyDays(30, 'Last 30 days'),
  ninetyDays(90, 'Last 90 days');

  const InsightsWindow(this.days, this.label);

  final int days;
  final String label;
}

/// Adherence over a rolling window, computed from materialised dose rows.
///
/// PRN ("as needed") medications are excluded from the denominator by
/// construction: they never materialise scheduled doses.
class AdherenceInsights {
  const AdherenceInsights({
    required this.window,
    required this.summary,
    required this.dailyPercent,
    required this.streakDays,
    required this.totalLogged,
  });

  final InsightsWindow window;
  final AdherenceSummary summary;

  /// One entry per day in the window (oldest first). `null` = no doses due.
  final List<double?> dailyPercent;

  /// Consecutive days ending today where every due dose was taken.
  final int streakDays;

  /// Total resolved doses in the window (taken + missed + skipped).
  final int totalLogged;

  static AdherenceInsights empty(InsightsWindow window) => AdherenceInsights(
        window: window,
        summary: AdherenceSummary.empty,
        dailyPercent: List<double?>.filled(window.days, null),
        streakDays: 0,
        totalLogged: 0,
      );
}

final NotifierProvider<InsightsWindowNotifier, InsightsWindow>
    insightsWindowProvider =
    NotifierProvider<InsightsWindowNotifier, InsightsWindow>(
  InsightsWindowNotifier.new,
);

class InsightsWindowNotifier extends Notifier<InsightsWindow> {
  @override
  InsightsWindow build() => InsightsWindow.sevenDays;

  void select(InsightsWindow window) => state = window;
}

final FutureProvider<AdherenceInsights> adherenceInsightsProvider =
    FutureProvider<AdherenceInsights>((Ref ref) async {
  final InsightsWindow window = ref.watch(insightsWindowProvider);
  final DateTime today = ref.watch(todayProvider);
  final DateTime now = DateTime.now();

  final DateTime from = DateTime(
    today.year,
    today.month,
    today.day - (window.days - 1),
  );

  final List<ScheduledDose> doses =
      await ref.watch(doseRepositoryProvider).getDosesInRange(from, today);

  // PRN medications never produce scheduled doses, but guard anyway so a
  // manual row can never leak into the denominator.
  final List<Medication> medications =
      await ref.watch(medicationsProvider.future);
  final Set<String> prnIds = <String>{
    for (final Medication medication in medications)
      if (medication.isAsNeeded) medication.id,
  };

  final List<ScheduledDose> eligible = doses
      .where((ScheduledDose dose) => !prnIds.contains(dose.medicationId))
      .toList(growable: false);

  final AdherenceSummary summary = AdherenceCalculator.calculate(
    doses: eligible,
    now: now,
  );

  // Per-day rollup, oldest first.
  final Map<String, List<ScheduledDose>> byDay = <String, List<ScheduledDose>>{};
  for (final ScheduledDose dose in eligible) {
    final DateTime day = DateTime(
      dose.localDate.year,
      dose.localDate.month,
      dose.localDate.day,
    );
    (byDay[day.toIso8601String()] ??= <ScheduledDose>[]).add(dose);
  }

  final List<double?> daily = <double?>[];
  for (int i = 0; i < window.days; i++) {
    final DateTime day = DateTime(from.year, from.month, from.day + i);
    final List<ScheduledDose>? dayDoses = byDay[day.toIso8601String()];
    if (dayDoses == null) {
      daily.add(null);
      continue;
    }
    final AdherenceSummary daySummary = AdherenceCalculator.calculate(
      doses: dayDoses,
      now: now,
    );
    daily.add(daySummary.percent);
  }

  // Streak: consecutive days ending today where every due dose was taken.
  int streak = 0;
  for (int i = daily.length - 1; i >= 0; i--) {
    final double? percent = daily[i];
    if (percent == null) {
      // A day with nothing due does not break the streak.
      continue;
    }
    if (percent >= 100) {
      streak++;
    } else {
      break;
    }
  }

  final int logged = summary.taken + summary.missed + summary.skipped;

  return AdherenceInsights(
    window: window,
    summary: summary,
    dailyPercent: daily,
    streakDays: streak,
    totalLogged: logged,
  );
});

/// Dose history for the log screen, newest first.
final FutureProvider<List<DoseLog>> doseHistoryProvider =
    FutureProvider<List<DoseLog>>((Ref ref) async {
  final DateTime today = ref.watch(todayProvider);
  final DateTime from = DateTime(today.year, today.month, today.day - 90);
  return ref.watch(doseRepositoryProvider).getLogsInRange(from, today);
});

/// Status counts for a single medication, used by its detail screen.
class MedicationAdherence {
  const MedicationAdherence({
    required this.taken,
    required this.missed,
    required this.skipped,
    required this.pending,
  });

  final int taken;
  final int missed;
  final int skipped;
  final int pending;

  int get resolved => taken + missed + skipped;

  double? get percent =>
      taken + missed == 0 ? null : (taken / (taken + missed)) * 100;
}

final FutureProviderFamily<MedicationAdherence, String>
    medicationAdherenceProvider =
    FutureProvider.family<MedicationAdherence, String>(
  (Ref ref, String medicationId) async {
    final DoseRepository repository = ref.watch(doseRepositoryProvider);
    final int taken =
        await repository.countByStatus(medicationId, DoseStatus.taken);
    final int missed =
        await repository.countByStatus(medicationId, DoseStatus.missed);
    final int skipped =
        await repository.countByStatus(medicationId, DoseStatus.skipped);
    final int pending =
        await repository.countByStatus(medicationId, DoseStatus.pending);
    return MedicationAdherence(
      taken: taken,
      missed: missed,
      skipped: skipped,
      pending: pending,
    );
  },
);
