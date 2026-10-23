import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/dose.dart';
import '../../domain/models/medication.dart';
import '../../domain/models/user_profile.dart';
import '../../state/dose_actions.dart';
import '../../state/doses_provider.dart';
import '../../state/profile_providers.dart';
import '../shared/app_widgets.dart';

/// The Today dashboard: greeting, progress, next dose, and the day's list.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<TodayEntry>> timeline =
        ref.watch(todayTimelineProvider);
    final UserProfile profile = ref.watch(activeProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(todayTimelineProvider),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.lg,
                    AppSpacing.gutter,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _Greeting(profile: profile),
                      const SizedBox(height: AppSpacing.xl),
                      const _ProgressCard(),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: "Today's doses",
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.xxl,
                    AppSpacing.gutter,
                    AppSpacing.md,
                  ),
                ),
              ),
              timeline.when(
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xxl),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (Object error, StackTrace _) =>
                    SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    child: InfoBanner(
                      message: 'Could not load today\'s doses: $error',
                      tone: AppInfoTone.critical,
                      icon: Icons.error_outline_rounded,
                    ),
                  ),
                ),
                data: (List<TodayEntry> entries) {
                  if (entries.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.gutter,
                        ),
                        child: const EmptyState(
                          icon: Icons.free_breakfast_outlined,
                          title: 'Nothing scheduled today',
                          message:
                              'Add a medicine with a schedule and its doses '
                              'will appear here.',
                        ),
                      ),
                    );
                  }
                  return SliverList.separated(
                    itemCount: entries.length + 1,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == entries.length) {
                        return const SizedBox(height: AppSpacing.huge);
                      }
                      return Padding(
                        padding: index == 0
                            ? const EdgeInsets.symmetric(
                                horizontal: AppSpacing.gutter)
                            : const EdgeInsets.symmetric(
                                horizontal: AppSpacing.gutter),
                        child: _DoseTile(entry: entries[index])
                            .animate()
                            .fadeIn(
                              duration: AppMotion.medium,
                              delay: (index * 45).ms,
                              curve: AppMotion.enter,
                            )
                            .slideY(begin: 0.08, curve: AppMotion.enter),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.profile});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          name.isEmpty ? hour : '$hour,',
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (name.isNotEmpty)
          Text(name, style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          _formatDate(now),
          style: theme.textTheme.bodyMedium,
        ),
      ],
    )
        .animate()
        .fadeIn(duration: AppMotion.medium, curve: AppMotion.enter)
        .slideY(begin: 0.1, curve: AppMotion.enter);
  }

  String _formatDate(DateTime date) {
    const List<String> weekdays = <String>[
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
      'Sunday',
    ];
    const List<String> months = <String>[
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }
}

class _ProgressCard extends ConsumerWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final AsyncValue<List<TodayEntry>> timeline =
        ref.watch(todayTimelineProvider);

    return AppCard(
      child: timeline.when(
        loading: () => const SizedBox(height: 72),
        error: (Object _, StackTrace __) =>
            const Text('Progress unavailable'),
        data: (List<TodayEntry> entries) {
          final int total = entries
              .where((TodayEntry e) => e.dose.status != DoseStatus.cancelled)
              .length;
          final int taken = entries
              .where((TodayEntry e) => e.dose.status == DoseStatus.taken)
              .length;
          final int missed = entries
              .where((TodayEntry e) => e.dose.status == DoseStatus.missed)
              .length;
          final double progress =
              total == 0 ? 0 : (taken / total).clamp(0.0, 1.0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Today',
                    style: theme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  if (total > 0)
                    Text(
                      '$taken of $total taken',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: taken == total
                            ? status.taken
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ThinProgress(
                value: progress,
                color: total > 0 && taken == total
                    ? status.taken
                    : theme.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: <Widget>[
                  if (missed > 0)
                    StatusChip(
                      label: '$missed missed',
                      color: status.missed,
                      containerColor: status.missedContainer,
                      icon: Icons.error_outline_rounded,
                    ),
                  if (taken > 0)
                    StatusChip(
                      label: '$taken taken',
                      color: status.taken,
                      containerColor: status.takenContainer,
                      icon: Icons.check_circle_outline_rounded,
                    ),
                  if (total == 0)
                    StatusChip(
                      label: 'No doses due',
                      color: theme.colorScheme.onSurfaceVariant,
                      containerColor:
                          theme.colorScheme.surfaceContainerHighest,
                      icon: Icons.calendar_today_outlined,
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DoseTile extends ConsumerWidget {
  const _DoseTile({required this.entry});

  final TodayEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final ScheduledDose dose = entry.dose;
    final Medication medication = entry.medication;

    final (Color accent, Color background, String label, IconData icon) =
        switch (dose.status) {
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
      DoseStatus.pending => entry.isNext
          ? (status.due, status.dueContainer, 'Due now', Icons.notifications_active_rounded)
          : (
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
              'Upcoming',
              Icons.schedule_rounded,
            ),
    };

    return AppCard(
      onTap: () => context.go('/medicines/${medication.id}'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(icon, color: accent, size: 24),
          ),
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
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${_formatMinutes(dose.scheduledMinutes)} · '
                  '${_doseLabel(dose)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (dose.status == DoseStatus.pending && entry.isNext)
            _TakeButtons(entry: entry)
          else
            StatusChip(
              label: label,
              color: accent,
              containerColor: background,
            ),
        ],
      ),
    );
  }

  String _formatMinutes(int minutes) {
    final int hour = minutes ~/ 60;
    final int minute = minutes % 60;
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }

  String _doseLabel(ScheduledDose dose) {
    final String quantity = dose.doseQuantity == dose.doseQuantity.roundToDouble()
        ? dose.doseQuantity.toInt().toString()
        : dose.doseQuantity.toStringAsFixed(1);
    return '$quantity ${dose.unit.singular}';
  }
}

/// Inline taken / skip actions for the dose that is due now.
class _TakeButtons extends ConsumerWidget {
  const _TakeButtons({required this.entry});

  final TodayEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _RoundAction(
          icon: Icons.check_rounded,
          color: context.statusColors.taken,
          tooltip: 'Mark as taken',
          onTap: () async {
            await ref.read(doseActionsProvider).taken(entry.dose);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ref.read(doseActionsProvider).lastMessage ??
                      'Dose recorded'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
        const SizedBox(width: AppSpacing.xs),
        _RoundAction(
          icon: Icons.close_rounded,
          color: context.statusColors.skipped,
          tooltip: 'Skip this dose',
          onTap: () => _confirmSkip(context, ref),
        ),
      ],
    );
  }

  Future<void> _confirmSkip(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Skip this dose?'),
        content: const Text(
          'Skipping records that you deliberately did not take this dose. '
          'It is never counted as taken.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Skip'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(doseActionsProvider).skip(entry.dose);
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: AppSpacing.touchTarget,
          height: AppSpacing.touchTarget,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}
