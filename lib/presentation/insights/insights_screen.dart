import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/inventory.dart';
import '../../domain/models/medication.dart';
import '../../domain/services/adherence_calculator.dart';
import '../../state/insights_provider.dart';
import '../../state/inventory_providers.dart';
import '../../state/medications_provider.dart';
import '../shared/app_widgets.dart';

/// Adherence window, per-day chart, streaks and a low-stock watchlist.
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<AdherenceInsights> insights =
        ref.watch(adherenceInsightsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
          onPressed: () => context.pop(),
        ),
        title: const Text('Insights'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(adherenceInsightsProvider),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.lg,
              AppSpacing.gutter,
              AppSpacing.huge,
            ),
            children: <Widget>[
              const _WindowPicker(),
              const SizedBox(height: AppSpacing.lg),
              ...insights.when(
                loading: () => <Widget>[
                  const Center(child: CircularProgressIndicator()),
                ],
                error: (Object error, StackTrace _) => <Widget>[
                  InfoBanner(
                    message: 'Could not compute insights: $error',
                    tone: AppInfoTone.critical,
                    icon: Icons.error_outline_rounded,
                  ),
                ],
                data: (AdherenceInsights data) => <Widget>[
                  _SummaryCard(insights: data),
                  SectionHeader(title: 'Day by day'),
                  SizedBox(
                    height: 180,
                    child: AppCard(
                      child: data.summary.hasData
                          ? _AdherenceChart(insights: data)
                          : Center(
                              child: Text(
                                'Not enough logged doses yet to show a chart.',
                                style: theme.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SectionHeader(title: 'Stock watchlist'),
              const _StockWatchlist(),
              const SizedBox(height: AppSpacing.xl),
              const InfoBanner(
                icon: Icons.health_and_safety_outlined,
                message:
                    'Insights describe what you recorded. They are not a '
                    'medical assessment, and a missed dose is never evidence '
                    'that a treatment has failed. Talk to your prescriber '
                    'before changing anything.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WindowPicker extends ConsumerWidget {
  const _WindowPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final InsightsWindow current = ref.watch(insightsWindowProvider);

    return Row(
      children: <Widget>[
        for (final InsightsWindow window in InsightsWindow.values) ...<Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: AnimatedContainer(
                duration: AppMotion.fast,
                curve: AppMotion.standard,
                decoration: BoxDecoration(
                  color: current == window
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: AppRadii.pill,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: AppRadii.pill,
                    onTap: () =>
                        ref.read(insightsWindowProvider.notifier).select(window),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Text(
                        window.label,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: current == window
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.insights});

  final AdherenceInsights insights;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final AdherenceSummary summary = insights.summary;
    final double? percent = summary.percent;

    final Color accent = percent == null
        ? theme.colorScheme.primary
        : percent >= 90
            ? status.taken
            : percent >= 70
                ? status.warning
                : status.missed;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      insights.window.label,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      percent == null ? '—' : '${percent.round()}%',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text('taken on schedule', style: theme.textTheme.titleSmall),
                  ],
                ),
              ),
              if (insights.streakDays > 0)
                StatusChip(
                  label: '${insights.streakDays} day streak',
                  color: status.taken,
                  containerColor: status.takenContainer,
                  icon: Icons.local_fire_department_rounded,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ThinProgress(value: (percent ?? 0) / 100, color: accent),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              StatusChip(
                label: '${summary.taken} taken',
                color: status.taken,
                containerColor: status.takenContainer,
                icon: Icons.check_rounded,
              ),
              StatusChip(
                label: '${summary.missed} missed',
                color: status.missed,
                containerColor: status.missedContainer,
                icon: Icons.close_rounded,
              ),
              StatusChip(
                label: '${summary.skipped} skipped',
                color: status.skipped,
                containerColor: status.skippedContainer,
                icon: Icons.remove_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(summary.explanation, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _AdherenceChart extends StatelessWidget {
  const _AdherenceChart({required this.insights});

  final AdherenceInsights insights;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;

    final List<FlSpot> spots = <FlSpot>[];
    for (int i = 0; i < insights.dailyPercent.length; i++) {
      final double? value = insights.dailyPercent[i];
      if (value == null) continue;
      spots.add(FlSpot(i.toDouble(), value));
    }

    if (spots.isEmpty) {
      return Center(
        child: Text('No logged doses in this window.',
            style: theme.textTheme.bodyMedium),
      );
    }

    final double maxY = 100;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: AppMotion.medium,
      curve: AppMotion.enter,
      builder: (BuildContext context, double t, Widget? child) => LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          minX: 0,
          maxX: (insights.dailyPercent.length - 1).toDouble(),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touched) =>
                  touched
                      .map(
                        (LineBarSpot spot) => LineTooltipItem(
                          '${spot.y.round()}%',
                          theme.textTheme.labelMedium!
                              .copyWith(color: theme.colorScheme.onPrimary),
                        ),
                      )
                      .toList(),
            ),
          ),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (double value) => FlLine(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 50,
                getTitlesWidget: (double value, TitleMeta meta) => Text(
                  '${value.round()}',
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              isCurved: false,
              preventCurveOverShooting: true,
              barWidth: 3,
              dotData: FlDotData(
                show: spots.length <= 14,
                getDotPainter: (FlSpot spot, double xPercentage,
                        LineChartBarData bar, int index) =>
                    FlDotCirclePainter(
                  radius: 3,
                  color: spot.y >= 100
                      ? status.taken
                      : spot.y >= 70
                          ? status.warning
                          : status.missed,
                  strokeWidth: 0,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
              ),
              spots: spots
                  .map((FlSpot spot) =>
                      FlSpot(spot.x, spot.y * t))
                  .toList(growable: false),
              color: theme.colorScheme.primary,
            ),
          ],
        ),
        duration: Duration.zero,
      ),
    );
  }
}

class _StockWatchlist extends ConsumerWidget {
  const _StockWatchlist();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final List<Medication> all =
        ref.watch(medicationsProvider).value ?? const <Medication>[];

    final List<(Medication, Inventory)> watchlist = <(Medication, Inventory)>[];
    for (final Medication medication in all) {
      if (medication.status != MedicationStatus.active) continue;
      final Inventory? inventory =
          ref.watch(inventoryProvider(medication.id)).value;
      if (inventory == null) continue;
      if (inventory.isLowStock || inventory.isEmpty) {
        watchlist.add((medication, inventory));
      }
    }

    if (all.isEmpty) {
      return const AppCard(
        child: Text('Add medicines to see a stock watchlist here.'),
      );
    }
    if (watchlist.isEmpty) {
      return AppCard(
        child: Row(
          children: <Widget>[
            Icon(Icons.check_circle_outline_rounded, color: status.taken),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Text('Everything is above its refill threshold.'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        for (final (Medication medication, Inventory inventory) in watchlist)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              child: Row(
                children: <Widget>[
                  Icon(
                    inventory.isEmpty
                        ? Icons.error_outline_rounded
                        : Icons.warning_amber_rounded,
                    color: inventory.isEmpty ? status.missed : status.warning,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(medication.name, style: theme.textTheme.titleSmall),
                        Text(
                          inventory.isEmpty
                              ? 'Out of stock'
                              : '${_qty(inventory.quantityOnHand)} '
                                  '${inventory.unit.singular} left · '
                                  'refill at ${_qty(inventory.refillThreshold)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _qty(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}
