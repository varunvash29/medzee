import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_spacing.dart';
import '../../routing/app_router.dart';
import '../shared/motion_widgets.dart';

/// Bottom-navigation shell hosting the five primary tabs.
///
/// The shell owns the nav bar only; each branch owns its own screen state so
/// switching tabs never resets scroll position or form input.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const List<_ShellTab> _tabs = <_ShellTab>[
    _ShellTab(AppRoutes.home, Icons.today_outlined, Icons.today_rounded, 'Today'),
    _ShellTab(AppRoutes.medicines, Icons.medication_outlined,
        Icons.medication_rounded, 'Medicines'),
    _ShellTab(AppRoutes.calendar, Icons.calendar_month_outlined,
        Icons.calendar_month_rounded, 'Calendar'),
    _ShellTab(AppRoutes.insights, Icons.show_chart_rounded,
        Icons.insights_rounded, 'Insights'),
    _ShellTab(AppRoutes.profile, Icons.person_outline_rounded,
        Icons.person_rounded, 'You'),
  ];

  @override
  Widget build(BuildContext context) {
    final int safeIndex = shell.currentIndex.clamp(0, _tabs.length - 1);

    return Scaffold(
      extendBody: true,
      body: shell,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: safeIndex == 0 || safeIndex == 1
          ? Padding(
              padding: const EdgeInsets.only(bottom: 72),
              child: _AddButton(index: safeIndex),
            )
          : null,
      bottomNavigationBar: _FloatingNavBar(
        tabs: _tabs,
        index: safeIndex,
        onSelected: (int i) {
          HapticFeedback.selectionClick();
          shell.goBranch(i, initialLocation: i == shell.currentIndex);
        },
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

/// Floating, softly elevated nav bar with a sliding selection pill.
class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.tabs,
    required this.index,
    required this.onSelected,
  });

  final List<_ShellTab> tabs;
  final int index;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool dark = theme.brightness == Brightness.dark;
    final MediaQueryData media = MediaQuery.of(context);
    // Large text scales must not clip the labels.
    final double height = 66 + (media.textScaler.scale(11) - 11).clamp(0, 10);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        media.padding.bottom + AppSpacing.sm,
      ),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF22222E) : const Color(0xFF14141F),
          borderRadius: BorderRadius.circular(30),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF14141F).withValues(alpha: dark ? 0.5 : 0.22),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints c) {
            final double w = c.maxWidth / tabs.length;
            return Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: reduceMotion(context)
                      ? Duration.zero
                      : AppMotion.medium,
                  curve: AppMotion.emphasized,
                  left: w * index + 6,
                  top: 6,
                  width: w - 12,
                  height: height - 14,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF8E8EFF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    for (int i = 0; i < tabs.length; i++)
                      Expanded(
                        child: _NavItem(
                          tab: tabs[i],
                          selected: i == index,
                          onTap: () => onSelected(i),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
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
        selected ? const Color(0xFF0E0E3A) : const Color(0xFFB4B4C8);

    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      child: ExcludeSemantics(
        child: InkResponse(
          onTap: onTap,
          radius: 32,
          highlightShape: BoxShape.circle,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedSwitcher(
                duration: AppMotion.fast,
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        ScaleTransition(scale: animation, child: child),
                child: Icon(
                  selected ? tab.selectedIcon : tab.icon,
                  key: ValueKey<bool>(selected),
                  size: 24,
                  color: color,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                tab.label,
                maxLines: 1,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
    return Pressable(
      haptic: true,
      onTap: () => context.go(AppRoutes.addMedicine),
      child: Semantics(
        button: true,
        label: 'Add medicine',
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.add_rounded, color: theme.colorScheme.onPrimary),
              const SizedBox(width: 8),
              Text(
                'Add',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
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
