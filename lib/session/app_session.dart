import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/local/app_database.dart';
import '../domain/models/user_profile.dart';
import '../routing/app_router.dart';
import '../services/firebase_service.dart';
import '../services/notification_action_dispatcher.dart';
import '../services/notification_service.dart';
import '../services/people/people_controller.dart';
import '../state/profile_providers.dart';
import '../state/providers.dart';
import 'other_people.dart';

/// Everything that belongs to one person while they are using the app: their
/// database, the provider graph built on it and the router.
///
/// Switching person closes one session and opens another, so nothing a person
/// sees, schedules or syncs can leak into someone else's.
class AppSession {
  AppSession._({
    required this.person,
    required this.database,
    required this.container,
    required this.router,
  });

  final Person person;
  final AppDatabase database;
  final ProviderContainer container;
  final GoRouter router;

  /// Opens [person]'s data and gets the app ready to show it.
  static Future<AppSession> open({
    required Person person,
    required FirebaseGateway firebase,
    required NotificationActionDispatcher dispatcher,
    required PeopleController people,
  }) async {
    final AppDatabase database = AppDatabase(name: person.databaseName);
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        appDatabaseProvider.overrideWithValue(database),
        firebaseGatewayProvider.overrideWithValue(firebase),
        notificationActionDispatcherProvider.overrideWithValue(dispatcher),
        peopleControllerProvider.overrideWithValue(people),
        syncStorageSuffixProvider.overrideWithValue(person.storageSuffix),
        sessionPersonIdProvider.overrideWithValue(person.id),
      ],
    );

    // Timezone database first: every reminder scheduling call depends on it.
    await container.read(timezoneServiceProvider).initialize();

    // Notification channels must exist before any schedule is (re)built.
    await container.read(notificationServiceProvider).initialize();

    // Resolve first-run state before building the router. GoRouter evaluates
    // its redirect against whatever the providers hold at creation time, so
    // relying on the async profile stream here could show onboarding to a
    // returning user (and, if they completed it again, create a duplicate
    // profile).
    final UserProfile? storedProfile =
        await container.read(profileRepositoryProvider).getProfile();
    // Reminders need the profile (travel mode lives there) before the first
    // reconcile, or they would briefly be built for the wrong time zone.
    await container.read(profileProvider.future);

    final GlobalKey<NavigatorState> navigatorKey =
        GlobalKey<NavigatorState>(debugLabel: 'root-${person.id}');
    final GoRouter router = createAppRouter(
      rootNavigatorKey: navigatorKey,
      initialLocation: (storedProfile?.onboardingCompleted ?? false)
          ? AppRoutes.home
          : AppRoutes.onboarding,
      // Until the profile stream has emitted, trust the value read from the
      // database above. Falling back to the default profile here would send a
      // returning user back to onboarding on every launch.
      isOnboardingComplete: () {
        final AsyncValue<UserProfile?> live = container.read(profileProvider);
        if (live.hasValue) return live.value?.onboardingCompleted ?? false;
        return storedProfile?.onboardingCompleted ?? false;
      },
    );

    // Route notification action taps into this session's router. The handler
    // survives branch switches because GoRouter keeps one navigator per shell
    // branch.
    dispatcher.onEvent = (NotificationActionEvent event) async {
      final Uri uri = Uri.parse(event.payload.isEmpty ? '/' : event.payload);
      if (uri.pathSegments.isEmpty) return;
      if (uri.pathSegments.first == 'medicines') {
        final String id =
            uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
        if (id.isEmpty) return;
        router.go('/medicines/$id');
        return;
      }
      router.go(AppRoutes.home);
    };

    return AppSession._(
      person: person,
      database: database,
      container: container,
      router: router,
    );
  }

  /// Work that must never block the first frame: rebuilding reminders after a
  /// reboot, time zone change or missed background run, resuming paused
  /// medicines, reconnecting sync and keeping everyone else's reminders alive.
  void startBackgroundWork(PeopleController people) {
    container.read(scheduleServiceProvider).reconcileAll().catchError(
          (Object _) => null,
        );
    container.read(scheduleChangeServiceProvider).applyDueResumes().catchError(
          (Object _) => 0,
        );
    container.read(cloudSyncControllerProvider).restore().catchError(
          (Object _) => null,
        );
    if (people.hasSeveral) {
      OtherPeople.reconcile(
        people: people.people,
        active: person,
        notifications: container.read(notificationServiceProvider),
      ).catchError((Object _) => null);
    }
  }

  /// Shuts this person's data down. The widget tree using [container] must
  /// already be gone.
  Future<void> close() async {
    container.dispose();
    await database.close();
  }
}
