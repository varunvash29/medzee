import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/core_enums.dart';
import '../../domain/models/dose.dart';
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

/// Home: what to take next, how today is going, and the main shortcuts.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<TodayEntry>> timeline =
        ref.watch(todayTimelineProvider);
    final UserProfile profile = ref.watch(activeProfileProvider);
    final bool noMedicines =
        ref.watch(medicationsProvider).value?.isEmpty ?? false;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(todayTimelineProvider),
          child: ListView(
            key: const PageStorageKey<String>('home-scroll'),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.md,
              AppSpacing.gutter,
              AppSpacing.xxl,
            ),
            children: <Widget>[
              _Header(profile: profile),
              const SizedBox(height: AppSpacing.xl),
              ...timeline.when(
                loading: () => const <Widget>[_Skeleton()],
                error: (Object e, StackTrace _) => <Widget>[
                  InfoBanner(
                    message: "Could not load today's doses: $e",
                    tone: AppInfoTone.critical,
                    icon: Icons.error_outline_rounded,
                  ),
                ],
                data: (List<TodayEntry> entries) => noMedicines
                    ? const <Widget>[_FirstUse()]
                    : _content(context, ref, entries),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _content(
    BuildContext context,
    WidgetRef ref,
    List<TodayEntry> entries,
  ) {
    final TodayEntry? next = entries
        .where((TodayEntry e) => e.dose.status == DoseStatus.pending)
        .cast<TodayEntry?>()
        .firstWhere((_) => true, orElse: () => null);

    return <Widget>[
      if (entries.isNotEmpty) ...<Widget>[
        _NextDoseCard(next: next),
        const SizedBox(height: AppSpacing.lg),
        _ProgressCard(entries: entries),
        const SizedBox(height: AppSpacing.lg),
      ],
      const _RefillBanner(),
      const _QuickActions(),
      const SizedBox(height: AppSpacing.xl),
      if (entries.isEmpty)
        const _QuietDay()
      else ...<Widget>[
        Text(
          "Today's schedule",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              for (int i = 0; i < entries.length; i++) ...<Widget>[
                if (i > 0) const Divider(height: 1, indent: 76),
                _DoseRow(entry: entries[i]),
              ],
            ],
          ),
        ),
      ],
    ];
  }
}

// ------------------------------------------------------------------ header

class _Header extends StatelessWidget {
  const _Header({required this.profile});

  final UserProfile profile;

  String get _greeting {
    final int h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? name = profile.displayName?.trim();
    const List<String> months = <String>[
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December',
    ];
    const List<String> days = <String>[
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
      'Sunday',
    ];
    final DateTime now = DateTime.now();

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_greeting, style: theme.textTheme.bodyMedium),
              Text(
                (name == null || name.isEmpty) ? 'Welcome' : name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        MedzeeMark.tile(size: 44),
      ],
    );
  }
}

// --------------------------------------------------------------- next dose

class _NextDoseCard extends ConsumerWidget {
  const _NextDoseCard({required this.next});

  final TodayEntry? next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final TodayEntry? e = next;

    if (e == null) {
      return AppCard(
        color: status.takenContainer,
        borderColor: Colors.transparent,
        child: Row(
          children: <Widget>[
            Icon(Icons.check_circle_rounded, color: status.taken, size: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('All done for today',
                      style: theme.textTheme.titleMedium),
                  Text(
                    'Every dose is logged. See you tomorrow.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final Medication m = e.medication;
    return AppCard(
      color: theme.colorScheme.primaryContainer,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () => context.push('/medicines/${m.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'NEXT DOSE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              DoseFormIcon(
                form: m.form,
                size: 48,
                background: theme.colorScheme.surface,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      m.name,
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${_doseLabel(e.dose, m)} · ${_time(context, e.dose)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _take(context, ref, e.dose),
                  icon: const Icon(Icons.check_rounded, size: 20),
                  label: const Text('Take now'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(
                onPressed: () => ref.read(doseActionsProvider).skip(e.dose),
                child: const Text('Skip'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _take(
  BuildContext context,
  WidgetRef ref,
  ScheduledDose dose,
) async {
  HapticFeedback.mediumImpact();
  final DoseActions actions = ref.read(doseActionsProvider);
  await actions.taken(dose);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(actions.lastMessage ?? 'Dose recorded'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => actions.undo(dose),
        ),
      ),
    );
}

String _time(BuildContext context, ScheduledDose d) => TimeOfDay(
      hour: d.scheduledMinutes ~/ 60,
      minute: d.scheduledMinutes % 60,
    ).format(context);

String _doseLabel(ScheduledDose d, Medication m) {
  final String q = d.doseQuantity == d.doseQuantity.roundToDouble()
      ? d.doseQuantity.toInt().toString()
      : d.doseQuantity.toString();
  final String strength = m.strengthLabel == null ? '' : ' · ${m.strengthLabel}';
  return '$q ${d.unit.singular}${d.doseQuantity == 1 ? '' : 's'}$strength';
}

// ---------------------------------------------------------------- progress

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.entries});

  final List<TodayEntry> entries;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    int taken = 0, missed = 0, upcoming = 0;
    for (final TodayEntry e in entries) {
      switch (e.dose.status) {
        case DoseStatus.taken:
          taken++;
        case DoseStatus.missed:
          missed++;
        case DoseStatus.pending:
          upcoming++;
        default:
          break;
      }
    }
    final int total = entries.length;

    Widget legend(String label, int n, Color color) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
              Text('$n', style: theme.textTheme.titleSmall),
            ],
          ),
        );

    return AppCard(
      child: Row(
        children: <Widget>[
          ProgressRing(
            value: total == 0 ? 0 : taken / total,
            size: 96,
            stroke: 10,
            color: status.taken,
            trackColor: theme.colorScheme.primaryContainer,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('$taken/$total', style: theme.textTheme.titleLarge),
                Text('doses', style: theme.textTheme.labelSmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              children: <Widget>[
                legend('Taken', taken, status.taken),
                legend('Upcoming', upcoming, theme.colorScheme.primary),
                legend('Missed', missed, status.missed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------- refill banner

class _RefillBanner extends ConsumerWidget {
  const _RefillBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Medication> low = ref.watch(lowStockMedicationsProvider);
    if (low.isEmpty) return const SizedBox.shrink();
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: AppCard(
        color: status.warningContainer,
        borderColor: Colors.transparent,
        onTap: () => context.push('/medicines/${low.first.id}'),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.inventory_2_outlined, color: status.warning),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                low.length == 1
                    ? '${low.first.name} is running low'
                    : '${low.length} medicines are running low',
                style: theme.textTheme.titleSmall,
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------- quick actions

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 2.3,
      children: <Widget>[
        _Action(
          icon: Icons.document_scanner_outlined,
          label: 'Scan prescription',
          onTap: () => context.push(AppRoutes.scanPrescription),
        ),
        _Action(
          icon: Icons.auto_awesome_outlined,
          label: 'Ask AI',
          onTap: () => context.go(AppRoutes.assistant),
        ),
        _Action(
          icon: Icons.add_circle_outline_rounded,
          label: 'Add medicine',
          onTap: () => context.push(AppRoutes.addMedicine),
        ),
        _Action(
          icon: Icons.insights_outlined,
          label: 'Insights',
          onTap: () => context.push(AppRoutes.insights),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.labelLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- dose row

class _DoseRow extends ConsumerWidget {
  const _DoseRow({required this.entry});

  final TodayEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final ScheduledDose d = entry.dose;
    final Medication m = entry.medication;
    final bool done = d.status != DoseStatus.pending;

    Widget trailing;
    switch (d.status) {
      case DoseStatus.taken:
        trailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.check_circle_rounded, size: 18, color: status.taken),
            const SizedBox(width: 4),
            Text('Taken',
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: status.taken)),
          ],
        );
      case DoseStatus.skipped:
        trailing = Text('Skipped', style: theme.textTheme.labelMedium);
      case DoseStatus.missed:
        trailing = Text(
          'Missed',
          style: theme.textTheme.labelMedium?.copyWith(color: status.missed),
        );
      default:
        trailing = OutlinedButton(
          onPressed: () => _take(context, ref, d),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(64, 36),
            padding: const EdgeInsets.symmetric(horizontal: 14),
          ),
          child: const Text('Take'),
        );
    }

    return InkWell(
      onTap: () => context.push('/medicines/${m.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 52,
              child: Text(
                _time(context, d).replaceAll(' ', '\n'),
                style: theme.textTheme.labelMedium?.copyWith(height: 1.2),
              ),
            ),
            DoseFormIcon(form: m.form, size: 40),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Opacity(
                opacity: done ? 0.6 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      m.name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _doseLabel(d, m),
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            trailing,
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------- empty states

class _FirstUse extends StatelessWidget {
  const _FirstUse();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxxl),
      child: Column(
        children: <Widget>[
          MedzeeMark.tile(size: 96),
          const SizedBox(height: AppSpacing.xl),
          Text('Add your first medicine',
              style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Type a name or scan a prescription. Medzee fills in the rest and '
            'reminds you on time.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.addMedicine),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add medicine'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.scanPrescription),
            icon: const Icon(Icons.document_scanner_outlined),
            label: const Text('Scan a prescription'),
          ),
        ],
      ),
    );
  }
}

class _QuietDay extends StatelessWidget {
  const _QuietDay();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Icon(Icons.spa_outlined,
            size: 40, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
        const SizedBox(height: AppSpacing.md),
        Text('Nothing scheduled today', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Add a medicine with a schedule and its doses will appear here.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final Color c = Theme.of(context).colorScheme.surfaceContainerHigh;
    Widget block(double h) => Container(
          height: h,
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(20),
          ),
        );
    return Column(children: <Widget>[block(150), block(120), block(160)]);
  }
}
