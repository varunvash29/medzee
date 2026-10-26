import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../domain/models/user_profile.dart';
import '../../state/profile_providers.dart';
import '../../state/timezone_providers.dart';
import '../shared/app_widgets.dart';
import '../shared/travel_widgets.dart';

/// Where reminders run: on the phone's time zone, or held on the person's own
/// ("home") zone while they travel.
class TimeZoneCard extends ConsumerWidget {
  const TimeZoneCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserProfile profile = ref.watch(activeProfileProvider);
    final String device = ref.watch(deviceZoneProvider);
    final String home = profile.timezoneId ?? device;
    final bool differs = ref.watch(travelStatusProvider).holding;
    final ThemeData theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          SwitchListTile(
            secondary: const Icon(Icons.flight_takeoff_rounded),
            title: const Text('Travel mode'),
            subtitle: Text(
              profile.travelMode
                  ? 'Reminders stay on ${zoneCity(home)} time, wherever your '
                      'phone is'
                  : 'Off. Reminders follow your phone\'s time zone '
                      '(${zoneCity(device)})',
            ),
            value: profile.travelMode,
            onChanged: (bool on) => ref.read(profileControllerProvider).update(
                  (UserProfile p) => p.copyWith(
                    travelMode: on,
                    timezoneId: p.timezoneId ?? device,
                  ),
                ),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.public_rounded),
            title: const Text('My reminder time zone'),
            subtitle: Text(
              '${zoneTitle(home)}. This is the time zone your reminder times '
              'are written in. Travel mode keeps reminders on it.',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () async {
              final String? picked = await pickTimeZone(
                context,
                current: home,
                title: 'My reminder time zone',
              );
              if (picked == null) return;
              await ref
                  .read(profileControllerProvider)
                  .update((UserProfile p) => p.copyWith(timezoneId: picked));
            },
          ),
          if (profile.travelMode) ...<Widget>[
            const Divider(height: 1, indent: 56),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ZoneClocks(homeZoneId: home),
                  if (!differs) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Your phone is on the same time as your reminders right '
                      'now.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
