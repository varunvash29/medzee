import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/core_enums.dart';
import '../domain/models/dose.dart';
import '../domain/models/medication.dart';
import '../domain/services/dose_status_resolver.dart';
import 'medications_provider.dart';
import 'providers.dart';

/// The calendar date the app currently treats as "today".
///
/// Kept as an explicit provider so every screen agrees on the day boundary
/// and so tests can pin it.
final Provider<DateTime> todayProvider = Provider<DateTime>((Ref ref) {
  final DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Doses scheduled for [todayProvider]'s date, with grace-window statuses
/// resolved on the way out.
///
/// The repository returns whatever was persisted; this provider upgrades a
/// pending dose whose grace window has elapsed to `missed` so the UI never
/// shows a stale "due" state.
final StreamProvider<List<ScheduledDose>> todayDosesProvider =
    StreamProvider<List<ScheduledDose>>((Ref ref) async* {
  final DateTime today = ref.watch(todayProvider);
  final DateTime now = DateTime.now();

  await for (final List<ScheduledDose> doses
      in ref.watch(doseRepositoryProvider).watchDosesForDate(today)) {
    yield doses
        .map(
          (ScheduledDose dose) => dose.copyWith(
            status: DoseStatusResolver.resolve(
              scheduledAt: dose.scheduledAt,
              now: now,
              current: dose.status,
            ),
          ),
        )
        .toList(growable: false);
  }
});

/// Today's doses joined with their medication, ordered by time of day.
///
/// This is the shape the home dashboard renders.
class TodayEntry {
  const TodayEntry({
    required this.dose,
    required this.medication,
    required this.isNext,
  });

  final ScheduledDose dose;
  final Medication medication;

  /// True for the single upcoming dose the dashboard highlights.
  final bool isNext;

  /// True when this entry is the next dose that is still pending.
  bool get isNow => isNext && dose.status == DoseStatus.pending;
}

final StreamProvider<List<TodayEntry>> todayTimelineProvider =
    StreamProvider<List<TodayEntry>>((Ref ref) async* {
  final List<ScheduledDose> doses = await ref.watch(todayDosesProvider.future);
  final List<Medication> medications =
      await ref.watch(medicationsProvider.future);
  final Map<String, Medication> byId = <String, Medication>{
    for (final Medication medication in medications) medication.id: medication,
  };

  final List<ScheduledDose> ordered = doses.toList()
    ..sort((ScheduledDose a, ScheduledDose b) {
      final int byTime = a.scheduledMinutes.compareTo(b.scheduledMinutes);
      if (byTime != 0) return byTime;
      return a.medicationId.compareTo(b.medicationId);
    });

  final DateTime now = DateTime.now();
  bool nextFound = false;
  final List<TodayEntry> entries = <TodayEntry>[];
  for (final ScheduledDose dose in ordered) {
    final Medication? medication = byId[dose.medicationId];
    if (medication == null) continue;
    final bool isNext = !nextFound &&
        dose.status == DoseStatus.pending &&
        !dose.scheduledAt.isAfter(now.add(const Duration(minutes: 30)));
    if (isNext) nextFound = true;
    entries.add(
      TodayEntry(dose: dose, medication: medication, isNext: isNext),
    );
  }
  yield entries;
});

/// Doses for an arbitrary calendar date, with statuses resolved the same way
/// as [todayDosesProvider]. Used by the calendar screen.
final StreamProviderFamily<List<ScheduledDose>, DateTime>
    dosesForDateProvider =
    StreamProvider.family<List<ScheduledDose>, DateTime>(
  (Ref ref, DateTime date) {
    final DateTime now = DateTime.now();
    return ref
        .watch(doseRepositoryProvider)
        .watchDosesForDate(date)
        .map(
          (List<ScheduledDose> doses) => doses
              .map(
                (ScheduledDose dose) => dose.copyWith(
                  status: DoseStatusResolver.resolve(
                    scheduledAt: dose.scheduledAt,
                    now: now,
                    current: dose.status,
                  ),
                ),
              )
              .toList(growable: false),
        );
  },
);

/// The selected date on the calendar screen.
final NotifierProvider<SelectedDateNotifier, DateTime> selectedDateProvider =
    NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void select(DateTime date) => state = DateTime(date.year, date.month, date.day);

  void goToPrevious() =>
      state = DateTime(state.year, state.month, state.day - 1);

  void goToNext() => state = DateTime(state.year, state.month, state.day + 1);

  void goToToday() {
    final DateTime now = DateTime.now();
    state = DateTime(now.year, now.month, now.day);
  }
}
