import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medzee/core/theme/app_theme.dart';
import 'package:medzee/domain/models/user_profile.dart';
import 'package:medzee/domain/repositories/profile_repository.dart';
import 'package:medzee/presentation/shared/travel_widgets.dart';
import 'package:medzee/state/profile_providers.dart';
import 'package:medzee/state/timezone_providers.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;

/// A device zone fixed for the test (the real notifier reads the platform).
class _FixedDeviceZone extends DeviceZoneNotifier {
  _FixedDeviceZone(this._id);

  final String _id;

  @override
  String build() => _id;
}

class _RecordingProfile extends ProfileController {
  _RecordingProfile() : super(_NoRepo());

  final List<UserProfile Function(UserProfile)> updates =
      <UserProfile Function(UserProfile)>[];

  @override
  Future<void> update(UserProfile Function(UserProfile) transform) async {
    updates.add(transform);
  }
}

class _NoRepo extends Mock implements ProfileRepository {}

Future<_RecordingProfile> _pump(
  WidgetTester tester, {
  required UserProfile profile,
  required String device,
}) async {
  final _RecordingProfile controller = _RecordingProfile();
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        activeProfileProvider.overrideWithValue(profile),
        deviceZoneProvider.overrideWith(() => _FixedDeviceZone(device)),
        profileControllerProvider.overrideWithValue(controller),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: TravelBanner()),
      ),
    ),
  );
  await tester.pump();
  return controller;
}

void main() {
  noteTests();
  setUpAll(tz_data.initializeTimeZones);

  testWidgets('says nothing when the phone is where the reminders are',
      (WidgetTester tester) async {
    await _pump(
      tester,
      profile: const UserProfile(id: 'p', timezoneId: 'America/New_York'),
      device: 'America/New_York',
    );
    expect(find.textContaining('Travel mode'), findsNothing);
    expect(find.textContaining('Your phone is on'), findsNothing);
  });

  testWidgets('offers travel mode when the phone has moved to another zone',
      (WidgetTester tester) async {
    final _RecordingProfile controller = await _pump(
      tester,
      profile: const UserProfile(id: 'p', timezoneId: 'America/New_York'),
      device: 'Asia/Kolkata',
    );
    expect(find.text('Your phone is on Kolkata time'), findsOneWidget);

    await tester.tap(find.text('Keep New York time'));
    await tester.pump();

    final UserProfile result = controller.updates.single(
      const UserProfile(id: 'p', timezoneId: 'America/New_York'),
    );
    expect(result.travelMode, isTrue);
    expect(result.timezoneId, 'America/New_York');
  });

  testWidgets('"Use ... time" makes the new place the home zone',
      (WidgetTester tester) async {
    final _RecordingProfile controller = await _pump(
      tester,
      profile: const UserProfile(id: 'p', timezoneId: 'America/New_York'),
      device: 'Asia/Kolkata',
    );
    await tester.tap(find.text('Use Kolkata time'));
    await tester.pump();

    final UserProfile result = controller.updates.single(
      const UserProfile(id: 'p', timezoneId: 'America/New_York'),
    );
    expect(result.timezoneId, 'Asia/Kolkata');
    expect(result.travelMode, isFalse);
  });

  testWidgets('the offer can be dismissed', (WidgetTester tester) async {
    await _pump(
      tester,
      profile: const UserProfile(id: 'p', timezoneId: 'America/New_York'),
      device: 'Asia/Kolkata',
    );
    await tester.tap(find.byTooltip('Dismiss'));
    await tester.pump();
    expect(find.textContaining('Your phone is on'), findsNothing);
  });

  testWidgets('with travel mode on, shows both clocks',
      (WidgetTester tester) async {
    await _pump(
      tester,
      profile: const UserProfile(
        id: 'p',
        timezoneId: 'America/New_York',
        travelMode: true,
      ),
      device: 'Asia/Kolkata',
    );
    expect(
      find.text('Travel mode · reminders on New York time'),
      findsOneWidget,
    );
    expect(find.textContaining('Reminders · New York'), findsOneWidget);
    expect(find.textContaining('Here · Kolkata'), findsOneWidget);
  });

  testWidgets('same offset in both places: nothing to show',
      (WidgetTester tester) async {
    // New York and Toronto keep the same time, so travel mode has no effect.
    await _pump(
      tester,
      profile: const UserProfile(
        id: 'p',
        timezoneId: 'America/New_York',
        travelMode: true,
      ),
      device: 'America/Toronto',
    );
    expect(find.textContaining('Travel mode'), findsNothing);
  });
}

Future<void> _pumpNote(
  WidgetTester tester, {
  required DateTime scheduledAt,
  required bool travelMode,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        activeProfileProvider.overrideWithValue(
          UserProfile(
            id: 'p',
            timezoneId: 'America/New_York',
            travelMode: travelMode,
          ),
        ),
        deviceZoneProvider.overrideWith(() => _FixedDeviceZone('Asia/Kolkata')),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: DeviceTimeNote(scheduledAt: scheduledAt)),
      ),
    ),
  );
  await tester.pump();
}

void noteTests() {
  group('DeviceTimeNote', () {
    testWidgets('shows the time on the phone\'s clock next to the reminder',
        (WidgetTester tester) async {
      // 8:00 AM in New York (EDT) is 12:00 UTC, which is 5:30 PM in Kolkata.
      await _pumpNote(
        tester,
        scheduledAt: DateTime.utc(2026, 10, 26, 12),
        travelMode: true,
      );
      expect(find.text('5:30 PM your time'), findsOneWidget);
    });

    testWidgets('says when the phone is already on the next day',
        (WidgetTester tester) async {
      // 8:00 PM in New York is 05:30 the next morning in Kolkata.
      await _pumpNote(
        tester,
        scheduledAt: DateTime.utc(2026, 10, 27, 0),
        travelMode: true,
      );
      expect(find.text('5:30 AM (next day) your time'), findsOneWidget);
    });

    testWidgets('is silent when travel mode is off',
        (WidgetTester tester) async {
      await _pumpNote(
        tester,
        scheduledAt: DateTime.utc(2026, 10, 26, 12),
        travelMode: false,
      );
      expect(find.textContaining('your time'), findsNothing);
    });
  });
}
