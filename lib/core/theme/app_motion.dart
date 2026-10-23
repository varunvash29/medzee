import 'package:flutter/material.dart';

/// Motion tokens.
///
/// Every animation in Medzee is short, purposeful and interruptible. We
/// avoid bounce/overshoot on anything the user taps in response to a
/// medication prompt, because latency there reads as "the app is broken".
abstract final class AppMotion {
  /// Default duration for small state changes (icon swap, chip, toggle).
  static const Duration fast = Duration(milliseconds: 150);

  /// Default duration for content transitions (card enter, list item).
  static const Duration medium = Duration(milliseconds: 280);

  /// Default duration for full-screen / sheet transitions.
  static const Duration slow = Duration(milliseconds: 420);

  /// Duration used for celebratory or progress animations.
  static const Duration celebrate = Duration(milliseconds: 650);

  /// Standard easing for entering elements.
  static const Curve enter = Curves.easeOutCubic;

  /// Standard easing for exiting elements.
  static const Curve exit = Curves.easeInCubic;

  /// Smooth curve for size/position changes.
  static const Curve standard = Curves.easeOutCubic;

  /// Slight emphasis for hero-like transitions.
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
}
