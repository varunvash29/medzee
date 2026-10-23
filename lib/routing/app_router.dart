import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/assistant/assistant_screen.dart';
import '../presentation/calendar/calendar_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/insights/insights_screen.dart';
import '../presentation/medicines/add_medicine_screen.dart';
import '../presentation/medicines/medicine_detail_screen.dart';
import '../presentation/medicines/medicines_screen.dart';
import '../presentation/onboarding/onboarding_screen.dart';
import '../presentation/prescription/scan_prescription_screen.dart';
import '../presentation/profile/profile_screen.dart';
import '../presentation/shell/app_shell.dart';

/// Route paths. Kept in one place so navigation and tests agree.
abstract final class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String medicines = '/medicines';
  static const String calendar = '/calendar';
  static const String insights = '/insights';
  static const String profile = '/profile';
  static const String addMedicine = '/medicines/new';
  static const String scanPrescription = '/medicines/scan';
  static const String assistant = '/assistant';
  static const String medicineDetail = '/medicines/:id';
}

/// Builds the app's [GoRouter].
///
/// [initialLocation] is a parameter so tests can start at any screen without
/// touching global state. [isOnboardingComplete] gates the redirect so a
/// returning user never sees the first-run flow.
GoRouter createAppRouter({
  required GlobalKey<NavigatorState> rootNavigatorKey,
  String initialLocation = AppRoutes.home,
  bool Function()? isOnboardingComplete,
}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    debugLogDiagnostics: false,
    redirect: (BuildContext context, GoRouterState state) {
      final bool Function()? check = isOnboardingComplete;
      if (check == null) return null;
      final bool complete = check();
      final bool onOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!complete && !onOnboarding) return AppRoutes.onboarding;
      if (complete && onOnboarding) return AppRoutes.home;
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.insights,
        builder: (BuildContext context, GoRouterState state) =>
            const InsightsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell shell) {
          return AppShell(shell: shell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.medicines,
                routes: <RouteBase>[
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) =>
                        const AddMedicineScreen(),
                  ),
                  GoRoute(
                    path: 'scan',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) =>
                        const ScanPrescriptionScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) =>
                        MedicineDetailScreen(
                      medicationId: state.pathParameters['id'] ?? '',
                    ),
                  ),
                ],
                builder: (BuildContext context, GoRouterState state) =>
                    const MedicinesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.calendar,
                builder: (BuildContext context, GoRouterState state) =>
                    const CalendarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.assistant,
                builder: (BuildContext context, GoRouterState state) =>
                    const AssistantScreen(embedded: true),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.profile,
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        Scaffold(
      body: Center(
        child: Text('Screen not found: ${state.uri}'),
      ),
    ),
  );
}
