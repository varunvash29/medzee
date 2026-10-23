import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/inventory.dart';
import '../../domain/models/medication.dart';
import '../../routing/app_router.dart';
import '../../state/inventory_providers.dart';
import '../../state/medications_provider.dart';
import '../shared/app_widgets.dart';
import '../shared/motion_widgets.dart';

/// The user's medicine library: search, status tabs and one clean row each.
class MedicinesScreen extends ConsumerStatefulWidget {
  const MedicinesScreen({super.key});

  @override
  ConsumerState<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends ConsumerState<MedicinesScreen> {
  final TextEditingController _search = TextEditingController();

  static const List<MedicationStatus> _tabs = <MedicationStatus>[
    MedicationStatus.active,
    MedicationStatus.paused,
    MedicationStatus.completed,
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LibraryFilter filter = ref.watch(libraryFilterProvider);
    final AsyncValue<List<Medication>> all = ref.watch(medicationsProvider);

    if (_search.text != filter.query) {
      _search.value = TextEditingValue(
        text: filter.query,
        selection: TextSelection.collapsed(offset: filter.query.length),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.md,
            AppSpacing.gutter,
            AppSpacing.xxl,
          ),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Medicines',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.addMedicine),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Add'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _search,
              onChanged: (String v) =>
                  ref.read(libraryFilterProvider.notifier).setQuery(v),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search medicines',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: filter.query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () =>
                            ref.read(libraryFilterProvider.notifier).setQuery(''),
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<MedicationStatus>(
              showSelectedIcon: false,
              segments: <ButtonSegment<MedicationStatus>>[
                for (final MedicationStatus s in _tabs)
                  ButtonSegment<MedicationStatus>(
                    value: s,
                    label: Text(s.label),
                  ),
              ],
              selected: <MedicationStatus>{
                _tabs.contains(filter.status) ? filter.status : _tabs.first,
              },
              onSelectionChanged: (Set<MedicationStatus> v) =>
                  ref.read(libraryFilterProvider.notifier).setStatus(v.first),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...all.when(
              loading: () => <Widget>[
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              error: (Object e, StackTrace _) => <Widget>[
                InfoBanner(
                  message: 'Could not load your medicines: $e',
                  tone: AppInfoTone.critical,
                  icon: Icons.error_outline_rounded,
                ),
              ],
              data: (List<Medication> meds) => _list(context, meds, filter),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _list(
    BuildContext context,
    List<Medication> meds,
    LibraryFilter filter,
  ) {
    final String q = filter.query.trim().toLowerCase();
    final List<Medication> shown = meds
        .where((Medication m) =>
            m.status == filter.status &&
            (q.isEmpty ||
                m.name.toLowerCase().contains(q) ||
                (m.genericName?.toLowerCase().contains(q) ?? false)))
        .toList()
      ..sort((Medication a, Medication b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    if (shown.isEmpty) {
      final bool searching = filter.query.isNotEmpty;
      return <Widget>[
        EmptyState(
          icon: searching
              ? Icons.search_off_rounded
              : Icons.medication_liquid_outlined,
          title: searching
              ? 'No matches'
              : 'No ${filter.status.label.toLowerCase()} medicines',
          message: searching
              ? 'Try a different name.'
              : filter.status == MedicationStatus.active
                  ? 'Add a medicine to start tracking doses.'
                  : 'Nothing here yet.',
          action: !searching && filter.status == MedicationStatus.active
              ? FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.addMedicine),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add medicine'),
                )
              : null,
        ),
      ];
    }

    return <Widget>[
      AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: <Widget>[
            for (int i = 0; i < shown.length; i++) ...<Widget>[
              if (i > 0) const Divider(height: 1, indent: 72),
              _MedicineRow(medication: shown[i]),
            ],
          ],
        ),
      ),
    ];
  }
}

class _MedicineRow extends ConsumerWidget {
  const _MedicineRow({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final List<SchedulePhase> phases =
        ref.watch(phasesProvider(medication.id)).value ??
            const <SchedulePhase>[];
    final Inventory? inv = ref.watch(inventoryProvider(medication.id)).value;

    final List<int> times = <int>{
      for (final SchedulePhase p in phases) ...p.timesMinutes,
    }.toList()
      ..sort();

    final List<String> meta = <String>[
      if (medication.strengthLabel != null) medication.strengthLabel!,
      _frequency(medication, phases, times.length),
    ];

    return InkWell(
      onTap: () => context.push('/medicines/${medication.id}'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: <Widget>[
            DoseFormIcon(form: medication.form, size: 44),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    medication.name,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meta.join(' · '),
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (medication.prescribedAs != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    PrescribedAsTag(medication.prescribedAs!),
                  ],
                  if (times.isNotEmpty) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: <Widget>[
                        for (final int t in times.take(4))
                          _Pill(
                            TimeOfDay(hour: t ~/ 60, minute: t % 60)
                                .format(context),
                            theme.colorScheme.primaryContainer,
                            theme.colorScheme.primary,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (inv != null && inv.isLowStock)
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: _Pill(
                  inv.isEmpty ? 'Out' : '${_n(inv.quantityOnHand)} left',
                  status.warningContainer,
                  status.warning,
                ),
              ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }

  static String _n(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

  static String _frequency(
    Medication m,
    List<SchedulePhase> phases,
    int timesPerDay,
  ) {
    if (m.isAsNeeded) return 'As needed';
    if (phases.isEmpty) return '';
    return switch (timesPerDay) {
      0 => 'No reminders',
      1 => 'Once daily',
      2 => 'Twice daily',
      _ => '$timesPerDay times daily',
    };
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, this.bg, this.fg);

  final String text;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
