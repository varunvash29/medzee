import 'core_enums.dart';

/// Current stock on hand for a medication.
class Inventory {
  const Inventory({
    required this.id,
    required this.medicationId,
    required this.quantityOnHand,
    required this.unit,
    this.refillThreshold = 0,
    this.initialQuantity = 0,
    this.lastRefillAt,
    this.expiryDate,
    this.notes,
    required this.updatedAt,
  });

  final String id;
  final String medicationId;

  /// Quantity currently in stock, expressed in [unit].
  final double quantityOnHand;
  final DoseUnit unit;

  /// When [quantityOnHand] drops to or below this value the app warns.
  final double refillThreshold;

  /// Quantity that was in stock when tracking started.
  final double initialQuantity;
  final DateTime? lastRefillAt;
  final DateTime? expiryDate;
  final String? notes;
  final DateTime updatedAt;

  bool get isLowStock =>
      refillThreshold > 0 && quantityOnHand <= refillThreshold;

  bool get isEmpty => quantityOnHand <= 0;

  /// Percentage of the original stock still available, clamped to 0..1.
  double get remainingFraction {
    if (initialQuantity <= 0) return 0;
    return (quantityOnHand / initialQuantity).clamp(0.0, 1.0);
  }

  Inventory copyWith({
    String? id,
    String? medicationId,
    double? quantityOnHand,
    DoseUnit? unit,
    double? refillThreshold,
    double? initialQuantity,
    DateTime? lastRefillAt,
    bool clearLastRefillAt = false,
    DateTime? expiryDate,
    bool clearExpiryDate = false,
    String? notes,
    bool clearNotes = false,
    DateTime? updatedAt,
  }) {
    return Inventory(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      quantityOnHand: quantityOnHand ?? this.quantityOnHand,
      unit: unit ?? this.unit,
      refillThreshold: refillThreshold ?? this.refillThreshold,
      initialQuantity: initialQuantity ?? this.initialQuantity,
      lastRefillAt:
          clearLastRefillAt ? null : (lastRefillAt ?? this.lastRefillAt),
      expiryDate: clearExpiryDate ? null : (expiryDate ?? this.expiryDate),
      notes: clearNotes ? null : (notes ?? this.notes),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// An immutable entry in the stock audit trail.
class InventoryTransaction {
  const InventoryTransaction({
    required this.id,
    required this.medicationId,
    required this.type,
    required this.quantityDelta,
    required this.quantityAfter,
    required this.unit,
    required this.createdAt,
    this.doseLogId,
    this.note,
  });

  final String id;
  final String medicationId;
  final InventoryTransactionType type;

  /// Signed change in stock (negative for deductions).
  final double quantityDelta;

  /// Stock level immediately after this transaction.
  final double quantityAfter;
  final DoseUnit unit;

  /// Set for deductions so a retried dose action can never deduct twice.
  final String? doseLogId;
  final String? note;
  final DateTime createdAt;

  bool get isIncrease => quantityDelta > 0;
}
