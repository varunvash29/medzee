import 'package:flutter/material.dart';
import '../../domain/services/medicine_name_inference.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/inventory.dart';
import '../../domain/models/medication.dart';
import '../../domain/services/medication_validator.dart';
import '../../routing/app_router.dart';
import '../../services/notification_service.dart';
import '../../state/medications_provider.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';
import '../shared/motion_widgets.dart';

/// Multi-step wizard for creating a medicine.
///
/// The wizard never persists a partial medicine: [MedicationService.save] is
/// called once, at the end, with validation enforced immediately before the
/// write. Steps 1-2 are informational and cheap to leave.
class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  static const int _stepCount = 4;

  int _step = 0;
  bool _busy = false;

  // ---- step 1: identity
  final TextEditingController _name = TextEditingController();
  final TextEditingController _generic = TextEditingController();
  final TextEditingController _strength = TextEditingController();
  DosageForm _form = DosageForm.tablet;
  AdministrationRoute _route = AdministrationRoute.oral;
  MedicineCategory _category = MedicineCategory.other;
  FoodInstruction _food = FoodInstruction.anyTime;
  bool _asNeeded = false;
  String _strengthUnit = 'mg';
  bool _strengthTouched = false;
  bool _formTouched = false;
  InferredMedicine? _inferred;

  // ---- step 2: schedule
  ScheduleKind _kind = ScheduleKind.daily;
  final List<int> _times = <int>[];
  final Set<int> _weekdays = <int>{};
  int _intervalHours = 8;
  int _intervalDays = 2;
  final List<int> _monthlyDays = <int>[];
  double _doseQuantity = 1;
  DoseUnit _unit = DoseUnit.tablet;
  int _durationDays = 7;
  bool _openEnded = false;

  // ---- step 3: stock
  bool _trackStock = true;
  final TextEditingController _initialStock = TextEditingController();
  final TextEditingController _refillThreshold = TextEditingController();

  // ---- step 4: review
  final TextEditingController _instructions = TextEditingController();

  String? _error;

  @override
  void initState() {
    super.initState();
    _times.add(8 * 60);
    _weekdays.addAll(<int>[1, 2, 3, 4, 5, 6, 7]);
    _monthlyDays.add(DateTime.now().day);
    _initialStock.text = '30';
    _refillThreshold.text = '5';
  }

  @override
  void dispose() {
    _name.dispose();
    _generic.dispose();
    _strength.dispose();
    _initialStock.dispose();
    _refillThreshold.dispose();
    _instructions.dispose();
    super.dispose();
  }

  /// Fills strength and form from what the user typed, unless they have
  /// already chosen those fields themselves.
  void _onNameChanged(String value) {
    final InferredMedicine parsed = MedicineNameInference.parse(value);
    setState(() {
      _inferred = parsed.hasInference ? parsed : null;
      if (!_strengthTouched && parsed.strength != null) {
        final double v = parsed.strength!;
        _strength.text = v == v.roundToDouble() ? v.toInt().toString() : '$v';
        _strengthUnit = parsed.strengthUnit ?? _strengthUnit;
      }
      if (!_formTouched && parsed.form != null) {
        _form = parsed.form!;
        _unit = MedicineNameInference.defaultUnit(_form);
      }
    });
  }

  String _strengthLabel() {
    final double v = _inferred!.strength!;
    final String n = v == v.roundToDouble() ? v.toInt().toString() : '$v';
    return '$n ${_inferred!.strengthUnit ?? _strengthUnit}';
  }

  bool get _canAdvance => switch (_step) {
    0 => _name.text.trim().isNotEmpty,
    1 => _kind == ScheduleKind.asNeeded || _times.isNotEmpty,
    2 => !_trackStock || _initialStock.text.isNotEmpty,
    _ => true,
  };

  void _setState(VoidCallback fn) {
    setState(fn);
    setState(() {}); // refresh _canAdvance after the mutation
  }

  Future<void> _save() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final DateTime now = DateTime.now().toUtc();
      final DateTime today = DateTime(now.year, now.month, now.day);

      final Medication medication = Medication(
        id: const Uuid().v4(),
        name:
            (_inferred != null && _inferred!.name.isNotEmpty)
                ? _inferred!.name
                : _name.text.trim(),
        genericName: _generic.text.trim().isEmpty ? null : _generic.text.trim(),
        category: _category,
        form: _form,
        strength: double.tryParse(_strength.text.trim()),
        strengthUnit: _strengthUnit,
        route: _route,
        foodInstruction: _food,
        instructions:
            _instructions.text.trim().isEmpty
                ? null
                : _instructions.text.trim(),
        status: MedicationStatus.active,
        startDate: today,
        isAsNeeded: _asNeeded || _kind == ScheduleKind.asNeeded,
        createdAt: now,
        updatedAt: now,
      );

      final SchedulePhase phase = SchedulePhase(
        id: const Uuid().v4(),
        medicationId: medication.id,
        order: 0,
        kind: _kind,
        startDate: today,
        endDate:
            _openEnded || _kind == ScheduleKind.asNeeded
                ? null
                : DateTime(
                  today.year,
                  today.month,
                  today.day + _durationDays - 1,
                ),
        // As-needed medicines never carry fixed reminder times — the
        // validator would (rightly) reject them, and the schedule step hides
        // the time editor for PRN so the user could not correct it.
        // (The parentheses matter: a cascade binds to the whole ternary.)
        timesMinutes:
            _kind == ScheduleKind.asNeeded
                ? const <int>[]
                : (List<int>.from(_times)..sort()),
        weekdays: Set<int>.from(_weekdays),
        intervalDays: _intervalDays,
        intervalHours: _intervalHours,
        monthlyDays: List<int>.from(_monthlyDays),
        doseQuantity: _doseQuantity,
        unit: _unit,
      );

      final ValidationResult validation = MedicationValidator.validate(
        medication: medication,
        phases: <SchedulePhase>[phase],
      );
      if (!validation.isValid) {
        setState(() => _error = validation.errors.values.first);
        return;
      }

      Inventory? inventory;
      if (_trackStock) {
        inventory = Inventory(
          id: const Uuid().v4(),
          medicationId: medication.id,
          quantityOnHand: double.tryParse(_initialStock.text.trim()) ?? 0,
          unit: _unit,
          refillThreshold: double.tryParse(_refillThreshold.text.trim()) ?? 0,
          initialQuantity: double.tryParse(_initialStock.text.trim()) ?? 0,
          updatedAt: now,
        );
      }

      await ref
          .read(medicationServiceProvider)
          .save(
            medication: medication,
            phases: <SchedulePhase>[phase],
            inventory: inventory,
          );

      // Surface any permission problem rather than silently never reminding.
      final NotificationService notifications = ref.read(
        notificationServiceProvider,
      );
      final NotificationPermissionStatus permission =
          await notifications.checkPermission();
      if (!mounted) return;

      if (!permission.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Saved, but notifications are blocked. Enable them in system '
              'settings to get reminders.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      ref.invalidate(medicationsProvider);
      if (mounted) context.go(AppRoutes.medicines);
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Could not save: $error');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            if (_step == 0) {
              context.pop();
            } else {
              setState(() => _step--);
            }
          },
        ),
        title: Text(switch (_step) {
          0 => 'About the medicine',
          1 => 'How and when',
          2 => 'Stock',
          _ => 'Review',
        }),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              0,
              AppSpacing.gutter,
              AppSpacing.sm,
            ),
            child: Row(
              children: <Widget>[
                for (int i = 0; i < _stepCount; i++)
                  Expanded(
                    child: AnimatedContainer(
                      duration: AppMotion.medium,
                      curve: AppMotion.standard,
                      height: 4,
                      margin: EdgeInsets.only(
                        right: i == _stepCount - 1 ? 0 : 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            i <= _step
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: AnimatedSwitcher(
                duration: AppMotion.medium,
                switchInCurve: AppMotion.enter,
                child: SingleChildScrollView(
                  key: ValueKey<int>(_step),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.lg,
                    AppSpacing.gutter,
                    AppSpacing.xl,
                  ),
                  child: switch (_step) {
                    0 => _buildIdentity(),
                    1 => _buildSchedule(),
                    2 => _buildStock(),
                    _ => _buildReview(theme),
                  },
                ),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.gutter,
                ),
                child: InfoBanner(
                  message: _error!,
                  tone: AppInfoTone.critical,
                  icon: Icons.error_outline_rounded,
                ),
              ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  if (_step > 0)
                    Expanded(
                      child: AppSecondaryButton(
                        label: 'Back',
                        onPressed: _busy ? null : () => setState(() => _step--),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: AppPrimaryButton(
                      label:
                          _step == _stepCount - 1
                              ? 'Save medicine'
                              : 'Continue',
                      busy: _busy,
                      onPressed:
                          !_canAdvance
                              ? null
                              : () {
                                if (_step == _stepCount - 1) {
                                  _save();
                                } else {
                                  setState(() {
                                    _error = null;
                                    _step++;
                                  });
                                }
                              },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------- step 1

  Widget _buildIdentity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: AppCard(
            onTap: () => context.push(AppRoutes.scanPrescription),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.document_scanner_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: Text(
                    'Have a prescription? Scan it instead of typing.',
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
        const _StepHeading(
          title: 'What are you taking?',
          subtitle:
              'Type the name exactly as it appears on the label. Medzee never '
              'guesses a medicine from partial text.',
        ),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          onChanged: _onNameChanged,
          decoration: const InputDecoration(
            labelText: 'Medicine name *',
            hintText: 'e.g. Metformin 500mg tablet',
          ),
        ),
        if (_inferred != null) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Filled in from the name: ${[if (_inferred!.strength != null) _strengthLabel(), if (_inferred!.form != null) _inferred!.form!.label].join(' · ')}. Change below if needed.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _strength,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => _strengthTouched = true,
                decoration: const InputDecoration(
                  labelText: 'Strength (optional)',
                  hintText: '500',
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 124,
              child: DropdownButtonFormField<String>(
                value: _strengthUnit,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Unit'),
                items: <DropdownMenuItem<String>>[
                  for (final String u in const <String>[
                    'mg',
                    'mcg',
                    'g',
                    'mL',
                    'IU',
                    '%',
                  ])
                    DropdownMenuItem<String>(value: u, child: Text(u)),
                ],
                onChanged:
                    (String? v) =>
                        setState(() => _strengthUnit = v ?? _strengthUnit),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Form', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: <Widget>[
            for (final DosageForm form in DosageForm.values)
              _FormChoice(
                form: form,
                selected: _form == form,
                onTap:
                    () => _setState(() {
                      _form = form;
                      _formTouched = true;
                      _unit = MedicineNameInference.defaultUnit(form);
                    }),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const SizedBox(height: AppSpacing.md),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: AppSpacing.md),
            title: Text(
              'More details',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            subtitle: const Text('Active ingredient, route, category, food'),
            children: <Widget>[
              TextField(
                controller: _generic,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Active ingredient (optional)',
                  hintText: 'e.g. metformin hydrochloride',
                  helperText:
                      'Shown when you look up information about this medicine.',
                ),
              ),
              DropdownButtonFormField<AdministrationRoute>(
                value: _route,
                decoration: const InputDecoration(labelText: 'Route'),
                items: <DropdownMenuItem<AdministrationRoute>>[
                  for (final AdministrationRoute route
                      in AdministrationRoute.values)
                    DropdownMenuItem<AdministrationRoute>(
                      value: route,
                      child: Text(route.label),
                    ),
                ],
                onChanged:
                    (AdministrationRoute? value) =>
                        _setState(() => _route = value ?? _route),
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<MedicineCategory>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: <DropdownMenuItem<MedicineCategory>>[
                  for (final MedicineCategory category
                      in MedicineCategory.values)
                    DropdownMenuItem<MedicineCategory>(
                      value: category,
                      child: Text(category.label),
                    ),
                ],
                onChanged:
                    (MedicineCategory? value) =>
                        _setState(() => _category = value ?? _category),
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<FoodInstruction>(
                value: _food,
                decoration: const InputDecoration(
                  labelText: 'Food instruction',
                ),
                items: <DropdownMenuItem<FoodInstruction>>[
                  for (final FoodInstruction food in FoodInstruction.values)
                    DropdownMenuItem<FoodInstruction>(
                      value: food,
                      child: Text(food.label),
                    ),
                ],
                onChanged:
                    (FoodInstruction? value) =>
                        _setState(() => _food = value ?? _food),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Take as needed (PRN)'),
          subtitle: const Text(
            'No fixed reminders. As-needed doses are excluded from adherence '
            'percentages.',
          ),
          value: _asNeeded,
          onChanged:
              (bool value) => _setState(() {
                _asNeeded = value;
                if (value) _kind = ScheduleKind.asNeeded;
              }),
        ),
      ],
    );
  }

  // ------------------------------------------------------------- step 2

  Widget _buildSchedule() {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _StepHeading(
          title: 'When should we remind you?',
          subtitle:
              'Times are local to this device and stay correct across '
              'daylight-saving changes.',
        ),
        if (!_asNeeded) ...<Widget>[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final ScheduleKind kind in ScheduleKind.values)
                ChoiceChip(
                  label: Text(kind.label),
                  selected: _kind == kind,
                  onSelected: (_) => _setState(() => _kind = kind),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        if (_kind == ScheduleKind.daily ||
            _kind == ScheduleKind.weekly ||
            _kind == ScheduleKind.custom ||
            _kind == ScheduleKind.everyNDays ||
            _kind == ScheduleKind.monthly)
          _TimeEditor(
            times: _times,
            onChanged:
                (List<int> times) => _setState(() {
                  _times
                    ..clear()
                    ..addAll(times);
                }),
          ),
        if (_kind == ScheduleKind.weekly || _kind == ScheduleKind.custom)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: _WeekdayPicker(
              selected: _weekdays,
              onChanged:
                  (Set<int> days) => _setState(() => _weekdays..addAll(days)),
            ),
          ),
        if (_kind == ScheduleKind.everyNHours) ...<Widget>[
          Text('Repeat every', style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: <Widget>[
              for (final int hours in <int>[4, 6, 8, 12, 24])
                ChoiceChip(
                  label: Text('$hours h'),
                  selected: _intervalHours == hours,
                  onSelected: (_) => _setState(() => _intervalHours = hours),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _TimeEditor(
            times: _times,
            onChanged:
                (List<int> times) => _setState(() {
                  _times
                    ..clear()
                    ..addAll(times);
                }),
          ),
        ],
        if (_kind == ScheduleKind.everyNDays) ...<Widget>[
          Text('Repeat every', style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: <Widget>[
              for (final int days in <int>[1, 2, 3, 7])
                ChoiceChip(
                  label: Text(days == 1 ? 'day' : '$days days'),
                  selected: _intervalDays == days,
                  onSelected: (_) => _setState(() => _intervalDays = days),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _TimeEditor(
            times: _times,
            onChanged:
                (List<int> times) => _setState(() {
                  _times
                    ..clear()
                    ..addAll(times);
                }),
          ),
        ],
        if (_kind == ScheduleKind.monthly) ...<Widget>[
          Text('On days of the month', style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              for (int day = 1; day <= 31; day++)
                ChoiceChip(
                  label: Text('$day'),
                  selected: _monthlyDays.contains(day),
                  onSelected:
                      (_) => _setState(() {
                        if (_monthlyDays.contains(day)) {
                          _monthlyDays.remove(day);
                        } else {
                          _monthlyDays.add(day);
                        }
                      }),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _TimeEditor(
            times: _times,
            onChanged:
                (List<int> times) => _setState(() {
                  _times
                    ..clear()
                    ..addAll(times);
                }),
          ),
        ],
        if (_kind == ScheduleKind.asNeeded)
          const InfoBanner(
            icon: Icons.info_outline_rounded,
            message:
                'As-needed medicines do not create reminders. You can still '
                'log a dose manually from the calendar.',
          )
        else ...<Widget>[
          const SizedBox(height: AppSpacing.xxl),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Dose size', style: theme.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: <Widget>[
                        IconButton.filledTonal(
                          icon: const Icon(Icons.remove_rounded),
                          onPressed:
                              _doseQuantity <= 0.5
                                  ? null
                                  : () => _setState(() => _doseQuantity -= 0.5),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: Text(
                            _doseQuantity == _doseQuantity.roundToDouble()
                                ? _doseQuantity.toInt().toString()
                                : _doseQuantity.toStringAsFixed(1),
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        IconButton.filledTonal(
                          icon: const Icon(Icons.add_rounded),
                          onPressed:
                              () => _setState(() => _doseQuantity += 0.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<DoseUnit>(
                  value: _unit,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  items: <DropdownMenuItem<DoseUnit>>[
                    for (final DoseUnit unit in DoseUnit.values)
                      DropdownMenuItem<DoseUnit>(
                        value: unit,
                        child: Text(unit.singular),
                      ),
                  ],
                  onChanged:
                      (DoseUnit? value) =>
                          _setState(() => _unit = value ?? _unit),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('No end date'),
            subtitle: const Text(
              'Turn off to set a fixed course length. Doses stop being '
              'scheduled after the end date.',
            ),
            value: _openEnded,
            onChanged: (bool value) => _setState(() => _openEnded = value),
          ),
          if (!_openEnded) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                Text('Course length', style: theme.textTheme.titleSmall),
                const Spacer(),
                IconButton.filledTonal(
                  icon: const Icon(Icons.remove_rounded),
                  onPressed:
                      _durationDays <= 1
                          ? null
                          : () => _setState(() => _durationDays--),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Text(
                    '$_durationDays d',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton.filledTonal(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: () => _setState(() => _durationDays++),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  // ------------------------------------------------------------- step 3

  Widget _buildStock() {
    final ThemeData theme = Theme.of(context);
    if (_kind == ScheduleKind.asNeeded) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _StepHeading(
            title: 'Track your supply?',
            subtitle:
                'As-needed stock can be recorded manually, but Medzee cannot '
                'estimate a run-out date without a fixed schedule.',
          ),
          InfoBanner(
            icon: Icons.inventory_2_outlined,
            message: 'You can add stock later from the medicine screen.',
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _StepHeading(
          title: 'Track stock?',
          subtitle:
              'Stock is deducted once per logged dose, with a full audit '
              'trail. You can turn this off and manage stock manually.',
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Track stock automatically'),
          value: _trackStock,
          onChanged: (bool value) => _setState(() => _trackStock = value),
        ),
        if (_trackStock) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _initialStock,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Starting quantity (${_unit.singular})',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _refillThreshold,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Low-stock alert at',
                    helperText: 'Warn me at or below this',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Medicine in ${_unit.label} is what gets deducted per dose. If your '
            'doses are measured differently, Medzee will ask you to adjust '
            'stock manually instead of guessing.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          InfoBanner(
            icon: Icons.warning_amber_rounded,
            tone: AppInfoTone.info,
            message:
                'Doses are never auto-marked as taken by stock changes — you '
                'confirm every dose yourself.',
          ),
        ],
      ],
    );
  }

  // ------------------------------------------------------------- step 4

  Widget _buildReview(ThemeData theme) {
    final List<int> times = _times.toList()..sort();
    final String scheduleText = switch (_kind) {
      ScheduleKind.asNeeded => 'As needed — no reminders',
      ScheduleKind.everyNHours => 'Every $_intervalHours hours',
      ScheduleKind.everyNDays => 'Every $_intervalDays days',
      ScheduleKind.monthly =>
        'Monthly on '
            '${_monthlyDays.join(', ')}',
      ScheduleKind.weekly =>
        'On ${_weekdays.map((int d) => _weekdayLabel(d)).join(', ')}',
      ScheduleKind.custom =>
        'Custom: ${_weekdays.map((int d) => _weekdayLabel(d)).join(', ')}',
      ScheduleKind.daily => 'Every day',
    };
    // PRN medicines save no reminder times, so the review must not show any.
    final String timeText =
        _kind == ScheduleKind.asNeeded || times.isEmpty
            ? ''
            : times
                .map(
                  (int m) =>
                      '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}',
                )
                .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _StepHeading(
          title: 'Check and confirm',
          subtitle: 'This is exactly what Medzee will save.',
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _ReviewRow('Name', _name.text.trim()),
              _ReviewRow(
                'Active ingredient',
                _generic.text.trim().isEmpty ? '—' : _generic.text.trim(),
              ),
              _ReviewRow(
                'Strength',
                _strength.text.trim().isEmpty
                    ? '—'
                    : '${_strength.text.trim()} (form: ${_form.label})',
              ),
              _ReviewRow('Route', _route.label),
              _ReviewRow('Food', _food.shortLabel),
              const Divider(height: AppSpacing.xxl),
              _ReviewRow('Schedule', scheduleText),
              if (timeText.isNotEmpty) _ReviewRow('Times', timeText),
              _ReviewRow(
                'Dose',
                '${_doseQuantity == _doseQuantity.roundToDouble() ? _doseQuantity.toInt() : _doseQuantity} ${_unit.label}',
              ),
              if (!_openEnded && _kind != ScheduleKind.asNeeded)
                _ReviewRow(
                  'Course',
                  '$_durationDays day${_durationDays == 1 ? '' : 's'}',
                ),
              const Divider(height: AppSpacing.xxl),
              _ReviewRow(
                'Stock',
                _trackStock
                    ? '${_initialStock.text} ${_unit.singular}, alert at ${_refillThreshold.text}'
                    : 'Not tracked',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _instructions,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Your own notes (optional)',
            hintText: 'e.g. Original prescription wording, exactly as written',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const InfoBanner(
          icon: Icons.health_and_safety_outlined,
          message:
              'Medzee does not provide medical advice. The schedule above is '
              'the one you entered — check it against your prescription before '
              'you rely on the reminders.',
        ),
      ],
    );
  }

  String _weekdayLabel(int isoWeekday) {
    const List<String> names = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    return names[isoWeekday - 1];
  }
}

class _FormChoice extends StatelessWidget {
  const _FormChoice({
    required this.form,
    required this.selected,
    required this.onTap,
  });

  final DosageForm form;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme c = theme.colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: form.label,
      child: Pressable(
        haptic: true,
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.standard,
          padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
          decoration: BoxDecoration(
            color: selected ? c.primaryContainer : c.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? c.primary : c.outlineVariant,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DoseFormIcon(
                form: form,
                size: 30,
                background:
                    selected
                        ? c.surface.withValues(alpha: 0.7)
                        : c.surfaceContainer,
              ),
              const SizedBox(width: 8),
              Text(
                form.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? c.onPrimaryContainer : c.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepHeading extends StatelessWidget {
  const _StepHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: theme.textTheme.headlineSmall)
              .animate()
              .fadeIn(duration: AppMotion.medium, curve: AppMotion.enter)
              .slideX(begin: 0.04, curve: AppMotion.enter),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 110,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          Expanded(child: Text(value, style: theme.textTheme.titleSmall)),
        ],
      ),
    );
  }
}

/// Adds and removes wall-clock times in 30-minute steps.
class _TimeEditor extends StatelessWidget {
  const _TimeEditor({required this.times, required this.onChanged});

  final List<int> times;
  final ValueChanged<List<int>> onChanged;

  Future<void> _pick(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
    );
    if (picked == null) return;
    final int minutes = picked.hour * 60 + picked.minute;
    if (times.contains(minutes)) return;
    onChanged(<int>[...times, minutes]);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<int> sorted = times.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Times', style: theme.textTheme.titleSmall),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _pick(context),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add time'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: <Widget>[
            for (final int minutes in sorted)
              Chip(
                avatar: const Icon(Icons.schedule_rounded, size: 16),
                label: Text(
                  '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
                  '${(minutes % 60).toString().padLeft(2, '0')}',
                ),
                onDeleted:
                    times.length <= 1
                        ? null
                        : () => onChanged(
                          times.where((int m) => m != minutes).toList(),
                        ),
              ),
          ],
        ),
      ],
    );
  }
}

class _WeekdayPicker extends StatelessWidget {
  const _WeekdayPicker({required this.selected, required this.onChanged});

  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  static const List<String> _labels = <String>[
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
    'S',
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Days', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: <Widget>[
            for (int day = 1; day <= 7; day++) ...<Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ChoiceChip(
                    label: Center(child: Text(_labels[day - 1])),
                    selected: selected.contains(day),
                    onSelected: (_) {
                      final Set<int> next = Set<int>.from(selected);
                      if (next.contains(day) && next.length > 1) {
                        next.remove(day);
                      } else {
                        next.add(day);
                      }
                      onChanged(next);
                    },
                  ),
                ),
              ),
              if (day < 7) const SizedBox(width: AppSpacing.xs),
            ],
          ],
        ),
      ],
    );
  }
}
