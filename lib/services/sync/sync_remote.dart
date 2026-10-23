import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

/// One row change coming from the cloud.
class RemoteChange {
  const RemoteChange({
    required this.id,
    required this.removed,
    this.data,
    this.hash,
  });

  final String id;
  final bool removed;

  /// Raw SQLite column values, keyed by column name.
  final Map<String, Object?>? data;

  /// Content hash stamped by the device that wrote the row.
  final String? hash;
}

/// The cloud side of sync, kept behind an interface so the engine can be
/// tested without Firebase.
abstract class SyncRemote {
  Future<void> upsert(
    String table,
    String id,
    Map<String, Object?> data,
    String hash,
  );

  Future<void> delete(String table, String id);

  /// Batches of changes made by *other* devices (own pending writes are
  /// filtered out).
  Stream<List<RemoteChange>> changes(String table);
}

/// Firestore layout: `vaults/{vaultId}/{table}/{rowId}` with fields
/// `d` (row data), `h` (content hash) and `t` (server timestamp).
class FirestoreSyncRemote implements SyncRemote {
  FirestoreSyncRemote(this._vaultId, [FirebaseFirestore? firestore])
      : _db = firestore ?? FirebaseFirestore.instance;

  final String _vaultId;
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String table) =>
      _db.collection('vaults').doc(_vaultId).collection(table);

  @override
  Future<void> upsert(
    String table,
    String id,
    Map<String, Object?> data,
    String hash,
  ) {
    return _col(table).doc(id).set(<String, Object?>{
      'd': data,
      'h': hash,
      't': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> delete(String table, String id) => _col(table).doc(id).delete();

  @override
  Stream<List<RemoteChange>> changes(String table) {
    return _col(table).snapshots().map((QuerySnapshot<Map<String, dynamic>> s) {
      final List<RemoteChange> out = <RemoteChange>[];
      for (final DocumentChange<Map<String, dynamic>> c in s.docChanges) {
        if (c.doc.metadata.hasPendingWrites) continue;
        if (c.type == DocumentChangeType.removed) {
          out.add(RemoteChange(id: c.doc.id, removed: true));
          continue;
        }
        final Map<String, dynamic>? doc = c.doc.data();
        final Object? d = doc?['d'];
        if (d is! Map) continue;
        out.add(
          RemoteChange(
            id: c.doc.id,
            removed: false,
            data: Map<String, Object?>.from(d),
            hash: doc?['h'] as String?,
          ),
        );
      }
      return out;
    });
  }
}
