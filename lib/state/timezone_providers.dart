import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/user_profile.dart';
import '../domain/services/local_time_converter.dart';
import '../domain/services/reminder_clock.dart';
import '../services/timezone_service.dart';
import 'profile_providers.dart';
import 'providers.dart';

/// Where the phone is right now. Refreshed when the app returns to the
/// foreground, because the phone may have crossed a time zone meanwhile.
final NotifierProvider<DeviceZoneNotifier, String> deviceZoneProvider =
    NotifierProvider<DeviceZoneNotifier, String>(DeviceZoneNotifier.new);

class DeviceZoneNotifier extends Notifier<String> {
  @override
  String build() => ref.read(timezoneServiceProvider).deviceZoneId;

  Future<void> refresh() async {
    final String id = await ref.read(timezoneServiceProvider).refreshDeviceZone();
    if (id != state) state = id;
  }
}

/// The zone this person's reminders run on: the phone's, unless travel mode is
/// holding them on their home zone.
final Provider<String> reminderZoneIdProvider = Provider<String>((Ref ref) {
  final UserProfile profile = ref.watch(activeProfileProvider);
  return ReminderZone.effectiveId(
    deviceId: ref.watch(deviceZoneProvider),
    homeId: profile.timezoneId,
    travelMode: profile.travelMode,
  );
});

final Provider<LocalTimeConverter> reminderConverterProvider =
    Provider<LocalTimeConverter>(
  (Ref ref) => ref
      .watch(timezoneServiceProvider)
      .converterFor(ref.watch(reminderZoneIdProvider)),
);

/// "Now" and "today" in the reminder zone.
final Provider<ReminderClock> reminderClockProvider = Provider<ReminderClock>(
  (Ref ref) => ReminderClock(ref.watch(reminderConverterProvider)),
);

/// The phone's own clock, for showing "here" times next to reminder times.
final Provider<ReminderClock> deviceClockProvider = Provider<ReminderClock>(
  (Ref ref) => ReminderClock(
    ref
        .watch(timezoneServiceProvider)
        .converterFor(ref.watch(deviceZoneProvider)),
  ),
);

/// What the Home screen and dose rows need to show two clocks.
class TravelStatus {
  const TravelStatus({
    required this.holding,
    required this.homeZoneId,
    required this.deviceZoneId,
  });

  /// Travel mode is on and the phone is in a different zone from the reminders.
  final bool holding;
  final String homeZoneId;
  final String deviceZoneId;

  static const TravelStatus off =
      TravelStatus(holding: false, homeZoneId: '', deviceZoneId: '');
}

final Provider<TravelStatus> travelStatusProvider =
    Provider<TravelStatus>((Ref ref) {
  final UserProfile profile = ref.watch(activeProfileProvider);
  final String device = ref.watch(deviceZoneProvider);
  final String? home = profile.timezoneId;
  final bool holding = ReminderZone.isHolding(
    deviceId: device,
    homeId: home,
    travelMode: profile.travelMode,
  );
  if (!holding) return TravelStatus.off;
  // Same offset right now (say New York and Toronto): nothing to show.
  if (TimezoneService.offsetOf(home!) == TimezoneService.offsetOf(device)) {
    return TravelStatus.off;
  }
  return TravelStatus(holding: true, homeZoneId: home, deviceZoneId: device);
});

/// Set when the phone is in a different time zone from the person's home zone
/// and travel mode is off, so Home can offer to keep reminders on home time.
final Provider<TravelStatus?> zoneChangeOfferProvider =
    Provider<TravelStatus?>((Ref ref) {
  final UserProfile profile = ref.watch(activeProfileProvider);
  final String device = ref.watch(deviceZoneProvider);
  final String? home = profile.timezoneId;
  if (profile.travelMode || home == null || home == device) return null;
  if (TimezoneService.offsetOf(home) == TimezoneService.offsetOf(device)) {
    return null;
  }
  return TravelStatus(holding: false, homeZoneId: home, deviceZoneId: device);
});

/// The offer is shown once per app session; closing it hides it until then.
final StateProvider<bool> zoneChangeOfferDismissedProvider =
    StateProvider<bool>((Ref ref) => false);
