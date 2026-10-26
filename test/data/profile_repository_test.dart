import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/data/local/app_database.dart';
import 'package:medzee/data/mappers.dart';
import 'package:medzee/data/repositories/profile_repository_impl.dart';
import 'package:medzee/domain/models/user_profile.dart';

void main() {
  late AppDatabase db;
  late ProfileRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ProfileRepositoryImpl(db);
  });

  tearDown(() => db.close());

  test('a duplicate profile row does not break reads', () async {
    final UserProfile first = UserProfile(
      id: 'first',
      displayName: 'Asha',
      onboardingCompleted: true,
      createdAt: DateTime.utc(2024, 1, 1),
    );
    final UserProfile second = UserProfile(
      id: 'second',
      displayName: 'Duplicate',
      onboardingCompleted: true,
      createdAt: DateTime.utc(2024, 6, 1),
    );
    await repository.saveProfile(first);
    // Bypass the repository to simulate a row written by an older build.
    await db.into(db.userProfiles).insert(second.toCompanion());

    expect(await repository.getProfile(), isNotNull);
    expect((await repository.getProfile())!.id, 'first');
    expect((await repository.watchProfile().first)!.id, 'first');
  });

  test('saving a profile removes stale duplicate rows', () async {
    final UserProfile first = UserProfile(
      id: 'first',
      onboardingCompleted: true,
      createdAt: DateTime.utc(2024, 1, 1),
    );
    final UserProfile second = UserProfile(
      id: 'second',
      onboardingCompleted: true,
      createdAt: DateTime.utc(2024, 6, 1),
    );
    await db.into(db.userProfiles).insert(first.toCompanion());
    await db.into(db.userProfiles).insert(second.toCompanion());

    await repository.saveProfile(first.copyWith(displayName: 'Updated'));

    final List<UserProfileRow> rows = await db.select(db.userProfiles).get();
    expect(rows, hasLength(1));
    expect(rows.single.id, 'first');
    expect((await repository.getProfile())!.displayName, 'Updated');
  });

  test('travel mode and the home time zone survive a save and reload',
      () async {
    await repository.saveProfile(
      const UserProfile(
        id: 'p',
        timezoneId: 'America/New_York',
        travelMode: true,
        onboardingCompleted: true,
      ),
    );

    final UserProfile? loaded = await repository.getProfile();
    expect(loaded!.travelMode, isTrue);
    expect(loaded.timezoneId, 'America/New_York');

    await repository.saveProfile(loaded.copyWith(travelMode: false));
    expect((await repository.getProfile())!.travelMode, isFalse);
    expect((await repository.getProfile())!.timezoneId, 'America/New_York');
  });

  test('a profile saved before travel mode existed reads as "off"', () async {
    // Raw insert without the new column: it takes the schema default.
    await db.customStatement(
      'INSERT INTO user_profiles (id, time_format, theme_mode, '
      'notifications_enabled, default_reminder_enabled, '
      'missed_follow_up_enabled, missed_follow_up_minutes, '
      'quiet_hours_enabled, quiet_hours_start_minutes, '
      'quiet_hours_end_minutes, daily_summary_enabled, '
      'daily_summary_minutes, notification_privacy, onboarding_completed, '
      "demo_mode, app_lock_enabled, text_scale, appearance) VALUES ('old', "
      "'h12', 'system', 1, 1, 0, 60, 0, 1320, 420, 0, 1200, 'detailed', 1, "
      "0, 0, 1.0, 'tint')",
    );
    final UserProfile? loaded = await repository.getProfile();
    expect(loaded!.travelMode, isFalse);
  });
}
