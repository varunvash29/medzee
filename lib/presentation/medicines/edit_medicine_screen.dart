import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/medication.dart';
import '../../domain/services/medicine_name_inference.dart';
import '../../services/medication_service.dart';
import '../../state/medications_provider.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';

/// Change anything about a medicine after it was added: name, details,
/// reminder times, dose, how long, or whether it is only taken when needed.
///
/// Saves through [MedicationService], so reminders and upcoming doses are
/// rebuilt and dose history is kept.
class EditMedicineScreen extends ConsumerStatefulWidget {
  const EditMedicineScreen({super.key, required this.medicationId});

  final String medicationId;

  @override
  ConsumerState<EditMedicineScreen> createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends ConsumerState<EditMedicineScreen> {
  Medication? _med;
  List<SchedulePhase> _phases = const <SchedulePhase>[];
  bool _loaded = false;
  bool _missing = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _strength = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  late DosageForm _form;
  late String _unit;
  late AdministrationRoute _route;
  late FoodInstruction _food;
  late bool _asNeeded;
  late ScheduleKind _kind;
  late List<int> _times;
  late double _dose;
  DateTime? _endDate; // null = ongoing

  bool _busy = false;
  String? _error;

  /// Tapering / multi-phase schedules are edited elsewhere; here we only
  /// change the details of those.
  bool get _singlePhase => _phases.length <= 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _strength.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final repo = ref.read(medicationRepositoryProvider);
    final Medication? m = await repo.getById(widget.medicationId);
    if (!mounted) return;
    if (m == null) {
      setState(() {
        _missing = true;
        _loaded = true;
      });
      return;
    }
    final List<SchedulePhase> phases = await repo.getPhases(m.id);
    if (!mounted) return;
    final SchedulePhase? p = phases.isEmpty ? null : phases.first;
    setState(() {
      _med = m;
      _phases = phases;
      _name.text = m.name;
      _strength.text = m.strength == null ? '' : _fmt(m.strength!);
      _notes.text = m.instructions ?? '';
      _form = m.form;
      _unit = m.strengthUnit;
      _route = m.route;
      _food = m.foodInstruction;
      _asNeeded = m.isAsNeeded || (p?.kind == ScheduleKind.asNeeded);
      _kind = p?.kind ?? ScheduleKind.daily;
      _times = List<int>.of(p?.timesMinutes ?? const <int>[]);
      _dose = p?.doseQuantity ?? 1;
      _endDate = p?.endDate ?? m.endDate;
      _loaded = true;
    });
  }

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  bool get _timesEditable =>
      !_asNeeded && _kind != ScheduleKind.everyNHours;

  DoseUnit get _doseUnit =>
      _phases.isNotEmpty && _phases.first.unit != DoseUnit.unit
          ? _phases.first.unit
          : MedicineNameInference.defaultUnit(_form);

  // ------------------------------------------------------------- actions

  Future<void> _editTime(int i) async {
    final TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _times[i] ~/ 60, minute: _times[i] % 60),
    );
    if (t == null) return;
    setState(() {
      _times[i] = t.hour * 60 + t.minute;
      _times = _times.toSet().toList()..sort();
    });
  }

  Future<void> _addTime() async {
    final TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (t == null) return;
    setState(() {
      _times = (<int>{..._times, t.hour * 60 + t.minute}).toList()..sort();
    });
  }

  Future<void> _pickEnd() async {
    final DateTime now = DateTime.now();
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: _endDate ?? now.add(const Duration(days: 7)),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (d != null) setState(() => _endDate = DateTime(d.year, d.month, d.day));
  }

  Future<void> _save() async {
    final Medication? m = _med;
    if (m == null || _busy) return;
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Enter the medicine name.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final DateTime now = DateTime.now().toUtc();
      final bool schedulable = _singlePhase;

      final DateTime? end = schedulable ? _endDate : m.endDate;
      final Medication updated = m.copyWith(
        name: _name.text.trim(),
        form: _form,
        strength: double.tryParse(_strength.text.trim()),
        clearStrength: _strength.text.trim().isEmpty,
        strengthUnit: _unit,
        route: _route,
        foodInstruction: _food,
        instructions: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        clearInstructions: _notes.text.trim().isEmpty,
        isAsNeeded: _asNeeded,
        endDate: end,
        clearEndDate: end == null,
        updatedAt: now,
      );

      List<SchedulePhase> phases = _phases;
      if (schedulable) {
        final SchedulePhase base = _phases.isNotEmpty
            ? _phases.first
            : SchedulePhase(
                id: '${m.id}-p0',
                medicationId: m.id,
                order: 0,
                kind: ScheduleKind.daily,
                startDate: DateTime.now(),
                weekdays: <int>{1, 2, 3, 4, 5, 6, 7},
              );
        final ScheduleKind kind = _asNeeded
            ? ScheduleKind.asNeeded
            : (base.kind == ScheduleKind.asNeeded
                ? ScheduleKind.daily
                : base.kind);
        phases = <SchedulePhase>[
          base.copyWith(
            kind: kind,
            timesMinutes: _asNeeded
                ? const <int>[]
                : (kind == ScheduleKind.everyNHours
                    ? base.timesMinutes
                    : (List<int>.of(_times)..sort())),
            doseQuantity: _dose,
            unit: _doseUnit,
            endDate: end,
            clearEndDate: end == null,
          ),
        ];
      }

      await ref
          .read(medicationServiceProvider)
          .save(medication: updated, phases: phases);
      ref.invalidate(medicationsProvider);
      if (mounted) context.pop();
    } on ValidationException catch (e) {
      if (mounted) setState(() => _error = e.errors.values.first);
    } catch (e) {
      if (mounted) setState(() => _error = 'Could not save: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // --------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (!_loaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit medicine')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_missing) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit medicine')),
        body: const EmptyState(
          icon: Icons.search_off_rounded,
          title: 'Medicine not found',
          message: 'It may have been deleted.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Close',
          onPressed: () => context.pop(),
        ),
        title: const Text('Edit medicine'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.sm,
            AppSpacing.gutter,
            AppSpacing.xl,
          ),
          children: <Widget>[
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Medicine name'),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Schedule', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            if (!_singlePhase)
              const InfoBanner(
                message: 'This medicine has a changing (tapering) schedule. '
                    'Its times and dose can\'t be edited here, but you can '
                    'change everything else.',
                icon: Icons.info_outline_rounded,
              )
            else ...<Widget>[
              AppCard(
                padding: EdgeInsets.zero,
                child: SwitchListTile(
                  title: const Text('Only when needed'),
                  subtitle: const Text('No fixed reminders'),
                  value: _asNeeded,
                  onChanged: (bool v) => setState(() => _asNeeded = v),
                ),
              ),
              if (_timesEditable) ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                Text('Reminder times', style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: <Widget>[
                    for (int i = 0; i < _times.length; i++)
                      InputChip(
                        avatar: const Icon(Icons.schedule_rounded, size: 18),
                        label: Text(
                          TimeOfDay(
                            hour: _times[i] ~/ 60,
                            minute: _times[i] % 60,
                          ).format(context),
                        ),
                        onPressed: () => _editTime(i),
                        onDeleted: _times.length > 1
                            ? () => setState(() => _times.removeAt(i))
                            : null,
                      ),
                    ActionChip(
                      avatar: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add time'),
                      onPressed: _addTime,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('Tap a time to change it.', style: theme.textTheme.bodySmall),
              ],
              if (!_asNeeded) ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                Text('Dose each time', style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                _doseRow(theme),
                const SizedBox(height: AppSpacing.lg),
                Text('Ends', style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: <Widget>[
                    ChoiceChip(
                      label: const Text('Ongoing'),
                      selected: _endDate == null,
                      onSelected: (_) => setState(() => _endDate = null),
                    ),
                    ChoiceChip(
                      label: Text(
                        _endDate == null
                            ? 'On a date…'
                            : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                      ),
                      selected: _endDate != null,
                      onSelected: (_) => _pickEnd(),
                    ),
                  ],
                ),
              ],
            ],
            const SizedBox(height: AppSpacing.xl),
            Text('Details', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                for (final DosageForm f in DosageForm.values)
                  if (f != DosageForm.other)
                    ChoiceChip(
                      label: Text(f.label),
                      selected: _form == f,
                      onSelected: (_) => setState(() => _form = f),
                    ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _strength,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Strength'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  width: 110,
                  child: DropdownButtonFormField<String>(
                    initialValue: const <String>['mg', 'mcg', 'g', 'mL', 'IU', '%']
                            .contains(_unit)
                        ? _unit
                        : 'mg',
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Unit'),
                    items: <DropdownMenuItem<String>>[
                      for (final String u in const <String>[
                        'mg', 'mcg', 'g', 'mL', 'IU', '%',
                      ])
                        DropdownMenuItem<String>(value: u, child: Text(u)),
                    ],
                    onChanged: (String? v) => setState(() => _unit = v ?? _unit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<FoodInstruction>(
              initialValue: _food,
              decoration: const InputDecoration(labelText: 'Food'),
              items: <DropdownMenuItem<FoodInstruction>>[
                for (final FoodInstruction f in FoodInstruction.values)
                  if (f != FoodInstruction.custom)
                    DropdownMenuItem<FoodInstruction>(
                      value: f,
                      child: Text(f.label),
                    ),
              ],
              onChanged: (FoodInstruction? v) =>
                  setState(() => _food = v ?? _food),
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<AdministrationRoute>(
              initialValue: _route,
              decoration: const InputDecoration(labelText: 'How it is taken'),
              items: <DropdownMenuItem<AdministrationRoute>>[
                for (final AdministrationRoute r in AdministrationRoute.values)
                  DropdownMenuItem<AdministrationRoute>(
                    value: r,
                    child: Text(r.label),
                  ),
              ],
              onChanged: (AdministrationRoute? v) =>
                  setState(() => _route = v ?? _route),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _notes,
              maxLines: 3,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'e.g. as advised by your doctor',
              ),
            ),
            if (_error != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              InfoBanner(
                message: _error!,
                tone: AppInfoTone.critical,
                icon: Icons.error_outline_rounded,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          child: AppPrimaryButton(
            label: 'Save changes',
            icon: Icons.check_rounded,
            busy: _busy,
            onPressed: _save,
          ),
        ),
      ),
    );
  }

  Widget _doseRow(ThemeData theme) {
    final bool countable = _form.isCountable;
    final double step = countable ? 0.5 : (_form == DosageForm.liquid ? 2.5 : 1);
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              '${_fmt(_dose)} ${_doseUnit.label}',
              style: theme.textTheme.titleMedium,
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Less',
            onPressed: _dose > step ? () => setState(() => _dose -= step) : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton.filledTonal(
            tooltip: 'More',
            onPressed: _dose < 100 ? () => setState(() => _dose += step) : null,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
