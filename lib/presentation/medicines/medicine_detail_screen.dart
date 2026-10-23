import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/inventory.dart';
import '../../domain/models/medication.dart';
import '../../domain/services/inventory_calculator.dart';
import '../../domain/services/schedule_generator.dart';
import '../../state/doses_provider.dart';
import '../../state/insights_provider.dart';
import '../../state/inventory_providers.dart';
import '../../state/medications_provider.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';

/// Single-medicine screen: identity, schedule, stock, history and lifecycle
/// actions. Every destructive action is confirmed in plain language.
class MedicineDetailScreen extends ConsumerWidget {
  const MedicineDetailScreen({super.key, required this.medicationId});

  final String medicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Medication?> medication =
        ref.watch(medicationProvider(medicationId));

    return Scaffold(
      appBar: AppBar(
        title: Text(medication.value?.name ?? 'Medicine'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: medication.value == null
                ? null
                : () => _showEditSheet(context, ref, medication.value!),
          ),
        ],
      ),
      body: medication.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: InfoBanner(
              message: 'Could not load this medicine: $error',
              tone: AppInfoTone.critical,
              icon: Icons.error_outline_rounded,
            ),
          ),
        ),
        data: (Medication? med) {
          if (med == null) {
            return const EmptyState(
              icon: Icons.medication_outlined,
              title: 'Medicine not found',
              message: 'It may have been deleted. Go back to your library '
                  'to see what is still there.',
            );
          }
          return _Detail(medication: med);
        },
      ),
    );
  }

  Future<void> _showEditSheet(
    BuildContext context,
    WidgetRef ref,
    Medication medication,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => _QuickEditSheet(medication: medication),
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final AsyncValue<List<SchedulePhase>> phases =
        ref.watch(phasesProvider(medication.id));
    final AsyncValue<Inventory?> inventory =
        ref.watch(inventoryProvider(medication.id));
    final AsyncValue<MedicationAdherence> adherence =
        ref.watch(medicationAdherenceProvider(medication.id));
    final DateTime today = ref.watch(todayProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.sm,
        AppSpacing.gutter,
        AppSpacing.huge,
      ),
      children: <Widget>[
        // ---------------------------------------------------------- identity
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                    child: Icon(
                      Icons.medication_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(medication.name, style: theme.textTheme.titleLarge),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          [
                            if (medication.strengthLabel != null)
                              medication.strengthLabel!,
                            medication.form.label,
                            medication.route.label,
                            medication.category.label,
                          ].join(' · '),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: <Widget>[
                  StatusChip(
                    label: medication.status.label,
                    color: medication.status == MedicationStatus.active
                        ? status.taken
                        : theme.colorScheme.onSurfaceVariant,
                    containerColor: medication.status == MedicationStatus.active
                        ? status.takenContainer
                        : theme.colorScheme.surfaceContainerHighest,
                  ),
                  if (medication.isAsNeeded)
                    StatusChip(
                      label: 'As needed',
                      color: status.info,
                      containerColor: status.infoContainer,
                      icon: Icons.info_outline_rounded,
                    ),
                  if (medication.foodInstruction != FoodInstruction.anyTime)
                    StatusChip(
                      label: medication.foodInstruction.shortLabel,
                      color: status.warning,
                      containerColor: status.warningContainer,
                      icon: Icons.restaurant_outlined,
                    ),
                ],
              ),
              if (medication.instructions?.trim().isNotEmpty ?? false) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                Text(
                  medication.instructions!.trim(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              if (medication.prescriber?.trim().isNotEmpty ?? false) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Prescribed by ${medication.prescriber!.trim()}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),

        // ------------------------------------------------------------ stock
        SectionHeader(title: 'Stock'),
        inventory.when(
          loading: () => const AppCard(child: SizedBox(height: 60)),
          error: (_, __) => const SizedBox.shrink(),
          data: (Inventory? inv) => _StockCard(medication: medication, inventory: inv),
        ),

        // ---------------------------------------------------------- schedule
        SectionHeader(title: 'Schedule'),
        phases.when(
          loading: () => const AppCard(child: SizedBox(height: 60)),
          error: (_, __) => const SizedBox.shrink(),
          data: (List<SchedulePhase> list) => _ScheduleCard(
            medication: medication,
            phases: list,
            today: today,
          ),
        ),

        // --------------------------------------------------------- adherence
        SectionHeader(title: 'Adherence'),
        adherence.when(
          loading: () => const AppCard(child: SizedBox(height: 60)),
          error: (_, __) => const SizedBox.shrink(),
          data: (MedicationAdherence value) {
            if (value.resolved == 0) {
              return const AppCard(
                child: Text(
                  'No logged doses yet. Once you record a dose it will show '
                  'up here.',
                ),
              );
            }
            final double? percent = value.percent;
            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Taken on schedule', style: theme.textTheme.titleSmall),
                      const Spacer(),
                      if (percent != null)
                        Text(
                          '${percent.round()}%',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: percent >= 90
                                ? status.taken
                                : percent >= 70
                                    ? status.warning
                                    : status.missed,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ThinProgress(value: (percent ?? 0) / 100),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: <Widget>[
                      StatusChip(
                        label: '${value.taken} taken',
                        color: status.taken,
                        containerColor: status.takenContainer,
                        icon: Icons.check_rounded,
                      ),
                      StatusChip(
                        label: '${value.missed} missed',
                        color: status.missed,
                        containerColor: status.missedContainer,
                        icon: Icons.close_rounded,
                      ),
                      StatusChip(
                        label: '${value.skipped} skipped',
                        color: status.skipped,
                        containerColor: status.skippedContainer,
                        icon: Icons.remove_rounded,
                      ),
                      if (value.pending > 0)
                        StatusChip(
                          label: '${value.pending} upcoming',
                          color: theme.colorScheme.onSurfaceVariant,
                          containerColor:
                              theme.colorScheme.surfaceContainerHighest,
                          icon: Icons.schedule_rounded,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Percentage is taken ÷ (taken + missed). Skipped doses are '
                    'deliberate and are not counted against you.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            );
          },
        ),

        // --------------------------------------------------------- lifecycle
        SectionHeader(title: 'Manage'),
        _LifecycleActions(medication: medication),
        const SizedBox(height: AppSpacing.lg),
        const InfoBanner(
          icon: Icons.health_and_safety_outlined,
          message:
              'Medzee records what you tell it. It does not recommend doses, '
              'changes or substitutes. Ask your pharmacist or prescriber '
              'before changing how you take a medicine.',
        ),
      ],
    );
  }
}

class _StockCard extends ConsumerWidget {
  const _StockCard({required this.medication, required this.inventory});

  final Medication medication;
  final Inventory? inventory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final AsyncValue<SupplyProjection?> projection =
        ref.watch(supplyProjectionProvider(medication.id));

    if (inventory == null) {
      return AppCard(
        child: Row(
          children: <Widget>[
            Icon(Icons.inventory_2_outlined,
                color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Text('No stock tracked for this medicine yet.'),
            ),
          ],
        ),
      );
    }

    final Inventory inv = inventory!;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${_qty(inv.quantityOnHand)} ${inv.unit.label}',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              if (inv.isLowStock)
                StatusChip(
                  label: 'Low stock',
                  color: status.warning,
                  containerColor: status.warningContainer,
                  icon: Icons.warning_amber_rounded,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Refill warns at ${_qty(inv.refillThreshold)} ${inv.unit.singular}',
            style: theme.textTheme.bodySmall,
          ),
          if (inv.expiryDate != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Expires ${_fmtDate(inv.expiryDate!)}',
              style: theme.textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          projection.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (SupplyProjection? p) {
              if (p == null) return const SizedBox.shrink();
              if (!p.canCalculate) {
                return InfoBanner(
                  message: p.reason ?? 'Run-out date unavailable.',
                  tone: AppInfoTone.warning,
                  icon: Icons.hourglass_empty_rounded,
                );
              }
              return InfoBanner(
                message:
                    'About ${p.daysRemaining} day${p.daysRemaining == 1 ? '' : 's'} '
                    'left at ${_qty(p.dailyConsumption)} ${inv.unit.singular} per day. '
                    'Expected to run out around ${_fmtDate(p.runOutDate!)}.',
                tone: p.daysRemaining! <= 5
                    ? AppInfoTone.warning
                    : AppInfoTone.neutral,
                icon: Icons.timelapse_rounded,
              );
            },
          ),
        ],
      ),
    );
  }

  String _qty(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);

  String _fmtDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.medication,
    required this.phases,
    required this.today,
  });

  final Medication medication;
  final List<SchedulePhase> phases;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (phases.isEmpty) {
      return AppCard(
        child: Text(
          medication.isAsNeeded
              ? 'Taken as needed — no fixed reminders are created.'
              : 'No schedule configured yet.',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final SchedulePhase phase in phases) ...<Widget>[
            if (phase != phases.first) const Divider(height: AppSpacing.xxl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    'Phase ${phase.order + 1}',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ScheduleGenerator.describe(phase),
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '${_qty(phase.doseQuantity)} ${phase.unit.label} per dose · '
                        '${phase.kind.label}',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'From ${_fmtDate(phase.startDate)}'
                        '${phase.endDate != null ? ' to ${_fmtDate(phase.endDate!)}' : ' (ongoing)'}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _qty(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);

  String _fmtDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _LifecycleActions extends ConsumerWidget {
  const _LifecycleActions({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool active = medication.status == MedicationStatus.active;

    return Column(
      children: <Widget>[
        AppSecondaryButton(
          label: active ? 'Pause reminders' : 'Resume reminders',
          icon: active ? Icons.pause_rounded : Icons.play_arrow_rounded,
          onPressed: () async {
            final service = ref.read(medicationServiceProvider);
            if (active) {
              await service.pause(medication);
            } else {
              await service.resume(medication);
            }
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        if (medication.status != MedicationStatus.completed)
          AppSecondaryButton(
            label: 'Mark course as finished',
            icon: Icons.flag_outlined,
            onPressed: () => _confirm(
              context,
              title: 'Finish this course?',
              body:
                  'Reminders stop and the medicine moves to Completed. Your '
                  'history and stock are kept.',
              onConfirm: () =>
                  ref.read(medicationServiceProvider).endTreatment(medication),
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
        AppSecondaryButton(
          label: 'Delete medicine',
          icon: Icons.delete_outline_rounded,
          destructive: true,
          onPressed: () => _confirm(
            context,
            title: 'Delete ${medication.name}?',
            body:
                'The medicine, its schedule and its reminders are removed. '
                'Past dose history is kept so your records stay complete.',
            confirmLabel: 'Delete',
            onConfirm: () =>
                ref.read(medicationServiceProvider).delete(medication),
          ),
        ),
      ],
    );
  }

  Future<void> _confirm(
    BuildContext context, {
    required String title,
    required String body,
    required Future<void> Function() onConfirm,
    String confirmLabel = 'Confirm',
  }) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    if (ok == true) await onConfirm();
  }
}

/// Compact sheet for renaming and toggling favourites without leaving the
/// detail screen. Full schedule editing lives in the add/edit flow.
class _QuickEditSheet extends ConsumerStatefulWidget {
  const _QuickEditSheet({required this.medication});

  final Medication medication;

  @override
  ConsumerState<_QuickEditSheet> createState() => _QuickEditSheetState();
}

class _QuickEditSheetState extends ConsumerState<_QuickEditSheet> {
  late final TextEditingController _name;
  late bool _favorite;
  String? _error;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.medication.name);
    _favorite = widget.medication.isFavorite;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.gutter,
        right: AppSpacing.gutter,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Edit medicine', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _name,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: _error,
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Favourite'),
            value: _favorite,
            onChanged: (bool value) => setState(() => _favorite = value),
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            label: 'Save',
            onPressed: () async {
              final String trimmed = _name.text.trim();
              if (trimmed.isEmpty) {
                setState(() => _error = 'Name cannot be empty.');
                return;
              }
              await ref.read(medicationRepositoryProvider).save(
                    widget.medication.copyWith(
                      name: trimmed,
                      isFavorite: _favorite,
                      updatedAt: DateTime.now().toUtc(),
                    ),
                  );
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
