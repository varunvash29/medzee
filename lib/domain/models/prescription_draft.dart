import 'core_enums.dart';

/// Fields of a [MedicineDraft] that can be flagged for the user to check.
enum DraftField { name, strength, form, dose, frequency, times, duration }

/// One medicine read from a prescription, not yet part of the user's data.
///
/// Everything here is an *extraction*: the app never treats it as verified.
/// Values the model could not read stay null and are flagged so the user must
/// resolve them before the medicine can be imported.
class MedicineDraft {
  MedicineDraft({
    required this.name,
    this.brandName,
    this.genericName,
    this.strength,
    this.strengthUnit,
    this.form,
    this.doseQuantity,
    this.doseUnit,
    this.timesPerDay,
    List<int>? times,
    this.asNeeded = false,
    this.durationDays,
    this.food,
    this.instructions,
    this.sourceText,
    this.confidence,
    Map<DraftField, String>? flags,
  })  : times = times ?? <int>[],
        flags = flags ?? <DraftField, String>{};

  String name;
  String? brandName;
  String? genericName;
  double? strength;
  String? strengthUnit;
  DosageForm? form;
  double? doseQuantity;
  DoseUnit? doseUnit;

  /// How often per day the prescription says to take it (as written).
  int? timesPerDay;

  /// Reminder times in minutes after midnight. Only filled from times the
  /// prescription states explicitly, or chosen by the user.
  List<int> times;
  bool asNeeded;
  int? durationDays;
  FoodInstruction? food;

  /// The prescriber's wording, kept verbatim.
  String? instructions;

  /// The line(s) of the document this was read from.
  String? sourceText;
  double? confidence;

  /// Why a field needs the user's attention. Editing a field clears its flag.
  final Map<DraftField, String> flags;

  /// The user confirmed they checked the highlighted details against the
  /// original document.
  bool reviewed = false;

  bool isFlagged(DraftField field) => flags.containsKey(field);

  /// Problems that block importing. Uncertainty alone does not block; the
  /// user can accept a flagged value, but a missing one must be filled in.
  List<String> get blockingProblems {
    final List<String> problems = <String>[];
    if (name.trim().isEmpty) problems.add('Enter the medicine name.');
    if (!asNeeded) {
      if (doseQuantity == null || doseQuantity! <= 0) {
        problems.add('Enter the dose per intake.');
      }
      if (times.isEmpty) problems.add('Choose at least one reminder time.');
    }
    return problems;
  }

  /// Flags that are still open need an explicit "I checked this".
  bool get needsReview => flags.isNotEmpty && !reviewed;

  bool get canImport => blockingProblems.isEmpty && !needsReview;
}

/// Everything read from one prescription document.
class ParsedPrescription {
  const ParsedPrescription({
    required this.medicines,
    this.prescriber,
    this.prescriptionDate,
    this.notes,
    this.warnings = const <String>[],
  });

  final List<MedicineDraft> medicines;
  final String? prescriber;
  final String? prescriptionDate;
  final String? notes;

  /// Document-level problems (unreadable parts, dropped entries).
  final List<String> warnings;
}
