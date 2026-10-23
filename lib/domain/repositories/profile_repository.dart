import '../models/user_profile.dart';

/// Persistence contract for the user's profile and preferences.
abstract interface class ProfileRepository {
  Stream<UserProfile?> watchProfile();

  Future<UserProfile?> getProfile();

  Future<void> saveProfile(UserProfile profile);

  Future<void> deleteProfile();
}
