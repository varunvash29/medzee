import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/user_profile.dart';
import '../domain/repositories/profile_repository.dart';
import 'providers.dart';

/// Live stream of the single local user profile.
///
/// Emits `null` before the first profile row exists (first launch) and the
/// profile thereafter. Nothing in the UI is allowed to assume a profile
/// exists — onboarding owns that transition.
final StreamProvider<UserProfile?> profileProvider =
    StreamProvider<UserProfile?>((Ref ref) {
  return ref.watch(profileRepositoryProvider).watchProfile();
});

/// Non-null profile accessor for screens that have already passed onboarding.
///
/// Falls back to [UserProfile.fallback] so widgets never crash during the
/// first frame before the stream emits.
final Provider<UserProfile> activeProfileProvider =
    Provider<UserProfile>((Ref ref) {
  final UserProfile? profile = ref.watch(profileProvider).value;
  return profile ?? UserProfile.fallback;
});

/// Convenience: whether onboarding has been completed.
final Provider<bool> onboardingCompletedProvider = Provider<bool>(
  (Ref ref) => ref.watch(activeProfileProvider).onboardingCompleted,
);

/// Writes profile updates through the repository.
///
/// Kept as a small controller so callers stay declarative:
/// `ref.read(profileControllerProvider).update(...)`.
class ProfileController {
  ProfileController(this._repository);

  final ProfileRepository _repository;

  /// Loads the current profile, applies [transform] and saves the result.
  /// No-op when no profile exists yet (onboarding must create it first).
  Future<void> update(UserProfile Function(UserProfile) transform) async {
    final UserProfile? current = await _repository.getProfile();
    if (current == null) return;
    await _repository.saveProfile(transform(current));
  }

  Future<void> save(UserProfile profile) => _repository.saveProfile(profile);
}

final Provider<ProfileController> profileControllerProvider =
    Provider<ProfileController>(
  (Ref ref) => ProfileController(ref.watch(profileRepositoryProvider)),
);
