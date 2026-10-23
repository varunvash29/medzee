import '../models/core_enums.dart';

/// Decides when an unlogged dose stops being "pending" and becomes "missed".
///
/// Medzee never marks a dose as missed the instant its scheduled time
/// passes. A grace period (default 60 minutes, configurable) allows the user
/// to log a dose late without it counting against their adherence.
abstract final class DoseStatusResolver {
  static const Duration defaultGracePeriod = Duration(minutes: 60);

  /// Returns the status a dose should have at [now].
  ///
  /// A dose that already has a recorded status is never downgraded.
  static DoseStatus resolve({
    required DateTime scheduledAt,
    required DateTime now,
    required DoseStatus current,
    Duration gracePeriod = defaultGracePeriod,
  }) {
    if (current != DoseStatus.pending) return current;
    if (scheduledAt.isAfter(now)) return DoseStatus.pending;
    if (now.difference(scheduledAt) < gracePeriod) return DoseStatus.pending;
    return DoseStatus.missed;
  }

  /// Whether a pending dose has exceeded the grace window.
  static bool isOverdue({
    required DateTime scheduledAt,
    required DateTime now,
    Duration gracePeriod = defaultGracePeriod,
  }) {
    if (scheduledAt.isAfter(now)) return false;
    return now.difference(scheduledAt) >= gracePeriod;
  }

  /// Whether a dose is inside the window in which it may still be taken
  /// without being counted as missed.
  static bool isWithinGrace({
    required DateTime scheduledAt,
    required DateTime now,
    Duration gracePeriod = defaultGracePeriod,
  }) {
    if (scheduledAt.isAfter(now)) return false;
    return now.difference(scheduledAt) < gracePeriod;
  }
}
