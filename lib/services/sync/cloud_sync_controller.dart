import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/local/app_database.dart';
import '../firebase_service.dart';
import 'cloud_sync_engine.dart';
import 'sync_remote.dart';

/// Owns the vault id, the on/off switch and the lifetime of the
/// [CloudSyncEngine].
///
/// The vault id is a random 128-bit value; it is the only thing needed to
/// reach the data (see `firestore.rules`). It is kept in secure storage and
/// shown to the user so a second device can join.
class CloudSyncController extends ChangeNotifier {
  CloudSyncController(
    this._db,
    this._gateway,
    this._auth, {
    required Future<void> Function() onRemoteApplied,
    FlutterSecureStorage storage = const FlutterSecureStorage(),
    String storageSuffix = '',
  })  : _storage = storage,
        _onRemoteApplied = onRemoteApplied,
        _vaultKey = 'medzee_vault_id$storageSuffix',
        _enabledKey = 'medzee_sync_enabled$storageSuffix';

  /// Each person on a shared device has their own vault, kept under their own
  /// keys. The first person's keys have no suffix, so existing installs keep
  /// their sync code.
  final String _vaultKey;
  final String _enabledKey;
  static final RegExp _vaultFormat = RegExp(r'^[0-9a-f]{32}$');

  final AppDatabase _db;
  final FirebaseGateway _gateway;
  final FirebaseAuthService _auth;
  final FlutterSecureStorage _storage;
  final Future<void> Function() _onRemoteApplied;

  CloudSyncEngine? _engine;
  String? _vaultId;
  bool _enabled = false;
  String? _lastError;

  bool get isAvailable => _gateway.isAvailable;
  bool get isEnabled => _enabled;
  String? get vaultId => _vaultId;
  String? get lastError => _lastError;
  SyncPhase get phase => _engine?.phase.value ?? SyncPhase.off;
  DateTime? get lastSync => _engine?.lastSync.value;

  /// Re-opens sync on app start if it was switched on before.
  Future<void> restore() async {
    if (!isAvailable) return;
    try {
      _vaultId = await _storage.read(key: _vaultKey);
      _enabled = (await _storage.read(key: _enabledKey)) == 'true' &&
          _vaultId != null;
    } catch (_) {
      _enabled = false;
    }
    if (_enabled) await _startEngine();
    notifyListeners();
  }

  /// Turns sync on with a new vault (first device).
  Future<void> enableNewVault() async {
    _vaultId ??= _newVaultId();
    await _persist(enabled: true);
    await _startEngine();
  }

  /// Joins an existing vault from another device. Local data is replaced by
  /// the cloud copy so the two histories never mix.
  Future<bool> joinVault(String code) async {
    final String id = code.trim().toLowerCase();
    if (!_vaultFormat.hasMatch(id)) {
      _lastError = 'That code is not valid. It is 32 letters and numbers.';
      notifyListeners();
      return false;
    }
    await _stopEngine();
    _vaultId = id;
    await _persist(enabled: true);
    final CloudSyncEngine engine = _buildEngine();
    await engine.wipeLocal();
    _engine = engine;
    await _begin(engine);
    return true;
  }

  Future<void> disable() async {
    await _stopEngine();
    await _persist(enabled: false);
    notifyListeners();
  }

  Future<void> _startEngine() async {
    await _stopEngine();
    final CloudSyncEngine engine = _buildEngine();
    _engine = engine;
    await _begin(engine);
  }

  CloudSyncEngine _buildEngine() => CloudSyncEngine(
        _db,
        FirestoreSyncRemote(_vaultId!),
        onRemoteApplied: _onRemoteApplied,
      );

  Future<void> _begin(CloudSyncEngine engine) async {
    _lastError = null;
    final String? uid = await _auth.ensureSignedIn();
    if (uid == null) {
      _lastError = 'Could not reach Firebase. Check your connection and that '
          'Anonymous sign-in is enabled.';
      notifyListeners();
      return;
    }
    engine.phase.addListener(notifyListeners);
    engine.lastSync.addListener(notifyListeners);
    await engine.start();
    notifyListeners();
  }

  @override
  void dispose() {
    // The person was switched or the app is closing: stop talking to the cloud
    // for them. Listeners go first so nothing notifies a disposed controller.
    final CloudSyncEngine? engine = _engine;
    _engine = null;
    if (engine != null) {
      engine.phase.removeListener(notifyListeners);
      engine.lastSync.removeListener(notifyListeners);
      engine.stop();
    }
    super.dispose();
  }

  Future<void> _stopEngine() async {
    final CloudSyncEngine? engine = _engine;
    _engine = null;
    if (engine != null) {
      engine.phase.removeListener(notifyListeners);
      engine.lastSync.removeListener(notifyListeners);
      await engine.stop();
    }
  }

  Future<void> _persist({required bool enabled}) async {
    _enabled = enabled;
    try {
      if (_vaultId != null) {
        await _storage.write(key: _vaultKey, value: _vaultId);
      }
      await _storage.write(key: _enabledKey, value: enabled.toString());
    } catch (e) {
      debugPrint('Sync: could not persist settings ($e)');
    }
  }

  static String _newVaultId() {
    final Random rng = Random.secure();
    return List<String>.generate(
      16,
      (_) => rng.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }
}
