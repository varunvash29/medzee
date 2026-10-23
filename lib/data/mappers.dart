import 'package:drift/drift.dart';

import '../domain/models/core_enums.dart';
import '../domain/models/dose.dart';
import '../domain/models/inventory.dart';
import '../domain/models/medication.dart';
import '../domain/models/medicine_info.dart';
import '../domain/models/notifications.dart';
import '../domain/models/user_profile.dart';
import 'local/app_database.dart';

/// Row <-> domain mappers.
///
/// The domain layer has no knowledge of Drift; these extensions are the only
/// place where the two representations meet. `row.toDomain()` converts a
/// database row into a domain object, `model.toCompanion()` does the
/// reverse.
abstract final class Mappers {
  /// Serialises a list of strings into a single column value.
  static String encodeList(List<String> values) =>
      values.map(encodeCsvItem).join('|');

  /// Reads a list of strings back from a column value.
  static List<String> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return const <String>[];
    return raw
        .split('|')
        .map(decodeCsvItem)
        .where((String value) => value.isNotEmpty)
        .toList(growable: false);
  }

  /// Serialises a list of integers into a single column value.
  static String encodeIntList(List<int> values) => values.join(',');

  /// Reads a list of integers back from a column value.
  static List<int> decodeIntList(String? raw) {
    if (raw == null || raw.isEmpty) return const <int>[];
    return raw
        .split(',')
        .map((String part) => int.tryParse(part.trim()))
        .whereType<int>()
        .toList(growable: false);
  }

  /// Escapes the list separator.
  static String encodeCsvItem(String value) =>
      value.replaceAll('|', r'\p').replaceAll(r'\p', r'\\p');

  /// Restores the list separator.
  static String decodeCsvItem(String value) =>
      value.replaceAll(r'\\p', r'\p').replaceAll(r'\p', '|');

  /// Normalises a date to midnight UTC so that date-only columns compare
  /// correctly regardless of the device timezone.
  static DateTime dateOnlyUtc(DateTime value) =>
      DateTime.utc(value.year, value.month, value.day);
}

extension UserProfileRowMapper on UserProfileRow {
  UserProfile toDomain() => UserProfile(
        id: id,
        displayName: displayName,
        timezoneId: timezoneId,
        timeFormat: TimeFormat.fromName(timeFormat),
        themeMode: AppThemeMode.fromName(themeMode),
        notificationsEnabled: notificationsEnabled,
        defaultReminderEnabled: defaultReminderEnabled,
        preReminderMinutes: preReminderMinutes,
        missedFollowUpEnabled: missedFollowUpEnabled,
        missedFollowUpMinutes: missedFollowUpMinutes,
        quietHoursEnabled: quietHoursEnabled,
        quietHoursStartMinutes: quietHoursStartMinutes,
        quietHoursEndMinutes: quietHoursEndMinutes,
        dailySummaryEnabled: dailySummaryEnabled,
        dailySummaryMinutes: dailySummaryMinutes,
        notificationPrivacy: NotificationPrivacy.fromName(notificationPrivacy),
        onboardingCompleted: onboardingCompleted,
        demoMode: demoMode,
        appLockEnabled: appLockEnabled,
        textScale: textScale,
        appearance: AppearanceStyle.fromName(appearance),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension UserProfileMapper on UserProfile {
  UserProfilesCompanion toCompanion() => UserProfilesCompanion(
        id: Value<String>(id),
        displayName: Value<String?>(displayName),
        timezoneId: Value<String?>(timezoneId),
        timeFormat: Value<String>(timeFormat.name),
        themeMode: Value<String>(themeMode.name),
        notificationsEnabled: Value<bool>(notificationsEnabled),
        defaultReminderEnabled: Value<bool>(defaultReminderEnabled),
        preReminderMinutes: Value<int?>(preReminderMinutes),
        missedFollowUpEnabled: Value<bool>(missedFollowUpEnabled),
        missedFollowUpMinutes: Value<int>(missedFollowUpMinutes),
        quietHoursEnabled: Value<bool>(quietHoursEnabled),
        quietHoursStartMinutes: Value<int>(quietHoursStartMinutes),
        quietHoursEndMinutes: Value<int>(quietHoursEndMinutes),
        dailySummaryEnabled: Value<bool>(dailySummaryEnabled),
        dailySummaryMinutes: Value<int>(dailySummaryMinutes),
        notificationPrivacy: Value<String>(notificationPrivacy.name),
        onboardingCompleted: Value<bool>(onboardingCompleted),
        demoMode: Value<bool>(demoMode),
        appLockEnabled: Value<bool>(appLockEnabled),
        textScale: Value<double>(textScale),
        appearance: Value<String>(appearance.name),
        createdAt: Value<DateTime?>(createdAt?.toUtc()),
        updatedAt: Value<DateTime?>(updatedAt?.toUtc()),
      );
}

extension MedicationRowMapper on MedicationRow {
  Medication toDomain() => Medication(
        id: id,
        name: name,
        genericName: genericName,
        brandName: brandName,
        category: MedicineCategory.fromName(category),
        form: DosageForm.fromName(form),
        strength: strength,
        strengthUnit: strengthUnit,
        route: AdministrationRoute.fromName(route),
        foodInstruction: FoodInstruction.fromName(foodInstruction),
        instructions: instructions,
        prescriber: prescriber,
        pharmacyName: pharmacyName,
        pharmacyPhone: pharmacyPhone,
        status: MedicationStatus.fromName(status),
        startDate: startDate,
        endDate: endDate,
        isAsNeeded: isAsNeeded,
        photoPath: photoPath,
        barcode: barcode,
        notes: notes,
        isFavorite: isFavorite,
        createdAt: createdAt.toUtc(),
        updatedAt: updatedAt.toUtc(),
      );
}

extension MedicationMapper on Medication {
  MedicationsCompanion toCompanion() => MedicationsCompanion(
        id: Value<String>(id),
        name: Value<String>(name),
        genericName: Value<String?>(genericName),
        brandName: Value<String?>(brandName),
        category: Value<String>(category.name),
        form: Value<String>(form.name),
        strength: Value<double?>(strength),
        strengthUnit: Value<String>(strengthUnit),
        route: Value<String>(route.name),
        foodInstruction: Value<String>(foodInstruction.name),
        instructions: Value<String?>(instructions),
        prescriber: Value<String?>(prescriber),
        pharmacyName: Value<String?>(pharmacyName),
        pharmacyPhone: Value<String?>(pharmacyPhone),
        status: Value<String>(status.name),
        startDate: Value<DateTime?>(startDate?.toUtc()),
        endDate: Value<DateTime?>(endDate?.toUtc()),
        isAsNeeded: Value<bool>(isAsNeeded),
        photoPath: Value<String?>(photoPath),
        barcode: Value<String?>(barcode),
        notes: Value<String?>(notes),
        isFavorite: Value<bool>(isFavorite),
        createdAt: Value<DateTime>(createdAt.toUtc()),
        updatedAt: Value<DateTime>(updatedAt.toUtc()),
      );
}

extension SchedulePhaseRowMapper on SchedulePhaseRow {
  SchedulePhase toDomain() => SchedulePhase(
        id: id,
        medicationId: medicationId,
        order: phaseOrder,
        kind: ScheduleKind.fromName(kind),
        startDate: startDate,
        endDate: endDate,
        timesMinutes: Mappers.decodeIntList(timesMinutes),
        weekdays: Mappers.decodeIntList(weekdays).toSet(),
        intervalDays: intervalDays,
        intervalHours: intervalHours,
        monthlyDays: Mappers.decodeIntList(monthlyDays),
        doseQuantity: doseQuantity,
        unit: DoseUnit.fromName(unit),
        foodInstruction: foodInstruction == null
            ? null
            : FoodInstruction.fromName(foodInstruction!),
        instructions: instructions,
        isActive: isActive,
      );
}

extension SchedulePhaseMapper on SchedulePhase {
  SchedulePhasesCompanion toCompanion() => SchedulePhasesCompanion(
        id: Value<String>(id),
        medicationId: Value<String>(medicationId),
        phaseOrder: Value<int>(order),
        kind: Value<String>(kind.name),
        startDate: Value<DateTime>(Mappers.dateOnlyUtc(startDate)),
        endDate: Value<DateTime?>(
            endDate == null ? null : Mappers.dateOnlyUtc(endDate!)),
        timesMinutes: Value<String>(Mappers.encodeIntList(timesMinutes)),
        weekdays: Value<String>(Mappers.encodeIntList(weekdays.toList()..sort())),
        intervalDays: Value<int>(intervalDays),
        intervalHours: Value<int>(intervalHours),
        monthlyDays: Value<String>(Mappers.encodeIntList(monthlyDays)),
        doseQuantity: Value<double>(doseQuantity),
        unit: Value<String>(unit.name),
        foodInstruction: Value<String?>(foodInstruction?.name),
        instructions: Value<String?>(instructions),
        isActive: Value<bool>(isActive),
      );
}

extension ScheduledDoseRowMapper on ScheduledDoseRow {
  ScheduledDose toDomain() => ScheduledDose(
        id: id,
        medicationId: medicationId,
        phaseId: phaseId,
        scheduledAt: scheduledAt.toUtc(),
        localDate: localDate,
        scheduledMinutes: scheduledMinutes,
        doseQuantity: doseQuantity,
        unit: DoseUnit.fromName(unit),
        status: DoseStatus.fromName(status),
        createdAt: createdAt.toUtc(),
      );
}

extension ScheduledDoseMapper on ScheduledDose {
  ScheduledDosesCompanion toCompanion() => ScheduledDosesCompanion(
        id: Value<String>(id),
        medicationId: Value<String>(medicationId),
        phaseId: Value<String>(phaseId),
        scheduledAt: Value<DateTime>(scheduledAt.toUtc()),
        localDate: Value<DateTime>(Mappers.dateOnlyUtc(localDate)),
        scheduledMinutes: Value<int>(scheduledMinutes),
        doseQuantity: Value<double>(doseQuantity),
        unit: Value<String>(unit.name),
        status: Value<String>(status.name),
        createdAt: Value<DateTime>(
            (createdAt ?? DateTime.now().toUtc()).toUtc()),
      );
}

extension DoseLogRowMapper on DoseLogRow {
  DoseLog toDomain() => DoseLog(
        id: id,
        medicationId: medicationId,
        scheduledDoseId: scheduledDoseId,
        status: DoseStatus.fromName(status),
        scheduledAt: scheduledAt.toUtc(),
        actedAt: actedAt.toUtc(),
        amountTaken: amountTaken,
        unit: unit == null ? null : DoseUnit.fromName(unit!),
        note: note,
        inventoryTransactionId: inventoryTransactionId,
        supersedesLogId: supersedesLogId,
        createdAt: createdAt.toUtc(),
      );
}

extension DoseLogMapper on DoseLog {
  DoseLogsCompanion toCompanion() => DoseLogsCompanion(
        id: Value<String>(id),
        medicationId: Value<String>(medicationId),
        scheduledDoseId: Value<String>(scheduledDoseId),
        status: Value<String>(status.name),
        scheduledAt: Value<DateTime>(scheduledAt.toUtc()),
        actedAt: Value<DateTime>(actedAt.toUtc()),
        amountTaken: Value<double?>(amountTaken),
        unit: Value<String?>(unit?.name),
        note: Value<String?>(note),
        inventoryTransactionId: Value<String?>(inventoryTransactionId),
        supersedesLogId: Value<String?>(supersedesLogId),
        isActive: const Value<bool>(true),
        createdAt: Value<DateTime>(
            (createdAt ?? DateTime.now().toUtc()).toUtc()),
      );
}

extension InventoryRowMapper on InventoryRow {
  Inventory toDomain() => Inventory(
        id: id,
        medicationId: medicationId,
        quantityOnHand: quantityOnHand,
        unit: DoseUnit.fromName(unit),
        refillThreshold: refillThreshold,
        initialQuantity: initialQuantity,
        lastRefillAt: lastRefillAt,
        expiryDate: expiryDate,
        notes: notes,
        updatedAt: updatedAt.toUtc(),
      );
}

extension InventoryMapper on Inventory {
  InventoriesCompanion toCompanion() => InventoriesCompanion(
        id: Value<String>(id),
        medicationId: Value<String>(medicationId),
        quantityOnHand: Value<double>(quantityOnHand),
        unit: Value<String>(unit.name),
        refillThreshold: Value<double>(refillThreshold),
        initialQuantity: Value<double>(initialQuantity),
        lastRefillAt: Value<DateTime?>(lastRefillAt?.toUtc()),
        expiryDate: Value<DateTime?>(expiryDate?.toUtc()),
        notes: Value<String?>(notes),
        updatedAt: Value<DateTime>(updatedAt.toUtc()),
      );
}

extension InventoryTransactionRowMapper on InventoryTransactionRow {
  InventoryTransaction toDomain() => InventoryTransaction(
        id: id,
        medicationId: medicationId,
        type: InventoryTransactionType.fromName(type),
        quantityDelta: quantityDelta,
        quantityAfter: quantityAfter,
        unit: DoseUnit.fromName(unit),
        doseLogId: doseLogId,
        note: note,
        createdAt: createdAt.toUtc(),
      );
}

extension InventoryTransactionMapper on InventoryTransaction {
  InventoryTransactionsCompanion toCompanion() =>
      InventoryTransactionsCompanion(
        id: Value<String>(id),
        medicationId: Value<String>(medicationId),
        type: Value<String>(type.name),
        quantityDelta: Value<double>(quantityDelta),
        quantityAfter: Value<double>(quantityAfter),
        unit: Value<String>(unit.name),
        doseLogId: Value<String?>(doseLogId),
        note: Value<String?>(note),
        createdAt: Value<DateTime>(createdAt.toUtc()),
      );
}

extension NotificationPreferenceRowMapper on NotificationPreferenceRow {
  NotificationPreference toDomain() => NotificationPreference(
        id: id,
        medicationId: medicationId,
        remindersEnabled: remindersEnabled,
        preReminderMinutes: preReminderMinutes,
        missedFollowUpEnabled: missedFollowUpEnabled,
        missedFollowUpMinutes: missedFollowUpMinutes,
        soundEnabled: soundEnabled,
        vibrationEnabled: vibrationEnabled,
        privacy: NotificationPrivacy.fromName(privacy),
        lowStockAlertEnabled: lowStockAlertEnabled,
        runOutAlertEnabled: runOutAlertEnabled,
        refillAlertEnabled: refillAlertEnabled,
      );
}

extension NotificationPreferenceMapper on NotificationPreference {
  NotificationPreferencesCompanion toCompanion() =>
      NotificationPreferencesCompanion(
        id: Value<String>(id),
        medicationId: Value<String?>(medicationId),
        remindersEnabled: Value<bool>(remindersEnabled),
        preReminderMinutes: Value<int?>(preReminderMinutes),
        missedFollowUpEnabled: Value<bool>(missedFollowUpEnabled),
        missedFollowUpMinutes: Value<int>(missedFollowUpMinutes),
        soundEnabled: Value<bool>(soundEnabled),
        vibrationEnabled: Value<bool>(vibrationEnabled),
        privacy: Value<String>(privacy.name),
        lowStockAlertEnabled: Value<bool>(lowStockAlertEnabled),
        runOutAlertEnabled: Value<bool>(runOutAlertEnabled),
        refillAlertEnabled: Value<bool>(refillAlertEnabled),
      );
}

extension RefillReminderRowMapper on RefillReminderRow {
  RefillReminder toDomain() => RefillReminder(
        id: id,
        medicationId: medicationId,
        threshold: threshold,
        enabled: enabled,
        lastNotifiedAt: lastNotifiedAt,
        leadDays: leadDays,
      );
}

extension RefillReminderMapper on RefillReminder {
  RefillRemindersCompanion toCompanion() => RefillRemindersCompanion(
        id: Value<String>(id),
        medicationId: Value<String>(medicationId),
        threshold: Value<double>(threshold),
        enabled: Value<bool>(enabled),
        lastNotifiedAt: Value<DateTime?>(lastNotifiedAt?.toUtc()),
        leadDays: Value<int>(leadDays),
      );
}

extension MedicineInformationRowMapper on MedicineInformationRow {
  MedicineInformation toDomain() => MedicineInformation(
        medicationId: medicationId,
        sourceName: sourceName,
        sourceUrl: sourceUrl,
        lastUpdated: lastUpdated,
        genericName: genericName,
        brandNames: Mappers.decodeList(brandNames),
        activeIngredients: Mappers.decodeList(activeIngredients),
        indications: Mappers.decodeList(indications),
        warnings: Mappers.decodeList(warnings),
        contraindications: Mappers.decodeList(contraindications),
        sideEffects: Mappers.decodeList(sideEffects),
        storage: storage,
        dosageForm: dosageForm,
        strengths: Mappers.decodeList(strengths),
        foodInteractions: Mappers.decodeList(foodInteractions),
        patientAdvice: Mappers.decodeList(patientAdvice),
      );
}

extension MedicineInformationMapper on MedicineInformation {
  MedicineInformationCacheCompanion toCompanion() =>
      MedicineInformationCacheCompanion(
        medicationId: Value<String>(medicationId),
        sourceName: Value<String>(sourceName),
        sourceUrl: Value<String>(sourceUrl),
        lastUpdated: Value<DateTime>(lastUpdated.toUtc()),
        genericName: Value<String?>(genericName),
        brandNames: Value<String>(Mappers.encodeList(brandNames)),
        activeIngredients: Value<String>(Mappers.encodeList(activeIngredients)),
        indications: Value<String>(Mappers.encodeList(indications)),
        warnings: Value<String>(Mappers.encodeList(warnings)),
        contraindications: Value<String>(Mappers.encodeList(contraindications)),
        sideEffects: Value<String>(Mappers.encodeList(sideEffects)),
        storage: Value<String?>(storage),
        dosageForm: Value<String?>(dosageForm),
        strengths: Value<String>(Mappers.encodeList(strengths)),
        foodInteractions: Value<String>(Mappers.encodeList(foodInteractions)),
        patientAdvice: Value<String>(Mappers.encodeList(patientAdvice)),
        cachedAt: Value<DateTime>(DateTime.now().toUtc()),
      );
}

extension AllergyRecordRowMapper on AllergyRecordRow {
  AllergyRecord toDomain() => AllergyRecord(
        id: id,
        substance: substance,
        reaction: reaction,
        severity: ClinicalSeverity.fromName(severity),
        notes: notes,
        createdAt: createdAt.toUtc(),
      );
}

extension AllergyRecordMapper on AllergyRecord {
  AllergyRecordsCompanion toCompanion() => AllergyRecordsCompanion(
        id: Value<String>(id),
        substance: Value<String>(substance),
        reaction: Value<String?>(reaction),
        severity: Value<String>(severity.name),
        notes: Value<String?>(notes),
        createdAt: Value<DateTime>(createdAt.toUtc()),
      );
}

extension InteractionAlertRowMapper on InteractionAlertRow {
  InteractionAlert toDomain() => InteractionAlert(
        id: id,
        medicationIds: Mappers.decodeList(medicationIds),
        severity: ClinicalSeverity.fromName(severity),
        description: description,
        sourceName: sourceName,
        sourceUrl: sourceUrl,
        detectedAt: detectedAt.toUtc(),
      );
}

extension InteractionAlertMapper on InteractionAlert {
  InteractionAlertsCompanion toCompanion() => InteractionAlertsCompanion(
        id: Value<String>(id),
        medicationIds: Value<String>(Mappers.encodeList(medicationIds)),
        severity: Value<String>(severity.name),
        description: Value<String>(description),
        sourceName: Value<String>(sourceName),
        sourceUrl: Value<String?>(sourceUrl),
        detectedAt: Value<DateTime>(detectedAt.toUtc()),
      );
}

extension PrescriptionAttachmentRowMapper on PrescriptionAttachmentRow {
  PrescriptionAttachment toDomain() => PrescriptionAttachment(
        id: id,
        medicationId: medicationId,
        filePath: filePath,
        type: AttachmentType.fromName(type),
        caption: caption,
        createdAt: createdAt.toUtc(),
      );
}

extension PrescriptionAttachmentMapper on PrescriptionAttachment {
  PrescriptionAttachmentsCompanion toCompanion() =>
      PrescriptionAttachmentsCompanion(
        id: Value<String>(id),
        medicationId: Value<String>(medicationId),
        filePath: Value<String>(filePath),
        type: Value<String>(type.name),
        caption: Value<String?>(caption),
        createdAt: Value<DateTime>(createdAt.toUtc()),
      );
}
