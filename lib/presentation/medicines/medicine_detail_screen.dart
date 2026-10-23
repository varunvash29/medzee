import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_motion.dart';
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
import '../shared/motion_widgets.dart';
import 'medicine_info_tabs.dart';
import 'stock_sheet.dart';

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
                : () => context.push('/medicines/$medicationId/edit'),
          ),
        ],
      ),
      body: medication.when( skipLoadingOnReload: true,
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
}

class _Detail extends ConsumerStatefulWidget {
  const _Detail({required this.medication});

  final Medication medication;

  @override
  ConsumerState<_Detail> createState() => _DetailState();
}

class _DetailState extends ConsumerState<_Detail> {
  int _tab = 0;

  Medication get medication => widget.medication;

  @override
  Widget build(BuildContext context) {
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
        AppSpacing.xxl,
      ),
      children: <Widget>[
        // ---------------------------------------------------------- identity
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: theme.colorScheme.primaryContainer,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DoseFormIcon(
                    form: medication.form,
                    size: 64,
                    background: theme.colorScheme.surface.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          medication.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          [
                            if (medication.strengthLabel != null)
                              medication.strengthLabel!,
                            medication.form.label,
                            medication.route.label,
                          ].join(' · '),
                          style: theme.textTheme.bodyMedium,
                        ),
                        if ((medication.genericName?.trim().isNotEmpty ?? false) &&
                            medication.genericName!.trim().toLowerCase() !=
                                medication.name.trim().toLowerCase())
                          Text(
                            medication.genericName!.trim(),
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              if (medication.prescribedAs != null) ...<Widget>[
                PrescribedAsTag(medication.prescribedAs!),
                const SizedBox(height: AppSpacing.sm),
              ],
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: <Widget>[
                  StatusChip(
                    label: medication.status.label,
                    color: medication.status == MedicationStatus.active
                        ? status.taken
                        : theme.colorScheme.onSurfaceVariant,
                    containerColor: theme.colorScheme.surface,
                    icon: medication.status == MedicationStatus.active
                        ? Icons.check_circle_outline_rounded
                        : Icons.pause_circle_outline_rounded,
                  ),
                  if (medication.isAsNeeded)
                    StatusChip(
                      label: 'As needed',
                      color: status.info,
                      containerColor: theme.colorScheme.surface,
                      icon: Icons.info_outline_rounded,
                    ),
                  if (medication.foodInstruction != FoodInstruction.anyTime)
                    StatusChip(
                      label: medication.foodInstruction.shortLabel,
                      color: status.warning,
                      containerColor: theme.colorScheme.surface,
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
        ).animate().fadeIn(duration: AppMotion.medium).slideY(
              begin: 0.04,
              curve: AppMotion.enter,
            ),

        const SizedBox(height: AppSpacing.lg),
        SegmentedButton<int>(
          showSelectedIcon: false,
          segments: const <ButtonSegment<int>>[
            ButtonSegment<int>(value: 0, label: Text('Overview')),
            ButtonSegment<int>(value: 1, label: Text('Info')),
            ButtonSegment<int>(value: 2, label: Text('Alternatives')),
          ],
          selected: <int>{_tab},
          onSelectionChanged: (Set<int> v) => setState(() => _tab = v.first),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_tab == 1)
          MedicineInfoTab(medication: medication)
        else if (_tab == 2)
          MedicineAlternativesTab(medication: medication)
        else ...<Widget>[
        // ------------------------------------------------------------ stock
        SectionHeader(title: 'Stock'),
        inventory.when( skipLoadingOnReload: true,
          loading: () => const AppCard(child: SizedBox(height: 60)),
          error: (_, __) => const SizedBox.shrink(),
          data: (Inventory? inv) => _StockCard(medication: medication, inventory: inv),
        ),

        // ---------------------------------------------------------- schedule
        SectionHeader(
          title: 'Schedule',
          trailing: TextButton.icon(
            onPressed: () => context.push('/medicines/${medication.id}/edit'),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit'),
          ),
        ),
        phases.when( skipLoadingOnReload: true,
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
        adherence.when( skipLoadingOnReload: true,
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
            FilledButton.tonal(
              onPressed: () => showStockSheet(
                context,
                ref,
                medication: medication,
                inventory: null,
                mode: StockMode.start,
              ),
              child: const Text('Track stock'),
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
          projection.when( skipLoadingOnReload: true,
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
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => showStockSheet(
                    context,
                    ref,
                    medication: medication,
                    inventory: inv,
                    mode: StockMode.refill,
                  ),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Add stock'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => showStockSheet(
                    context,
                    ref,
                    medication: medication,
                    inventory: inv,
                    mode: StockMode.count,
                  ),
                  child: const Text('Set count'),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => showStockSheet(
                context,
                ref,
                medication: medication,
                inventory: inv,
                mode: StockMode.alert,
              ),
              child: const Text('Change low-stock alert'),
            ),
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
    final ThemeData theme = Theme.of(context);
    final bool active = medication.status == MedicationStatus.active;

    final List<_ActionRow> rows = <_ActionRow>[
      _ActionRow(
        icon: active ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
        label: active ? 'Pause reminders' : 'Resume reminders',
        onTap: () async {
          final service = ref.read(medicationServiceProvider);
          if (active) {
            await service.pause(medication);
          } else {
            await service.resume(medication);
          }
        },
      ),
      if (medication.status != MedicationStatus.completed)
        _ActionRow(
          icon: Icons.flag_outlined,
          label: 'Mark course as finished',
          onTap: () => _confirm(
            context,
            title: 'Finish this course?',
            body:
                'Reminders stop and the medicine moves to Completed. Your '
                'history and stock are kept.',
            onConfirm: () =>
                ref.read(medicationServiceProvider).endTreatment(medication),
          ),
        ),
      _ActionRow(
        icon: Icons.delete_outline_rounded,
        label: 'Delete medicine',
        destructive: true,
        onTap: () => _confirm(
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
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < rows.length; i++) ...<Widget>[
            if (i > 0) const Divider(indent: 56),
            rows[i],
          ],
        ],
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context, {
    required String title,
    required String body,
    required Future<void> Function() onConfirm,
    String confirmLabel = 'Confirm',
  }) async {
    final bool? ok = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            0,
            AppSpacing.xxl,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xl),
              AppPrimaryButton(
                label: confirmLabel,
                onPressed: () => Navigator.of(context).pop(true),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Center(child: Text('Cancel')),
              ),
            ],
          ),
        ),
      ),
    );
    if (ok == true) await onConfirm();
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color =
        destructive ? theme.colorScheme.error : theme.colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg - 2,
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: color, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(color: color),
              ),
            ),
            if (!destructive)
              Icon(Icons.chevron_right_rounded,
                  color: theme.colorScheme.outline),
          ],
        ),
      ),
    );
  }
}

/// Compact sheet for renaming and toggling favourites without leaving the
/// detail screen. Full schedule editing lives in the add/edit flow.
