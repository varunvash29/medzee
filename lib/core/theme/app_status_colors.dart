import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic colours that are specific to medication status.
///
/// These live outside [ColorScheme] because they encode clinical meaning
/// (taken, due, missed, low stock) rather than a UI role. Every one of them
/// ships a paired "soft" container colour so status chips stay quiet.
@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.taken,
    required this.takenContainer,
    required this.due,
    required this.dueContainer,
    required this.upcoming,
    required this.upcomingContainer,
    required this.missed,
    required this.missedContainer,
    required this.skipped,
    required this.skippedContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.infoContainer,
  });

  final Color taken;
  final Color takenContainer;
  final Color due;
  final Color dueContainer;
  final Color upcoming;
  final Color upcomingContainer;
  final Color missed;
  final Color missedContainer;
  final Color skipped;
  final Color skippedContainer;
  final Color warning;
  final Color warningContainer;
  final Color info;
  final Color infoContainer;

  static const AppStatusColors light = AppStatusColors(
    taken: AppColors.success,
    takenContainer: AppColors.successSoft,
    due: AppColors.warning,
    dueContainer: AppColors.warningSoft,
    upcoming: AppColors.info,
    upcomingContainer: AppColors.infoSoft,
    missed: AppColors.critical,
    missedContainer: AppColors.criticalSoft,
    skipped: AppColors.neutral,
    skippedContainer: AppColors.neutralSoft,
    warning: AppColors.warning,
    warningContainer: AppColors.warningSoft,
    info: AppColors.info,
    infoContainer: AppColors.infoSoft,
  );

  static const AppStatusColors dark = AppStatusColors(
    taken: Color(0xFF5FD48A),
    takenContainer: AppColors.successSoftDark,
    due: Color(0xFFF0B558),
    dueContainer: AppColors.warningSoftDark,
    upcoming: Color(0xFF7FA9F5),
    upcomingContainer: AppColors.infoSoftDark,
    missed: Color(0xFFF08A84),
    missedContainer: AppColors.criticalSoftDark,
    skipped: Color(0xFF9AAAA6),
    skippedContainer: AppColors.neutralSoftDark,
    warning: Color(0xFFF0B558),
    warningContainer: AppColors.warningSoftDark,
    info: Color(0xFF7FA9F5),
    infoContainer: AppColors.infoSoftDark,
  );

  @override
  AppStatusColors copyWith({
    Color? taken,
    Color? takenContainer,
    Color? due,
    Color? dueContainer,
    Color? upcoming,
    Color? upcomingContainer,
    Color? missed,
    Color? missedContainer,
    Color? skipped,
    Color? skippedContainer,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? infoContainer,
  }) {
    return AppStatusColors(
      taken: taken ?? this.taken,
      takenContainer: takenContainer ?? this.takenContainer,
      due: due ?? this.due,
      dueContainer: dueContainer ?? this.dueContainer,
      upcoming: upcoming ?? this.upcoming,
      upcomingContainer: upcomingContainer ?? this.upcomingContainer,
      missed: missed ?? this.missed,
      missedContainer: missedContainer ?? this.missedContainer,
      skipped: skipped ?? this.skipped,
      skippedContainer: skippedContainer ?? this.skippedContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
    );
  }

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      taken: Color.lerp(taken, other.taken, t)!,
      takenContainer: Color.lerp(takenContainer, other.takenContainer, t)!,
      due: Color.lerp(due, other.due, t)!,
      dueContainer: Color.lerp(dueContainer, other.dueContainer, t)!,
      upcoming: Color.lerp(upcoming, other.upcoming, t)!,
      upcomingContainer:
          Color.lerp(upcomingContainer, other.upcomingContainer, t)!,
      missed: Color.lerp(missed, other.missed, t)!,
      missedContainer: Color.lerp(missedContainer, other.missedContainer, t)!,
      skipped: Color.lerp(skipped, other.skipped, t)!,
      skippedContainer: Color.lerp(skippedContainer, other.skippedContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
    );
  }
}

/// Convenience accessor: `context.statusColors.taken`.
extension AppStatusColorsX on BuildContext {
  AppStatusColors get statusColors =>
      Theme.of(this).extension<AppStatusColors>() ?? AppStatusColors.light;
}
