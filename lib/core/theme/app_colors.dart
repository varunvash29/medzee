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
  static const Color teal = Color(0xFF0F9D92);
  static const Color tealDeep = Color(0xFF07766E);
  static const Color tealBright = Color(0xFF3FD3C4);
  static const Color tealSoft = Color(0xFFD8F3F0);
  static const Color tealSoftDark = Color(0xFF0C4B47);

  // ------------------------------------------------------------- neutrals
  static const Color ink = Color(0xFF15201E);
  static const Color inkDark = Color(0xFFE9F0EE);
  static const Color slate = Color(0xFF687673);
  static const Color slateDark = Color(0xFF9AAAA6);

  static const Color canvas = Color(0xFFF7F8F7);
  static const Color canvasDark = Color(0xFF0D1312);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF161D1C);
  static const Color surfaceMuted = Color(0xFFF0F3F2);
  static const Color surfaceMutedDark = Color(0xFF1C2523);
  static const Color hairline = Color(0xFFE4E9E7);
  static const Color hairlineDark = Color(0xFF283231);

  // ------------------------------------------------------------- semantic
  /// Dose confirmed / healthy state.
  static const Color success = Color(0xFF2E9E5B);
  static const Color successSoft = Color(0xFFE3F5EA);
  static const Color successSoftDark = Color(0xFF123A24);

  /// Due soon / refill needed.
  static const Color warning = Color(0xFFE39A2E);
  static const Color warningSoft = Color(0xFFFDF1DE);
  static const Color warningSoftDark = Color(0xFF3D2C11);

  /// Missed / critical.
  static const Color critical = Color(0xFFD8524C);
  static const Color criticalSoft = Color(0xFFFBE7E5);
  static const Color criticalSoftDark = Color(0xFF3E1B19);

  /// Informational / informational accent.
  static const Color info = Color(0xFF3D7BE0);
  static const Color infoSoft = Color(0xFFE6EEFC);
  static const Color infoSoftDark = Color(0xFF16294A);

  /// Neutral "skipped" marker.
  static const Color neutral = Color(0xFF7C8A87);
  static const Color neutralSoft = Color(0xFFEDF1F0);
  static const Color neutralSoftDark = Color(0xFF232C2B);
}
