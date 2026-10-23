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
}
