import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/services/reminder_clock.dart';
import '../../routing/app_router.dart';
import '../../services/timezone_service.dart';
import '../../state/profile_providers.dart';
import '../../state/providers.dart';
import '../../state/timezone_providers.dart';

/// "New York" from "America/New_York".
String zoneCity(String timeZoneId) => TimezoneService.cityOf(timeZoneId);

/// "New York (GMT-05:00)".
String zoneTitle(String timeZoneId) =>
    '${zoneCity(timeZoneId)} (${TimezoneService.offsetLabel(timeZoneId)})';

String _clockText(BuildContext context, DateTime wallClock) =>
    TimeOfDay(hour: wallClock.hour, minute: wallClock.minute).format(context);

/// The time of a dose on the phone's own clock, shown next to the reminder
/// time while travel mode holds reminders on another zone. Shows nothing the
/// rest of the time.
class DeviceTimeNote extends ConsumerWidget {
  const DeviceTimeNote({super.key, required this.scheduledAt, this.style});

  final DateTime scheduledAt;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(travelStatusProvider).holding) {
      return const SizedBox.shrink();
    }
    final DateTime here = ref.watch(deviceClockProvider).wallClock(scheduledAt);
    final DateTime there =
        ref.watch(reminderClockProvider).wallClock(scheduledAt);
    final int dayShift = DateTime(here.year, here.month, here.day)
        .difference(DateTime(there.year, there.month, there.day))
        .inDays;
    final String suffix = dayShift > 0
        ? ' (next day)'
        : dayShift < 0
            ? ' (previous day)'
            : '';
    return Text(
      '${_clockText(context, here)}$suffix your time',
      style: style ??
          Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
    );
  }
}

/// Two clocks side by side: the reminder zone and the phone's. Keeps itself
/// current.
class ZoneClocks extends ConsumerWidget {
  const ZoneClocks({super.key, required this.homeZoneId});

  final String homeZoneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String deviceId = ref.watch(deviceZoneProvider);
    return _Ticker(
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);
        final DateTime now = DateTime.now().toUtc();
        final ReminderClock home = ReminderClock(
          ref.read(timezoneServiceProvider).converterFor(homeZoneId),
        );
        final ReminderClock here = ReminderClock(
          ref.read(timezoneServiceProvider).converterFor(deviceId),
        );
        Widget clock(String label, String zone, DateTime wall) => Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _clockText(context, wall),
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(
                    '$label · ${zoneCity(zone)}',
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                  ),
                ],
              ),
            );
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            clock('Reminders', homeZoneId, home.wallClock(now)),
            const SizedBox(width: AppSpacing.md),
            clock('Here', deviceId, here.wallClock(now)),
          ],
        );
      },
    );
  }
}

/// Rebuilds [builder] every half minute so clocks do not go stale.
class _Ticker extends StatefulWidget {
  const _Ticker({required this.builder});

  final WidgetBuilder builder;

  @override
  State<_Ticker> createState() => _TickerState();
}

class _TickerState extends State<_Ticker> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (Timer _) => mounted ? setState(() {}) : null,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}

/// Home banner for time zones: either confirms that travel mode is holding
/// reminders on home time, or offers to when the phone has moved.
class TravelBanner extends ConsumerWidget {
  const TravelBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TravelStatus travel = ref.watch(travelStatusProvider);
    if (travel.holding) return _holding(context, ref, travel);

    final TravelStatus? offer = ref.watch(zoneChangeOfferProvider);
    final bool dismissed = ref.watch(zoneChangeOfferDismissedProvider);
    if (offer != null && !dismissed) return _offer(context, ref, offer);
    return const SizedBox.shrink();
  }

  Widget _holding(BuildContext context, WidgetRef ref, TravelStatus travel) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Material(
        color: status.warningContainer,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.go(AppRoutes.profile),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.flight_takeoff_rounded, color: status.warning),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Travel mode · reminders on ${zoneCity(travel.homeZoneId)} time',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ZoneClocks(homeZoneId: travel.homeZoneId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _offer(BuildContext context, WidgetRef ref, TravelStatus offer) {
    final ThemeData theme = Theme.of(context);
    final AppStatusColors status = context.statusColors;
    final String home = zoneCity(offer.homeZoneId);
    final String here = zoneCity(offer.deviceZoneId);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Material(
        color: status.warningContainer,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.public_rounded, color: status.warning),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Your phone is on $here time',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Dismiss',
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => ref
                        .read(zoneChangeOfferDismissedProvider.notifier)
                        .state = true,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: Text(
                  'Your reminders were set for $home time. Keep getting them '
                  'on $home time, or follow your phone?',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: <Widget>[
                  FilledButton(
                    onPressed: () => ref
                        .read(profileControllerProvider)
                        .update((UserProfile p) => p.copyWith(travelMode: true)),
                    child: Text('Keep $home time'),
                  ),
                  TextButton(
                    onPressed: () => ref.read(profileControllerProvider).update(
                          (UserProfile p) => p.copyWith(
                            timezoneId: offer.deviceZoneId,
                            travelMode: false,
                          ),
                        ),
                    child: Text('Use $here time'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A searchable list of every time zone. Returns the chosen zone id.
Future<String?> pickTimeZone(
  BuildContext context, {
  required String current,
  String title = 'Choose a time zone',
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext ctx) =>
        _ZonePicker(current: current, title: title),
  );
}

class _ZonePicker extends StatefulWidget {
  const _ZonePicker({required this.current, required this.title});

  final String current;
  final String title;

  @override
  State<_ZonePicker> createState() => _ZonePickerState();
}

class _ZonePickerState extends State<_ZonePicker> {
  final TextEditingController _search = TextEditingController();
  late final List<String> _all = TimezoneService.allTimeZones;
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<String> get _matches {
    final String q = _query.trim().toLowerCase().replaceAll(' ', '_');
    if (q.isEmpty) {
      // Common zones first, then everything else.
      final Set<String> common = TimezoneService.commonTimeZones.toSet();
      return <String>[
        ...TimezoneService.commonTimeZones,
        ..._all.where((String id) => !common.contains(id)),
      ];
    }
    return _all.where((String id) => id.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> matches = _matches;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.gutter,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _search,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: 'Search a city or country',
                      ),
                      onChanged: (String v) => setState(() => _query = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: matches.isEmpty
                    ? const Center(child: Text('No time zone matches that.'))
                    : ListView.builder(
                        itemCount: matches.length,
                        itemBuilder: (BuildContext c, int i) {
                          final String id = matches[i];
                          return ListTile(
                            title: Text(zoneTitle(id)),
                            subtitle: Text(id.replaceAll('_', ' ')),
                            trailing: id == widget.current
                                ? Icon(
                                    Icons.check_rounded,
                                    color: theme.colorScheme.primary,
                                  )
                                : null,
                            onTap: () => Navigator.of(context).pop(id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
