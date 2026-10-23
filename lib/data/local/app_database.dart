import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Medzee's local SQLite database.
///
/// All medication data lives on the device. The schema is versioned and
/// migrated forward in [migration]; nothing in the app is allowed to depend
/// on a specific schema version at runtime.
@DriftDatabase(
  tables: <Type>[
    UserProfiles,
    Medications,
    SchedulePhases,
    ScheduledDoses,
    DoseLogs,
    Inventories,
    InventoryTransactions,
    NotificationPreferences,
    RefillReminders,
    MedicineInformationCache,
    AllergyRecords,
    InteractionAlerts,
    PrescriptionAttachments,
    CaregiverAccess,
    NotificationSchedules,
    ScheduleAuditLog,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Used by tests to run against an in-memory database.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => kDatabaseSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(        onCreate: (Migrator m) async {
          await m.createAll();
          await _createIndexes();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future schema changes are applied here, one step at a time, so
          // that an existing install never loses history.
          for (int step = from; step < to; step++) {
            await switch (step + 1) {
              2 => _migrateToV2(m),
              _ => m.createAll(),
            };
          }
        },
        beforeOpen: (OpeningDetails details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_scheduled_doses_medication_date '
      'ON scheduled_doses (medication_id, local_date)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_scheduled_doses_status '
      'ON scheduled_doses (status, scheduled_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_dose_logs_medication '
      'ON dose_logs (medication_id, scheduled_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_dose_logs_scheduled_dose '
      'ON dose_logs (scheduled_dose_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_inventory_tx_medication '
      'ON inventory_transactions (medication_id, created_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_phases_medication '
      'ON schedule_phases (medication_id, phase_order)',
    );
  }

  /// v2: the schedule assistant's audit log.
  Future<void> _migrateToV2(Migrator m) async {
    await m.createTable(scheduleAuditLog);
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'medzee',
    native: DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
    ),
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
