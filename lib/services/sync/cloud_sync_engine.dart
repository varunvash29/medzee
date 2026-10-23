import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../data/local/app_database.dart';
import 'sync_remote.dart';

/// Where the sync engine is at.
enum SyncPhase { off, connecting, live, error }

/// Two-way mirror between the local SQLite tables and a [SyncRemote].
///
/// Works on raw rows (`SELECT *` / upsert by column name), so every synced
/// table is handled the same way and nothing here knows about medicines.
/// Local stays the source of truth for the UI and for reminders; the cloud is
/// a replica other devices read from.
///
/// Conflict rule: per row, the most recent change wins. Where a table has an
/// `updated_at` column the newer value wins; otherwise the latest arrival does.
class CloudSyncEngine {
  CloudSyncEngine(this._db, this._remote, {this.onRemoteApplied});

  /// Parents before children.
  static const List<String> tables = <String>[
    'user_profiles',
    'medications',
    'schedule_phases',
    'scheduled_doses',
    'dose_logs',
    'inventories',
    'inventory_transactions',
    'notification_preferences',
    'refill_reminders',
  ];

  final AppDatabase _db;
  final SyncRemote _remote;

  /// Called after rows from another device were written locally, so the app
  /// can rebuild reminders.
  final Future<void> Function()? onRemoteApplied;

  final ValueNotifier<SyncPhase> phase = ValueNotifier<SyncPhase>(SyncPhase.off);
  final ValueNotifier<DateTime?> lastSync = ValueNotifier<DateTime?>(null);

  final Map<String, Map<String, String>> _known =
      <String, Map<String, String>>{};
  final Map<String, Set<String>> _localIds = <String, Set<String>>{};

  /// Completes once the first cloud snapshot of a table has been applied.
  /// Local pushes wait for it so a re-joining device cannot overwrite newer
  /// cloud rows it has not received yet.
  final Map<String, Completer<void>> _remoteReady =
      <String, Completer<void>>{};
  final List<StreamSubscription<Object?>> _subs =
      <StreamSubscription<Object?>>[];

  /// Serialises writes into the local database.
  Future<void> _applyQueue = Future<void>.value();
  Timer? _reschedule;

  Future<void> start() async {
    if (_subs.isNotEmpty) return;
    phase.value = SyncPhase.connecting;
    for (final String table in tables) {
      _known[table] = <String, String>{};
      _localIds[table] = <String>{};
      final Completer<void> ready = _remoteReady[table] = Completer<void>();
      final TableInfo<Table, dynamic> info = _info(table);

      _subs.add(
        _remote.changes(table).listen(
          (List<RemoteChange> batch) {
            _applyQueue = _applyQueue
                .then((_) => _applyRemote(table, batch))
                .whenComplete(() {
              if (!ready.isCompleted) ready.complete();
            });
          },
          onError: (Object e) {
            debugPrint('Sync: remote $table failed ($e)');
            phase.value = SyncPhase.error;
          },
        ),
      );
      _subs.add(
        _db
            .customSelect('SELECT * FROM $table', readsFrom: {info})
            .watch()
            .listen((_) {
          ready.future
              .timeout(const Duration(seconds: 8), onTimeout: () {})
              .then((_) {
            _applyQueue = _applyQueue.then((_) => _pushLocal(table));
          });
        }),
      );
    }
    phase.value = SyncPhase.live;
  }

  Future<void> stop() async {
    for (final StreamSubscription<Object?> s in _subs) {
      await s.cancel();
    }
    _subs.clear();
    _reschedule?.cancel();
    phase.value = SyncPhase.off;
  }

  /// Deletes every synced row on this device (used when joining an existing
  /// cloud vault so the two histories do not mix). Call before [start].
  Future<void> wipeLocal() async {
    await _db.customStatement('PRAGMA foreign_keys = OFF');
    try {
      for (final String table in tables.reversed) {
        await _db.customUpdate(
          'DELETE FROM $table',
          updates: {_info(table)},
          updateKind: UpdateKind.delete,
        );
      }
    } finally {
      await _db.customStatement('PRAGMA foreign_keys = ON');
    }
  }

  TableInfo<Table, dynamic> _info(String table) => _db.allTables.firstWhere(
        (TableInfo<Table, dynamic> t) => t.actualTableName == table,
      );

  static String hashRow(Map<String, Object?> data) {
    final List<String> keys = data.keys.toList()..sort();
    final String json = jsonEncode(<Object?>[
      for (final String k in keys) <Object?>[k, data[k]],
    ]);
    return md5.convert(utf8.encode(json)).toString();
  }

  /// Pushes local changes. The emitted snapshot is only a trigger: pushes are
  /// queued behind remote applies, so the table is re-read here. Acting on a
  /// stale snapshot would treat a row that was just synced in as "deleted
  /// locally" and bounce it between devices.
  Future<void> _pushLocal(String table) async {
    final List<QueryRow> rows =
        await _db.customSelect('SELECT * FROM $table').get();
    final Map<String, String> known = _known[table]!;
    final Set<String> previous = _localIds[table]!;
    final Set<String> current = <String>{};
    try {
      for (final QueryRow row in rows) {
        final Map<String, Object?> data = Map<String, Object?>.from(row.data);
        final String id = data['id']! as String;
        current.add(id);
        final String hash = hashRow(data);
        if (known[id] == hash) continue;
        known[id] = hash;
        await _remote.upsert(table, id, data, hash);
      }
      for (final String gone in previous.difference(current)) {
        known.remove(gone);
        await _remote.delete(table, gone);
      }
      _localIds[table] = current;
      lastSync.value = DateTime.now();
      if (phase.value == SyncPhase.error) phase.value = SyncPhase.live;
    } catch (e) {
      debugPrint('Sync: push $table failed ($e)');
      known.clear(); // retry everything on the next local change
      phase.value = SyncPhase.error;
    }
  }

  Future<void> _applyRemote(String table, List<RemoteChange> batch) async {
    if (batch.isEmpty) return;
    final Map<String, String> known = _known[table]!;
    bool wrote = false;
    await _db.customStatement('PRAGMA foreign_keys = OFF');
    try {
      for (final RemoteChange change in batch) {
        if (change.removed) {
          if (!known.containsKey(change.id)) continue;
          known.remove(change.id);
          _localIds[table]!.remove(change.id);
          await _db.customUpdate(
            'DELETE FROM $table WHERE id = ?',
            variables: <Variable<Object>>[Variable<String>(change.id)],
            updates: {_info(table)},
            updateKind: UpdateKind.delete,
          );
          wrote = true;
          continue;
        }
        final Map<String, Object?> data = change.data!;
        final String hash = change.hash ?? hashRow(data);
        if (known[change.id] == hash) continue;
        if (await _localIsNewer(table, change.id, data)) continue;
        known[change.id] = hash;
        _localIds[table]!.add(change.id);
        await _upsertLocal(table, data);
        wrote = true;
      }
    } catch (e) {
      debugPrint('Sync: apply $table failed ($e)');
      phase.value = SyncPhase.error;
    } finally {
      await _db.customStatement('PRAGMA foreign_keys = ON');
    }
    if (wrote) {
      lastSync.value = DateTime.now();
      _reschedule?.cancel();
      _reschedule = Timer(const Duration(seconds: 1), () {
        onRemoteApplied?.call();
      });
    }
  }

  Future<bool> _localIsNewer(
    String table,
    String id,
    Map<String, Object?> remote,
  ) async {
    final Object? remoteStamp = remote['updated_at'];
    if (remoteStamp is! num) return false;
    final List<QueryRow> local = await _db.customSelect(
      'SELECT * FROM $table WHERE id = ?',
      variables: <Variable<Object>>[Variable<String>(id)],
    ).get();
    if (local.isEmpty) return false;
    final Object? localStamp = local.first.data['updated_at'];
    return localStamp is num && localStamp > remoteStamp;
  }

  Future<void> _upsertLocal(String table, Map<String, Object?> data) async {
    final List<String> cols = data.keys.toList();
    final String placeholders = List<String>.filled(cols.length, '?').join(', ');
    final String updates = cols
        .where((String c) => c != 'id')
        .map((String c) => '$c = excluded.$c')
        .join(', ');
    await _db.customUpdate(
      'INSERT INTO $table (${cols.join(', ')}) VALUES ($placeholders) '
      'ON CONFLICT(id) DO UPDATE SET $updates',
      variables: <Variable<Object>>[
        for (final String c in cols) Variable<Object>(data[c]),
      ],
      updates: {_info(table)},
      updateKind: UpdateKind.insert,
    );
  }
}
