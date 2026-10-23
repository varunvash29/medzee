import 'package:flutter/material.dart';

/// Medzee brand palette.
///
/// The palette is intentionally restrained: one expressive teal for brand and
/// primary actions, a warm neutral canvas, and four semantic colours that
/// carry clinical meaning (taken / upcoming / warning / missed).
///
/// Every value below has a light and a dark counterpart so the product reads
/// as one coherent system in both modes.
abstract final class AppColors {
  // ---------------------------------------------------------------- brand
  static const Color brand = Color(0xFF5B5BF0);
  static const Color brandDeep = Color(0xFF3D3DD1);
  static const Color brandBright = Color(0xFF9A9AFF);
  static const Color brandSoft = Color(0xFFE6E6FF);
  static const Color brandSoftDark = Color(0xFF26264F);

  // ------------------------------------------------------------- neutrals
  static const Color ink = Color(0xFF14141F);
  static const Color inkDark = Color(0xFFEDEDF5);
  static const Color slate = Color(0xFF6B6B80);
  static const Color slateDark = Color(0xFFA0A0B5);

  static const Color canvas = Color(0xFFF5F5FA);
  static const Color canvasDark = Color(0xFF0B0B11);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF15151E);
  static const Color surfaceMuted = Color(0xFFECECF4);
  static const Color surfaceMutedDark = Color(0xFF1D1D29);
  static const Color hairline = Color(0xFFE1E1EC);
  static const Color hairlineDark = Color(0xFF2A2A38);

  // --------------------------------------------------------------- accents
  /// Warm accents give the teal brand some energy. Use sparingly.
  static const Color sun = Color(0xFFFFB547);
  static const Color sky = Color(0xFF4DA3FF);
  static const Color violet = Color(0xFF8B7CFF);
  static const Color coral = Color(0xFFFF7A6B);

  // ------------------------------------------------------------- semantic
  /// Dose confirmed / healthy state.
  static const Color success = Color(0xFF2563EB);
  static const Color successSoft = Color(0xFFE3ECFF);
  static const Color successSoftDark = Color(0xFF16254D);

  /// Due soon / refill needed.
  static const Color warning = Color(0xFFE39A2E);
  static const Color warningSoft = Color(0xFFFDF1DE);
  static const Color warningSoftDark = Color(0xFF3D2C11);

  /// Missed / critical.
  static const Color critical = Color(0xFFD8524C);
  static const Color criticalSoft = Color(0xFFFBE7E5);
  static const Color criticalSoftDark = Color(0xFF3E1B19);

  /// Informational / informational accent.
  static const Color info = Color(0xFF8B5CF6);
  static const Color infoSoft = Color(0xFFEFE8FF);
  static const Color infoSoftDark = Color(0xFF2A2050);

  /// Neutral "skipped" marker.
  static const Color neutral = Color(0xFF80809A);
  static const Color neutralSoft = Color(0xFFEDEDF4);
  static const Color neutralSoftDark = Color(0xFF272733);
}
