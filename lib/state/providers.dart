import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../data/repositories/dose_repository_impl.dart';
import '../data/repositories/inventory_repository_impl.dart';
import '../data/repositories/medication_repository_impl.dart';
import '../data/repositories/notification_schedule_repository_impl.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/repositories/dose_repository.dart';
import '../domain/repositories/inventory_repository.dart';
import '../domain/repositories/medication_repository.dart';
import '../domain/repositories/notification_schedule_repository.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/services/local_time_converter.dart';
import '../services/dose_service.dart';
import '../domain/models/medicine_profile.dart';
import '../services/ai/medicine_knowledge.dart';
import '../services/ai/prescription_extractor.dart';
import '../services/ai/schedule_assistant.dart';
import '../services/schedule_change_service.dart';
import '../services/firebase_service.dart';
import '../services/sync/cloud_sync_controller.dart';
import '../services/medication_service.dart';
import '../services/medicine_info_service.dart';
import '../services/notification_service.dart';
import '../services/notification_action_dispatcher.dart';
import '../services/schedule_service.dart';
import '../services/timezone_service.dart';

/// Dependency injection root.
///
/// The database is supplied by [main] (or by a test override). Everything
/// else is derived from it, so the object graph stays a pure function of the
/// database plus the notification action handler.
final Provider<AppDatabase> appDatabaseProvider = Provider<AppDatabase>(
  (Ref ref) => throw UnimplementedError(
    'appDatabaseProvider must be overridden before use.',
  ),
);

/// Handler for taps on notification actions. `main` installs one that
/// forwards into the router; tests may leave it null.
final Provider<NotificationActionDispatcher> notificationActionDispatcherProvider =
    Provider<NotificationActionDispatcher>(
  (Ref ref) => NotificationActionDispatcher(),
);

// ------------------------------------------------------------- repositories

final Provider<MedicationRepository> medicationRepositoryProvider =
    Provider<MedicationRepository>(
  (Ref ref) => MedicationRepositoryImpl(ref.watch(appDatabaseProvider)),
);

final Provider<DoseRepository> doseRepositoryProvider =
    Provider<DoseRepository>(
  (Ref ref) => DoseRepositoryImpl(ref.watch(appDatabaseProvider)),
);

final Provider<InventoryRepository> inventoryRepositoryProvider =
    Provider<InventoryRepository>(
  (Ref ref) => InventoryRepositoryImpl(ref.watch(appDatabaseProvider)),
);

final Provider<ProfileRepository> profileRepositoryProvider =
    Provider<ProfileRepository>(
  (Ref ref) => ProfileRepositoryImpl(ref.watch(appDatabaseProvider)),
);

final Provider<NotificationScheduleRepository>
    notificationScheduleRepositoryProvider =
    Provider<NotificationScheduleRepository>(
  (Ref ref) =>
      NotificationScheduleRepositoryImpl(ref.watch(appDatabaseProvider)),
);

// --------------------------------------------------------------- timezone

/// Thin seam over the static [TimezoneService] so tests can substitute a
/// deterministic timezone without patching global state.
class TimezoneFacade {
  TimezoneFacade();

  /// Loads the timezone database and resolves the device timezone.
  Future<String> initialize() => TimezoneService.initialize();

  /// Converter bound to the active timezone.
  LocalTimeConverter get converter => TimezoneService.converter;

  /// Current timezone identifier, e.g. "Europe/Berlin".
  String get timeZoneId => TimezoneService.timeZoneId;

  /// A converter bound to a specific timezone.
  LocalTimeConverter converterFor(String timeZoneId) =>
      TimezoneService.converterFor(timeZoneId);
}

final Provider<TimezoneFacade> timezoneServiceProvider =
    Provider<TimezoneFacade>((Ref ref) => TimezoneFacade());

// ---------------------------------------------------------------- services

final Provider<NotificationService> notificationServiceProvider =
    Provider<NotificationService>(
  (Ref ref) => NotificationService(
    ref.watch(timezoneServiceProvider).converter,
    onAction: ref.watch(notificationActionDispatcherProvider).handler,
  ),
);

final Provider<ScheduleService> scheduleServiceProvider =
    Provider<ScheduleService>(
  (Ref ref) => ScheduleService(
    medicationRepository: ref.watch(medicationRepositoryProvider),
    doseRepository: ref.watch(doseRepositoryProvider),
    notificationScheduleRepository:
        ref.watch(notificationScheduleRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
  ),
);

final Provider<DoseService> doseServiceProvider = Provider<DoseService>(
  (Ref ref) => DoseService(
    doseRepository: ref.watch(doseRepositoryProvider),
    inventoryRepository: ref.watch(inventoryRepositoryProvider),
  ),
);

final Provider<MedicationService> medicationServiceProvider =
    Provider<MedicationService>(
  (Ref ref) => MedicationService(
    medicationRepository: ref.watch(medicationRepositoryProvider),
    inventoryRepository: ref.watch(inventoryRepositoryProvider),
    doseRepository: ref.watch(doseRepositoryProvider),
    scheduleService: ref.watch(scheduleServiceProvider),
  ),
);

/// External medicine lookup. [OpenFdaProvider] hits the real openFDA API;
/// swap for [UnavailableMedicineInfoProvider] in tests or offline builds.
final Provider<MedicineInfoProvider> medicineInfoProvider =
    Provider<MedicineInfoProvider>(
  (Ref ref) => OpenFdaProvider(),
);

/// Supplied by [main] with the result of [FirebaseGateway.tryInitialize] —
/// never lazily initialised, so a missing `google-services.json` degrades to
/// a clean "unavailable" instead of throwing inside the widget tree.
final Provider<FirebaseGateway> firebaseGatewayProvider =
    Provider<FirebaseGateway>(
  (Ref ref) => throw UnimplementedError(
    'firebaseGatewayProvider must be overridden before use.',
  ),
);

/// FCM push channel (caregiver/sync use — reminders stay local exact alarms).
final Provider<PushService> pushServiceProvider = Provider<PushService>(
  (Ref ref) => PushService(
    ref.watch(firebaseGatewayProvider),
    ref.watch(notificationActionDispatcherProvider),
  ),
);

/// Anonymous-auth seam for future sync scoping.
final Provider<FirebaseAuthService> firebaseAuthServiceProvider =
    Provider<FirebaseAuthService>(
  (Ref ref) => FirebaseAuthService(ref.watch(firebaseGatewayProvider)),
);

/// Optional cloud mirror of the local database (Firestore). Off until the
/// user switches it on in Profile.
final ChangeNotifierProvider<CloudSyncController> cloudSyncControllerProvider =
    ChangeNotifierProvider<CloudSyncController>(
  (Ref ref) => CloudSyncController(
    ref.watch(appDatabaseProvider),
    ref.watch(firebaseGatewayProvider),
    ref.watch(firebaseAuthServiceProvider),
    onRemoteApplied: () => ref.read(scheduleServiceProvider).reconcileAll(),
  ),
);

/// Reads prescriptions with Gemini through Firebase AI Logic.
final Provider<PrescriptionExtractor> prescriptionExtractorProvider =
    Provider<PrescriptionExtractor>(
  (Ref ref) => GeminiPrescriptionExtractor(
    available: ref.watch(firebaseGatewayProvider).isAvailable,
  ),
);

/// Understands plain-language schedule requests (proposals only).
final Provider<ScheduleAssistant> scheduleAssistantProvider =
    Provider<ScheduleAssistant>(
  (Ref ref) => GeminiScheduleAssistant(
    available: ref.watch(firebaseGatewayProvider).isAvailable,
  ),
);

/// Applies confirmed proposals, with an audit trail and undo.
final Provider<ScheduleChangeService> scheduleChangeServiceProvider =
    Provider<ScheduleChangeService>(
  (Ref ref) => ScheduleChangeService(
    database: ref.watch(appDatabaseProvider),
    medications: ref.watch(medicationRepositoryProvider),
    inventory: ref.watch(inventoryRepositoryProvider),
    medicationService: ref.watch(medicationServiceProvider),
  ),
);

/// What a medicine is, inferred from its name (India-focused).
final Provider<MedicineKnowledge> medicineKnowledgeProvider =
    Provider<MedicineKnowledge>(
  (Ref ref) => GeminiMedicineKnowledge(
    available: ref.watch(firebaseGatewayProvider).isAvailable,
  ),
);

/// The profile for one medicine name, cached per name.
final FutureProviderFamily<MedicineProfile, String> medicineProfileProvider =
    FutureProvider.family<MedicineProfile, String>(
  (Ref ref, String name) =>
      ref.watch(medicineKnowledgeProvider).lookup(name),
);
