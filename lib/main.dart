import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'data/local/app_database.dart';
import 'domain/models/user_profile.dart';
import 'routing/app_router.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'state/profile_providers.dart';
import 'state/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final AppDatabase database = AppDatabase();

  // Firebase is optional: without google-services.json the gateway reports
  // itself unavailable and the app stays fully offline. Attempted before the
  // container so providers receive the resolved instance.
  final FirebaseGateway firebase = await FirebaseGateway.tryInitialize();

  final ProviderContainer container = ProviderContainer(
    overrides: <Override>[
      appDatabaseProvider.overrideWithValue(database),
      firebaseGatewayProvider.overrideWithValue(firebase),
    ],
  );

  // Timezone database first: every reminder scheduling call depends on it.
  await container.read(timezoneServiceProvider).initialize();

  // Notification channels must exist before any schedule is (re)built.
  final NotificationService notifications =
      container.read(notificationServiceProvider);
  await notifications.initialize();

  // Push is best-effort: permission denial or an absent config must never
  // block startup.
  if (firebase.isAvailable && !kIsWeb) {
    container.read(pushServiceProvider).initialize().catchError(
          (Object _) => PushStatus.unavailable,
        );
  }

  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  // Resolve first-run state before building the router. GoRouter evaluates its
  // redirect against whatever the providers hold at creation time, so relying
  // on the async profile stream here could show onboarding to a returning user
  // (and, if they completed it again, create a duplicate profile).
  final UserProfile? storedProfile =
      await container.read(profileRepositoryProvider).getProfile();
  final String initialLocation =
      (storedProfile?.onboardingCompleted ?? false)
          ? AppRoutes.home
          : AppRoutes.onboarding;
  final GoRouter router = createAppRouter(
    rootNavigatorKey: navigatorKey,
    initialLocation: initialLocation,
    // Until the profile stream has emitted, trust the value read from the
    // database above. Falling back to the default profile here would send a
    // returning user back to onboarding on every launch.
    isOnboardingComplete: () {
      final AsyncValue<UserProfile?> live = container.read(profileProvider);
      if (live.hasValue) return live.value?.onboardingCompleted ?? false;
      return storedProfile?.onboardingCompleted ?? false;
    },
  );

  // Route notification action taps into the router. The handler survives
  // branch switches because GoRouter keeps one navigator per shell branch.
  container.read(notificationActionDispatcherProvider).onEvent =
      (NotificationActionEvent event) async {
    final Uri uri = Uri.parse(event.payload.isEmpty ? '/' : event.payload);
    if (uri.pathSegments.isEmpty) return;
    if (uri.pathSegments.first == 'medicines') {
      final String id = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
      if (id.isEmpty) return;
      router.go('/medicines/$id');
      return;
    }
    router.go(AppRoutes.home);
  };

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MedzeeApp(router: router),
    ),
  );

  // Reconcile after the first frame: a reboot, timezone change or missed
  // background execution must never leave the user without reminders. Never
  // blocks startup.
  container.read(scheduleServiceProvider).reconcileAll().catchError(
        (Object _) => null,
      );
  container.read(scheduleChangeServiceProvider).applyDueResumes().catchError(
        (Object _) => 0,
      );
  container.read(cloudSyncControllerProvider).restore().catchError(
        (Object _) => null,
      );
}

/// Root widget: theme, text scale and the router.
class MedzeeApp extends ConsumerWidget {
  const MedzeeApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserProfile profile = ref.watch(activeProfileProvider);

    return MaterialApp.router(
      title: 'Medzee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: switch (profile.themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      },
      routerConfig: router,
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: TextScaler.linear(profile.textScale),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
