
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/medication.dart';
import '../../domain/models/prescription_draft.dart';
import '../../routing/app_router.dart';
import '../../services/ai/prescription_extractor.dart';
import '../../services/medication_service.dart';
import '../../state/medications_provider.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';

enum _Stage { pick, reading, review }

/// Scan or import a prescription, check what was read, and add the medicines.
///
/// The AI only proposes drafts. Nothing is saved until the user has resolved
/// every missing or uncertain detail and confirmed the import.
class ScanPrescriptionScreen extends ConsumerStatefulWidget {
  const ScanPrescriptionScreen({super.key});

  @override
  ConsumerState<ScanPrescriptionScreen> createState() =>
      _ScanPrescriptionScreenState();
}

class _ScanPrescriptionScreenState
    extends ConsumerState<ScanPrescriptionScreen> {
  _Stage _stage = _Stage.pick;
  int _run = 0; // bumped to cancel an in-flight read
  Uint8List? _preview;
  bool _isPdf = false;
  String? _error;
  ParsedPrescription? _result;
  final List<MedicineDraft> _drafts = <MedicineDraft>[];
  bool _importing = false;

  // ------------------------------------------------------------- picking

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final XFile? file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 2400,
        imageQuality: 88,
      );
      if (file == null) return;
      final Uint8List bytes = await file.readAsBytes();
      await _read(bytes, _mimeFor(file.name, file.mimeType), isPdf: false);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not open the camera or photo library. '
            'Check Medzee\'s permissions in system settings.');
      }
    }
  }

  Future<void> _pickPdf() async {
    final FilePickerResult? picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      withData: true,
    );
    final PlatformFile? file = picked?.files.single;
    final Uint8List? bytes = file?.bytes;
    if (file == null || bytes == null) return;
    final String mime = _mimeFor(file.name, null);
    await _read(bytes, mime, isPdf: mime == 'application/pdf');
  }

  String _mimeFor(String name, String? reported) {
    if (reported != null && reported.contains('/')) return reported;
    final String ext = name.split('.').last.toLowerCase();
    return switch (ext) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      _ => 'image/jpeg',
    };
  }

  // ------------------------------------------------------------- reading

  Future<void> _read(
    Uint8List bytes,
    String mime, {
    required bool isPdf,
  }) async {
    final int run = ++_run;
    setState(() {
      _stage = _Stage.reading;
      _preview = isPdf ? null : bytes;
      _isPdf = isPdf;
      _error = null;
    });
    try {
      final ParsedPrescription result =
          await ref.read(prescriptionExtractorProvider).extract(bytes, mime);
      if (!mounted || run != _run) return; // cancelled
      final List<Medication> existing =
          ref.read(medicationsProvider).value ?? const <Medication>[];
      setState(() {
        _result = result;
        _drafts
          ..clear()
          ..addAll(result.medicines);
        _stage = _Stage.review;
        _existing = existing;
      });
    } on ExtractionException catch (e) {
      if (!mounted || run != _run) return;
      setState(() {
        _stage = _Stage.pick;
        _error = e.message;
      });
    }
  }

  List<Medication> _existing = const <Medication>[];

  void _cancelReading() {
    _run++;
    setState(() => _stage = _Stage.pick);
  }

  // ------------------------------------------------------------- import

  Medication _toMedication(MedicineDraft d, DateTime now) {
    final DateTime today = DateTime(now.year, now.month, now.day);
    return Medication(
      id: const Uuid().v4(),
      name: d.name.trim(),
      genericName: d.genericName,
      brandName: d.brandName,
      form: d.form ?? DosageForm.tablet,
      strength: d.strength,
      strengthUnit: d.strengthUnit ?? 'mg',
      foodInstruction: d.food ?? FoodInstruction.anyTime,
      instructions: d.instructions,
      prescriber: _result?.prescriber,
      status: MedicationStatus.active,
      startDate: today,
      endDate: d.durationDays == null
          ? null
          : DateTime(today.year, today.month, today.day + d.durationDays! - 1),
      isAsNeeded: d.asNeeded,
      notes: 'Added from a scanned prescription and confirmed by you.',
      createdAt: now.toUtc(),
      updatedAt: now.toUtc(),
    );
  }

  Future<void> _import(List<MedicineDraft> drafts) async {
    if (_importing || drafts.isEmpty) return;
    setState(() => _importing = true);
    final MedicationService service = ref.read(medicationServiceProvider);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    int added = 0;
    String? failure;
    for (final MedicineDraft d in drafts) {
      try {
        final Medication med = _toMedication(d, now);
        final SchedulePhase phase = SchedulePhase(
          id: const Uuid().v4(),
          medicationId: med.id,
          order: 0,
          kind: d.asNeeded ? ScheduleKind.asNeeded : ScheduleKind.daily,
          startDate: today,
          endDate: med.endDate,
          timesMinutes: d.asNeeded ? const <int>[] : (List<int>.from(d.times)..sort()),
          weekdays: <int>{1, 2, 3, 4, 5, 6, 7},
          doseQuantity: d.doseQuantity ?? 1,
          unit: d.doseUnit ??
              (d.form == null
                  ? DoseUnit.tablet
                  : _unitFor(d.form!)),
        );
        await service.save(medication: med, phases: <SchedulePhase>[phase]);
        added++;
        _drafts.remove(d);
      } on ValidationException catch (e) {
        failure = '${d.name}: ${e.errors.values.first}';
      } catch (e) {
        failure = '${d.name}: could not be saved.';
      }
    }
    ref.invalidate(medicationsProvider);
    if (!mounted) return;
    setState(() => _importing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          failure == null
              ? 'Added $added ${added == 1 ? 'medicine' : 'medicines'}.'
              : 'Added $added. $failure',
        ),
      ),
    );
    if (_drafts.isEmpty) context.go(AppRoutes.medicines);
  }

  DoseUnit _unitFor(DosageForm f) => switch (f) {
        DosageForm.tablet => DoseUnit.tablet,
        DosageForm.capsule => DoseUnit.capsule,
        DosageForm.liquid => DoseUnit.millilitre,
        DosageForm.drops => DoseUnit.drop,
        DosageForm.inhaler => DoseUnit.puff,
        DosageForm.patch => DoseUnit.patch,
        DosageForm.cream => DoseUnit.application,
        _ => DoseUnit.unit,
      };

  // ------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Close',
          onPressed: () => context.pop(),
        ),
        title: const Text('Scan prescription'),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: switch (_stage) {
            _Stage.pick => _buildPick(context),
            _Stage.reading => _buildReading(context),
            _Stage.review => _buildReview(context),
          },
        ),
      ),
    );
  }

  Widget _buildPick(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool available = ref.watch(prescriptionExtractorProvider).isAvailable;
    return ListView(
      key: const ValueKey<String>('pick'),
      padding: const EdgeInsets.all(AppSpacing.gutter),
      children: <Widget>[
        Text('Add medicines from a prescription',
            style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Take a photo or choose a file. Medzee reads it, then you check '
          'every detail before anything is added.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xl),
        if (_error != null) ...<Widget>[
          InfoBanner(
            message: _error!,
            tone: AppInfoTone.critical,
            icon: Icons.error_outline_rounded,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (!available)
          const InfoBanner(
            message: 'Reading prescriptions needs Firebase, which is not '
                'available on this device.',
            tone: AppInfoTone.warning,
            icon: Icons.cloud_off_outlined,
          )
        else ...<Widget>[
          if (!kIsWeb)
            _SourceTile(
              icon: Icons.photo_camera_outlined,
              title: 'Take a photo',
              subtitle: 'Lay the page flat, in good light',
              onTap: () => _pickPhoto(ImageSource.camera),
            ),
          _SourceTile(
            icon: Icons.image_outlined,
            title: 'Choose an image',
            subtitle: 'From your photo library',
            onTap: () => _pickPhoto(ImageSource.gallery),
          ),
          _SourceTile(
            icon: Icons.picture_as_pdf_outlined,
            title: 'Upload a PDF or file',
            subtitle: 'PDF, JPG, PNG or WebP, up to 8 MB',
            onTap: _pickPdf,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          color: theme.colorScheme.surfaceContainerLow,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.lock_outline_rounded,
                  size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Your image is sent securely to Google\'s Gemini AI through '
                  'Firebase to be read. Medzee does not keep the image. The '
                  'AI can misread handwriting, so it only suggests: you '
                  'confirm everything, and your doctor\'s instructions come '
                  'first.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReading(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      key: const ValueKey<String>('reading'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 220,
                height: 280,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    if (_preview != null)
                      Image.memory(_preview!, fit: BoxFit.cover)
                    else
                      ColoredBox(
                        color: theme.colorScheme.surfaceContainerHigh,
                        child: Icon(
                          _isPdf
                              ? Icons.picture_as_pdf_outlined
                              : Icons.description_outlined,
                          size: 64,
                        ),
                      ),
                    const _ScanLine(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Reading prescription…', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'This can take a few seconds',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            TextButton(
              onPressed: _cancelReading,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReview(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ParsedPrescription result = _result!;
    final List<MedicineDraft> ready =
        _drafts.where((MedicineDraft d) => d.canImport).toList();

    return Column(
      key: const ValueKey<String>('review'),
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            children: <Widget>[
              if (_preview != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: _SourcePreview(bytes: _preview!),
                ),
              if (result.prescriber != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text('Prescribed by ${result.prescriber}',
                      style: theme.textTheme.bodyMedium),
                ),
              for (final String w in result.warnings)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: InfoBanner(
                    message: w,
                    tone: AppInfoTone.warning,
                    icon: Icons.visibility_outlined,
                  ),
                ),
              if (_drafts.isEmpty)
                EmptyState(
                  icon: Icons.document_scanner_outlined,
                  title: 'No medicines found',
                  message: 'This may not be a prescription, or it was too '
                      'hard to read. Try a clearer, well-lit photo.',
                  action: AppPrimaryButton(
                    label: 'Try again',
                    expanded: false,
                    onPressed: () => setState(() => _stage = _Stage.pick),
                  ),
                )
              else ...<Widget>[
                Text(
                  '${_drafts.length} ${_drafts.length == 1 ? 'medicine' : 'medicines'} found',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Highlighted details were unclear. Fix or confirm them, '
                  'then tick the box to add each medicine.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                for (final MedicineDraft d in List<MedicineDraft>.of(_drafts))
                  Padding(
                    key: ObjectKey(d),
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: _DraftCard(
                      draft: d,
                      duplicateOf: _duplicate(d),
                      onChanged: () => setState(() {}),
                      onRemove: () => setState(() => _drafts.remove(d)),
                      onImport: d.canImport && !_importing
                          ? () => _import(<MedicineDraft>[d])
                          : null,
                    ),
                  ),
              ],
            ],
          ),
        ),
        if (_drafts.length > 1)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: AppPrimaryButton(
              label: ready.isEmpty
                  ? 'Resolve the highlighted details'
                  : 'Add ${ready.length} ready ${ready.length == 1 ? 'medicine' : 'medicines'}',
              icon: Icons.check_rounded,
              busy: _importing,
              onPressed: ready.isEmpty ? null : () => _import(ready),
            ),
          ),
      ],
    );
  }

  Medication? _duplicate(MedicineDraft d) {
    final String n = d.name.trim().toLowerCase();
    if (n.isEmpty) return null;
    for (final Medication m in _existing) {
      if (m.status == MedicationStatus.archived) continue;
      if (m.name.trim().toLowerCase() == n) return m;
    }
    return null;
  }
}

// ----------------------------------------------------------------- widgets

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: theme.textTheme.titleSmall),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

/// A scanning line that sweeps over the document while it is being read.
class _ScanLine extends StatefulWidget {
  const _ScanLine();

  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? _) => Align(
        alignment: Alignment(0, -1 + 2 * Curves.easeInOut.transform(_c.value)),
        child: Container(
          height: 3,
          decoration: BoxDecoration(
            color: color,
            boxShadow: <BoxShadow>[
              BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourcePreview extends StatelessWidget {
  const _SourcePreview({required this.bytes});
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        leading: const Icon(Icons.image_outlined),
        title: const Text('Original document'),
        subtitle: const Text('Compare what was read with the source'),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InteractiveViewer(
                child: Image.memory(bytes, fit: BoxFit.contain),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One editable medicine from the prescription.
class _DraftCard extends StatefulWidget {
  const _DraftCard({
    required this.draft,
    required this.duplicateOf,
    required this.onChanged,
    required this.onRemove,
    required this.onImport,
  });

  final MedicineDraft draft;
  final Medication? duplicateOf;
  final VoidCallback onChanged;
  final VoidCallback onRemove;
  final VoidCallback? onImport;

  @override
  State<_DraftCard> createState() => _DraftCardState();
}

class _DraftCardState extends State<_DraftCard> {
  late final TextEditingController _name =
      TextEditingController(text: widget.draft.name);
  late final TextEditingController _strength = TextEditingController(
    text: _num(widget.draft.strength),
  );
  late final TextEditingController _dose = TextEditingController(
    text: _num(widget.draft.doseQuantity),
  );
  late final TextEditingController _days = TextEditingController(
    text: widget.draft.durationDays?.toString() ?? '',
  );

  MedicineDraft get d => widget.draft;

  static String _num(double? v) {
    if (v == null) return '';
    return v == v.roundToDouble() ? v.toInt().toString() : v.toString();
  }

  @override
  void dispose() {
    _name.dispose();
    _strength.dispose();
    _dose.dispose();
    _days.dispose();
    super.dispose();
  }

  void _edited(DraftField f) {
    d.flags.remove(f);
    widget.onChanged();
  }

  static const List<int> _spread1 = <int>[8 * 60];
  static const Map<int, List<int>> _spread = <int, List<int>>{
    1: _spread1,
    2: <int>[8 * 60, 20 * 60],
    3: <int>[8 * 60, 14 * 60, 21 * 60],
    4: <int>[8 * 60, 12 * 60, 16 * 60, 21 * 60],
  };

  Future<void> _addTime() async {
    final TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (t == null) return;
    final int m = t.hour * 60 + t.minute;
    if (!d.times.contains(m)) {
      d.times = (List<int>.of(d.times)..add(m))..sort();
    }
    _edited(DraftField.times);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final List<String> blocking = d.blockingProblems;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Medicine'),
                  onChanged: (String v) {
                    d.name = v;
                    _edited(DraftField.name);
                  },
                ),
              ),
              IconButton(
                tooltip: 'Remove this medicine',
                icon: const Icon(Icons.close_rounded),
                onPressed: widget.onRemove,
              ),
            ],
          ),
          _flag(DraftField.name, status),
          if (widget.duplicateOf != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: InfoBanner(
                message: 'You already have ${widget.duplicateOf!.name} in '
                    'Medzee. Importing adds a second entry.',
                tone: AppInfoTone.warning,
                icon: Icons.content_copy_outlined,
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _strength,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Strength'),
                  onChanged: (String v) {
                    d.strength = double.tryParse(v);
                    _edited(DraftField.strength);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(
                width: 110,
                child: DropdownButtonFormField<String>(
                  value: d.strengthUnit,
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
                  onChanged: (String? v) {
                    d.strengthUnit = v;
                    _edited(DraftField.strength);
                  },
                ),
              ),
            ],
          ),
          _flag(DraftField.strength, status),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<DosageForm>(
            value: d.form,
            decoration: const InputDecoration(labelText: 'Form'),
            items: <DropdownMenuItem<DosageForm>>[
              for (final DosageForm f in DosageForm.values)
                if (f != DosageForm.other)
                  DropdownMenuItem<DosageForm>(value: f, child: Text(f.label)),
            ],
            onChanged: (DosageForm? v) {
              d.form = v;
              if (v != null && d.doseUnit == null) {
                d.doseUnit = switch (v) {
                  DosageForm.tablet => DoseUnit.tablet,
                  DosageForm.capsule => DoseUnit.capsule,
                  DosageForm.liquid => DoseUnit.millilitre,
                  DosageForm.drops => DoseUnit.drop,
                  DosageForm.inhaler => DoseUnit.puff,
                  DosageForm.patch => DoseUnit.patch,
                  DosageForm.cream => DoseUnit.application,
                  _ => DoseUnit.unit,
                };
              }
              _edited(DraftField.form);
            },
          ),
          _flag(DraftField.form, status),
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Only when needed'),
            value: d.asNeeded,
            onChanged: (bool v) {
              d.asNeeded = v;
              widget.onChanged();
            },
          ),
          if (!d.asNeeded) ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _dose,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration:
                        const InputDecoration(labelText: 'Dose each time'),
                    onChanged: (String v) {
                      d.doseQuantity = double.tryParse(v);
                      _edited(DraftField.dose);
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DropdownButtonFormField<DoseUnit>(
                    value: d.doseUnit,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Unit'),
                    items: <DropdownMenuItem<DoseUnit>>[
                      for (final DoseUnit u in DoseUnit.values)
                        DropdownMenuItem<DoseUnit>(
                          value: u,
                          child: Text(u.label),
                        ),
                    ],
                    onChanged: (DoseUnit? v) {
                      d.doseUnit = v;
                      _edited(DraftField.dose);
                    },
                  ),
                ),
              ],
            ),
            _flag(DraftField.dose, status),
            const SizedBox(height: AppSpacing.md),
            Text(
              d.timesPerDay == null
                  ? 'Reminder times'
                  : 'Reminder times (prescription says ${d.timesPerDay}× a day)',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                for (final int m in d.times)
                  InputChip(
                    label: Text(
                      TimeOfDay(hour: m ~/ 60, minute: m % 60).format(context),
                    ),
                    onDeleted: () {
                      d.times = List<int>.of(d.times)..remove(m);
                      _edited(DraftField.times);
                    },
                  ),
                ActionChip(
                  avatar: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add time'),
                  onPressed: _addTime,
                ),
                if (d.times.isEmpty &&
                    d.timesPerDay != null &&
                    _spread.containsKey(d.timesPerDay))
                  ActionChip(
                    avatar: const Icon(Icons.auto_awesome_rounded, size: 18),
                    label: const Text('Spread through the day'),
                    onPressed: () {
                      d.times = List<int>.of(_spread[d.timesPerDay]!);
                      _edited(DraftField.times);
                    },
                  ),
              ],
            ),
            _flag(DraftField.times, status),
          ],
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _days,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Days to take (blank = ongoing)',
            ),
            onChanged: (String v) {
              d.durationDays = int.tryParse(v);
              _edited(DraftField.duration);
            },
          ),
          _flag(DraftField.duration, status),
          if (d.instructions != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'From the prescription: “${d.instructions}”',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
          if (d.sourceText != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                'Read from: “${d.sourceText}”',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          if (d.flags.isNotEmpty)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: d.reviewed,
              onChanged: (bool? v) {
                d.reviewed = v ?? false;
                widget.onChanged();
              },
              title: const Text(
                'I\'ve checked the highlighted details against the document',
              ),
            ),
          if (blocking.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                blocking.first,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: status.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          AppPrimaryButton(
            label: 'Add this medicine',
            icon: Icons.check_rounded,
            onPressed: widget.onImport,
          ),
        ],
      ),
    );
  }

  Widget _flag(DraftField field, AppStatusColors status) {
    final String? note = d.flags[field];
    if (note == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.error_outline_rounded, size: 16, color: status.warning),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              note,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: status.warning,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
