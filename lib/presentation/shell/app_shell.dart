import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_spacing.dart';
import '../../routing/app_router.dart';

/// Bottom-navigation shell hosting the five primary tabs.
///
/// The shell owns the nav bar only; each branch owns its own screen state so
/// switching tabs never resets scroll position or form input.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const List<_ShellTab> _tabs = <_ShellTab>[
    _ShellTab(AppRoutes.home, Icons.today_outlined, Icons.today, 'Today'),
    _ShellTab(
        AppRoutes.medicines, Icons.medication_outlined, Icons.medication, 'Medicines'),
    _ShellTab(AppRoutes.calendar, Icons.calendar_month_outlined,
        Icons.calendar_month, 'Calendar'),
    _ShellTab(
        AppRoutes.insights, Icons.insights_outlined, Icons.insights, 'Insights'),
    _ShellTab(
        AppRoutes.profile, Icons.person_outline_rounded, Icons.person, 'You'),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int index = _tabs
        .indexWhere((_ShellTab tab) => tab.location == shell.currentIndexLocation);
    final int safeIndex = index < 0 ? 0 : index;

    return Scaffold(
      body: shell,
      floatingActionButton: safeIndex == 0 || safeIndex == 1
          ? Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _AddButton(index: safeIndex),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: <Widget>[
                for (int i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: _NavTab(
                      tab: _tabs[i],
                      selected: i == safeIndex,
                      onTap: () => shell.goBranch(
                        i,
                        initialLocation: i == shell.currentIndex,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellTab {
  const _ShellTab(this.location, this.icon, this.selectedIcon, this.label);

  final String location;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

extension on StatefulNavigationShell {
  String get currentIndexLocation => AppShell._tabs[currentIndex].location;
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _ShellTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color =
        selected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedSwitcher(
            duration: AppMotion.fast,
            switchInCurve: AppMotion.enter,
            transitionBuilder: (Widget child, Animation<double> animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              selected ? tab.selectedIcon : tab.icon,
              key: ValueKey<bool>(selected),
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            tab.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: selected ? 0.4 : 0.2,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

/// Floating "add medicine" action, shown on the Today and Medicines tabs.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FloatingActionButton(
      heroTag: 'add-medicine-$index',
      onPressed: () => context.go(AppRoutes.addMedicine),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      shape: const CircleBorder(),
      child: const Icon(Icons.add_rounded, size: 28),
    )
        .animate()
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1, 1),
          duration: AppMotion.medium,
          curve: AppMotion.enter,
        )
        .fadeIn(duration: AppMotion.medium);
  }
}
