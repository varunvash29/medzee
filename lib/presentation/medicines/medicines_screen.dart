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
import '../../state/insights_provider.dart';
import '../../state/inventory_providers.dart';
import '../../state/medications_provider.dart';
import '../shared/app_widgets.dart';

/// Searchable library of the user's medicines with status filters.
class MedicinesScreen extends ConsumerStatefulWidget {
  const MedicinesScreen({super.key});

  @override
  ConsumerState<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends ConsumerState<MedicinesScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LibraryFilter filter = ref.watch(libraryFilterProvider);
    final AsyncValue<List<Medication>> all = ref.watch(medicationsProvider);

    // Keep the field in sync when the query is cleared from elsewhere
    // (e.g. the suffix button) without clobbering the cursor on every build.
    if (_search.text != filter.query) {
      _search.value = TextEditingValue(
        text: filter.query,
        selection: TextSelection.collapsed(offset: filter.query.length),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.lg,
                AppSpacing.gutter,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Medicines', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _search,
                    onChanged: (String value) =>
                        ref.read(libraryFilterProvider.notifier).setQuery(value),
                    decoration: InputDecoration(
                      hintText: 'Search by name or active ingredient',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: filter.query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => ref
                                  .read(libraryFilterProvider.notifier)
                                  .setQuery(''),
                            ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        for (final MedicationStatus status
                            in MedicationStatus.values)
                          Padding(
                            padding:
                                const EdgeInsets.only(right: AppSpacing.sm),
                            child: _FilterChip(
                              label: status.label,
                              selected: filter.status == status,
                              onTap: () => ref
                                  .read(libraryFilterProvider.notifier)
                                  .setStatus(status),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: all.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object error, StackTrace _) => Padding(
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  child: InfoBanner(
                    message: 'Could not load your medicines: $error',
                    tone: AppInfoTone.critical,
                    icon: Icons.error_outline_rounded,
                  ),
                ),
                data: (List<Medication> medications) {
                  final String query = filter.query.trim().toLowerCase();
                  final List<Medication> filtered = medications
                      .where((Medication m) =>
                          m.status == filter.status &&
                          (query.isEmpty ||
                              m.name.toLowerCase().contains(query) ||
                              (m.genericName
                                      ?.toLowerCase()
                                      .contains(query) ??
                                  false)))
                      .toList()
                    ..sort((Medication a, Medication b) =>
                        switch (filter.sort) {
                          MedicineSort.name =>
                            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
                          MedicineSort.recentlyAdded =>
                            b.createdAt.compareTo(a.createdAt),
                          MedicineSort.nextDose ||
                          MedicineSort.lowStock =>
                            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
                        });

                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: filter.query.isEmpty
                          ? Icons.medication_liquid_outlined
                          : Icons.search_off_rounded,
                      title: filter.query.isEmpty
                          ? 'No ${filter.status.label.toLowerCase()} medicines'
                          : 'No matches',
                      message: filter.query.isEmpty
                          ? 'Medicines you add will appear here, grouped by '
                              'their current status.'
                          : 'Try a different name or clear the search.',
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      AppSpacing.lg,
                      AppSpacing.gutter,
                      AppSpacing.huge,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int index) =>
                        _MedicineTile(
                      medication: filtered[index],
                      index: index,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.standard,
      decoration: BoxDecoration(
        color: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadii.pill,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.pill,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicineTile extends ConsumerWidget {
  const _MedicineTile({required this.medication, required this.index});

  final Medication medication;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final AsyncValue<Inventory?> inventory =
        ref.watch(inventoryProvider(medication.id));
    final AsyncValue<MedicationAdherence> adherence =
        ref.watch(medicationAdherenceProvider(medication.id));

    final Inventory? stock = inventory.value;
    final bool lowStock = stock?.isLowStock ?? false;

    return AppCard(
      onTap: () => context.go('/medicines/${medication.id}'),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(
              _iconFor(medication.form),
              color: theme.colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        medication.name,
                        style: theme.textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (medication.isFavorite)
                      const Icon(Icons.favorite_rounded,
                          size: 15, color: AppColorsLike.pink),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle(medication),
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: <Widget>[
                    if (stock != null)
                      StatusChip(
                        label: lowStock
                            ? 'Low · ${_qty(stock.quantityOnHand)} left'
                            : '${_qty(stock.quantityOnHand)} ${stock.unit.singular}',
                        color: lowStock
                            ? status.warning
                            : theme.colorScheme.onSurfaceVariant,
                        containerColor: lowStock
                            ? status.warningContainer
                            : theme.colorScheme.surfaceContainerHighest,
                        icon: lowStock
                            ? Icons.warning_amber_rounded
                            : Icons.inventory_2_outlined,
                      ),
                    adherence.when(
                      data: (MedicationAdherence value) {
                        final double? percent = value.percent;
                        if (percent == null) return const SizedBox.shrink();
                        return StatusChip(
                          label: '${percent.round()}% taken',
                          color: percent >= 90
                              ? status.taken
                              : percent >= 70
                                  ? status.warning
                                  : status.missed,
                          containerColor: percent >= 90
                              ? status.takenContainer
                              : percent >= 70
                                  ? status.warningContainer
                                  : status.missedContainer,
                          icon: Icons.trending_up_rounded,
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.outline,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: AppMotion.medium,
          delay: (index * 40).ms,
          curve: AppMotion.enter,
        )
        .slideX(begin: 0.04, curve: AppMotion.enter);
  }

  String _subtitle(Medication medication) {
    final List<String> parts = <String>[
      if (medication.strengthLabel != null) medication.strengthLabel!,
      medication.form.label,
      medication.route.label,
    ];
    return parts.join(' · ');
  }

  String _qty(double value) =>
      value == value.roundToDouble()
          ? value.toInt().toString()
          : value.toStringAsFixed(1);

  IconData _iconFor(DosageForm form) => switch (form) {
        DosageForm.tablet || DosageForm.capsule => Icons.medication_rounded,
        DosageForm.liquid => Icons.local_drink_rounded,
        DosageForm.injection => Icons.colorize_rounded,
        DosageForm.inhaler => Icons.air_rounded,
        DosageForm.drops => Icons.water_drop_rounded,
        DosageForm.cream => Icons.brush_rounded,
        DosageForm.patch => Icons.healing_rounded,
        DosageForm.other => Icons.medication_liquid_rounded,
      };
}

/// Small colour constants kept local to the tile to avoid growing the
/// shared palette for a single decorative use.
abstract final class AppColorsLike {
  static const Color pink = Color(0xFFE0699A);
}
