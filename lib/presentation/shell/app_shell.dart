import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Hosts the five primary tabs behind a flat, standard navigation bar.
///
/// Each branch keeps its own state, so switching tabs never resets scroll
/// position or typed text. Nothing floats above the content: screens that
/// need an "add" action put it in their own header or empty state.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const List<NavigationDestination> _tabs = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.medication_outlined),
      selectedIcon: Icon(Icons.medication_rounded),
      label: 'Meds',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_month_outlined),
      selectedIcon: Icon(Icons.calendar_month_rounded),
      label: 'Calendar',
    ),
    NavigationDestination(
      icon: Icon(Icons.auto_awesome_outlined),
      selectedIcon: Icon(Icons.auto_awesome_rounded),
      label: 'Assistant',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex.clamp(0, _tabs.length - 1),
        destinations: _tabs,
        onDestinationSelected: (int i) {
          HapticFeedback.selectionClick();
          shell.goBranch(i, initialLocation: i == shell.currentIndex);
        },
      ),
    );
  }
}
