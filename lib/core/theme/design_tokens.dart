import 'package:flutter/material.dart';

/// Medzee Design Tokens
/// Based on a "Premium Wellness" identity: Calm, Professional, and Warm.
class MedzeeColors {
  // Primary Palette
  static const Color forestTeal = Color(0xFF167D70);
  static const Color deepTeal = Color(0xFF105B53);
  static const Color softMint = Color(0xFFDDF3EA);
  static const Color paleMintBackground = Color(0xFFF2F8F5);
  static const Color warmOffWhite = Color(0xFFF8F8F5);
  static const Color white = Color(0xFFFFFFFF);

  // Text Palette
  static const Color primaryText = Color(0xFF202B29);
  static const Color secondaryText = Color(0xFF7B8985);
  static const Color subtleBorder = Color(0xFFE7ECE8);

  // Semantic Palette
  static const Color success = Color(0xFF28866B);
  static const Color warning = Color(0xFFD99A39);
  static const Color critical = Color(0xFFC85C58);
  static const Color informational = Color(0xFF5479B8);

  // Dark Mode Variants
  static const Color darkBackground = Color(0xFF121A18);
  static const Color darkSurface = Color(0xFF1B2624);
  static const Color darkTextPrimary = Color(0xFFE7ECE8);
  static const Color darkTextSecondary = Color(0xFF94A3A0);
}

class MedzeeSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double huge = 32.0;
}

class MedzeeRadius {
  static const double button = 16.0;
  static const double input = 16.0;
  static const double card = 20.0;
  static const double hero = 28.0;
  static const double pill = 100.0;
}

class MedzeeTypeScale {
  static const double display = 32.0;
  static const double heading = 28.0;
  static const double section = 18.0;
  static const double body = 15.0;
  static const double supporting = 13.0;
  static const double compact = 12.0;
}