import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'domain/models/user_profile.dart';
import 'services/people/people_controller.dart';
import 'state/profile_providers.dart';
import 'state/providers.dart';
import 'state/timezone_providers.dart';

/// Root widget for one person's session: theme, text scale and the router,
/// plus the few things that must keep running while the app is open.
class MedzeeApp extends ConsumerStatefulWidget {
  const MedzeeApp({super.key, required this.router});

  final GoRouter router;

  @override
  ConsumerState<MedzeeApp> createState() => _MedzeeAppState();
}

class _MedzeeAppState extends ConsumerState<MedzeeApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Reminders are built for one time zone. When that zone changes (travel
    // mode toggled, home zone edited, phone moved) rebuild them for the new
    // one straight away.
    ref.listenManual<String>(reminderZoneIdProvider, (String? before, String after) {
      if (before != null && before != after) {
        ref.read(scheduleServiceProvider).reconcileAll().catchError(
              (Object _) => null,
            );
      }
    });

    ref.listenManual<AsyncValue<UserProfile?>>(
      profileProvider,
      fireImmediately: true,
      (AsyncValue<UserProfile?>? before, AsyncValue<UserProfile?> after) {
        final UserProfile? p = after.value;
        if (p == null) return;
        // Keep the person switcher's name in step with the profile's.
        final PeopleController people = ref.read(peopleControllerProvider);
        people.syncName(ref.read(sessionPersonIdProvider), p.displayName);
        // Everyone gets a home time zone to start with: where they set up.
        if (p.onboardingCompleted && p.timezoneId == null) {
          Future<void>.microtask(() {
            ref.read(profileControllerProvider).update(
                  (UserProfile current) => current.timezoneId == null
                      ? current.copyWith(
                          timezoneId: ref.read(deviceZoneProvider),
                        )
                      : current,
                );
          });
        }
      },
    );

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The phone may have crossed a time zone while the app was in the
    // background. Re-reading it makes reminders follow (or, in travel mode,
    // deliberately not follow) the new zone.
    if (state == AppLifecycleState.resumed) {
      ref.read(deviceZoneProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
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
      routerConfig: widget.router,
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
