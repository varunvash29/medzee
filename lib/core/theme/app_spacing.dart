import 'package:flutter/widgets.dart';

/// Spacing scale (4pt base). Use these instead of magic numbers.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;

  /// Standard horizontal page gutter.
  static const double gutter = 20;

  /// Minimum accessible touch target.
  static const double touchTarget = 48;
}

/// Corner radii used across the product.
abstract final class AppRadii {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
  static const double full = 999;

  static const BorderRadius card = BorderRadius.all(Radius.circular(md));
  static const BorderRadius cardLarge =
      BorderRadius.all(Radius.circular(lg));
  static const BorderRadius sheet =
      BorderRadius.vertical(top: Radius.circular(xl));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(full));
}

/// Named shadows — soft, low-contrast elevation that reads as premium.
abstract final class AppShadows {
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0D15201E),
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> lifted = [
    BoxShadow(
      color: Color(0x1415201E),
      blurRadius: 28,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> none = [];
}
