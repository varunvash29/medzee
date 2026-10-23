import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'notification_action_dispatcher.dart';
import 'notification_service.dart';

/// Feature-detected Firebase gateway.
///
/// Medzee is offline-first: reminders are local exact alarms, data never
/// leaves the device, and nothing clinical depends on a server. Firebase is an
/// *optional* add-on for future caregiver/sync features. Without a valid
/// `google-services.json`, [FirebaseGateway.isAvailable] is false and every
/// dependent service reports itself unavailable — startup never breaks.
class FirebaseGateway {
  const FirebaseGateway._(this._initialized);

  final bool _initialized;

  /// Whether a usable Firebase app exists on this install.
  bool get isAvailable => _initialized;

  /// Attempts to initialise Firebase. Any configuration problem (missing or
  /// invalid `google-services.json`, no Play services, offline first run)
  /// degrades to an unavailable gateway instead of crashing startup.
  static Future<FirebaseGateway> tryInitialize() async {
    try {
      await Firebase.initializeApp();
      debugPrint('Firebase: initialised.');
      return const FirebaseGateway._(true);
    } catch (error) {
      debugPrint('Firebase: unavailable ($error). Continuing fully offline.');
      return const FirebaseGateway._(false);
    }
  }
}

/// FCM push channel.
///
/// This is intentionally *not* used for dose reminders — local exact alarms
/// are precise, private, and work offline. FCM is the seam for future
/// caregiver alerts and sync nudges.
class PushService {
  PushService(this._gateway, this._dispatcher);

  final FirebaseGateway _gateway;
  final NotificationActionDispatcher _dispatcher;

  FirebaseMessaging? get _messaging =>
      _gateway.isAvailable ? FirebaseMessaging.instance : null;

  StreamSubscription<RemoteMessage>? _foregroundSub;

  /// Whether push is wired up on this install.
  bool get isAvailable => _gateway.isAvailable;

  /// Requests permission and wires message handling. No-op when Firebase is
  /// unavailable; permission denial is reported, not fatal.
  Future<PushStatus> initialize() async {
    final FirebaseMessaging? messaging = _messaging;
    if (messaging == null) return PushStatus.unavailable;

    final NotificationSettings settings =
        await messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      return PushStatus.denied;
    }

    // Foreground messages whose payload is an app route navigate through the
    // same dispatcher as local notification taps.
    _foregroundSub ??=
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    if (kDebugMode) {
      // Setup aid only: prints the registration token so it can be pasted into
      // the Firebase console's "Send test message" dialog. Never runs in a
      // release build.
      unawaited(debugRegistrationToken());
    }

    return PushStatus.ready;
  }

  /// Registers this install with FCM and returns its registration token.
  ///
  /// Debug builds only — the token is a device credential and is deliberately
  /// never surfaced (or logged) in release. Returns null when Firebase is
  /// unavailable or registration fails.
  Future<String?> debugRegistrationToken() async {
    if (!kDebugMode) return null;
    final FirebaseMessaging? messaging = _messaging;
    if (messaging == null) return null;
    try {
      // NOTE: do NOT call register() first. `register()` belongs to the newer
      // installation-ID API and, once used, disables the legacy token API.
      // The console's "send test message" dialog still takes a registration
      // token, which only getToken() returns.
      // ignore: deprecated_member_use
      final String? token = await messaging.getToken();
      debugPrint('FCM token (debug): $token');
      return token;
    } catch (error) {
      debugPrint('FCM token (debug): unavailable ($error).');
      return null;
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final String payload = message.data['payload'] as String? ?? '';
    debugPrint('FCM foreground message: data=${message.data}');
    _dispatcher.dispatch(
      NotificationActionEvent(actionId: 'fcm', payload: payload),
    );
  }

  Future<void> dispose() async => _foregroundSub?.cancel();
}

/// Whether the push channel could be activated.
enum PushStatus { ready, denied, unavailable }

/// Anonymous-auth seam.
///
/// Provides a stable per-install identity that a future caregiver/sync
/// feature can scope data to. No personal data is attached to the account.
class FirebaseAuthService {
  FirebaseAuthService(this._gateway);

  final FirebaseGateway _gateway;

  fb.FirebaseAuth? get _auth =>
      _gateway.isAvailable ? fb.FirebaseAuth.instance : null;

  bool get isAvailable => _gateway.isAvailable;

  /// The current anonymous uid, or null when signed out / unavailable.
  String? get currentUid => _auth?.currentUser?.uid;

  /// Emits the uid whenever the auth state changes; emits null when Firebase
  /// is unavailable.
  Stream<String?> authStateChanges() {
    final fb.FirebaseAuth? auth = _auth;
    if (auth == null) return const Stream<String?>.empty();
    return auth.authStateChanges().map((fb.User? user) => user?.uid);
  }

  /// Signs in anonymously. Returns the uid, or null when Firebase is
  /// unavailable or the request fails — callers must degrade gracefully.
  Future<String?> ensureSignedIn() async {
    final fb.FirebaseAuth? auth = _auth;
    if (auth == null) return null;
    try {
      final fb.User? existing = auth.currentUser;
      if (existing != null) return existing.uid;
      final fb.UserCredential credential = await auth.signInAnonymously();
      return credential.user?.uid;
    } catch (error) {
      debugPrint('Firebase auth: sign-in failed ($error).');
      return null;
    }
  }

  Future<void> signOut() async => _auth?.signOut();
}
