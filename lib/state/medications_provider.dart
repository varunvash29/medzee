import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/core_enums.dart';
import '../domain/models/medication.dart';
import 'providers.dart';

/// Every medication, live.
final StreamProvider<List<Medication>> medicationsProvider =
    StreamProvider<List<Medication>>(
  (Ref ref) => ref.watch(medicationRepositoryProvider).watchAll(),
);

/// Medications limited to a lifecycle status, live.
final StreamProviderFamily<List<Medication>, MedicationStatus>
    medicationsByStatusProvider =
    StreamProvider.family<List<Medication>, MedicationStatus>(
  (Ref ref, MedicationStatus status) =>
      ref.watch(medicationRepositoryProvider).watchByStatus(status),
);

/// One medication by id, live. Emits `null` when it no longer exists.
final StreamProviderFamily<Medication?, String> medicationProvider =
    StreamProvider.family<Medication?, String>(
  (Ref ref, String id) => ref.watch(medicationRepositoryProvider).watchById(id),
);

/// Schedule phases of one medication, live.
final StreamProviderFamily<List<SchedulePhase>, String> phasesProvider =
    StreamProvider.family<List<SchedulePhase>, String>(
  (Ref ref, String id) =>
      ref.watch(medicationRepositoryProvider).watchPhases(id),
);

/// The user's current library filter, shared between the library screen and
/// any screen that deep-links into it.
class LibraryFilter {
  const LibraryFilter({
    this.status = MedicationStatus.active,
    this.query = '',
    this.sort = MedicineSort.nextDose,
  });

  final MedicationStatus status;
  final String query;
  final MedicineSort sort;

  LibraryFilter copyWith({
    MedicationStatus? status,
    String? query,
    MedicineSort? sort,
  }) =>
      LibraryFilter(
        status: status ?? this.status,
        query: query ?? this.query,
        sort: sort ?? this.sort,
      );
}

final NotifierProvider<LibraryFilterNotifier, LibraryFilter>
    libraryFilterProvider =
    NotifierProvider<LibraryFilterNotifier, LibraryFilter>(
  LibraryFilterNotifier.new,
);

class LibraryFilterNotifier extends Notifier<LibraryFilter> {
  @override
  LibraryFilter build() => const LibraryFilter();

  void setStatus(MedicationStatus status) =>
      state = state.copyWith(status: status);

  void setQuery(String query) => state = state.copyWith(query: query);

  void setSort(MedicineSort sort) => state = state.copyWith(sort: sort);
}
