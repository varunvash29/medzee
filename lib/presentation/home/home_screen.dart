import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/dose.dart';
import '../../domain/models/inventory.dart';
import '../../domain/models/medication.dart';
import '../../domain/models/user_profile.dart';
import '../../routing/app_router.dart';
import '../../state/dose_actions.dart';
import '../../state/doses_provider.dart';
import '../../state/inventory_providers.dart';
import '../../state/medications_provider.dart';
import '../../state/profile_providers.dart';
import '../shared/app_widgets.dart';
import '../shared/medzee_logo.dart';
import '../shared/motion_widgets.dart';

/// The Today dashboard: greeting, daily progress, refill nudge and the day's
/// schedule grouped by part of day.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<TodayEntry>> timeline = ref.watch(
      todayTimelineProvider,
    );
    final UserProfile profile = ref.watch(activeProfileProvider);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(todayTimelineProvider),
              child: CustomScrollView(
                key: const PageStorageKey<String>('home-scroll'),
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.gutter,
                        AppSpacing.md,
                        AppSpacing.gutter,
                        0,
                      ),
                      child: _Header(profile: profile),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.gutter,
                        AppSpacing.xl,
                        AppSpacing.gutter,
                        0,
                      ),
                      child: _DailyProgressHero(
                        timeline: timeline,
                        profile: profile,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: _RefillBanner()),
                  ..._scheduleSlivers(context, ref, timeline, profile),
                  // Leaves room for the floating nav bar and Add button.
                  const SliverToBoxAdapter(child: SizedBox(height: 150)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _scheduleSlivers(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<TodayEntry>> timeline,
    UserProfile profile,
  ) {
    return timeline.when(
      loading:
          () => const <Widget>[SliverToBoxAdapter(child: _ScheduleSkeleton())],
      error:
          (Object error, StackTrace _) => <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                child: InfoBanner(
                  message: "Could not load today's doses: $error",
                  tone: AppInfoTone.critical,
                  icon: Icons.error_outline_rounded,
                ),
              ),
            ),
          ],
      data: (List<TodayEntry> entries) {
        final bool noMedicines =
            ref.watch(medicationsProvider).value?.isEmpty ?? false;
        if (entries.isEmpty) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.xxxl,
                  AppSpacing.gutter,
                  0,
                ),
                child: noMedicines ? const _FirstUseEmpty() : const _QuietDay(),
              ),
            ),
          ];
        }

        final Map<_Period, List<TodayEntry>> groups =
            <_Period, List<TodayEntry>>{};
        for (final TodayEntry e in entries) {
          groups
              .putIfAbsent(
                _Period.of(e.dose.scheduledMinutes),
                () => <TodayEntry>[],
              )
              .add(e);
        }

        int runningIndex = 0;
        return <Widget>[
          for (final _Period period in _Period.values)
            if (groups[period] != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.xxl,
                    AppSpacing.gutter,
                    0,
                  ),
                  child: _PeriodSection(
                    period: period,
                    entries: groups[period]!,
                    profile: profile,
                    startIndex:
                        (() {
                          final int s = runningIndex;
                          runningIndex += groups[period]!.length;
                          return s;
                        })(),
                  ),
                ),
              ),
        ];
      },
    );
  }
}

enum _Period {
  morning('Morning', Icons.wb_twilight_rounded, Color(0xFFFFA726)),
  afternoon('Afternoon', Icons.wb_sunny_rounded, Color(0xFF29B6F6)),
  evening('Evening', Icons.wb_twilight_rounded, Color(0xFFFF7A6B)),
  bedtime('Bedtime', Icons.nightlight_round, Color(0xFF8B7CFF));

  const _Period(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  static _Period of(int minutes) => switch (minutes) {
    < 12 * 60 => morning,
    < 17 * 60 => afternoon,
    < 21 * 60 => evening,
    _ => bedtime,
  };
}

String _formatTime(int minutes, TimeFormat format) {
  final int h = minutes ~/ 60;
  final int m = minutes % 60;
  final String mm = m.toString().padLeft(2, '0');
  if (format == TimeFormat.h24) return '${h.toString().padLeft(2, '0')}:$mm';
  final int h12 = h % 12 == 0 ? 12 : h % 12;
  return '$h12:$mm ${h < 12 ? 'AM' : 'PM'}';
}

// ---------------------------------------------------------------- header

class _Header extends StatelessWidget {
  const _Header({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime now = DateTime.now();
    final String hour = switch (now.hour) {
      < 12 => 'Good morning',
      < 17 => 'Good afternoon',
      _ => 'Good evening',
    };
    final String name = profile.displayName?.trim() ?? '';

    return Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _formatDate(now),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name.isEmpty ? hour : '$hour,',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                  if (name.isNotEmpty)
                    Text(
                      name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.12,
                        letterSpacing: -0.6,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Semantics(
              button: true,
              label: 'Open profile',
              child: Pressable(
                onTap: () => context.go(AppRoutes.profile),
                child:
                    name.isEmpty
                        ? MedzeeMark.tile(size: 44)
                        : Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            name.characters.first.toUpperCase(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: AppMotion.medium, curve: AppMotion.enter)
        .slideY(begin: 0.08, curve: AppMotion.enter);
  }

  String _formatDate(DateTime date) {
    const List<String> weekdays = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const List<String> months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }
}

// ------------------------------------------------------------------ hero

class _DailyProgressHero extends StatelessWidget {
  const _DailyProgressHero({required this.timeline, required this.profile});

  final AsyncValue<List<TodayEntry>> timeline;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool dark = theme.brightness == Brightness.dark;

    final List<TodayEntry> entries = timeline.value ?? const <TodayEntry>[];
    final int total =
        entries
            .where((TodayEntry e) => e.dose.status != DoseStatus.cancelled)
            .length;
    final int taken =
        entries
            .where((TodayEntry e) => e.dose.status == DoseStatus.taken)
            .length;
    final int missed =
        entries
            .where((TodayEntry e) => e.dose.status == DoseStatus.missed)
            .length;
    final double progress = total == 0 ? 0 : taken / total;
    final bool done = total > 0 && taken == total;

    TodayEntry? next;
    for (final TodayEntry e in entries) {
      if (e.dose.status == DoseStatus.pending) {
        next = e;
        break;
      }
    }

    final String headline =
        total == 0
            ? 'A quiet day'
            : done
            ? 'All logged for today'
            : taken == 0
            ? 'Your day, ahead'
            : 'Your day, in balance';
    final String summary =
        total == 0 ? 'No doses due' : '$taken of $total doses completed';

    const Color onHero = Colors.white;
    final Color accent = done ? const Color(0xFFFFE08A) : Colors.white;

    return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: dark ? const Color(0xFF4A4AD8) : const Color(0xFF5B5BF0),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'TODAY',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: onHero.withValues(alpha: 0.75),
                                letterSpacing: 1.6,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnimatedSwitcher(
                              duration: AppMotion.medium,
                              child: Text(
                                headline,
                                key: ValueKey<String>(headline),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: onHero,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              summary,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: onHero.withValues(alpha: 0.88),
                              ),
                            ),
                            if (missed > 0) ...<Widget>[
                              const SizedBox(height: AppSpacing.md),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.error_outline_rounded,
                                      size: 14,
                                      color: onHero,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$missed missed',
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            color: onHero,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Semantics(
                        label:
                            total == 0
                                ? 'No doses scheduled today'
                                : '$taken of $total doses completed',
                        child: ProgressRing(
                          value: progress,
                          size: 96,
                          stroke: 11,
                          color: accent,
                          trackColor: Colors.white.withValues(alpha: 0.22),
                          child:
                              done
                                  ? AnimatedCheck(size: 34, color: accent)
                                  : Text(
                                    total == 0
                                        ? '–'
                                        : '${(progress * 100).round()}%',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: onHero,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  if (next != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm + 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.schedule_rounded,
                            size: 18,
                            color: onHero,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Next · ${next.medication.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: onHero,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            _formatTime(
                              next.dose.scheduledMinutes,
                              profile.timeFormat,
                            ),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: onHero.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: AppMotion.medium, delay: 60.ms)
        .slideY(begin: 0.06, curve: AppMotion.enter);
  }
}

// ---------------------------------------------------------------- refill

/// Compact amber nudge; renders nothing when no medicine is low on stock.
class _RefillBanner extends ConsumerWidget {
  const _RefillBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Medication> low = ref.watch(lowStockMedicationsProvider);
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;

    return AnimatedSize(
      duration: AppMotion.medium,
      curve: AppMotion.enter,
      alignment: Alignment.topCenter,
      child:
          low.isEmpty
              ? const SizedBox(width: double.infinity)
              : Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.md,
                  AppSpacing.gutter,
                  0,
                ),
                child: Pressable(
                  onTap: () => context.go('/medicines/${low.first.id}'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: status.warningContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.inventory_2_outlined,
                          color: status.warning,
                          size: 22,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: _RefillText(low: low)),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: AppMotion.medium),
    );
  }
}

class _RefillText extends ConsumerWidget {
  const _RefillText({required this.low});

  final List<Medication> low;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final Medication first = low.first;
    final Inventory? inventory = ref.watch(inventoryProvider(first.id)).value;
    final int? days =
        ref.watch(supplyProjectionProvider(first.id)).value?.daysRemaining;

    final String detail =
        low.length > 1
            ? '${first.name} and ${low.length - 1} more'
            : days != null
            ? '${first.name} · $days ${days == 1 ? 'day' : 'days'} remaining'
            : inventory != null
            ? '${first.name} · ${_qty(inventory.quantityOnHand)} left'
            : first.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Running low',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          detail,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  String _qty(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
}

// -------------------------------------------------------------- schedule

class _PeriodSection extends StatelessWidget {
  const _PeriodSection({
    required this.period,
    required this.entries,
    required this.profile,
    required this.startIndex,
  });

  final _Period period;
  final List<TodayEntry> entries;
  final UserProfile profile;
  final int startIndex;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int done =
        entries
            .where((TodayEntry e) => e.dose.status == DoseStatus.taken)
            .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: period.color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(period.icon, size: 18, color: period.color),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                period.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '$done/${entries.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        for (int i = 0; i < entries.length; i++)
          _DoseRow(
                entry: entries[i],
                profile: profile,
                isFirst: i == 0,
                isLast: i == entries.length - 1,
              )
              .animate()
              .fadeIn(
                duration: AppMotion.medium,
                delay: ((startIndex + i) * 40).ms,
              )
              .slideY(begin: 0.06, curve: AppMotion.enter),
      ],
    );
  }
}

class _DoseRow extends ConsumerWidget {
  const _DoseRow({
    required this.entry,
    required this.profile,
    required this.isFirst,
    required this.isLast,
  });

  final TodayEntry entry;
  final UserProfile profile;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final ScheduledDose dose = entry.dose;
    final Medication medication = entry.medication;
    final bool resolved =
        dose.status == DoseStatus.taken ||
        dose.status == DoseStatus.skipped ||
        dose.status == DoseStatus.cancelled;
    final bool highlighted = entry.isNext && dose.status == DoseStatus.pending;

    final Color dotColor = switch (dose.status) {
      DoseStatus.taken => status.taken,
      DoseStatus.missed => status.missed,
      DoseStatus.pending =>
        highlighted ? status.due : theme.colorScheme.outline,
      _ => theme.colorScheme.outline,
    };

    final String strength =
        medication.strengthLabel == null
            ? ''
            : ' · ${medication.strengthLabel}';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: 62,
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                _formatTime(dose.scheduledMinutes, profile.timeFormat),
                style: theme.textTheme.labelMedium?.copyWith(
                  color:
                      resolved
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 22,
            child: Column(
              children: <Widget>[
                Container(
                  width: 2,
                  height: 20,
                  color:
                      isFirst
                          ? Colors.transparent
                          : theme.colorScheme.outlineVariant,
                ),
                AnimatedContainer(
                  duration: AppMotion.medium,
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color:
                        dose.status == DoseStatus.pending && !highlighted
                            ? Colors.transparent
                            : dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: dotColor, width: 2),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color:
                        isLast
                            ? Colors.transparent
                            : theme.colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Pressable(
                scale: 0.98,
                onTap: () => context.go('/medicines/${medication.id}'),
                child: AnimatedContainer(
                  duration: AppMotion.medium,
                  curve: AppMotion.enter,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color:
                        highlighted
                            ? theme.colorScheme.surface
                            : resolved
                            ? Colors.transparent
                            : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          highlighted
                              ? theme.colorScheme.primary.withValues(
                                alpha: 0.45,
                              )
                              : theme.colorScheme.outlineVariant.withValues(
                                alpha: resolved ? 0.4 : 0.8,
                              ),
                      width: highlighted ? 1.4 : 1,
                    ),
                    boxShadow:
                        highlighted && theme.brightness == Brightness.light
                            ? AppShadows.soft
                            : null,
                  ),
                  child: AnimatedOpacity(
                    duration: AppMotion.medium,
                    opacity: resolved ? 0.62 : 1,
                    child: Row(
                      children: <Widget>[
                        DoseFormIcon(form: medication.form, size: 42),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                medication.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_doseLabel(dose)}$strength',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        AnimatedSwitcher(
                          duration: AppMotion.medium,
                          switchInCurve: AppMotion.enter,
                          transitionBuilder:
                              (Widget child, Animation<double> a) =>
                                  FadeTransition(
                                    opacity: a,
                                    child: ScaleTransition(
                                      scale: a,
                                      child: child,
                                    ),
                                  ),
                          child: _Trailing(
                            key: ValueKey<DoseStatus>(dose.status),
                            entry: entry,
                            highlighted: highlighted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _doseLabel(ScheduledDose dose) {
    final String quantity =
        dose.doseQuantity == dose.doseQuantity.roundToDouble()
            ? dose.doseQuantity.toInt().toString()
            : dose.doseQuantity.toStringAsFixed(1);
    return '$quantity ${dose.unit.singular}';
  }
}

class _Trailing extends ConsumerWidget {
  const _Trailing({super.key, required this.entry, required this.highlighted});

  final TodayEntry entry;
  final bool highlighted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;

    if (entry.dose.status == DoseStatus.pending && entry.isNext) {
      return _TakeButtons(entry: entry);
    }

    final (
      Color accent,
      Color background,
      String label,
      IconData icon,
    ) = switch (entry.dose.status) {
      DoseStatus.taken => (
        status.taken,
        status.takenContainer,
        'Taken',
        Icons.check_rounded,
      ),
      DoseStatus.missed => (
        status.missed,
        status.missedContainer,
        'Missed',
        Icons.close_rounded,
      ),
      DoseStatus.skipped => (
        status.skipped,
        status.skippedContainer,
        'Skipped',
        Icons.remove_rounded,
      ),
      DoseStatus.cancelled => (
        theme.colorScheme.onSurfaceVariant,
        theme.colorScheme.surfaceContainerHighest,
        'Cancelled',
        Icons.remove_rounded,
      ),
      DoseStatus.pending => (
        theme.colorScheme.onSurfaceVariant,
        theme.colorScheme.surfaceContainer,
        'Upcoming',
        Icons.schedule_rounded,
      ),
    };

    return StatusChip(
      label: label,
      color: accent,
      containerColor: background,
      icon: icon,
    );
  }
}

/// Inline taken / skip actions for the dose that is due now.
class _TakeButtons extends ConsumerWidget {
  const _TakeButtons({required this.entry});

  final TodayEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Tooltip(
          message: 'Skip this dose',
          child: Pressable(
            onTap: () => _confirmSkip(context, ref),
            child: Container(
              width: AppSpacing.touchTarget,
              height: AppSpacing.touchTarget,
              alignment: Alignment.center,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        Tooltip(
          message: 'Mark as taken',
          child: Pressable(
            scale: 0.92,
            onTap: () async {
              HapticFeedback.mediumImpact();
              await ref.read(doseActionsProvider).taken(entry.dose);
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        ref.read(doseActionsProvider).lastMessage ??
                            'Dose recorded',
                      ),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    ),
                  );
              }
            },
            child: Container(
              width: AppSpacing.touchTarget,
              height: AppSpacing.touchTarget,
              decoration: BoxDecoration(
                color: status.taken,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: status.taken.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmSkip(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder:
          (BuildContext context) => SafeArea(
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
                  Text(
                    'Skip this dose?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Skipping records that you deliberately did not take this '
                    'dose. It is never counted as taken.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppSecondaryButton(
                    label: 'Skip dose',
                    destructive: true,
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
    if (confirmed != true) return;
    await ref.read(doseActionsProvider).skip(entry.dose);
  }
}

// ---------------------------------------------------------- empty states

class _FirstUseEmpty extends StatelessWidget {
  const _FirstUseEmpty();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.6,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              MedzeeMark(
                    size: 120,
                    primary: theme.colorScheme.primary,
                    secondary: theme.colorScheme.primary.withValues(
                      alpha: 0.35,
                    ),
                    seam: theme.colorScheme.surface,
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(
                    begin: -3,
                    end: 3,
                    duration: 2400.ms,
                    curve: Curves.easeInOut,
                  ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Start your routine',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Add your first medicine and Medzee will remind you, keep a log and '
          'tell you before stock runs out.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppPrimaryButton(
          label: 'Add medicine',
          icon: Icons.add_rounded,
          expanded: false,
          onPressed: () => context.go(AppRoutes.addMedicine),
        ),
      ],
    ).animate().fadeIn(duration: AppMotion.slow);
  }
}

class _QuietDay extends StatelessWidget {
  const _QuietDay();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Icon(
          Icons.spa_outlined,
          size: 44,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Nothing scheduled today', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Add a medicine with a schedule and its doses will appear here.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    ).animate().fadeIn(duration: AppMotion.slow);
  }
}

/// Layout-preserving placeholder while the timeline loads.
class _ScheduleSkeleton extends StatelessWidget {
  const _ScheduleSkeleton();

  @override
  Widget build(BuildContext context) {
    final Color c = Theme.of(context).colorScheme.surfaceContainerHigh;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.xxl,
        AppSpacing.gutter,
        0,
      ),
      child: Column(
            children: List<Widget>.generate(
              3,
              (int i) => Container(
                height: 68,
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          )
          .animate(onPlay: (AnimationController ctl) => ctl.repeat())
          .shimmer(
            duration: 1400.ms,
            color: Colors.white.withValues(alpha: 0.35),
          ),
    );
  }
}
