import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medzee/core/theme/app_theme.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/models/dose.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/models/user_profile.dart';
import 'package:medzee/domain/services/reminder_clock.dart';
import 'package:medzee/presentation/calendar/calendar_screen.dart';
import 'package:medzee/services/dose_service.dart';
import 'package:medzee/services/timezone_service.dart';
import 'package:medzee/state/dose_actions.dart';
import 'package:medzee/state/doses_provider.dart';
import 'package:medzee/state/medications_provider.dart';
import 'package:medzee/state/profile_providers.dart';
import 'package:medzee/state/timezone_providers.dart';

import '../helpers/fakes.dart';

/// A [FakeDoseRepository] that remembers what was removed.
class _RecordingDoses extends FakeDoseRepository {
  final List<String> deleted = <String>[];

  @override
  Future<int> deleteDoses(Iterable<String> doseIds) async {
    deleted.addAll(doseIds);
    return doseIds.length;
  }
}

final DateTime _day = DateTime(2026, 10, 26);

Medication _med(String id, String name) => Medication(
      id: id,
      name: name,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

ScheduledDose _dose(String id, String medId, int minutes, DoseStatus status) =>
    ScheduledDose(
      id: id,
      medicationId: medId,
      phaseId: 'p',
      scheduledAt: DateTime.utc(2026, 10, 26).add(Duration(minutes: minutes)),
      localDate: _day,
      scheduledMinutes: minutes,
      doseQuantity: 1,
      unit: DoseUnit.tablet,
      status: status,
    );

Future<_RecordingDoses> _pump(
  WidgetTester tester,
  List<ScheduledDose> doses,
) async {
  tester.view.physicalSize = const Size(800, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final _RecordingDoses repo = _RecordingDoses();
  final DoseActions actions = DoseActions(
    DoseService(
      doseRepository: repo,
      inventoryRepository: FakeInventoryRepository(),
    ),
    (String id) async => _med(id, id == 'a' ? 'Aspirin' : 'Metformin'),
  );
  // 9 AM on the 26th, so the day under test is "today".
  final ReminderClock clock = ReminderClock(
    FixedOffsetConverter(),
    nowUtc: () => DateTime.utc(2026, 10, 26, 9),
  );

  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext c, GoRouterState s) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/medicines/:id',
        builder: (BuildContext c, GoRouterState s) =>
            const Scaffold(body: Text('detail')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        activeProfileProvider.overrideWithValue(UserProfile.fallback),
        reminderClockProvider.overrideWithValue(clock),
        dosesForDateProvider.overrideWith(
          (Ref ref, DateTime date) => Stream<List<ScheduledDose>>.value(
            date == _day ? doses : const <ScheduledDose>[],
          ),
        ),
        dosesInRangeProvider.overrideWith(
          (Ref ref, ({DateTime from, DateTime to}) range) =>
              Stream<List<ScheduledDose>>.value(doses),
        ),
        medicationProvider.overrideWith(
          (Ref ref, String id) => Stream<Medication?>.value(
            _med(id, id == 'a' ? 'Aspirin' : 'Metformin'),
          ),
        ),
        doseActionsProvider.overrideWithValue(actions),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.light(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  testWidgets('cancelled doses are not counted in the day\'s total',
      (WidgetTester tester) async {
    await _pump(tester, <ScheduledDose>[
      _dose('1', 'a', 8 * 60, DoseStatus.taken),
      _dose('2', 'm', 20 * 60, DoseStatus.pending),
      _dose('3', 'm', 8 * 60, DoseStatus.cancelled),
      _dose('4', 'm', 12 * 60, DoseStatus.cancelled),
    ]);

    expect(find.text('1 of 2 taken'), findsOneWidget,
        reason: 'two live doses; the two cancelled ones do not count');
    expect(find.textContaining('2 cancelled'), findsOneWidget);
  });

  testWidgets('a day with only cancelled doses still lists them',
      (WidgetTester tester) async {
    await _pump(tester, <ScheduledDose>[
      _dose('3', 'm', 8 * 60, DoseStatus.cancelled),
    ]);

    expect(find.text('Nothing scheduled'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('No doses on this day'), findsNothing);
  });

  testWidgets('"Remove" clears every cancelled dose of the day and nothing else',
      (WidgetTester tester) async {
    final _RecordingDoses repo = await _pump(tester, <ScheduledDose>[
      _dose('1', 'a', 8 * 60, DoseStatus.taken),
      _dose('3', 'm', 8 * 60, DoseStatus.cancelled),
      _dose('4', 'm', 12 * 60, DoseStatus.cancelled),
    ]);

    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(repo.deleted, unorderedEquals(<String>['3', '4']));
    expect(find.textContaining('Removed 2 cancelled doses'), findsOneWidget);
  });

  testWidgets('a cancelled dose offers removal, not taking or skipping',
      (WidgetTester tester) async {
    final _RecordingDoses repo = await _pump(tester, <ScheduledDose>[
      _dose('3', 'm', 8 * 60, DoseStatus.cancelled),
    ]);

    await tester.tap(find.text('Cancelled'));
    await tester.pumpAndSettle();

    expect(find.text('Remove from calendar'), findsOneWidget);
    expect(find.text('Mark as taken'), findsNothing);
    expect(find.text('Mark as skipped'), findsNothing);

    await tester.tap(find.text('Remove from calendar'));
    await tester.pumpAndSettle();
    expect(repo.deleted, <String>['3']);
  });

  testWidgets('a live dose still offers the usual actions',
      (WidgetTester tester) async {
    await _pump(tester, <ScheduledDose>[
      _dose('2', 'm', 20 * 60, DoseStatus.pending),
    ]);

    await tester.tap(find.text('Upcoming'));
    await tester.pumpAndSettle();

    expect(find.text('Mark as taken'), findsOneWidget);
    expect(find.text('Remove from calendar'), findsNothing);
  });
}
