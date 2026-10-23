import '../models/medicine_info.dart';

/// Persistence contract for cached clinical information, allergy records,
/// interaction alerts and attachments.
abstract interface class MedicineInfoRepository {
  Future<MedicineInformation?> get(String medicationId);

  Future<void> cache(MedicineInformation information);

  Stream<List<AllergyRecord>> watchAllergies();

  Future<void> addAllergy(AllergyRecord allergy);

  Future<void> deleteAllergy(String id);

  Stream<List<InteractionAlert>> watchAlerts();

  Future<void> addAlert(InteractionAlert alert);

  Stream<List<PrescriptionAttachment>> watchAttachments(String medicationId);

  Future<void> addAttachment(PrescriptionAttachment attachment);

  Future<void> deleteAttachment(String id);
}
