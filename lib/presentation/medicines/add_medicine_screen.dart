import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/inventory.dart';
import '../../domain/models/medication.dart';
import '../../domain/models/medicine_profile.dart';
import '../../domain/services/medication_validator.dart';
import '../../domain/services/medicine_name_inference.dart';
import '../../routing/app_router.dart';
import '../../services/medication_service.dart';
import '../../services/notification_service.dart';
import '../../state/medications_provider.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';
import '../shared/motion_widgets.dart';
import 'medicine_info_tabs.dart';

enum _Freq { once, twice, thrice, asNeeded }

/// Add a medicine on one screen.
///
/// The person types a name; Medzee works out the strength, form, route and
/// food advice itself. They only choose when to take it and for how long.
class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _stock = TextEditingController();
  Timer? _debounce;
  int _lookupId = 0;
  bool _looking = false;

  /// What the AI (or the typed name) says about the medicine.
  MedicineProfile? _profile;

  // Manual overrides, set only if the person edits the detected details.
  DosageForm? _formOverride;
  double? _strengthOverride;
  String? _unitOverride;
  AdministrationRoute? _routeOverride;
  FoodInstruction? _foodOverride;

  _Freq? _freq = _Freq.once;
  List<int> _times = <int>[8 * 60];
  double _dose = 1;
  int? _durationDays; // null = ongoing
  bool _trackStock = false;

  bool _busy = false;
  String? _error;

  static const Map<_Freq, List<int>> _defaultTimes = <_Freq, List<int>>{
    _Freq.once: <int>[8 * 60],
    _Freq.twice: <int>[8 * 60, 20 * 60],
    _Freq.thrice: <int>[8 * 60, 14 * 60, 20 * 60],
    _Freq.asNeeded: <int>[],
  };

  @override
  void dispose() {
    _debounce?.cancel();
    _name.dispose();
    _stock.dispose();
    super.dispose();
  }

  // ----------------------------------------------------- inferred details

  MedicineProfile get _effective =>
      _profile ??
      ref.read(medicineKnowledgeProvider).offlineGuess(_name.text);

  DosageForm get _form => _formOverride ?? _effective.form ?? DosageForm.tablet;

  double? get _strength => _strengthOverride ?? _effective.strength;

  String get _unit => _unitOverride ?? _effective.strengthUnit ?? 'mg';

  AdministrationRoute get _route =>
      _routeOverride ?? _effective.route ?? AdministrationRoute.oral;

  FoodInstruction get _food =>
      _foodOverride ?? _effective.food ?? FoodInstruction.anyTime;

  DoseUnit get _doseUnit => MedicineNameInference.defaultUnit(_form);

  void _onNameChanged(String value) {
    _debounce?.cancel();
    final String q = value.trim();
    setState(() {
      _error = null;
      _profile = null;
      _looking = q.length >= 3;
    });
    if (q.length < 3) return;
    final int id = ++_lookupId;
    _debounce = Timer(const Duration(milliseconds: 1100), () async {
      final MedicineProfile p =
          await ref.read(medicineKnowledgeProvider).lookup(q);
      if (!mounted || id != _lookupId) return;
      setState(() {
        _profile = p.recognized
            ? p
            : ref.read(medicineKnowledgeProvider).offlineGuess(q);
        _looking = false;
        // Keep the dose sensible for the detected form.
        if (!_form.isCountable && _dose == 1) _dose = _defaultDose(_form);
      });
    });
  }

  static double _defaultDose(DosageForm f) => switch (f) {
        DosageForm.liquid => 5,
        DosageForm.drops => 2,
        DosageForm.inhaler => 2,
        _ => 1,
      };

  // ------------------------------------------------------------ schedule

  void _pickFreq(_Freq f) {
    setState(() {
      _freq = f;
      _times = List<int>.of(_defaultTimes[f]!);
    });
  }

  Future<void> _editTime(int index) async {
    final int current = _times[index];
    final TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (t == null) return;
    setState(() {
      _times[index] = t.hour * 60 + t.minute;
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
      _freq = null; // now a custom pattern
    });
  }

  Future<void> _customDuration() async {
    final TextEditingController c = TextEditingController();
    final int? days = await showDialog<int>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Number of days'),
        content: TextField(
          controller: c,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'e.g. 10'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, int.tryParse(c.text.trim())),
            child: const Text('Set'),
          ),
        ],
      ),
    );
    c.dispose();
    if (days != null && days >= 1 && days <= 3650) {
      setState(() => _durationDays = days);
    }
  }

  // ---------------------------------------------------------------- save

  bool get _asNeeded => _freq == _Freq.asNeeded;

  bool get _canSave =>
      _name.text.trim().isNotEmpty && (_asNeeded || _times.isNotEmpty);

  String get _summary {
    final String name = _effective.recognized && _effective.name.isNotEmpty
        ? _effective.name
        : MedicineNameInference.parse(_name.text).name;
    final String strength = (_strength == null ||
            name.contains(_fmt(_strength!)))
        ? ''
        : ' ${_fmt(_strength!)} $_unit';
    final String when = _asNeeded
        ? 'as needed'
        : '${_times.length == 1 ? 'once' : _times.length == 2 ? 'twice' : '${_times.length} times'} a day at '
            '${_times.map((int m) => TimeOfDay(hour: m ~/ 60, minute: m % 60).format(context)).join(', ')}';
    final String length =
        _durationDays == null ? 'ongoing' : 'for $_durationDays days';
    return '$name$strength · $when · $length';
  }

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  Future<void> _save() async {
    if (_busy || !_canSave) return;
    final double? stock = double.tryParse(_stock.text.trim());
    if (_trackStock && (stock == null || stock <= 0)) {
      setState(() => _error = 'Enter how many you have, or turn stock off.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final DateTime now = DateTime.now().toUtc();
      final DateTime today = DateTime(now.year, now.month, now.day);
      final InferredMedicine typed = MedicineNameInference.parse(_name.text);
      final MedicineProfile p = _effective;

      final Medication medication = Medication(
        id: const Uuid().v4(),
        name: p.recognized && p.name.isNotEmpty
            ? p.name
            : (typed.name.isEmpty ? _name.text.trim() : typed.name),
        genericName: p.genericName,
        category: p.category ?? MedicineCategory.other,
        form: _form,
        strength: _strength,
        strengthUnit: _unit,
        route: _route,
        foodInstruction: _food,
        status: MedicationStatus.active,
        startDate: today,
        endDate: _durationDays == null
            ? null
            : DateTime(today.year, today.month, today.day + _durationDays! - 1),
        isAsNeeded: _asNeeded,
        createdAt: now,
        updatedAt: now,
      );

      final SchedulePhase phase = SchedulePhase(
        id: const Uuid().v4(),
        medicationId: medication.id,
        order: 0,
        kind: _asNeeded ? ScheduleKind.asNeeded : ScheduleKind.daily,
        startDate: today,
        endDate: medication.endDate,
        timesMinutes: _asNeeded ? const <int>[] : (List<int>.of(_times)..sort()),
        weekdays: <int>{1, 2, 3, 4, 5, 6, 7},
        doseQuantity: _dose,
        unit: _doseUnit,
      );

      final ValidationResult v = MedicationValidator.validate(
        medication: medication,
        phases: <SchedulePhase>[phase],
      );
      if (!v.isValid) {
        setState(() => _error = v.errors.values.first);
        return;
      }

      final Inventory? inventory = _trackStock
          ? Inventory(
              id: const Uuid().v4(),
              medicationId: medication.id,
              quantityOnHand: stock!,
              unit: _doseUnit,
              refillThreshold: 5,
              initialQuantity: stock,
              updatedAt: now,
            )
          : null;

      // Re-use what was looked up so the Info tab needs no second request.
      if (p.recognized) {
        await ref
            .read(medicineKnowledgeProvider)
            .remember(medicineLookupName(medication), p);
      }

      await ref.read(medicationServiceProvider).save(
            medication: medication,
            phases: <SchedulePhase>[phase],
            inventory: inventory,
          );

      final NotificationPermissionStatus permission =
          await ref.read(notificationServiceProvider).checkPermission();
      if (!mounted) return;
      if (!permission.granted && permission.supported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Saved, but notifications are blocked. Enable them in system '
              'settings to get reminders.',
            ),
          ),
        );
      }
      ref.invalidate(medicationsProvider);
      context.go('${AppRoutes.medicines}/${medication.id}');
    } on ValidationException catch (e) {
      if (mounted) setState(() => _error = e.errors.values.first);
    } catch (e) {
      if (mounted) setState(() => _error = 'Could not save: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ---------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Close',
          onPressed: () => context.pop(),
        ),
        title: const Text('Add medicine'),
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
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              onChanged: _onNameChanged,
              decoration: const InputDecoration(
                labelText: 'Medicine name',
                hintText: 'e.g. Dolo 650, Metformin 500',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => context.push(AppRoutes.scanPrescription),
                icon: const Icon(Icons.document_scanner_outlined, size: 18),
                label: const Text('Scan a prescription instead'),
              ),
            ),
            _detected(theme),
            const SizedBox(height: AppSpacing.xl),
            _label('How often?'),
            SegmentedButton<_Freq>(
              showSelectedIcon: false,
              emptySelectionAllowed: true,
              segments: const <ButtonSegment<_Freq>>[
                ButtonSegment<_Freq>(value: _Freq.once, label: Text('Once')),
                ButtonSegment<_Freq>(value: _Freq.twice, label: Text('Twice')),
                ButtonSegment<_Freq>(value: _Freq.thrice, label: Text('3 times')),
              ],
              selected: (_freq == null || _freq == _Freq.asNeeded)
                  ? <_Freq>{}
                  : <_Freq>{_freq!},
              onSelectionChanged: (Set<_Freq> s) {
                if (s.isNotEmpty) _pickFreq(s.first);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('Only when needed'),
                selected: _asNeeded,
                onSelected: (bool on) => on
                    ? _pickFreq(_Freq.asNeeded)
                    : _pickFreq(_Freq.once),
              ),
            ),
            if (!_asNeeded) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
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
                          ? () => setState(() {
                                _times.removeAt(i);
                                _freq = null;
                              })
                          : null,
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add time'),
                    onPressed: _addTime,
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            _label('Dose each time'),
            _doseRow(theme),
            const SizedBox(height: AppSpacing.xl),
            _label('For how long?'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                ChoiceChip(
                  label: const Text('Ongoing'),
                  selected: _durationDays == null,
                  onSelected: (_) => setState(() => _durationDays = null),
                ),
                for (final int d in const <int>[3, 5, 7, 14, 30])
                  ChoiceChip(
                    label: Text('$d days'),
                    selected: _durationDays == d,
                    onSelected: (_) => setState(() => _durationDays = d),
                  ),
                ActionChip(
                  label: Text(
                    _durationDays != null &&
                            !const <int>[3, 5, 7, 14, 30].contains(_durationDays)
                        ? '$_durationDays days'
                        : 'Custom',
                  ),
                  onPressed: _customDuration,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    title: const Text('Track my stock'),
                    subtitle: const Text(
                      'Get a heads-up before you run out',
                    ),
                    value: _trackStock,
                    onChanged: (bool v) => setState(() => _trackStock = v),
                  ),
                  if (_trackStock)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        AppSpacing.lg,
                      ),
                      child: TextField(
                        controller: _stock,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'How many do you have?',
                          suffixText: _doseUnit.label,
                        ),
                      ),
                    ),
                ],
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
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.md,
            AppSpacing.gutter,
            AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (_canSave)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    _summary,
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              AppPrimaryButton(
                label: 'Add medicine',
                icon: Icons.check_rounded,
                busy: _busy,
                onPressed: _canSave ? _save : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      );

  // ------------------------------------------------ detected-details card

  Widget _detected(ThemeData theme) {
    final AppStatusColors status = context.statusColors;
    final String typed = _name.text.trim();
    if (typed.length < 2) return const SizedBox.shrink();

    if (_looking) {
      return AppCard(
        color: theme.colorScheme.primaryContainer,
        borderColor: Colors.transparent,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Looking up $typed…',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    }

    final MedicineProfile p = _effective;
    final bool known = p.recognized;
    final List<String> facts = <String>[
      _form.label,
      if (_strength != null) '${_fmt(_strength!)} $_unit',
      if (_route != AdministrationRoute.oral) _route.label,
    ];
    final String? foodLine = switch (_food) {
      FoodInstruction.beforeFood => 'Usually taken before food',
      FoodInstruction.afterFood => 'Usually taken after food',
      FoodInstruction.withFood => 'Usually taken with food',
      FoodInstruction.emptyStomach => 'Usually taken on an empty stomach',
      _ => null,
    };

    return AppCard(
      color: known ? theme.colorScheme.primaryContainer : null,
      borderColor: known ? Colors.transparent : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              DoseFormIcon(
                form: _form,
                size: 44,
                background: theme.colorScheme.surface,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      known && p.name.isNotEmpty ? p.name : typed,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      known
                          ? (p.ingredients.isNotEmpty
                              ? p.ingredients
                                  .map((Ingredient i) => i.label)
                                  .join(' + ')
                              : (p.genericName ?? facts.join(' · ')))
                          : 'Not recognised. Check the spelling, or set the '
                              'details yourself.',
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _editDetails,
                child: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: <Widget>[
              for (final String f in facts) _Tag(f),
              if (known && p.prescriptionStatus != null)
                _Tag(p.prescriptionStatus!),
            ],
          ),
          if (foodLine != null && known) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(foodLine, style: theme.textTheme.bodySmall),
          ],
          if (known) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.info_outline_rounded,
                    size: 14, color: status.info),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Filled in automatically. Your doctor\'s instructions '
                    'come first.',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _editDetails() async {
    final _Details? r = await showModalBottomSheet<_Details>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _DetailsSheet(
        form: _form,
        strength: _strength,
        unit: _unit,
        route: _route,
        food: _food,
      ),
    );
    if (r == null) return;
    setState(() {
      _formOverride = r.form;
      _strengthOverride = r.strength;
      _unitOverride = r.unit;
      _routeOverride = r.route;
      _foodOverride = r.food;
      if (!r.form.isCountable && _dose == 1) _dose = _defaultDose(r.form);
    });
  }

  // --------------------------------------------------------------- dose

  Widget _doseRow(ThemeData theme) {
    final bool countable = _form.isCountable;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              _doseLabel(),
              style: theme.textTheme.titleMedium,
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Less',
            onPressed: _dose > (countable ? 0.5 : 1)
                ? () => setState(
                      () => _dose -= countable ? 0.5 : _step,
                    )
                : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton.filledTonal(
            tooltip: 'More',
            onPressed: _dose < 100
                ? () => setState(() => _dose += countable ? 0.5 : _step)
                : null,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }

  String _doseLabel() {
    final String n = _fmt(_dose);
    return switch (_doseUnit) {
      DoseUnit.tablet => '$n ${_dose == 1 ? 'tablet' : 'tablets'}',
      DoseUnit.capsule => '$n ${_dose == 1 ? 'capsule' : 'capsules'}',
      DoseUnit.patch => '$n ${_dose == 1 ? 'patch' : 'patches'}',
      DoseUnit.drop => '$n ${_dose == 1 ? 'drop' : 'drops'}',
      DoseUnit.puff => '$n ${_dose == 1 ? 'puff' : 'puffs'}',
      _ => '$n ${_doseUnit.label}',
    };
  }

  double get _step => _form == DosageForm.liquid ? 2.5 : 1;
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ----------------------------------------------------------- edit sheet

class _Details {
  const _Details(this.form, this.strength, this.unit, this.route, this.food);
  final DosageForm form;
  final double? strength;
  final String unit;
  final AdministrationRoute route;
  final FoodInstruction food;
}

class _DetailsSheet extends StatefulWidget {
  const _DetailsSheet({
    required this.form,
    required this.strength,
    required this.unit,
    required this.route,
    required this.food,
  });

  final DosageForm form;
  final double? strength;
  final String unit;
  final AdministrationRoute route;
  final FoodInstruction food;

  @override
  State<_DetailsSheet> createState() => _DetailsSheetState();
}

class _DetailsSheetState extends State<_DetailsSheet> {
  late DosageForm _form = widget.form;
  late String _unit = widget.unit;
  late AdministrationRoute _route = widget.route;
  late FoodInstruction _food = widget.food;
  late final TextEditingController _strength = TextEditingController(
    text: widget.strength == null
        ? ''
        : (widget.strength == widget.strength!.roundToDouble()
            ? widget.strength!.toInt().toString()
            : widget.strength.toString()),
  );

  @override
  void dispose() {
    _strength.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Medicine details', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
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
                    initialValue: _unit,
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
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              label: 'Done',
              onPressed: () => Navigator.pop(
                context,
                _Details(
                  _form,
                  double.tryParse(_strength.text.trim()),
                  _unit,
                  _route,
                  _food,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
