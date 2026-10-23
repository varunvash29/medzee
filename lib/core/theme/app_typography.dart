import 'package:flutter/material.dart';

/// The bundled typeface family. Medzee ships Inter as an asset so that the
/// app renders identically offline with no runtime font fetch.
const String kAppFontFamily = 'Inter';

/// Type scale for Medzee.
///
/// The scale is deliberately compact: one display size, one title size per
/// level, and a small number of body/label sizes. Everything else is
/// expressed through weight and colour so screens stay visually calm.
abstract final class AppTypography {
  static TextTheme textTheme(ColorScheme scheme) {
    final Color onSurface = scheme.onSurface;
    final Color muted = scheme.onSurfaceVariant;

    return TextTheme(
      displaySmall: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 34,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 28,
        height: 1.18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: onSurface,
      ),
      headlineSmall: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 24,
        height: 1.22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 16.5,
        height: 1.34,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: onSurface,
      ),
      titleSmall: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 14.5,
        height: 1.36,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 15.5,
        height: 1.48,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: muted,
      ),
      bodySmall: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 12.5,
        height: 1.46,
        fontWeight: FontWeight.w400,
        color: muted,
      ),
      labelLarge: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 15,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onSurface,
      ),
      labelMedium: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 12.5,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: muted,
      ),
      labelSmall: TextStyle(
        fontFamily: kAppFontFamily,
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: muted,
      ),
    );
  }
}
