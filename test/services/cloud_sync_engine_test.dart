import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/data/local/app_database.dart';
import 'package:medzee/data/repositories/medication_repository_impl.dart';
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/services/sync/cloud_sync_engine.dart';
import 'package:medzee/services/sync/sync_remote.dart';

/// An in-memory cloud shared by several engines, mimicking Firestore's
/// "other devices only" change feed.
class FakeCloud {
  final Map<String, Map<String, Map<String, Object?>>> rows =
      <String, Map<String, Map<String, Object?>>>{};
  final List<SyncRemote> remotes = <SyncRemote>[];

  SyncRemote connect() {
    final _FakeRemote r = _FakeRemote(this);
    remotes.add(r);
    return r;
  }
}

class _FakeRemote implements SyncRemote {
  _FakeRemote(this._cloud);

  final FakeCloud _cloud;
  final Map<String, StreamController<List<RemoteChange>>> _controllers =
      <String, StreamController<List<RemoteChange>>>{};

  StreamController<List<RemoteChange>> _c(String table) => _controllers
      .putIfAbsent(table, () => StreamController<List<RemoteChange>>());

  @override
  Stream<List<RemoteChange>> changes(String table) {
    final StreamController<List<RemoteChange>> c = _c(table);
    // Initial snapshot: everything already in the cloud.
    Timer.run(() {
      final Map<String, Map<String, Object?>> existing =
          _cloud.rows[table] ?? <String, Map<String, Object?>>{};
      c.add(<RemoteChange>[
        for (final MapEntry<String, Map<String, Object?>> e in existing.entries)
          RemoteChange(
            id: e.key,
            removed: false,
            data: Map<String, Object?>.from(e.value),
            hash: CloudSyncEngine.hashRow(e.value),
          ),
      ]);
    });
    return c.stream;
  }

  @override
  Future<void> upsert(
    String table,
    String id,
    Map<String, Object?> data,
    String hash,
  ) async {
    (_cloud.rows[table] ??= <String, Map<String, Object?>>{})[id] =
        Map<String, Object?>.from(data);
    for (final SyncRemote o in _cloud.remotes) {
      final _FakeRemote other = o as _FakeRemote;
      if (other == this) continue;
      other._c(table).add(<RemoteChange>[
        RemoteChange(id: id, removed: false, data: data, hash: hash),
      ]);
    }
  }

  @override
  Future<void> delete(String table, String id) async {
    _cloud.rows[table]?.remove(id);
    for (final SyncRemote o in _cloud.remotes) {
      final _FakeRemote other = o as _FakeRemote;
      if (other == this) continue;
      other._c(table).add(<RemoteChange>[RemoteChange(id: id, removed: true)]);
    }
  }
}

Medication _med(String id, String name) => Medication(
      id: id,
      name: name,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

Future<void> _settle() async {
  for (int i = 0; i < 10; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

void main() {
  late AppDatabase phoneDb;
  late AppDatabase webDb;
  late MedicationRepositoryImpl phone;
  late MedicationRepositoryImpl web;
  late FakeCloud cloud;
  late CloudSyncEngine phoneSync;
  late CloudSyncEngine webSync;

  setUp(() {
    phoneDb = AppDatabase.forTesting(NativeDatabase.memory());
    webDb = AppDatabase.forTesting(NativeDatabase.memory());
    phone = MedicationRepositoryImpl(phoneDb);
    web = MedicationRepositoryImpl(webDb);
    cloud = FakeCloud();
    phoneSync = CloudSyncEngine(phoneDb, cloud.connect());
    webSync = CloudSyncEngine(webDb, cloud.connect());
  });

  tearDown(() async {
    await phoneSync.stop();
    await webSync.stop();
    await phoneDb.close();
    await webDb.close();
  });

  test('a medicine saved on one device appears on the other', () async {
    await phoneSync.start();
    await webSync.start();
    await _settle();

    await phone.save(_med('m1', 'Metformin'));
    await _settle();

    final Medication? onWeb = await web.getById('m1');
    expect(onWeb, isNotNull);
    expect(onWeb!.name, 'Metformin');
  });

  test('existing local data is uploaded and a new device receives it',
      () async {
    await phone.save(_med('m1', 'Aspirin'));
    await phoneSync.start();
    await _settle();
    expect(cloud.rows['medications']!.containsKey('m1'), isTrue);

    await webSync.wipeLocal();
    await webSync.start();
    await _settle();
    expect((await web.getById('m1'))?.name, 'Aspirin');
  });

  test('deleting on one device removes it from the other', () async {
    await phoneSync.start();
    await webSync.start();
    await phone.save(_med('m1', 'Metformin'));
    await _settle();
    expect(await web.getById('m1'), isNotNull);

    await phone.delete('m1');
    await _settle();
    expect(await web.getById('m1'), isNull);
  });

  test('remote changes trigger the reschedule hook', () async {
    int calls = 0;
    final CloudSyncEngine hooked = CloudSyncEngine(
      webDb,
      cloud.connect(),
      onRemoteApplied: () async => calls++,
    );
    await phoneSync.start();
    await hooked.start();
    await phone.save(_med('m1', 'Metformin'));
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    expect(calls, greaterThan(0));
    await hooked.stop();
  });

  test('hashRow ignores key order', () {
    expect(
      CloudSyncEngine.hashRow(<String, Object?>{'a': 1, 'b': 'x'}),
      CloudSyncEngine.hashRow(<String, Object?>{'b': 'x', 'a': 1}),
    );
  });
}
