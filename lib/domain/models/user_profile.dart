import 'core_enums.dart';

/// Per-user settings and preferences.
class UserProfile {
  const UserProfile({
    required this.id,
    this.displayName,
    this.timezoneId,
    this.travelMode = false,
    this.timeFormat = TimeFormat.h12,
    this.themeMode = AppThemeMode.system,
    this.notificationsEnabled = true,
    this.defaultReminderEnabled = true,
    this.preReminderMinutes,
    this.missedFollowUpEnabled = false,
    this.missedFollowUpMinutes = 60,
    this.quietHoursEnabled = false,
    this.quietHoursStartMinutes = 22 * 60,
    this.quietHoursEndMinutes = 7 * 60,
    this.dailySummaryEnabled = false,
    this.dailySummaryMinutes = 20 * 60,
    this.notificationPrivacy = NotificationPrivacy.detailed,
    this.onboardingCompleted = false,
    this.demoMode = false,
    this.appLockEnabled = false,
    this.textScale = 1.0,
    this.appearance = AppearanceStyle.tint,
    this.createdAt,
    this.updatedAt,
  });

  final String id;

  /// Optional preferred name used in the home greeting.
  final String? displayName;

  /// The IANA time zone the reminders are written in (their "home" zone),
  /// e.g. "America/New_York". Null until first set.
  final String? timezoneId;

  /// When on, reminders stay on [timezoneId] even if the phone is in another
  /// time zone. When off they follow the phone.
  final bool travelMode;
  final TimeFormat timeFormat;
  final AppThemeMode themeMode;
  final bool notificationsEnabled;
  final bool defaultReminderEnabled;

  /// Minutes before the scheduled time to fire an early nudge.
  final int? preReminderMinutes;
  final bool missedFollowUpEnabled;
  final int missedFollowUpMinutes;
  final bool quietHoursEnabled;
  final int quietHoursStartMinutes;
  final int quietHoursEndMinutes;
  final bool dailySummaryEnabled;
  final int dailySummaryMinutes;
  final NotificationPrivacy notificationPrivacy;
  final bool onboardingCompleted;

  /// When enabled the app is seeded with clearly labelled sample data.
  final bool demoMode;
  final bool appLockEnabled;

  /// Accessibility multiplier applied to the app's typography.
  final double textScale;
  final AppearanceStyle appearance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Safe defaults used before the first profile row exists.
  ///
  /// Only the UI reads this during the first frame; persistence always goes
  /// through a real row created by onboarding.
  static UserProfile get fallback => const UserProfile(id: 'local');

  bool get hasQuietHours => quietHoursEnabled;

  UserProfile copyWith({
    String? id,
    String? displayName,
    bool clearDisplayName = false,
    String? timezoneId,
    bool clearTimezoneId = false,
    bool? travelMode,
    TimeFormat? timeFormat,
    AppThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? defaultReminderEnabled,
    int? preReminderMinutes,
    bool clearPreReminderMinutes = false,
    bool? missedFollowUpEnabled,
    int? missedFollowUpMinutes,
    bool? quietHoursEnabled,
    int? quietHoursStartMinutes,
    int? quietHoursEndMinutes,
    bool? dailySummaryEnabled,
    int? dailySummaryMinutes,
    NotificationPrivacy? notificationPrivacy,
    bool? onboardingCompleted,
    bool? demoMode,
    bool? appLockEnabled,
    double? textScale,
    AppearanceStyle? appearance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: clearDisplayName ? null : (displayName ?? this.displayName),
      timezoneId: clearTimezoneId ? null : (timezoneId ?? this.timezoneId),
      travelMode: travelMode ?? this.travelMode,
      timeFormat: timeFormat ?? this.timeFormat,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultReminderEnabled:
          defaultReminderEnabled ?? this.defaultReminderEnabled,
      preReminderMinutes: clearPreReminderMinutes
          ? null
          : (preReminderMinutes ?? this.preReminderMinutes),
      missedFollowUpEnabled:
          missedFollowUpEnabled ?? this.missedFollowUpEnabled,
      missedFollowUpMinutes:
          missedFollowUpMinutes ?? this.missedFollowUpMinutes,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStartMinutes:
          quietHoursStartMinutes ?? this.quietHoursStartMinutes,
      quietHoursEndMinutes:
          quietHoursEndMinutes ?? this.quietHoursEndMinutes,
      dailySummaryEnabled: dailySummaryEnabled ?? this.dailySummaryEnabled,
      dailySummaryMinutes:
          dailySummaryMinutes ?? this.dailySummaryMinutes,
      notificationPrivacy:
          notificationPrivacy ?? this.notificationPrivacy,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      demoMode: demoMode ?? this.demoMode,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      textScale: textScale ?? this.textScale,
      appearance: appearance ?? this.appearance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Theme preference.
enum AppThemeMode {
  system,
  light,
  dark;

  static AppThemeMode fromName(String value) => AppThemeMode.values.firstWhere(
        (AppThemeMode e) => e.name == value,
        orElse: () => AppThemeMode.system,
      );

  String get label => switch (this) {
        AppThemeMode.system => 'Match system',
        AppThemeMode.light => 'Light',
        AppThemeMode.dark => 'Dark',
      };
}

/// Visual personality of the app surfaces.
enum AppearanceStyle {
  /// Brand teal (default).
  tint,

  /// Neutral slate.
  neutral;

  static AppearanceStyle fromName(String value) => AppearanceStyle.values.firstWhere(
        (AppearanceStyle e) => e.name == value,
        orElse: () => AppearanceStyle.tint,
      );

  String get label => switch (this) {
        AppearanceStyle.tint => 'Medzee teal',
        AppearanceStyle.neutral => 'Neutral',
      };
}
