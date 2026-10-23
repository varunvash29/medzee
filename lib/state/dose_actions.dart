import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/dose.dart';
import '../domain/models/medication.dart';
import '../services/dose_service.dart';
import 'providers.dart';

/// User-facing write API for dose actions.
///
/// Every method resolves the medication from the repository first, so the UI
/// never has to carry a [Medication] alongside a dose just to log it, and a
/// medication deleted mid-flight fails loudly instead of silently.
class DoseActions {
  DoseActions(this._doseService, this._medicationLookup);

  final DoseService _doseService;
  final Future<Medication?> Function(String medicationId) _medicationLookup;

  /// Last human-readable stock message produced by an action, shown in the
  /// snackbar after a dose is logged.
  String? lastMessage;

  Future<DoseLogResult?> _run(
    ScheduledDose dose,
    Future<DoseLogResult> Function(DoseService, ScheduledDose, Medication)
        action,
  ) async {
    final Medication? medication = await _medicationLookup(dose.medicationId);
    if (medication == null) return null;
    final DoseLogResult result = await action(_doseService, dose, medication);
    lastMessage = result.stockMessage;
    return result;
  }

  Future<DoseLogResult?> taken(ScheduledDose dose, {double? amount}) =>
      _run(
        dose,
        (DoseService service, ScheduledDose d, Medication m) =>
            service.markTaken(d, m, amount: amount),
      );

  Future<DoseLogResult?> skip(ScheduledDose dose) => _run(
        dose,
        (DoseService service, ScheduledDose d, Medication m) =>
            service.markSkipped(d, m),
      );

  Future<DoseLogResult?> missed(ScheduledDose dose) => _run(
        dose,
        (DoseService service, ScheduledDose d, Medication m) =>
            service.markMissed(d, m),
      );

  Future<DoseLogResult?> undo(ScheduledDose dose) =>
      _run(dose, (DoseService service, ScheduledDose d, Medication m) => service.undo(d, m));
}

final Provider<DoseActions> doseActionsProvider = Provider<DoseActions>(
  (Ref ref) => DoseActions(
    ref.watch(doseServiceProvider),
    (String id) => ref.read(medicationRepositoryProvider).getById(id),
  ),
);
