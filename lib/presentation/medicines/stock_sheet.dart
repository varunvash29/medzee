import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_spacing.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/inventory.dart';
import '../../domain/models/medication.dart';
import '../../domain/services/medicine_name_inference.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';

/// What the stock sheet is for.
enum StockMode {
  /// Start tracking a medicine that has no stock yet.
  start,

  /// More arrived (an order, a pharmacy pick-up): adds to what is there.
  refill,

  /// The person counted what is left: replaces the number.
  count,

  /// Change when the low-stock warning appears.
  alert,
}

/// Opens the sheet for adding, correcting or starting stock.
Future<void> showStockSheet(
  BuildContext context,
  WidgetRef ref, {
  required Medication medication,
  required Inventory? inventory,
  required StockMode mode,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext ctx) => _StockSheet(
      medication: medication,
      inventory: inventory,
      mode: mode,
    ),
  );
}

class _StockSheet extends ConsumerStatefulWidget {
  const _StockSheet({
    required this.medication,
    required this.inventory,
    required this.mode,
  });

  final Medication medication;
  final Inventory? inventory;
  final StockMode mode;

  @override
  ConsumerState<_StockSheet> createState() => _StockSheetState();
}

class _StockSheetState extends ConsumerState<_StockSheet> {
  late final TextEditingController _qty = TextEditingController(
    text: widget.mode == StockMode.count && widget.inventory != null
        ? _fmt(widget.inventory!.quantityOnHand)
        : '',
  );
  late final TextEditingController _alert = TextEditingController(
    text: _fmt(widget.inventory?.refillThreshold ?? 5),
  );
  bool _busy = false;
  String? _error;

  Inventory? get _inv => widget.inventory;

  DoseUnit get _unit =>
      _inv?.unit ?? MedicineNameInference.defaultUnit(widget.medication.form);

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  void dispose() {
    _qty.dispose();
    _alert.dispose();
    super.dispose();
  }

  String get _title => switch (widget.mode) {
        StockMode.start => 'Track stock',
        StockMode.refill => 'Add stock',
        StockMode.count => 'Set what you have',
        StockMode.alert => 'Low-stock alert',
      };

  String get _hint => switch (widget.mode) {
        StockMode.start => 'How many do you have now?',
        StockMode.refill => 'How many did you get?',
        StockMode.count => 'How many are left?',
        StockMode.alert => '',
      };

  /// The total after this change, shown live for a refill.
  String? get _preview {
    final double? n = double.tryParse(_qty.text.trim());
    if (widget.mode != StockMode.refill || n == null || n <= 0 || _inv == null) {
      return null;
    }
    return 'New total: ${_fmt(_inv!.quantityOnHand + n)} ${_unit.label}';
  }

  Future<void> _save() async {
    if (_busy) return;
    final double? q = double.tryParse(_qty.text.trim());
    final double? alert = double.tryParse(_alert.text.trim());

    if (widget.mode != StockMode.alert && (q == null || q < 0)) {
      setState(() => _error = 'Enter a number.');
      return;
    }
    if (widget.mode == StockMode.refill && q! <= 0) {
      setState(() => _error = 'Enter how many you added.');
      return;
    }
    if ((widget.mode == StockMode.start || widget.mode == StockMode.alert) &&
        (alert == null || alert < 0)) {
      setState(() => _error = 'Enter the number to be warned at.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repo = ref.read(inventoryRepositoryProvider);
      final service = ref.read(medicationServiceProvider);
      final Medication med = widget.medication;
      final Inventory? inv = _inv;
      final DateTime now = DateTime.now().toUtc();

      switch (widget.mode) {
        case StockMode.start:
          await repo.saveInventory(Inventory(
            id: const Uuid().v4(),
            medicationId: med.id,
            quantityOnHand: q!,
            unit: _unit,
            refillThreshold: alert!,
            initialQuantity: q,
            updatedAt: now,
          ));
        case StockMode.refill:
          await repo.saveInventory(
            await service.refill(medication: med, inventory: inv!, quantity: q!),
          );
        case StockMode.count:
          await repo.saveInventory(
            await service.adjustStock(
              medication: med,
              inventory: inv!,
              newQuantity: q!,
              note: 'Counted by you',
            ),
          );
        case StockMode.alert:
          await repo.saveInventory(
            inv!.copyWith(refillThreshold: alert, updatedAt: now),
          );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = 'Could not save: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool needsQty = widget.mode != StockMode.alert;
    final bool needsAlert =
        widget.mode == StockMode.start || widget.mode == StockMode.alert;

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(_title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 2),
            Text(widget.medication.name, style: theme.textTheme.bodyMedium),
            if (_inv != null && widget.mode != StockMode.alert) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Now: ${_fmt(_inv!.quantityOnHand)} ${_unit.label}',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (needsQty)
              TextField(
                controller: _qty,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() => _error = null),
                decoration: InputDecoration(
                  labelText: _hint,
                  suffixText: _unit.label,
                ),
              ),
            if (_preview != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text(_preview!, style: theme.textTheme.titleSmall),
            ],
            if (needsAlert) ...<Widget>[
              if (needsQty) const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _alert,
                autofocus: widget.mode == StockMode.alert,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Warn me when this many are left',
                  suffixText: _unit.label,
                ),
              ),
            ],
            if (_error != null) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              Text(
                _error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              label: widget.mode == StockMode.refill ? 'Add to stock' : 'Save',
              busy: _busy,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
