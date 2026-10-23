// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timezoneIdMeta = const VerificationMeta(
    'timezoneId',
  );
  @override
  late final GeneratedColumn<String> timezoneId = GeneratedColumn<String>(
    'timezone_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeFormatMeta = const VerificationMeta(
    'timeFormat',
  );
  @override
  late final GeneratedColumn<String> timeFormat = GeneratedColumn<String>(
    'time_format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _defaultReminderEnabledMeta =
      const VerificationMeta('defaultReminderEnabled');
  @override
  late final GeneratedColumn<bool> defaultReminderEnabled =
      GeneratedColumn<bool>(
        'default_reminder_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("default_reminder_enabled" IN (0, 1))',
        ),
      );
  static const VerificationMeta _preReminderMinutesMeta =
      const VerificationMeta('preReminderMinutes');
  @override
  late final GeneratedColumn<int> preReminderMinutes = GeneratedColumn<int>(
    'pre_reminder_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _missedFollowUpEnabledMeta =
      const VerificationMeta('missedFollowUpEnabled');
  @override
  late final GeneratedColumn<bool> missedFollowUpEnabled =
      GeneratedColumn<bool>(
        'missed_follow_up_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("missed_follow_up_enabled" IN (0, 1))',
        ),
      );
  static const VerificationMeta _missedFollowUpMinutesMeta =
      const VerificationMeta('missedFollowUpMinutes');
  @override
  late final GeneratedColumn<int> missedFollowUpMinutes = GeneratedColumn<int>(
    'missed_follow_up_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quietHoursEnabledMeta = const VerificationMeta(
    'quietHoursEnabled',
  );
  @override
  late final GeneratedColumn<bool> quietHoursEnabled = GeneratedColumn<bool>(
    'quiet_hours_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("quiet_hours_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _quietHoursStartMinutesMeta =
      const VerificationMeta('quietHoursStartMinutes');
  @override
  late final GeneratedColumn<int> quietHoursStartMinutes = GeneratedColumn<int>(
    'quiet_hours_start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quietHoursEndMinutesMeta =
      const VerificationMeta('quietHoursEndMinutes');
  @override
  late final GeneratedColumn<int> quietHoursEndMinutes = GeneratedColumn<int>(
    'quiet_hours_end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailySummaryEnabledMeta =
      const VerificationMeta('dailySummaryEnabled');
  @override
  late final GeneratedColumn<bool> dailySummaryEnabled = GeneratedColumn<bool>(
    'daily_summary_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("daily_summary_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _dailySummaryMinutesMeta =
      const VerificationMeta('dailySummaryMinutes');
  @override
  late final GeneratedColumn<int> dailySummaryMinutes = GeneratedColumn<int>(
    'daily_summary_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationPrivacyMeta =
      const VerificationMeta('notificationPrivacy');
  @override
  late final GeneratedColumn<String> notificationPrivacy =
      GeneratedColumn<String>(
        'notification_privacy',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _demoModeMeta = const VerificationMeta(
    'demoMode',
  );
  @override
  late final GeneratedColumn<bool> demoMode = GeneratedColumn<bool>(
    'demo_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("demo_mode" IN (0, 1))',
    ),
  );
  static const VerificationMeta _appLockEnabledMeta = const VerificationMeta(
    'appLockEnabled',
  );
  @override
  late final GeneratedColumn<bool> appLockEnabled = GeneratedColumn<bool>(
    'app_lock_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("app_lock_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _textScaleMeta = const VerificationMeta(
    'textScale',
  );
  @override
  late final GeneratedColumn<double> textScale = GeneratedColumn<double>(
    'text_scale',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appearanceMeta = const VerificationMeta(
    'appearance',
  );
  @override
  late final GeneratedColumn<String> appearance = GeneratedColumn<String>(
    'appearance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    timezoneId,
    timeFormat,
    themeMode,
    notificationsEnabled,
    defaultReminderEnabled,
    preReminderMinutes,
    missedFollowUpEnabled,
    missedFollowUpMinutes,
    quietHoursEnabled,
    quietHoursStartMinutes,
    quietHoursEndMinutes,
    dailySummaryEnabled,
    dailySummaryMinutes,
    notificationPrivacy,
    onboardingCompleted,
    demoMode,
    appLockEnabled,
    textScale,
    appearance,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('timezone_id')) {
      context.handle(
        _timezoneIdMeta,
        timezoneId.isAcceptableOrUnknown(data['timezone_id']!, _timezoneIdMeta),
      );
    }
    if (data.containsKey('time_format')) {
      context.handle(
        _timeFormatMeta,
        timeFormat.isAcceptableOrUnknown(data['time_format']!, _timeFormatMeta),
      );
    } else if (isInserting) {
      context.missing(_timeFormatMeta);
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    } else if (isInserting) {
      context.missing(_themeModeMeta);
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationsEnabledMeta);
    }
    if (data.containsKey('default_reminder_enabled')) {
      context.handle(
        _defaultReminderEnabledMeta,
        defaultReminderEnabled.isAcceptableOrUnknown(
          data['default_reminder_enabled']!,
          _defaultReminderEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultReminderEnabledMeta);
    }
    if (data.containsKey('pre_reminder_minutes')) {
      context.handle(
        _preReminderMinutesMeta,
        preReminderMinutes.isAcceptableOrUnknown(
          data['pre_reminder_minutes']!,
          _preReminderMinutesMeta,
        ),
      );
    }
    if (data.containsKey('missed_follow_up_enabled')) {
      context.handle(
        _missedFollowUpEnabledMeta,
        missedFollowUpEnabled.isAcceptableOrUnknown(
          data['missed_follow_up_enabled']!,
          _missedFollowUpEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_missedFollowUpEnabledMeta);
    }
    if (data.containsKey('missed_follow_up_minutes')) {
      context.handle(
        _missedFollowUpMinutesMeta,
        missedFollowUpMinutes.isAcceptableOrUnknown(
          data['missed_follow_up_minutes']!,
          _missedFollowUpMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_missedFollowUpMinutesMeta);
    }
    if (data.containsKey('quiet_hours_enabled')) {
      context.handle(
        _quietHoursEnabledMeta,
        quietHoursEnabled.isAcceptableOrUnknown(
          data['quiet_hours_enabled']!,
          _quietHoursEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quietHoursEnabledMeta);
    }
    if (data.containsKey('quiet_hours_start_minutes')) {
      context.handle(
        _quietHoursStartMinutesMeta,
        quietHoursStartMinutes.isAcceptableOrUnknown(
          data['quiet_hours_start_minutes']!,
          _quietHoursStartMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quietHoursStartMinutesMeta);
    }
    if (data.containsKey('quiet_hours_end_minutes')) {
      context.handle(
        _quietHoursEndMinutesMeta,
        quietHoursEndMinutes.isAcceptableOrUnknown(
          data['quiet_hours_end_minutes']!,
          _quietHoursEndMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quietHoursEndMinutesMeta);
    }
    if (data.containsKey('daily_summary_enabled')) {
      context.handle(
        _dailySummaryEnabledMeta,
        dailySummaryEnabled.isAcceptableOrUnknown(
          data['daily_summary_enabled']!,
          _dailySummaryEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailySummaryEnabledMeta);
    }
    if (data.containsKey('daily_summary_minutes')) {
      context.handle(
        _dailySummaryMinutesMeta,
        dailySummaryMinutes.isAcceptableOrUnknown(
          data['daily_summary_minutes']!,
          _dailySummaryMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailySummaryMinutesMeta);
    }
    if (data.containsKey('notification_privacy')) {
      context.handle(
        _notificationPrivacyMeta,
        notificationPrivacy.isAcceptableOrUnknown(
          data['notification_privacy']!,
          _notificationPrivacyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationPrivacyMeta);
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_onboardingCompletedMeta);
    }
    if (data.containsKey('demo_mode')) {
      context.handle(
        _demoModeMeta,
        demoMode.isAcceptableOrUnknown(data['demo_mode']!, _demoModeMeta),
      );
    } else if (isInserting) {
      context.missing(_demoModeMeta);
    }
    if (data.containsKey('app_lock_enabled')) {
      context.handle(
        _appLockEnabledMeta,
        appLockEnabled.isAcceptableOrUnknown(
          data['app_lock_enabled']!,
          _appLockEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appLockEnabledMeta);
    }
    if (data.containsKey('text_scale')) {
      context.handle(
        _textScaleMeta,
        textScale.isAcceptableOrUnknown(data['text_scale']!, _textScaleMeta),
      );
    } else if (isInserting) {
      context.missing(_textScaleMeta);
    }
    if (data.containsKey('appearance')) {
      context.handle(
        _appearanceMeta,
        appearance.isAcceptableOrUnknown(data['appearance']!, _appearanceMeta),
      );
    } else if (isInserting) {
      context.missing(_appearanceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      timezoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone_id'],
      ),
      timeFormat:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}time_format'],
          )!,
      themeMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}theme_mode'],
          )!,
      notificationsEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}notifications_enabled'],
          )!,
      defaultReminderEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}default_reminder_enabled'],
          )!,
      preReminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pre_reminder_minutes'],
      ),
      missedFollowUpEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}missed_follow_up_enabled'],
          )!,
      missedFollowUpMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}missed_follow_up_minutes'],
          )!,
      quietHoursEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}quiet_hours_enabled'],
          )!,
      quietHoursStartMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}quiet_hours_start_minutes'],
          )!,
      quietHoursEndMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}quiet_hours_end_minutes'],
          )!,
      dailySummaryEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}daily_summary_enabled'],
          )!,
      dailySummaryMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}daily_summary_minutes'],
          )!,
      notificationPrivacy:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}notification_privacy'],
          )!,
      onboardingCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}onboarding_completed'],
          )!,
      demoMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}demo_mode'],
          )!,
      appLockEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}app_lock_enabled'],
          )!,
      textScale:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}text_scale'],
          )!,
      appearance:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}appearance'],
          )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfileRow extends DataClass implements Insertable<UserProfileRow> {
  final String id;
  final String? displayName;
  final String? timezoneId;
  final String timeFormat;
  final String themeMode;
  final bool notificationsEnabled;
  final bool defaultReminderEnabled;
  final int? preReminderMinutes;
  final bool missedFollowUpEnabled;
  final int missedFollowUpMinutes;
  final bool quietHoursEnabled;
  final int quietHoursStartMinutes;
  final int quietHoursEndMinutes;
  final bool dailySummaryEnabled;
  final int dailySummaryMinutes;
  final String notificationPrivacy;
  final bool onboardingCompleted;
  final bool demoMode;
  final bool appLockEnabled;
  final double textScale;
  final String appearance;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const UserProfileRow({
    required this.id,
    this.displayName,
    this.timezoneId,
    required this.timeFormat,
    required this.themeMode,
    required this.notificationsEnabled,
    required this.defaultReminderEnabled,
    this.preReminderMinutes,
    required this.missedFollowUpEnabled,
    required this.missedFollowUpMinutes,
    required this.quietHoursEnabled,
    required this.quietHoursStartMinutes,
    required this.quietHoursEndMinutes,
    required this.dailySummaryEnabled,
    required this.dailySummaryMinutes,
    required this.notificationPrivacy,
    required this.onboardingCompleted,
    required this.demoMode,
    required this.appLockEnabled,
    required this.textScale,
    required this.appearance,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || timezoneId != null) {
      map['timezone_id'] = Variable<String>(timezoneId);
    }
    map['time_format'] = Variable<String>(timeFormat);
    map['theme_mode'] = Variable<String>(themeMode);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['default_reminder_enabled'] = Variable<bool>(defaultReminderEnabled);
    if (!nullToAbsent || preReminderMinutes != null) {
      map['pre_reminder_minutes'] = Variable<int>(preReminderMinutes);
    }
    map['missed_follow_up_enabled'] = Variable<bool>(missedFollowUpEnabled);
    map['missed_follow_up_minutes'] = Variable<int>(missedFollowUpMinutes);
    map['quiet_hours_enabled'] = Variable<bool>(quietHoursEnabled);
    map['quiet_hours_start_minutes'] = Variable<int>(quietHoursStartMinutes);
    map['quiet_hours_end_minutes'] = Variable<int>(quietHoursEndMinutes);
    map['daily_summary_enabled'] = Variable<bool>(dailySummaryEnabled);
    map['daily_summary_minutes'] = Variable<int>(dailySummaryMinutes);
    map['notification_privacy'] = Variable<String>(notificationPrivacy);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['demo_mode'] = Variable<bool>(demoMode);
    map['app_lock_enabled'] = Variable<bool>(appLockEnabled);
    map['text_scale'] = Variable<double>(textScale);
    map['appearance'] = Variable<String>(appearance);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      displayName:
          displayName == null && nullToAbsent
              ? const Value.absent()
              : Value(displayName),
      timezoneId:
          timezoneId == null && nullToAbsent
              ? const Value.absent()
              : Value(timezoneId),
      timeFormat: Value(timeFormat),
      themeMode: Value(themeMode),
      notificationsEnabled: Value(notificationsEnabled),
      defaultReminderEnabled: Value(defaultReminderEnabled),
      preReminderMinutes:
          preReminderMinutes == null && nullToAbsent
              ? const Value.absent()
              : Value(preReminderMinutes),
      missedFollowUpEnabled: Value(missedFollowUpEnabled),
      missedFollowUpMinutes: Value(missedFollowUpMinutes),
      quietHoursEnabled: Value(quietHoursEnabled),
      quietHoursStartMinutes: Value(quietHoursStartMinutes),
      quietHoursEndMinutes: Value(quietHoursEndMinutes),
      dailySummaryEnabled: Value(dailySummaryEnabled),
      dailySummaryMinutes: Value(dailySummaryMinutes),
      notificationPrivacy: Value(notificationPrivacy),
      onboardingCompleted: Value(onboardingCompleted),
      demoMode: Value(demoMode),
      appLockEnabled: Value(appLockEnabled),
      textScale: Value(textScale),
      appearance: Value(appearance),
      createdAt:
          createdAt == null && nullToAbsent
              ? const Value.absent()
              : Value(createdAt),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory UserProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileRow(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      timezoneId: serializer.fromJson<String?>(json['timezoneId']),
      timeFormat: serializer.fromJson<String>(json['timeFormat']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      defaultReminderEnabled: serializer.fromJson<bool>(
        json['defaultReminderEnabled'],
      ),
      preReminderMinutes: serializer.fromJson<int?>(json['preReminderMinutes']),
      missedFollowUpEnabled: serializer.fromJson<bool>(
        json['missedFollowUpEnabled'],
      ),
      missedFollowUpMinutes: serializer.fromJson<int>(
        json['missedFollowUpMinutes'],
      ),
      quietHoursEnabled: serializer.fromJson<bool>(json['quietHoursEnabled']),
      quietHoursStartMinutes: serializer.fromJson<int>(
        json['quietHoursStartMinutes'],
      ),
      quietHoursEndMinutes: serializer.fromJson<int>(
        json['quietHoursEndMinutes'],
      ),
      dailySummaryEnabled: serializer.fromJson<bool>(
        json['dailySummaryEnabled'],
      ),
      dailySummaryMinutes: serializer.fromJson<int>(
        json['dailySummaryMinutes'],
      ),
      notificationPrivacy: serializer.fromJson<String>(
        json['notificationPrivacy'],
      ),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      demoMode: serializer.fromJson<bool>(json['demoMode']),
      appLockEnabled: serializer.fromJson<bool>(json['appLockEnabled']),
      textScale: serializer.fromJson<double>(json['textScale']),
      appearance: serializer.fromJson<String>(json['appearance']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String?>(displayName),
      'timezoneId': serializer.toJson<String?>(timezoneId),
      'timeFormat': serializer.toJson<String>(timeFormat),
      'themeMode': serializer.toJson<String>(themeMode),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'defaultReminderEnabled': serializer.toJson<bool>(defaultReminderEnabled),
      'preReminderMinutes': serializer.toJson<int?>(preReminderMinutes),
      'missedFollowUpEnabled': serializer.toJson<bool>(missedFollowUpEnabled),
      'missedFollowUpMinutes': serializer.toJson<int>(missedFollowUpMinutes),
      'quietHoursEnabled': serializer.toJson<bool>(quietHoursEnabled),
      'quietHoursStartMinutes': serializer.toJson<int>(quietHoursStartMinutes),
      'quietHoursEndMinutes': serializer.toJson<int>(quietHoursEndMinutes),
      'dailySummaryEnabled': serializer.toJson<bool>(dailySummaryEnabled),
      'dailySummaryMinutes': serializer.toJson<int>(dailySummaryMinutes),
      'notificationPrivacy': serializer.toJson<String>(notificationPrivacy),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'demoMode': serializer.toJson<bool>(demoMode),
      'appLockEnabled': serializer.toJson<bool>(appLockEnabled),
      'textScale': serializer.toJson<double>(textScale),
      'appearance': serializer.toJson<String>(appearance),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  UserProfileRow copyWith({
    String? id,
    Value<String?> displayName = const Value.absent(),
    Value<String?> timezoneId = const Value.absent(),
    String? timeFormat,
    String? themeMode,
    bool? notificationsEnabled,
    bool? defaultReminderEnabled,
    Value<int?> preReminderMinutes = const Value.absent(),
    bool? missedFollowUpEnabled,
    int? missedFollowUpMinutes,
    bool? quietHoursEnabled,
    int? quietHoursStartMinutes,
    int? quietHoursEndMinutes,
    bool? dailySummaryEnabled,
    int? dailySummaryMinutes,
    String? notificationPrivacy,
    bool? onboardingCompleted,
    bool? demoMode,
    bool? appLockEnabled,
    double? textScale,
    String? appearance,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => UserProfileRow(
    id: id ?? this.id,
    displayName: displayName.present ? displayName.value : this.displayName,
    timezoneId: timezoneId.present ? timezoneId.value : this.timezoneId,
    timeFormat: timeFormat ?? this.timeFormat,
    themeMode: themeMode ?? this.themeMode,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    defaultReminderEnabled:
        defaultReminderEnabled ?? this.defaultReminderEnabled,
    preReminderMinutes:
        preReminderMinutes.present
            ? preReminderMinutes.value
            : this.preReminderMinutes,
    missedFollowUpEnabled: missedFollowUpEnabled ?? this.missedFollowUpEnabled,
    missedFollowUpMinutes: missedFollowUpMinutes ?? this.missedFollowUpMinutes,
    quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
    quietHoursStartMinutes:
        quietHoursStartMinutes ?? this.quietHoursStartMinutes,
    quietHoursEndMinutes: quietHoursEndMinutes ?? this.quietHoursEndMinutes,
    dailySummaryEnabled: dailySummaryEnabled ?? this.dailySummaryEnabled,
    dailySummaryMinutes: dailySummaryMinutes ?? this.dailySummaryMinutes,
    notificationPrivacy: notificationPrivacy ?? this.notificationPrivacy,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    demoMode: demoMode ?? this.demoMode,
    appLockEnabled: appLockEnabled ?? this.appLockEnabled,
    textScale: textScale ?? this.textScale,
    appearance: appearance ?? this.appearance,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  UserProfileRow copyWithCompanion(UserProfilesCompanion data) {
    return UserProfileRow(
      id: data.id.present ? data.id.value : this.id,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      timezoneId:
          data.timezoneId.present ? data.timezoneId.value : this.timezoneId,
      timeFormat:
          data.timeFormat.present ? data.timeFormat.value : this.timeFormat,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      notificationsEnabled:
          data.notificationsEnabled.present
              ? data.notificationsEnabled.value
              : this.notificationsEnabled,
      defaultReminderEnabled:
          data.defaultReminderEnabled.present
              ? data.defaultReminderEnabled.value
              : this.defaultReminderEnabled,
      preReminderMinutes:
          data.preReminderMinutes.present
              ? data.preReminderMinutes.value
              : this.preReminderMinutes,
      missedFollowUpEnabled:
          data.missedFollowUpEnabled.present
              ? data.missedFollowUpEnabled.value
              : this.missedFollowUpEnabled,
      missedFollowUpMinutes:
          data.missedFollowUpMinutes.present
              ? data.missedFollowUpMinutes.value
              : this.missedFollowUpMinutes,
      quietHoursEnabled:
          data.quietHoursEnabled.present
              ? data.quietHoursEnabled.value
              : this.quietHoursEnabled,
      quietHoursStartMinutes:
          data.quietHoursStartMinutes.present
              ? data.quietHoursStartMinutes.value
              : this.quietHoursStartMinutes,
      quietHoursEndMinutes:
          data.quietHoursEndMinutes.present
              ? data.quietHoursEndMinutes.value
              : this.quietHoursEndMinutes,
      dailySummaryEnabled:
          data.dailySummaryEnabled.present
              ? data.dailySummaryEnabled.value
              : this.dailySummaryEnabled,
      dailySummaryMinutes:
          data.dailySummaryMinutes.present
              ? data.dailySummaryMinutes.value
              : this.dailySummaryMinutes,
      notificationPrivacy:
          data.notificationPrivacy.present
              ? data.notificationPrivacy.value
              : this.notificationPrivacy,
      onboardingCompleted:
          data.onboardingCompleted.present
              ? data.onboardingCompleted.value
              : this.onboardingCompleted,
      demoMode: data.demoMode.present ? data.demoMode.value : this.demoMode,
      appLockEnabled:
          data.appLockEnabled.present
              ? data.appLockEnabled.value
              : this.appLockEnabled,
      textScale: data.textScale.present ? data.textScale.value : this.textScale,
      appearance:
          data.appearance.present ? data.appearance.value : this.appearance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileRow(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('timeFormat: $timeFormat, ')
          ..write('themeMode: $themeMode, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('defaultReminderEnabled: $defaultReminderEnabled, ')
          ..write('preReminderMinutes: $preReminderMinutes, ')
          ..write('missedFollowUpEnabled: $missedFollowUpEnabled, ')
          ..write('missedFollowUpMinutes: $missedFollowUpMinutes, ')
          ..write('quietHoursEnabled: $quietHoursEnabled, ')
          ..write('quietHoursStartMinutes: $quietHoursStartMinutes, ')
          ..write('quietHoursEndMinutes: $quietHoursEndMinutes, ')
          ..write('dailySummaryEnabled: $dailySummaryEnabled, ')
          ..write('dailySummaryMinutes: $dailySummaryMinutes, ')
          ..write('notificationPrivacy: $notificationPrivacy, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('demoMode: $demoMode, ')
          ..write('appLockEnabled: $appLockEnabled, ')
          ..write('textScale: $textScale, ')
          ..write('appearance: $appearance, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    displayName,
    timezoneId,
    timeFormat,
    themeMode,
    notificationsEnabled,
    defaultReminderEnabled,
    preReminderMinutes,
    missedFollowUpEnabled,
    missedFollowUpMinutes,
    quietHoursEnabled,
    quietHoursStartMinutes,
    quietHoursEndMinutes,
    dailySummaryEnabled,
    dailySummaryMinutes,
    notificationPrivacy,
    onboardingCompleted,
    demoMode,
    appLockEnabled,
    textScale,
    appearance,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileRow &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.timezoneId == this.timezoneId &&
          other.timeFormat == this.timeFormat &&
          other.themeMode == this.themeMode &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.defaultReminderEnabled == this.defaultReminderEnabled &&
          other.preReminderMinutes == this.preReminderMinutes &&
          other.missedFollowUpEnabled == this.missedFollowUpEnabled &&
          other.missedFollowUpMinutes == this.missedFollowUpMinutes &&
          other.quietHoursEnabled == this.quietHoursEnabled &&
          other.quietHoursStartMinutes == this.quietHoursStartMinutes &&
          other.quietHoursEndMinutes == this.quietHoursEndMinutes &&
          other.dailySummaryEnabled == this.dailySummaryEnabled &&
          other.dailySummaryMinutes == this.dailySummaryMinutes &&
          other.notificationPrivacy == this.notificationPrivacy &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.demoMode == this.demoMode &&
          other.appLockEnabled == this.appLockEnabled &&
          other.textScale == this.textScale &&
          other.appearance == this.appearance &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfileRow> {
  final Value<String> id;
  final Value<String?> displayName;
  final Value<String?> timezoneId;
  final Value<String> timeFormat;
  final Value<String> themeMode;
  final Value<bool> notificationsEnabled;
  final Value<bool> defaultReminderEnabled;
  final Value<int?> preReminderMinutes;
  final Value<bool> missedFollowUpEnabled;
  final Value<int> missedFollowUpMinutes;
  final Value<bool> quietHoursEnabled;
  final Value<int> quietHoursStartMinutes;
  final Value<int> quietHoursEndMinutes;
  final Value<bool> dailySummaryEnabled;
  final Value<int> dailySummaryMinutes;
  final Value<String> notificationPrivacy;
  final Value<bool> onboardingCompleted;
  final Value<bool> demoMode;
  final Value<bool> appLockEnabled;
  final Value<double> textScale;
  final Value<String> appearance;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.timezoneId = const Value.absent(),
    this.timeFormat = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.defaultReminderEnabled = const Value.absent(),
    this.preReminderMinutes = const Value.absent(),
    this.missedFollowUpEnabled = const Value.absent(),
    this.missedFollowUpMinutes = const Value.absent(),
    this.quietHoursEnabled = const Value.absent(),
    this.quietHoursStartMinutes = const Value.absent(),
    this.quietHoursEndMinutes = const Value.absent(),
    this.dailySummaryEnabled = const Value.absent(),
    this.dailySummaryMinutes = const Value.absent(),
    this.notificationPrivacy = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.demoMode = const Value.absent(),
    this.appLockEnabled = const Value.absent(),
    this.textScale = const Value.absent(),
    this.appearance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    this.displayName = const Value.absent(),
    this.timezoneId = const Value.absent(),
    required String timeFormat,
    required String themeMode,
    required bool notificationsEnabled,
    required bool defaultReminderEnabled,
    this.preReminderMinutes = const Value.absent(),
    required bool missedFollowUpEnabled,
    required int missedFollowUpMinutes,
    required bool quietHoursEnabled,
    required int quietHoursStartMinutes,
    required int quietHoursEndMinutes,
    required bool dailySummaryEnabled,
    required int dailySummaryMinutes,
    required String notificationPrivacy,
    required bool onboardingCompleted,
    required bool demoMode,
    required bool appLockEnabled,
    required double textScale,
    required String appearance,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       timeFormat = Value(timeFormat),
       themeMode = Value(themeMode),
       notificationsEnabled = Value(notificationsEnabled),
       defaultReminderEnabled = Value(defaultReminderEnabled),
       missedFollowUpEnabled = Value(missedFollowUpEnabled),
       missedFollowUpMinutes = Value(missedFollowUpMinutes),
       quietHoursEnabled = Value(quietHoursEnabled),
       quietHoursStartMinutes = Value(quietHoursStartMinutes),
       quietHoursEndMinutes = Value(quietHoursEndMinutes),
       dailySummaryEnabled = Value(dailySummaryEnabled),
       dailySummaryMinutes = Value(dailySummaryMinutes),
       notificationPrivacy = Value(notificationPrivacy),
       onboardingCompleted = Value(onboardingCompleted),
       demoMode = Value(demoMode),
       appLockEnabled = Value(appLockEnabled),
       textScale = Value(textScale),
       appearance = Value(appearance);
  static Insertable<UserProfileRow> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? timezoneId,
    Expression<String>? timeFormat,
    Expression<String>? themeMode,
    Expression<bool>? notificationsEnabled,
    Expression<bool>? defaultReminderEnabled,
    Expression<int>? preReminderMinutes,
    Expression<bool>? missedFollowUpEnabled,
    Expression<int>? missedFollowUpMinutes,
    Expression<bool>? quietHoursEnabled,
    Expression<int>? quietHoursStartMinutes,
    Expression<int>? quietHoursEndMinutes,
    Expression<bool>? dailySummaryEnabled,
    Expression<int>? dailySummaryMinutes,
    Expression<String>? notificationPrivacy,
    Expression<bool>? onboardingCompleted,
    Expression<bool>? demoMode,
    Expression<bool>? appLockEnabled,
    Expression<double>? textScale,
    Expression<String>? appearance,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (timezoneId != null) 'timezone_id': timezoneId,
      if (timeFormat != null) 'time_format': timeFormat,
      if (themeMode != null) 'theme_mode': themeMode,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (defaultReminderEnabled != null)
        'default_reminder_enabled': defaultReminderEnabled,
      if (preReminderMinutes != null)
        'pre_reminder_minutes': preReminderMinutes,
      if (missedFollowUpEnabled != null)
        'missed_follow_up_enabled': missedFollowUpEnabled,
      if (missedFollowUpMinutes != null)
        'missed_follow_up_minutes': missedFollowUpMinutes,
      if (quietHoursEnabled != null) 'quiet_hours_enabled': quietHoursEnabled,
      if (quietHoursStartMinutes != null)
        'quiet_hours_start_minutes': quietHoursStartMinutes,
      if (quietHoursEndMinutes != null)
        'quiet_hours_end_minutes': quietHoursEndMinutes,
      if (dailySummaryEnabled != null)
        'daily_summary_enabled': dailySummaryEnabled,
      if (dailySummaryMinutes != null)
        'daily_summary_minutes': dailySummaryMinutes,
      if (notificationPrivacy != null)
        'notification_privacy': notificationPrivacy,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (demoMode != null) 'demo_mode': demoMode,
      if (appLockEnabled != null) 'app_lock_enabled': appLockEnabled,
      if (textScale != null) 'text_scale': textScale,
      if (appearance != null) 'appearance': appearance,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<String?>? displayName,
    Value<String?>? timezoneId,
    Value<String>? timeFormat,
    Value<String>? themeMode,
    Value<bool>? notificationsEnabled,
    Value<bool>? defaultReminderEnabled,
    Value<int?>? preReminderMinutes,
    Value<bool>? missedFollowUpEnabled,
    Value<int>? missedFollowUpMinutes,
    Value<bool>? quietHoursEnabled,
    Value<int>? quietHoursStartMinutes,
    Value<int>? quietHoursEndMinutes,
    Value<bool>? dailySummaryEnabled,
    Value<int>? dailySummaryMinutes,
    Value<String>? notificationPrivacy,
    Value<bool>? onboardingCompleted,
    Value<bool>? demoMode,
    Value<bool>? appLockEnabled,
    Value<double>? textScale,
    Value<String>? appearance,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      timezoneId: timezoneId ?? this.timezoneId,
      timeFormat: timeFormat ?? this.timeFormat,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultReminderEnabled:
          defaultReminderEnabled ?? this.defaultReminderEnabled,
      preReminderMinutes: preReminderMinutes ?? this.preReminderMinutes,
      missedFollowUpEnabled:
          missedFollowUpEnabled ?? this.missedFollowUpEnabled,
      missedFollowUpMinutes:
          missedFollowUpMinutes ?? this.missedFollowUpMinutes,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStartMinutes:
          quietHoursStartMinutes ?? this.quietHoursStartMinutes,
      quietHoursEndMinutes: quietHoursEndMinutes ?? this.quietHoursEndMinutes,
      dailySummaryEnabled: dailySummaryEnabled ?? this.dailySummaryEnabled,
      dailySummaryMinutes: dailySummaryMinutes ?? this.dailySummaryMinutes,
      notificationPrivacy: notificationPrivacy ?? this.notificationPrivacy,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      demoMode: demoMode ?? this.demoMode,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      textScale: textScale ?? this.textScale,
      appearance: appearance ?? this.appearance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (timezoneId.present) {
      map['timezone_id'] = Variable<String>(timezoneId.value);
    }
    if (timeFormat.present) {
      map['time_format'] = Variable<String>(timeFormat.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (defaultReminderEnabled.present) {
      map['default_reminder_enabled'] = Variable<bool>(
        defaultReminderEnabled.value,
      );
    }
    if (preReminderMinutes.present) {
      map['pre_reminder_minutes'] = Variable<int>(preReminderMinutes.value);
    }
    if (missedFollowUpEnabled.present) {
      map['missed_follow_up_enabled'] = Variable<bool>(
        missedFollowUpEnabled.value,
      );
    }
    if (missedFollowUpMinutes.present) {
      map['missed_follow_up_minutes'] = Variable<int>(
        missedFollowUpMinutes.value,
      );
    }
    if (quietHoursEnabled.present) {
      map['quiet_hours_enabled'] = Variable<bool>(quietHoursEnabled.value);
    }
    if (quietHoursStartMinutes.present) {
      map['quiet_hours_start_minutes'] = Variable<int>(
        quietHoursStartMinutes.value,
      );
    }
    if (quietHoursEndMinutes.present) {
      map['quiet_hours_end_minutes'] = Variable<int>(
        quietHoursEndMinutes.value,
      );
    }
    if (dailySummaryEnabled.present) {
      map['daily_summary_enabled'] = Variable<bool>(dailySummaryEnabled.value);
    }
    if (dailySummaryMinutes.present) {
      map['daily_summary_minutes'] = Variable<int>(dailySummaryMinutes.value);
    }
    if (notificationPrivacy.present) {
      map['notification_privacy'] = Variable<String>(notificationPrivacy.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (demoMode.present) {
      map['demo_mode'] = Variable<bool>(demoMode.value);
    }
    if (appLockEnabled.present) {
      map['app_lock_enabled'] = Variable<bool>(appLockEnabled.value);
    }
    if (textScale.present) {
      map['text_scale'] = Variable<double>(textScale.value);
    }
    if (appearance.present) {
      map['appearance'] = Variable<String>(appearance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('timeFormat: $timeFormat, ')
          ..write('themeMode: $themeMode, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('defaultReminderEnabled: $defaultReminderEnabled, ')
          ..write('preReminderMinutes: $preReminderMinutes, ')
          ..write('missedFollowUpEnabled: $missedFollowUpEnabled, ')
          ..write('missedFollowUpMinutes: $missedFollowUpMinutes, ')
          ..write('quietHoursEnabled: $quietHoursEnabled, ')
          ..write('quietHoursStartMinutes: $quietHoursStartMinutes, ')
          ..write('quietHoursEndMinutes: $quietHoursEndMinutes, ')
          ..write('dailySummaryEnabled: $dailySummaryEnabled, ')
          ..write('dailySummaryMinutes: $dailySummaryMinutes, ')
          ..write('notificationPrivacy: $notificationPrivacy, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('demoMode: $demoMode, ')
          ..write('appLockEnabled: $appLockEnabled, ')
          ..write('textScale: $textScale, ')
          ..write('appearance: $appearance, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, MedicationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genericNameMeta = const VerificationMeta(
    'genericName',
  );
  @override
  late final GeneratedColumn<String> genericName = GeneratedColumn<String>(
    'generic_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandNameMeta = const VerificationMeta(
    'brandName',
  );
  @override
  late final GeneratedColumn<String> brandName = GeneratedColumn<String>(
    'brand_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
    'form',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<double> strength = GeneratedColumn<double>(
    'strength',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strengthUnitMeta = const VerificationMeta(
    'strengthUnit',
  );
  @override
  late final GeneratedColumn<String> strengthUnit = GeneratedColumn<String>(
    'strength_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routeMeta = const VerificationMeta('route');
  @override
  late final GeneratedColumn<String> route = GeneratedColumn<String>(
    'route',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodInstructionMeta = const VerificationMeta(
    'foodInstruction',
  );
  @override
  late final GeneratedColumn<String> foodInstruction = GeneratedColumn<String>(
    'food_instruction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prescriberMeta = const VerificationMeta(
    'prescriber',
  );
  @override
  late final GeneratedColumn<String> prescriber = GeneratedColumn<String>(
    'prescriber',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pharmacyNameMeta = const VerificationMeta(
    'pharmacyName',
  );
  @override
  late final GeneratedColumn<String> pharmacyName = GeneratedColumn<String>(
    'pharmacy_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pharmacyPhoneMeta = const VerificationMeta(
    'pharmacyPhone',
  );
  @override
  late final GeneratedColumn<String> pharmacyPhone = GeneratedColumn<String>(
    'pharmacy_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAsNeededMeta = const VerificationMeta(
    'isAsNeeded',
  );
  @override
  late final GeneratedColumn<bool> isAsNeeded = GeneratedColumn<bool>(
    'is_as_needed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_as_needed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    genericName,
    brandName,
    category,
    form,
    strength,
    strengthUnit,
    route,
    foodInstruction,
    instructions,
    prescriber,
    pharmacyName,
    pharmacyPhone,
    status,
    startDate,
    endDate,
    isAsNeeded,
    photoPath,
    barcode,
    notes,
    isFavorite,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('generic_name')) {
      context.handle(
        _genericNameMeta,
        genericName.isAcceptableOrUnknown(
          data['generic_name']!,
          _genericNameMeta,
        ),
      );
    }
    if (data.containsKey('brand_name')) {
      context.handle(
        _brandNameMeta,
        brandName.isAcceptableOrUnknown(data['brand_name']!, _brandNameMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('form')) {
      context.handle(
        _formMeta,
        form.isAcceptableOrUnknown(data['form']!, _formMeta),
      );
    } else if (isInserting) {
      context.missing(_formMeta);
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    if (data.containsKey('strength_unit')) {
      context.handle(
        _strengthUnitMeta,
        strengthUnit.isAcceptableOrUnknown(
          data['strength_unit']!,
          _strengthUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_strengthUnitMeta);
    }
    if (data.containsKey('route')) {
      context.handle(
        _routeMeta,
        route.isAcceptableOrUnknown(data['route']!, _routeMeta),
      );
    } else if (isInserting) {
      context.missing(_routeMeta);
    }
    if (data.containsKey('food_instruction')) {
      context.handle(
        _foodInstructionMeta,
        foodInstruction.isAcceptableOrUnknown(
          data['food_instruction']!,
          _foodInstructionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foodInstructionMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('prescriber')) {
      context.handle(
        _prescriberMeta,
        prescriber.isAcceptableOrUnknown(data['prescriber']!, _prescriberMeta),
      );
    }
    if (data.containsKey('pharmacy_name')) {
      context.handle(
        _pharmacyNameMeta,
        pharmacyName.isAcceptableOrUnknown(
          data['pharmacy_name']!,
          _pharmacyNameMeta,
        ),
      );
    }
    if (data.containsKey('pharmacy_phone')) {
      context.handle(
        _pharmacyPhoneMeta,
        pharmacyPhone.isAcceptableOrUnknown(
          data['pharmacy_phone']!,
          _pharmacyPhoneMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('is_as_needed')) {
      context.handle(
        _isAsNeededMeta,
        isAsNeeded.isAcceptableOrUnknown(
          data['is_as_needed']!,
          _isAsNeededMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isAsNeededMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    } else if (isInserting) {
      context.missing(_isFavoriteMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      genericName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generic_name'],
      ),
      brandName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_name'],
      ),
      category:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}category'],
          )!,
      form:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}form'],
          )!,
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}strength'],
      ),
      strengthUnit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}strength_unit'],
          )!,
      route:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}route'],
          )!,
      foodInstruction:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}food_instruction'],
          )!,
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      ),
      prescriber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prescriber'],
      ),
      pharmacyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pharmacy_name'],
      ),
      pharmacyPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pharmacy_phone'],
      ),
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      isAsNeeded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_as_needed'],
          )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isFavorite:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_favorite'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class MedicationRow extends DataClass implements Insertable<MedicationRow> {
  final String id;
  final String name;
  final String? genericName;
  final String? brandName;
  final String category;
  final String form;
  final double? strength;
  final String strengthUnit;
  final String route;
  final String foodInstruction;
  final String? instructions;
  final String? prescriber;
  final String? pharmacyName;
  final String? pharmacyPhone;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isAsNeeded;
  final String? photoPath;
  final String? barcode;
  final String? notes;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MedicationRow({
    required this.id,
    required this.name,
    this.genericName,
    this.brandName,
    required this.category,
    required this.form,
    this.strength,
    required this.strengthUnit,
    required this.route,
    required this.foodInstruction,
    this.instructions,
    this.prescriber,
    this.pharmacyName,
    this.pharmacyPhone,
    required this.status,
    this.startDate,
    this.endDate,
    required this.isAsNeeded,
    this.photoPath,
    this.barcode,
    this.notes,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || genericName != null) {
      map['generic_name'] = Variable<String>(genericName);
    }
    if (!nullToAbsent || brandName != null) {
      map['brand_name'] = Variable<String>(brandName);
    }
    map['category'] = Variable<String>(category);
    map['form'] = Variable<String>(form);
    if (!nullToAbsent || strength != null) {
      map['strength'] = Variable<double>(strength);
    }
    map['strength_unit'] = Variable<String>(strengthUnit);
    map['route'] = Variable<String>(route);
    map['food_instruction'] = Variable<String>(foodInstruction);
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    if (!nullToAbsent || prescriber != null) {
      map['prescriber'] = Variable<String>(prescriber);
    }
    if (!nullToAbsent || pharmacyName != null) {
      map['pharmacy_name'] = Variable<String>(pharmacyName);
    }
    if (!nullToAbsent || pharmacyPhone != null) {
      map['pharmacy_phone'] = Variable<String>(pharmacyPhone);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['is_as_needed'] = Variable<bool>(isAsNeeded);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      name: Value(name),
      genericName:
          genericName == null && nullToAbsent
              ? const Value.absent()
              : Value(genericName),
      brandName:
          brandName == null && nullToAbsent
              ? const Value.absent()
              : Value(brandName),
      category: Value(category),
      form: Value(form),
      strength:
          strength == null && nullToAbsent
              ? const Value.absent()
              : Value(strength),
      strengthUnit: Value(strengthUnit),
      route: Value(route),
      foodInstruction: Value(foodInstruction),
      instructions:
          instructions == null && nullToAbsent
              ? const Value.absent()
              : Value(instructions),
      prescriber:
          prescriber == null && nullToAbsent
              ? const Value.absent()
              : Value(prescriber),
      pharmacyName:
          pharmacyName == null && nullToAbsent
              ? const Value.absent()
              : Value(pharmacyName),
      pharmacyPhone:
          pharmacyPhone == null && nullToAbsent
              ? const Value.absent()
              : Value(pharmacyPhone),
      status: Value(status),
      startDate:
          startDate == null && nullToAbsent
              ? const Value.absent()
              : Value(startDate),
      endDate:
          endDate == null && nullToAbsent
              ? const Value.absent()
              : Value(endDate),
      isAsNeeded: Value(isAsNeeded),
      photoPath:
          photoPath == null && nullToAbsent
              ? const Value.absent()
              : Value(photoPath),
      barcode:
          barcode == null && nullToAbsent
              ? const Value.absent()
              : Value(barcode),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      genericName: serializer.fromJson<String?>(json['genericName']),
      brandName: serializer.fromJson<String?>(json['brandName']),
      category: serializer.fromJson<String>(json['category']),
      form: serializer.fromJson<String>(json['form']),
      strength: serializer.fromJson<double?>(json['strength']),
      strengthUnit: serializer.fromJson<String>(json['strengthUnit']),
      route: serializer.fromJson<String>(json['route']),
      foodInstruction: serializer.fromJson<String>(json['foodInstruction']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      prescriber: serializer.fromJson<String?>(json['prescriber']),
      pharmacyName: serializer.fromJson<String?>(json['pharmacyName']),
      pharmacyPhone: serializer.fromJson<String?>(json['pharmacyPhone']),
      status: serializer.fromJson<String>(json['status']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      isAsNeeded: serializer.fromJson<bool>(json['isAsNeeded']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      notes: serializer.fromJson<String?>(json['notes']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'genericName': serializer.toJson<String?>(genericName),
      'brandName': serializer.toJson<String?>(brandName),
      'category': serializer.toJson<String>(category),
      'form': serializer.toJson<String>(form),
      'strength': serializer.toJson<double?>(strength),
      'strengthUnit': serializer.toJson<String>(strengthUnit),
      'route': serializer.toJson<String>(route),
      'foodInstruction': serializer.toJson<String>(foodInstruction),
      'instructions': serializer.toJson<String?>(instructions),
      'prescriber': serializer.toJson<String?>(prescriber),
      'pharmacyName': serializer.toJson<String?>(pharmacyName),
      'pharmacyPhone': serializer.toJson<String?>(pharmacyPhone),
      'status': serializer.toJson<String>(status),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'isAsNeeded': serializer.toJson<bool>(isAsNeeded),
      'photoPath': serializer.toJson<String?>(photoPath),
      'barcode': serializer.toJson<String?>(barcode),
      'notes': serializer.toJson<String?>(notes),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicationRow copyWith({
    String? id,
    String? name,
    Value<String?> genericName = const Value.absent(),
    Value<String?> brandName = const Value.absent(),
    String? category,
    String? form,
    Value<double?> strength = const Value.absent(),
    String? strengthUnit,
    String? route,
    String? foodInstruction,
    Value<String?> instructions = const Value.absent(),
    Value<String?> prescriber = const Value.absent(),
    Value<String?> pharmacyName = const Value.absent(),
    Value<String?> pharmacyPhone = const Value.absent(),
    String? status,
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> endDate = const Value.absent(),
    bool? isAsNeeded,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MedicationRow(
    id: id ?? this.id,
    name: name ?? this.name,
    genericName: genericName.present ? genericName.value : this.genericName,
    brandName: brandName.present ? brandName.value : this.brandName,
    category: category ?? this.category,
    form: form ?? this.form,
    strength: strength.present ? strength.value : this.strength,
    strengthUnit: strengthUnit ?? this.strengthUnit,
    route: route ?? this.route,
    foodInstruction: foodInstruction ?? this.foodInstruction,
    instructions: instructions.present ? instructions.value : this.instructions,
    prescriber: prescriber.present ? prescriber.value : this.prescriber,
    pharmacyName: pharmacyName.present ? pharmacyName.value : this.pharmacyName,
    pharmacyPhone:
        pharmacyPhone.present ? pharmacyPhone.value : this.pharmacyPhone,
    status: status ?? this.status,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    isAsNeeded: isAsNeeded ?? this.isAsNeeded,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    barcode: barcode.present ? barcode.value : this.barcode,
    notes: notes.present ? notes.value : this.notes,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MedicationRow copyWithCompanion(MedicationsCompanion data) {
    return MedicationRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      genericName:
          data.genericName.present ? data.genericName.value : this.genericName,
      brandName: data.brandName.present ? data.brandName.value : this.brandName,
      category: data.category.present ? data.category.value : this.category,
      form: data.form.present ? data.form.value : this.form,
      strength: data.strength.present ? data.strength.value : this.strength,
      strengthUnit:
          data.strengthUnit.present
              ? data.strengthUnit.value
              : this.strengthUnit,
      route: data.route.present ? data.route.value : this.route,
      foodInstruction:
          data.foodInstruction.present
              ? data.foodInstruction.value
              : this.foodInstruction,
      instructions:
          data.instructions.present
              ? data.instructions.value
              : this.instructions,
      prescriber:
          data.prescriber.present ? data.prescriber.value : this.prescriber,
      pharmacyName:
          data.pharmacyName.present
              ? data.pharmacyName.value
              : this.pharmacyName,
      pharmacyPhone:
          data.pharmacyPhone.present
              ? data.pharmacyPhone.value
              : this.pharmacyPhone,
      status: data.status.present ? data.status.value : this.status,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isAsNeeded:
          data.isAsNeeded.present ? data.isAsNeeded.value : this.isAsNeeded,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      notes: data.notes.present ? data.notes.value : this.notes,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('genericName: $genericName, ')
          ..write('brandName: $brandName, ')
          ..write('category: $category, ')
          ..write('form: $form, ')
          ..write('strength: $strength, ')
          ..write('strengthUnit: $strengthUnit, ')
          ..write('route: $route, ')
          ..write('foodInstruction: $foodInstruction, ')
          ..write('instructions: $instructions, ')
          ..write('prescriber: $prescriber, ')
          ..write('pharmacyName: $pharmacyName, ')
          ..write('pharmacyPhone: $pharmacyPhone, ')
          ..write('status: $status, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isAsNeeded: $isAsNeeded, ')
          ..write('photoPath: $photoPath, ')
          ..write('barcode: $barcode, ')
          ..write('notes: $notes, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    genericName,
    brandName,
    category,
    form,
    strength,
    strengthUnit,
    route,
    foodInstruction,
    instructions,
    prescriber,
    pharmacyName,
    pharmacyPhone,
    status,
    startDate,
    endDate,
    isAsNeeded,
    photoPath,
    barcode,
    notes,
    isFavorite,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.genericName == this.genericName &&
          other.brandName == this.brandName &&
          other.category == this.category &&
          other.form == this.form &&
          other.strength == this.strength &&
          other.strengthUnit == this.strengthUnit &&
          other.route == this.route &&
          other.foodInstruction == this.foodInstruction &&
          other.instructions == this.instructions &&
          other.prescriber == this.prescriber &&
          other.pharmacyName == this.pharmacyName &&
          other.pharmacyPhone == this.pharmacyPhone &&
          other.status == this.status &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isAsNeeded == this.isAsNeeded &&
          other.photoPath == this.photoPath &&
          other.barcode == this.barcode &&
          other.notes == this.notes &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicationsCompanion extends UpdateCompanion<MedicationRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> genericName;
  final Value<String?> brandName;
  final Value<String> category;
  final Value<String> form;
  final Value<double?> strength;
  final Value<String> strengthUnit;
  final Value<String> route;
  final Value<String> foodInstruction;
  final Value<String?> instructions;
  final Value<String?> prescriber;
  final Value<String?> pharmacyName;
  final Value<String?> pharmacyPhone;
  final Value<String> status;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> isAsNeeded;
  final Value<String?> photoPath;
  final Value<String?> barcode;
  final Value<String?> notes;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.genericName = const Value.absent(),
    this.brandName = const Value.absent(),
    this.category = const Value.absent(),
    this.form = const Value.absent(),
    this.strength = const Value.absent(),
    this.strengthUnit = const Value.absent(),
    this.route = const Value.absent(),
    this.foodInstruction = const Value.absent(),
    this.instructions = const Value.absent(),
    this.prescriber = const Value.absent(),
    this.pharmacyName = const Value.absent(),
    this.pharmacyPhone = const Value.absent(),
    this.status = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isAsNeeded = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.barcode = const Value.absent(),
    this.notes = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    required String name,
    this.genericName = const Value.absent(),
    this.brandName = const Value.absent(),
    required String category,
    required String form,
    this.strength = const Value.absent(),
    required String strengthUnit,
    required String route,
    required String foodInstruction,
    this.instructions = const Value.absent(),
    this.prescriber = const Value.absent(),
    this.pharmacyName = const Value.absent(),
    this.pharmacyPhone = const Value.absent(),
    required String status,
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    required bool isAsNeeded,
    this.photoPath = const Value.absent(),
    this.barcode = const Value.absent(),
    this.notes = const Value.absent(),
    required bool isFavorite,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       form = Value(form),
       strengthUnit = Value(strengthUnit),
       route = Value(route),
       foodInstruction = Value(foodInstruction),
       status = Value(status),
       isAsNeeded = Value(isAsNeeded),
       isFavorite = Value(isFavorite),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MedicationRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? genericName,
    Expression<String>? brandName,
    Expression<String>? category,
    Expression<String>? form,
    Expression<double>? strength,
    Expression<String>? strengthUnit,
    Expression<String>? route,
    Expression<String>? foodInstruction,
    Expression<String>? instructions,
    Expression<String>? prescriber,
    Expression<String>? pharmacyName,
    Expression<String>? pharmacyPhone,
    Expression<String>? status,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isAsNeeded,
    Expression<String>? photoPath,
    Expression<String>? barcode,
    Expression<String>? notes,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (genericName != null) 'generic_name': genericName,
      if (brandName != null) 'brand_name': brandName,
      if (category != null) 'category': category,
      if (form != null) 'form': form,
      if (strength != null) 'strength': strength,
      if (strengthUnit != null) 'strength_unit': strengthUnit,
      if (route != null) 'route': route,
      if (foodInstruction != null) 'food_instruction': foodInstruction,
      if (instructions != null) 'instructions': instructions,
      if (prescriber != null) 'prescriber': prescriber,
      if (pharmacyName != null) 'pharmacy_name': pharmacyName,
      if (pharmacyPhone != null) 'pharmacy_phone': pharmacyPhone,
      if (status != null) 'status': status,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isAsNeeded != null) 'is_as_needed': isAsNeeded,
      if (photoPath != null) 'photo_path': photoPath,
      if (barcode != null) 'barcode': barcode,
      if (notes != null) 'notes': notes,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? genericName,
    Value<String?>? brandName,
    Value<String>? category,
    Value<String>? form,
    Value<double?>? strength,
    Value<String>? strengthUnit,
    Value<String>? route,
    Value<String>? foodInstruction,
    Value<String?>? instructions,
    Value<String?>? prescriber,
    Value<String?>? pharmacyName,
    Value<String?>? pharmacyPhone,
    Value<String>? status,
    Value<DateTime?>? startDate,
    Value<DateTime?>? endDate,
    Value<bool>? isAsNeeded,
    Value<String?>? photoPath,
    Value<String?>? barcode,
    Value<String?>? notes,
    Value<bool>? isFavorite,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      brandName: brandName ?? this.brandName,
      category: category ?? this.category,
      form: form ?? this.form,
      strength: strength ?? this.strength,
      strengthUnit: strengthUnit ?? this.strengthUnit,
      route: route ?? this.route,
      foodInstruction: foodInstruction ?? this.foodInstruction,
      instructions: instructions ?? this.instructions,
      prescriber: prescriber ?? this.prescriber,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      pharmacyPhone: pharmacyPhone ?? this.pharmacyPhone,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isAsNeeded: isAsNeeded ?? this.isAsNeeded,
      photoPath: photoPath ?? this.photoPath,
      barcode: barcode ?? this.barcode,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (genericName.present) {
      map['generic_name'] = Variable<String>(genericName.value);
    }
    if (brandName.present) {
      map['brand_name'] = Variable<String>(brandName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (strength.present) {
      map['strength'] = Variable<double>(strength.value);
    }
    if (strengthUnit.present) {
      map['strength_unit'] = Variable<String>(strengthUnit.value);
    }
    if (route.present) {
      map['route'] = Variable<String>(route.value);
    }
    if (foodInstruction.present) {
      map['food_instruction'] = Variable<String>(foodInstruction.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (prescriber.present) {
      map['prescriber'] = Variable<String>(prescriber.value);
    }
    if (pharmacyName.present) {
      map['pharmacy_name'] = Variable<String>(pharmacyName.value);
    }
    if (pharmacyPhone.present) {
      map['pharmacy_phone'] = Variable<String>(pharmacyPhone.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isAsNeeded.present) {
      map['is_as_needed'] = Variable<bool>(isAsNeeded.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('genericName: $genericName, ')
          ..write('brandName: $brandName, ')
          ..write('category: $category, ')
          ..write('form: $form, ')
          ..write('strength: $strength, ')
          ..write('strengthUnit: $strengthUnit, ')
          ..write('route: $route, ')
          ..write('foodInstruction: $foodInstruction, ')
          ..write('instructions: $instructions, ')
          ..write('prescriber: $prescriber, ')
          ..write('pharmacyName: $pharmacyName, ')
          ..write('pharmacyPhone: $pharmacyPhone, ')
          ..write('status: $status, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isAsNeeded: $isAsNeeded, ')
          ..write('photoPath: $photoPath, ')
          ..write('barcode: $barcode, ')
          ..write('notes: $notes, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchedulePhasesTable extends SchedulePhases
    with TableInfo<$SchedulePhasesTable, SchedulePhaseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedulePhasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _phaseOrderMeta = const VerificationMeta(
    'phaseOrder',
  );
  @override
  late final GeneratedColumn<int> phaseOrder = GeneratedColumn<int>(
    'phase_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timesMinutesMeta = const VerificationMeta(
    'timesMinutes',
  );
  @override
  late final GeneratedColumn<String> timesMinutes = GeneratedColumn<String>(
    'times_minutes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<String> weekdays = GeneratedColumn<String>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalHoursMeta = const VerificationMeta(
    'intervalHours',
  );
  @override
  late final GeneratedColumn<int> intervalHours = GeneratedColumn<int>(
    'interval_hours',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyDaysMeta = const VerificationMeta(
    'monthlyDays',
  );
  @override
  late final GeneratedColumn<String> monthlyDays = GeneratedColumn<String>(
    'monthly_days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseQuantityMeta = const VerificationMeta(
    'doseQuantity',
  );
  @override
  late final GeneratedColumn<double> doseQuantity = GeneratedColumn<double>(
    'dose_quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodInstructionMeta = const VerificationMeta(
    'foodInstruction',
  );
  @override
  late final GeneratedColumn<String> foodInstruction = GeneratedColumn<String>(
    'food_instruction',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    phaseOrder,
    kind,
    startDate,
    endDate,
    timesMinutes,
    weekdays,
    intervalDays,
    intervalHours,
    monthlyDays,
    doseQuantity,
    unit,
    foodInstruction,
    instructions,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_phases';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchedulePhaseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('phase_order')) {
      context.handle(
        _phaseOrderMeta,
        phaseOrder.isAcceptableOrUnknown(data['phase_order']!, _phaseOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseOrderMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('times_minutes')) {
      context.handle(
        _timesMinutesMeta,
        timesMinutes.isAcceptableOrUnknown(
          data['times_minutes']!,
          _timesMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timesMinutesMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdaysMeta);
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intervalDaysMeta);
    }
    if (data.containsKey('interval_hours')) {
      context.handle(
        _intervalHoursMeta,
        intervalHours.isAcceptableOrUnknown(
          data['interval_hours']!,
          _intervalHoursMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intervalHoursMeta);
    }
    if (data.containsKey('monthly_days')) {
      context.handle(
        _monthlyDaysMeta,
        monthlyDays.isAcceptableOrUnknown(
          data['monthly_days']!,
          _monthlyDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyDaysMeta);
    }
    if (data.containsKey('dose_quantity')) {
      context.handle(
        _doseQuantityMeta,
        doseQuantity.isAcceptableOrUnknown(
          data['dose_quantity']!,
          _doseQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_doseQuantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('food_instruction')) {
      context.handle(
        _foodInstructionMeta,
        foodInstruction.isAcceptableOrUnknown(
          data['food_instruction']!,
          _foodInstructionMeta,
        ),
      );
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchedulePhaseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchedulePhaseRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      medicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}medication_id'],
          )!,
      phaseOrder:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}phase_order'],
          )!,
      kind:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}kind'],
          )!,
      startDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_date'],
          )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      timesMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}times_minutes'],
          )!,
      weekdays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}weekdays'],
          )!,
      intervalDays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}interval_days'],
          )!,
      intervalHours:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}interval_hours'],
          )!,
      monthlyDays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}monthly_days'],
          )!,
      doseQuantity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}dose_quantity'],
          )!,
      unit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit'],
          )!,
      foodInstruction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_instruction'],
      ),
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      ),
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
    );
  }

  @override
  $SchedulePhasesTable createAlias(String alias) {
    return $SchedulePhasesTable(attachedDatabase, alias);
  }
}

class SchedulePhaseRow extends DataClass
    implements Insertable<SchedulePhaseRow> {
  final String id;
  final String medicationId;
  final int phaseOrder;
  final String kind;
  final DateTime startDate;
  final DateTime? endDate;

  /// Minutes-from-midnight values, serialised as a comma separated list.
  final String timesMinutes;
  final String weekdays;
  final int intervalDays;
  final int intervalHours;
  final String monthlyDays;
  final double doseQuantity;
  final String unit;
  final String? foodInstruction;
  final String? instructions;
  final bool isActive;
  const SchedulePhaseRow({
    required this.id,
    required this.medicationId,
    required this.phaseOrder,
    required this.kind,
    required this.startDate,
    this.endDate,
    required this.timesMinutes,
    required this.weekdays,
    required this.intervalDays,
    required this.intervalHours,
    required this.monthlyDays,
    required this.doseQuantity,
    required this.unit,
    this.foodInstruction,
    this.instructions,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['phase_order'] = Variable<int>(phaseOrder);
    map['kind'] = Variable<String>(kind);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['times_minutes'] = Variable<String>(timesMinutes);
    map['weekdays'] = Variable<String>(weekdays);
    map['interval_days'] = Variable<int>(intervalDays);
    map['interval_hours'] = Variable<int>(intervalHours);
    map['monthly_days'] = Variable<String>(monthlyDays);
    map['dose_quantity'] = Variable<double>(doseQuantity);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || foodInstruction != null) {
      map['food_instruction'] = Variable<String>(foodInstruction);
    }
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SchedulePhasesCompanion toCompanion(bool nullToAbsent) {
    return SchedulePhasesCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      phaseOrder: Value(phaseOrder),
      kind: Value(kind),
      startDate: Value(startDate),
      endDate:
          endDate == null && nullToAbsent
              ? const Value.absent()
              : Value(endDate),
      timesMinutes: Value(timesMinutes),
      weekdays: Value(weekdays),
      intervalDays: Value(intervalDays),
      intervalHours: Value(intervalHours),
      monthlyDays: Value(monthlyDays),
      doseQuantity: Value(doseQuantity),
      unit: Value(unit),
      foodInstruction:
          foodInstruction == null && nullToAbsent
              ? const Value.absent()
              : Value(foodInstruction),
      instructions:
          instructions == null && nullToAbsent
              ? const Value.absent()
              : Value(instructions),
      isActive: Value(isActive),
    );
  }

  factory SchedulePhaseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchedulePhaseRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      phaseOrder: serializer.fromJson<int>(json['phaseOrder']),
      kind: serializer.fromJson<String>(json['kind']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      timesMinutes: serializer.fromJson<String>(json['timesMinutes']),
      weekdays: serializer.fromJson<String>(json['weekdays']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      intervalHours: serializer.fromJson<int>(json['intervalHours']),
      monthlyDays: serializer.fromJson<String>(json['monthlyDays']),
      doseQuantity: serializer.fromJson<double>(json['doseQuantity']),
      unit: serializer.fromJson<String>(json['unit']),
      foodInstruction: serializer.fromJson<String?>(json['foodInstruction']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'phaseOrder': serializer.toJson<int>(phaseOrder),
      'kind': serializer.toJson<String>(kind),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'timesMinutes': serializer.toJson<String>(timesMinutes),
      'weekdays': serializer.toJson<String>(weekdays),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'intervalHours': serializer.toJson<int>(intervalHours),
      'monthlyDays': serializer.toJson<String>(monthlyDays),
      'doseQuantity': serializer.toJson<double>(doseQuantity),
      'unit': serializer.toJson<String>(unit),
      'foodInstruction': serializer.toJson<String?>(foodInstruction),
      'instructions': serializer.toJson<String?>(instructions),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  SchedulePhaseRow copyWith({
    String? id,
    String? medicationId,
    int? phaseOrder,
    String? kind,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    String? timesMinutes,
    String? weekdays,
    int? intervalDays,
    int? intervalHours,
    String? monthlyDays,
    double? doseQuantity,
    String? unit,
    Value<String?> foodInstruction = const Value.absent(),
    Value<String?> instructions = const Value.absent(),
    bool? isActive,
  }) => SchedulePhaseRow(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    phaseOrder: phaseOrder ?? this.phaseOrder,
    kind: kind ?? this.kind,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    timesMinutes: timesMinutes ?? this.timesMinutes,
    weekdays: weekdays ?? this.weekdays,
    intervalDays: intervalDays ?? this.intervalDays,
    intervalHours: intervalHours ?? this.intervalHours,
    monthlyDays: monthlyDays ?? this.monthlyDays,
    doseQuantity: doseQuantity ?? this.doseQuantity,
    unit: unit ?? this.unit,
    foodInstruction:
        foodInstruction.present ? foodInstruction.value : this.foodInstruction,
    instructions: instructions.present ? instructions.value : this.instructions,
    isActive: isActive ?? this.isActive,
  );
  SchedulePhaseRow copyWithCompanion(SchedulePhasesCompanion data) {
    return SchedulePhaseRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      phaseOrder:
          data.phaseOrder.present ? data.phaseOrder.value : this.phaseOrder,
      kind: data.kind.present ? data.kind.value : this.kind,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      timesMinutes:
          data.timesMinutes.present
              ? data.timesMinutes.value
              : this.timesMinutes,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      intervalDays:
          data.intervalDays.present
              ? data.intervalDays.value
              : this.intervalDays,
      intervalHours:
          data.intervalHours.present
              ? data.intervalHours.value
              : this.intervalHours,
      monthlyDays:
          data.monthlyDays.present ? data.monthlyDays.value : this.monthlyDays,
      doseQuantity:
          data.doseQuantity.present
              ? data.doseQuantity.value
              : this.doseQuantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      foodInstruction:
          data.foodInstruction.present
              ? data.foodInstruction.value
              : this.foodInstruction,
      instructions:
          data.instructions.present
              ? data.instructions.value
              : this.instructions,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchedulePhaseRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('phaseOrder: $phaseOrder, ')
          ..write('kind: $kind, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('timesMinutes: $timesMinutes, ')
          ..write('weekdays: $weekdays, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('intervalHours: $intervalHours, ')
          ..write('monthlyDays: $monthlyDays, ')
          ..write('doseQuantity: $doseQuantity, ')
          ..write('unit: $unit, ')
          ..write('foodInstruction: $foodInstruction, ')
          ..write('instructions: $instructions, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    phaseOrder,
    kind,
    startDate,
    endDate,
    timesMinutes,
    weekdays,
    intervalDays,
    intervalHours,
    monthlyDays,
    doseQuantity,
    unit,
    foodInstruction,
    instructions,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchedulePhaseRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.phaseOrder == this.phaseOrder &&
          other.kind == this.kind &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.timesMinutes == this.timesMinutes &&
          other.weekdays == this.weekdays &&
          other.intervalDays == this.intervalDays &&
          other.intervalHours == this.intervalHours &&
          other.monthlyDays == this.monthlyDays &&
          other.doseQuantity == this.doseQuantity &&
          other.unit == this.unit &&
          other.foodInstruction == this.foodInstruction &&
          other.instructions == this.instructions &&
          other.isActive == this.isActive);
}

class SchedulePhasesCompanion extends UpdateCompanion<SchedulePhaseRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<int> phaseOrder;
  final Value<String> kind;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String> timesMinutes;
  final Value<String> weekdays;
  final Value<int> intervalDays;
  final Value<int> intervalHours;
  final Value<String> monthlyDays;
  final Value<double> doseQuantity;
  final Value<String> unit;
  final Value<String?> foodInstruction;
  final Value<String?> instructions;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SchedulePhasesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.phaseOrder = const Value.absent(),
    this.kind = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.timesMinutes = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.intervalHours = const Value.absent(),
    this.monthlyDays = const Value.absent(),
    this.doseQuantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.foodInstruction = const Value.absent(),
    this.instructions = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchedulePhasesCompanion.insert({
    required String id,
    required String medicationId,
    required int phaseOrder,
    required String kind,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    required String timesMinutes,
    required String weekdays,
    required int intervalDays,
    required int intervalHours,
    required String monthlyDays,
    required double doseQuantity,
    required String unit,
    this.foodInstruction = const Value.absent(),
    this.instructions = const Value.absent(),
    required bool isActive,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       phaseOrder = Value(phaseOrder),
       kind = Value(kind),
       startDate = Value(startDate),
       timesMinutes = Value(timesMinutes),
       weekdays = Value(weekdays),
       intervalDays = Value(intervalDays),
       intervalHours = Value(intervalHours),
       monthlyDays = Value(monthlyDays),
       doseQuantity = Value(doseQuantity),
       unit = Value(unit),
       isActive = Value(isActive);
  static Insertable<SchedulePhaseRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<int>? phaseOrder,
    Expression<String>? kind,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? timesMinutes,
    Expression<String>? weekdays,
    Expression<int>? intervalDays,
    Expression<int>? intervalHours,
    Expression<String>? monthlyDays,
    Expression<double>? doseQuantity,
    Expression<String>? unit,
    Expression<String>? foodInstruction,
    Expression<String>? instructions,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (phaseOrder != null) 'phase_order': phaseOrder,
      if (kind != null) 'kind': kind,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (timesMinutes != null) 'times_minutes': timesMinutes,
      if (weekdays != null) 'weekdays': weekdays,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (intervalHours != null) 'interval_hours': intervalHours,
      if (monthlyDays != null) 'monthly_days': monthlyDays,
      if (doseQuantity != null) 'dose_quantity': doseQuantity,
      if (unit != null) 'unit': unit,
      if (foodInstruction != null) 'food_instruction': foodInstruction,
      if (instructions != null) 'instructions': instructions,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchedulePhasesCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<int>? phaseOrder,
    Value<String>? kind,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<String>? timesMinutes,
    Value<String>? weekdays,
    Value<int>? intervalDays,
    Value<int>? intervalHours,
    Value<String>? monthlyDays,
    Value<double>? doseQuantity,
    Value<String>? unit,
    Value<String?>? foodInstruction,
    Value<String?>? instructions,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return SchedulePhasesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      phaseOrder: phaseOrder ?? this.phaseOrder,
      kind: kind ?? this.kind,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      timesMinutes: timesMinutes ?? this.timesMinutes,
      weekdays: weekdays ?? this.weekdays,
      intervalDays: intervalDays ?? this.intervalDays,
      intervalHours: intervalHours ?? this.intervalHours,
      monthlyDays: monthlyDays ?? this.monthlyDays,
      doseQuantity: doseQuantity ?? this.doseQuantity,
      unit: unit ?? this.unit,
      foodInstruction: foodInstruction ?? this.foodInstruction,
      instructions: instructions ?? this.instructions,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (phaseOrder.present) {
      map['phase_order'] = Variable<int>(phaseOrder.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (timesMinutes.present) {
      map['times_minutes'] = Variable<String>(timesMinutes.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(weekdays.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (intervalHours.present) {
      map['interval_hours'] = Variable<int>(intervalHours.value);
    }
    if (monthlyDays.present) {
      map['monthly_days'] = Variable<String>(monthlyDays.value);
    }
    if (doseQuantity.present) {
      map['dose_quantity'] = Variable<double>(doseQuantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (foodInstruction.present) {
      map['food_instruction'] = Variable<String>(foodInstruction.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulePhasesCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('phaseOrder: $phaseOrder, ')
          ..write('kind: $kind, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('timesMinutes: $timesMinutes, ')
          ..write('weekdays: $weekdays, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('intervalHours: $intervalHours, ')
          ..write('monthlyDays: $monthlyDays, ')
          ..write('doseQuantity: $doseQuantity, ')
          ..write('unit: $unit, ')
          ..write('foodInstruction: $foodInstruction, ')
          ..write('instructions: $instructions, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduledDosesTable extends ScheduledDoses
    with TableInfo<$ScheduledDosesTable, ScheduledDoseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledDosesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _phaseIdMeta = const VerificationMeta(
    'phaseId',
  );
  @override
  late final GeneratedColumn<String> phaseId = GeneratedColumn<String>(
    'phase_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<DateTime> localDate = GeneratedColumn<DateTime>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledMinutesMeta = const VerificationMeta(
    'scheduledMinutes',
  );
  @override
  late final GeneratedColumn<int> scheduledMinutes = GeneratedColumn<int>(
    'scheduled_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseQuantityMeta = const VerificationMeta(
    'doseQuantity',
  );
  @override
  late final GeneratedColumn<double> doseQuantity = GeneratedColumn<double>(
    'dose_quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    phaseId,
    scheduledAt,
    localDate,
    scheduledMinutes,
    doseQuantity,
    unit,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_doses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduledDoseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('phase_id')) {
      context.handle(
        _phaseIdMeta,
        phaseId.isAcceptableOrUnknown(data['phase_id']!, _phaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('scheduled_minutes')) {
      context.handle(
        _scheduledMinutesMeta,
        scheduledMinutes.isAcceptableOrUnknown(
          data['scheduled_minutes']!,
          _scheduledMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledMinutesMeta);
    }
    if (data.containsKey('dose_quantity')) {
      context.handle(
        _doseQuantityMeta,
        doseQuantity.isAcceptableOrUnknown(
          data['dose_quantity']!,
          _doseQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_doseQuantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {medicationId, scheduledAt},
  ];
  @override
  ScheduledDoseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledDoseRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      medicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}medication_id'],
          )!,
      phaseId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}phase_id'],
          )!,
      scheduledAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}scheduled_at'],
          )!,
      localDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}local_date'],
          )!,
      scheduledMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}scheduled_minutes'],
          )!,
      doseQuantity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}dose_quantity'],
          )!,
      unit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $ScheduledDosesTable createAlias(String alias) {
    return $ScheduledDosesTable(attachedDatabase, alias);
  }
}

class ScheduledDoseRow extends DataClass
    implements Insertable<ScheduledDoseRow> {
  final String id;
  final String medicationId;
  final String phaseId;
  final DateTime scheduledAt;
  final DateTime localDate;
  final int scheduledMinutes;
  final double doseQuantity;
  final String unit;
  final String status;
  final DateTime createdAt;
  const ScheduledDoseRow({
    required this.id,
    required this.medicationId,
    required this.phaseId,
    required this.scheduledAt,
    required this.localDate,
    required this.scheduledMinutes,
    required this.doseQuantity,
    required this.unit,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['phase_id'] = Variable<String>(phaseId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['local_date'] = Variable<DateTime>(localDate);
    map['scheduled_minutes'] = Variable<int>(scheduledMinutes);
    map['dose_quantity'] = Variable<double>(doseQuantity);
    map['unit'] = Variable<String>(unit);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScheduledDosesCompanion toCompanion(bool nullToAbsent) {
    return ScheduledDosesCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      phaseId: Value(phaseId),
      scheduledAt: Value(scheduledAt),
      localDate: Value(localDate),
      scheduledMinutes: Value(scheduledMinutes),
      doseQuantity: Value(doseQuantity),
      unit: Value(unit),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory ScheduledDoseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledDoseRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      phaseId: serializer.fromJson<String>(json['phaseId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      localDate: serializer.fromJson<DateTime>(json['localDate']),
      scheduledMinutes: serializer.fromJson<int>(json['scheduledMinutes']),
      doseQuantity: serializer.fromJson<double>(json['doseQuantity']),
      unit: serializer.fromJson<String>(json['unit']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'phaseId': serializer.toJson<String>(phaseId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'localDate': serializer.toJson<DateTime>(localDate),
      'scheduledMinutes': serializer.toJson<int>(scheduledMinutes),
      'doseQuantity': serializer.toJson<double>(doseQuantity),
      'unit': serializer.toJson<String>(unit),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScheduledDoseRow copyWith({
    String? id,
    String? medicationId,
    String? phaseId,
    DateTime? scheduledAt,
    DateTime? localDate,
    int? scheduledMinutes,
    double? doseQuantity,
    String? unit,
    String? status,
    DateTime? createdAt,
  }) => ScheduledDoseRow(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    phaseId: phaseId ?? this.phaseId,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    localDate: localDate ?? this.localDate,
    scheduledMinutes: scheduledMinutes ?? this.scheduledMinutes,
    doseQuantity: doseQuantity ?? this.doseQuantity,
    unit: unit ?? this.unit,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  ScheduledDoseRow copyWithCompanion(ScheduledDosesCompanion data) {
    return ScheduledDoseRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      phaseId: data.phaseId.present ? data.phaseId.value : this.phaseId,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      scheduledMinutes:
          data.scheduledMinutes.present
              ? data.scheduledMinutes.value
              : this.scheduledMinutes,
      doseQuantity:
          data.doseQuantity.present
              ? data.doseQuantity.value
              : this.doseQuantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledDoseRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('phaseId: $phaseId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('localDate: $localDate, ')
          ..write('scheduledMinutes: $scheduledMinutes, ')
          ..write('doseQuantity: $doseQuantity, ')
          ..write('unit: $unit, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    phaseId,
    scheduledAt,
    localDate,
    scheduledMinutes,
    doseQuantity,
    unit,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledDoseRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.phaseId == this.phaseId &&
          other.scheduledAt == this.scheduledAt &&
          other.localDate == this.localDate &&
          other.scheduledMinutes == this.scheduledMinutes &&
          other.doseQuantity == this.doseQuantity &&
          other.unit == this.unit &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ScheduledDosesCompanion extends UpdateCompanion<ScheduledDoseRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> phaseId;
  final Value<DateTime> scheduledAt;
  final Value<DateTime> localDate;
  final Value<int> scheduledMinutes;
  final Value<double> doseQuantity;
  final Value<String> unit;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ScheduledDosesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.phaseId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.localDate = const Value.absent(),
    this.scheduledMinutes = const Value.absent(),
    this.doseQuantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduledDosesCompanion.insert({
    required String id,
    required String medicationId,
    required String phaseId,
    required DateTime scheduledAt,
    required DateTime localDate,
    required int scheduledMinutes,
    required double doseQuantity,
    required String unit,
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       phaseId = Value(phaseId),
       scheduledAt = Value(scheduledAt),
       localDate = Value(localDate),
       scheduledMinutes = Value(scheduledMinutes),
       doseQuantity = Value(doseQuantity),
       unit = Value(unit),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<ScheduledDoseRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? phaseId,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? localDate,
    Expression<int>? scheduledMinutes,
    Expression<double>? doseQuantity,
    Expression<String>? unit,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (phaseId != null) 'phase_id': phaseId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (localDate != null) 'local_date': localDate,
      if (scheduledMinutes != null) 'scheduled_minutes': scheduledMinutes,
      if (doseQuantity != null) 'dose_quantity': doseQuantity,
      if (unit != null) 'unit': unit,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduledDosesCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<String>? phaseId,
    Value<DateTime>? scheduledAt,
    Value<DateTime>? localDate,
    Value<int>? scheduledMinutes,
    Value<double>? doseQuantity,
    Value<String>? unit,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ScheduledDosesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      phaseId: phaseId ?? this.phaseId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      localDate: localDate ?? this.localDate,
      scheduledMinutes: scheduledMinutes ?? this.scheduledMinutes,
      doseQuantity: doseQuantity ?? this.doseQuantity,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (phaseId.present) {
      map['phase_id'] = Variable<String>(phaseId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<DateTime>(localDate.value);
    }
    if (scheduledMinutes.present) {
      map['scheduled_minutes'] = Variable<int>(scheduledMinutes.value);
    }
    if (doseQuantity.present) {
      map['dose_quantity'] = Variable<double>(doseQuantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledDosesCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('phaseId: $phaseId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('localDate: $localDate, ')
          ..write('scheduledMinutes: $scheduledMinutes, ')
          ..write('doseQuantity: $doseQuantity, ')
          ..write('unit: $unit, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoseLogsTable extends DoseLogs
    with TableInfo<$DoseLogsTable, DoseLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _scheduledDoseIdMeta = const VerificationMeta(
    'scheduledDoseId',
  );
  @override
  late final GeneratedColumn<String> scheduledDoseId = GeneratedColumn<String>(
    'scheduled_dose_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actedAtMeta = const VerificationMeta(
    'actedAt',
  );
  @override
  late final GeneratedColumn<DateTime> actedAt = GeneratedColumn<DateTime>(
    'acted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountTakenMeta = const VerificationMeta(
    'amountTaken',
  );
  @override
  late final GeneratedColumn<double> amountTaken = GeneratedColumn<double>(
    'amount_taken',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inventoryTransactionIdMeta =
      const VerificationMeta('inventoryTransactionId');
  @override
  late final GeneratedColumn<String> inventoryTransactionId =
      GeneratedColumn<String>(
        'inventory_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _supersedesLogIdMeta = const VerificationMeta(
    'supersedesLogId',
  );
  @override
  late final GeneratedColumn<String> supersedesLogId = GeneratedColumn<String>(
    'supersedes_log_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    scheduledDoseId,
    status,
    scheduledAt,
    actedAt,
    amountTaken,
    unit,
    note,
    inventoryTransactionId,
    supersedesLogId,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoseLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('scheduled_dose_id')) {
      context.handle(
        _scheduledDoseIdMeta,
        scheduledDoseId.isAcceptableOrUnknown(
          data['scheduled_dose_id']!,
          _scheduledDoseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDoseIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('acted_at')) {
      context.handle(
        _actedAtMeta,
        actedAt.isAcceptableOrUnknown(data['acted_at']!, _actedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_actedAtMeta);
    }
    if (data.containsKey('amount_taken')) {
      context.handle(
        _amountTakenMeta,
        amountTaken.isAcceptableOrUnknown(
          data['amount_taken']!,
          _amountTakenMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('inventory_transaction_id')) {
      context.handle(
        _inventoryTransactionIdMeta,
        inventoryTransactionId.isAcceptableOrUnknown(
          data['inventory_transaction_id']!,
          _inventoryTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('supersedes_log_id')) {
      context.handle(
        _supersedesLogIdMeta,
        supersedesLogId.isAcceptableOrUnknown(
          data['supersedes_log_id']!,
          _supersedesLogIdMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoseLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseLogRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      medicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}medication_id'],
          )!,
      scheduledDoseId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}scheduled_dose_id'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      scheduledAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}scheduled_at'],
          )!,
      actedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}acted_at'],
          )!,
      amountTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_taken'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      inventoryTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inventory_transaction_id'],
      ),
      supersedesLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supersedes_log_id'],
      ),
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $DoseLogsTable createAlias(String alias) {
    return $DoseLogsTable(attachedDatabase, alias);
  }
}

class DoseLogRow extends DataClass implements Insertable<DoseLogRow> {
  final String id;
  final String medicationId;
  final String scheduledDoseId;
  final String status;
  final DateTime scheduledAt;
  final DateTime actedAt;
  final double? amountTaken;
  final String? unit;
  final String? note;
  final String? inventoryTransactionId;
  final String? supersedesLogId;

  /// Only one log per scheduled dose is "active"; corrections deactivate the
  /// previous row instead of deleting it.
  final bool isActive;
  final DateTime createdAt;
  const DoseLogRow({
    required this.id,
    required this.medicationId,
    required this.scheduledDoseId,
    required this.status,
    required this.scheduledAt,
    required this.actedAt,
    this.amountTaken,
    this.unit,
    this.note,
    this.inventoryTransactionId,
    this.supersedesLogId,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['scheduled_dose_id'] = Variable<String>(scheduledDoseId);
    map['status'] = Variable<String>(status);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['acted_at'] = Variable<DateTime>(actedAt);
    if (!nullToAbsent || amountTaken != null) {
      map['amount_taken'] = Variable<double>(amountTaken);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || inventoryTransactionId != null) {
      map['inventory_transaction_id'] = Variable<String>(
        inventoryTransactionId,
      );
    }
    if (!nullToAbsent || supersedesLogId != null) {
      map['supersedes_log_id'] = Variable<String>(supersedesLogId);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DoseLogsCompanion toCompanion(bool nullToAbsent) {
    return DoseLogsCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      scheduledDoseId: Value(scheduledDoseId),
      status: Value(status),
      scheduledAt: Value(scheduledAt),
      actedAt: Value(actedAt),
      amountTaken:
          amountTaken == null && nullToAbsent
              ? const Value.absent()
              : Value(amountTaken),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      inventoryTransactionId:
          inventoryTransactionId == null && nullToAbsent
              ? const Value.absent()
              : Value(inventoryTransactionId),
      supersedesLogId:
          supersedesLogId == null && nullToAbsent
              ? const Value.absent()
              : Value(supersedesLogId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory DoseLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseLogRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      scheduledDoseId: serializer.fromJson<String>(json['scheduledDoseId']),
      status: serializer.fromJson<String>(json['status']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      actedAt: serializer.fromJson<DateTime>(json['actedAt']),
      amountTaken: serializer.fromJson<double?>(json['amountTaken']),
      unit: serializer.fromJson<String?>(json['unit']),
      note: serializer.fromJson<String?>(json['note']),
      inventoryTransactionId: serializer.fromJson<String?>(
        json['inventoryTransactionId'],
      ),
      supersedesLogId: serializer.fromJson<String?>(json['supersedesLogId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'scheduledDoseId': serializer.toJson<String>(scheduledDoseId),
      'status': serializer.toJson<String>(status),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'actedAt': serializer.toJson<DateTime>(actedAt),
      'amountTaken': serializer.toJson<double?>(amountTaken),
      'unit': serializer.toJson<String?>(unit),
      'note': serializer.toJson<String?>(note),
      'inventoryTransactionId': serializer.toJson<String?>(
        inventoryTransactionId,
      ),
      'supersedesLogId': serializer.toJson<String?>(supersedesLogId),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DoseLogRow copyWith({
    String? id,
    String? medicationId,
    String? scheduledDoseId,
    String? status,
    DateTime? scheduledAt,
    DateTime? actedAt,
    Value<double?> amountTaken = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> inventoryTransactionId = const Value.absent(),
    Value<String?> supersedesLogId = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
  }) => DoseLogRow(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    scheduledDoseId: scheduledDoseId ?? this.scheduledDoseId,
    status: status ?? this.status,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    actedAt: actedAt ?? this.actedAt,
    amountTaken: amountTaken.present ? amountTaken.value : this.amountTaken,
    unit: unit.present ? unit.value : this.unit,
    note: note.present ? note.value : this.note,
    inventoryTransactionId:
        inventoryTransactionId.present
            ? inventoryTransactionId.value
            : this.inventoryTransactionId,
    supersedesLogId:
        supersedesLogId.present ? supersedesLogId.value : this.supersedesLogId,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  DoseLogRow copyWithCompanion(DoseLogsCompanion data) {
    return DoseLogRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      scheduledDoseId:
          data.scheduledDoseId.present
              ? data.scheduledDoseId.value
              : this.scheduledDoseId,
      status: data.status.present ? data.status.value : this.status,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      actedAt: data.actedAt.present ? data.actedAt.value : this.actedAt,
      amountTaken:
          data.amountTaken.present ? data.amountTaken.value : this.amountTaken,
      unit: data.unit.present ? data.unit.value : this.unit,
      note: data.note.present ? data.note.value : this.note,
      inventoryTransactionId:
          data.inventoryTransactionId.present
              ? data.inventoryTransactionId.value
              : this.inventoryTransactionId,
      supersedesLogId:
          data.supersedesLogId.present
              ? data.supersedesLogId.value
              : this.supersedesLogId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseLogRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledDoseId: $scheduledDoseId, ')
          ..write('status: $status, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('actedAt: $actedAt, ')
          ..write('amountTaken: $amountTaken, ')
          ..write('unit: $unit, ')
          ..write('note: $note, ')
          ..write('inventoryTransactionId: $inventoryTransactionId, ')
          ..write('supersedesLogId: $supersedesLogId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    scheduledDoseId,
    status,
    scheduledAt,
    actedAt,
    amountTaken,
    unit,
    note,
    inventoryTransactionId,
    supersedesLogId,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseLogRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.scheduledDoseId == this.scheduledDoseId &&
          other.status == this.status &&
          other.scheduledAt == this.scheduledAt &&
          other.actedAt == this.actedAt &&
          other.amountTaken == this.amountTaken &&
          other.unit == this.unit &&
          other.note == this.note &&
          other.inventoryTransactionId == this.inventoryTransactionId &&
          other.supersedesLogId == this.supersedesLogId &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class DoseLogsCompanion extends UpdateCompanion<DoseLogRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> scheduledDoseId;
  final Value<String> status;
  final Value<DateTime> scheduledAt;
  final Value<DateTime> actedAt;
  final Value<double?> amountTaken;
  final Value<String?> unit;
  final Value<String?> note;
  final Value<String?> inventoryTransactionId;
  final Value<String?> supersedesLogId;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DoseLogsCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduledDoseId = const Value.absent(),
    this.status = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.actedAt = const Value.absent(),
    this.amountTaken = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
    this.inventoryTransactionId = const Value.absent(),
    this.supersedesLogId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoseLogsCompanion.insert({
    required String id,
    required String medicationId,
    required String scheduledDoseId,
    required String status,
    required DateTime scheduledAt,
    required DateTime actedAt,
    this.amountTaken = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
    this.inventoryTransactionId = const Value.absent(),
    this.supersedesLogId = const Value.absent(),
    required bool isActive,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       scheduledDoseId = Value(scheduledDoseId),
       status = Value(status),
       scheduledAt = Value(scheduledAt),
       actedAt = Value(actedAt),
       isActive = Value(isActive),
       createdAt = Value(createdAt);
  static Insertable<DoseLogRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? scheduledDoseId,
    Expression<String>? status,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? actedAt,
    Expression<double>? amountTaken,
    Expression<String>? unit,
    Expression<String>? note,
    Expression<String>? inventoryTransactionId,
    Expression<String>? supersedesLogId,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduledDoseId != null) 'scheduled_dose_id': scheduledDoseId,
      if (status != null) 'status': status,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (actedAt != null) 'acted_at': actedAt,
      if (amountTaken != null) 'amount_taken': amountTaken,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (inventoryTransactionId != null)
        'inventory_transaction_id': inventoryTransactionId,
      if (supersedesLogId != null) 'supersedes_log_id': supersedesLogId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoseLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<String>? scheduledDoseId,
    Value<String>? status,
    Value<DateTime>? scheduledAt,
    Value<DateTime>? actedAt,
    Value<double?>? amountTaken,
    Value<String?>? unit,
    Value<String?>? note,
    Value<String?>? inventoryTransactionId,
    Value<String?>? supersedesLogId,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DoseLogsCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduledDoseId: scheduledDoseId ?? this.scheduledDoseId,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      actedAt: actedAt ?? this.actedAt,
      amountTaken: amountTaken ?? this.amountTaken,
      unit: unit ?? this.unit,
      note: note ?? this.note,
      inventoryTransactionId:
          inventoryTransactionId ?? this.inventoryTransactionId,
      supersedesLogId: supersedesLogId ?? this.supersedesLogId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (scheduledDoseId.present) {
      map['scheduled_dose_id'] = Variable<String>(scheduledDoseId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (actedAt.present) {
      map['acted_at'] = Variable<DateTime>(actedAt.value);
    }
    if (amountTaken.present) {
      map['amount_taken'] = Variable<double>(amountTaken.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (inventoryTransactionId.present) {
      map['inventory_transaction_id'] = Variable<String>(
        inventoryTransactionId.value,
      );
    }
    if (supersedesLogId.present) {
      map['supersedes_log_id'] = Variable<String>(supersedesLogId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoseLogsCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledDoseId: $scheduledDoseId, ')
          ..write('status: $status, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('actedAt: $actedAt, ')
          ..write('amountTaken: $amountTaken, ')
          ..write('unit: $unit, ')
          ..write('note: $note, ')
          ..write('inventoryTransactionId: $inventoryTransactionId, ')
          ..write('supersedesLogId: $supersedesLogId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoriesTable extends Inventories
    with TableInfo<$InventoriesTable, InventoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _quantityOnHandMeta = const VerificationMeta(
    'quantityOnHand',
  );
  @override
  late final GeneratedColumn<double> quantityOnHand = GeneratedColumn<double>(
    'quantity_on_hand',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refillThresholdMeta = const VerificationMeta(
    'refillThreshold',
  );
  @override
  late final GeneratedColumn<double> refillThreshold = GeneratedColumn<double>(
    'refill_threshold',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialQuantityMeta = const VerificationMeta(
    'initialQuantity',
  );
  @override
  late final GeneratedColumn<double> initialQuantity = GeneratedColumn<double>(
    'initial_quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastRefillAtMeta = const VerificationMeta(
    'lastRefillAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastRefillAt = GeneratedColumn<DateTime>(
    'last_refill_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    quantityOnHand,
    unit,
    refillThreshold,
    initialQuantity,
    lastRefillAt,
    expiryDate,
    notes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventories';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('quantity_on_hand')) {
      context.handle(
        _quantityOnHandMeta,
        quantityOnHand.isAcceptableOrUnknown(
          data['quantity_on_hand']!,
          _quantityOnHandMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityOnHandMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('refill_threshold')) {
      context.handle(
        _refillThresholdMeta,
        refillThreshold.isAcceptableOrUnknown(
          data['refill_threshold']!,
          _refillThresholdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_refillThresholdMeta);
    }
    if (data.containsKey('initial_quantity')) {
      context.handle(
        _initialQuantityMeta,
        initialQuantity.isAcceptableOrUnknown(
          data['initial_quantity']!,
          _initialQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialQuantityMeta);
    }
    if (data.containsKey('last_refill_at')) {
      context.handle(
        _lastRefillAtMeta,
        lastRefillAt.isAcceptableOrUnknown(
          data['last_refill_at']!,
          _lastRefillAtMeta,
        ),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      medicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}medication_id'],
          )!,
      quantityOnHand:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}quantity_on_hand'],
          )!,
      unit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit'],
          )!,
      refillThreshold:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}refill_threshold'],
          )!,
      initialQuantity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}initial_quantity'],
          )!,
      lastRefillAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_refill_at'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $InventoriesTable createAlias(String alias) {
    return $InventoriesTable(attachedDatabase, alias);
  }
}

class InventoryRow extends DataClass implements Insertable<InventoryRow> {
  final String id;
  final String medicationId;
  final double quantityOnHand;
  final String unit;
  final double refillThreshold;
  final double initialQuantity;
  final DateTime? lastRefillAt;
  final DateTime? expiryDate;
  final String? notes;
  final DateTime updatedAt;
  const InventoryRow({
    required this.id,
    required this.medicationId,
    required this.quantityOnHand,
    required this.unit,
    required this.refillThreshold,
    required this.initialQuantity,
    this.lastRefillAt,
    this.expiryDate,
    this.notes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['quantity_on_hand'] = Variable<double>(quantityOnHand);
    map['unit'] = Variable<String>(unit);
    map['refill_threshold'] = Variable<double>(refillThreshold);
    map['initial_quantity'] = Variable<double>(initialQuantity);
    if (!nullToAbsent || lastRefillAt != null) {
      map['last_refill_at'] = Variable<DateTime>(lastRefillAt);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InventoriesCompanion toCompanion(bool nullToAbsent) {
    return InventoriesCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      quantityOnHand: Value(quantityOnHand),
      unit: Value(unit),
      refillThreshold: Value(refillThreshold),
      initialQuantity: Value(initialQuantity),
      lastRefillAt:
          lastRefillAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lastRefillAt),
      expiryDate:
          expiryDate == null && nullToAbsent
              ? const Value.absent()
              : Value(expiryDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      updatedAt: Value(updatedAt),
    );
  }

  factory InventoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      quantityOnHand: serializer.fromJson<double>(json['quantityOnHand']),
      unit: serializer.fromJson<String>(json['unit']),
      refillThreshold: serializer.fromJson<double>(json['refillThreshold']),
      initialQuantity: serializer.fromJson<double>(json['initialQuantity']),
      lastRefillAt: serializer.fromJson<DateTime?>(json['lastRefillAt']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'quantityOnHand': serializer.toJson<double>(quantityOnHand),
      'unit': serializer.toJson<String>(unit),
      'refillThreshold': serializer.toJson<double>(refillThreshold),
      'initialQuantity': serializer.toJson<double>(initialQuantity),
      'lastRefillAt': serializer.toJson<DateTime?>(lastRefillAt),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InventoryRow copyWith({
    String? id,
    String? medicationId,
    double? quantityOnHand,
    String? unit,
    double? refillThreshold,
    double? initialQuantity,
    Value<DateTime?> lastRefillAt = const Value.absent(),
    Value<DateTime?> expiryDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
  }) => InventoryRow(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    quantityOnHand: quantityOnHand ?? this.quantityOnHand,
    unit: unit ?? this.unit,
    refillThreshold: refillThreshold ?? this.refillThreshold,
    initialQuantity: initialQuantity ?? this.initialQuantity,
    lastRefillAt: lastRefillAt.present ? lastRefillAt.value : this.lastRefillAt,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InventoryRow copyWithCompanion(InventoriesCompanion data) {
    return InventoryRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      quantityOnHand:
          data.quantityOnHand.present
              ? data.quantityOnHand.value
              : this.quantityOnHand,
      unit: data.unit.present ? data.unit.value : this.unit,
      refillThreshold:
          data.refillThreshold.present
              ? data.refillThreshold.value
              : this.refillThreshold,
      initialQuantity:
          data.initialQuantity.present
              ? data.initialQuantity.value
              : this.initialQuantity,
      lastRefillAt:
          data.lastRefillAt.present
              ? data.lastRefillAt.value
              : this.lastRefillAt,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('quantityOnHand: $quantityOnHand, ')
          ..write('unit: $unit, ')
          ..write('refillThreshold: $refillThreshold, ')
          ..write('initialQuantity: $initialQuantity, ')
          ..write('lastRefillAt: $lastRefillAt, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    quantityOnHand,
    unit,
    refillThreshold,
    initialQuantity,
    lastRefillAt,
    expiryDate,
    notes,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.quantityOnHand == this.quantityOnHand &&
          other.unit == this.unit &&
          other.refillThreshold == this.refillThreshold &&
          other.initialQuantity == this.initialQuantity &&
          other.lastRefillAt == this.lastRefillAt &&
          other.expiryDate == this.expiryDate &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt);
}

class InventoriesCompanion extends UpdateCompanion<InventoryRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<double> quantityOnHand;
  final Value<String> unit;
  final Value<double> refillThreshold;
  final Value<double> initialQuantity;
  final Value<DateTime?> lastRefillAt;
  final Value<DateTime?> expiryDate;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const InventoriesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.quantityOnHand = const Value.absent(),
    this.unit = const Value.absent(),
    this.refillThreshold = const Value.absent(),
    this.initialQuantity = const Value.absent(),
    this.lastRefillAt = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoriesCompanion.insert({
    required String id,
    required String medicationId,
    required double quantityOnHand,
    required String unit,
    required double refillThreshold,
    required double initialQuantity,
    this.lastRefillAt = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       quantityOnHand = Value(quantityOnHand),
       unit = Value(unit),
       refillThreshold = Value(refillThreshold),
       initialQuantity = Value(initialQuantity),
       updatedAt = Value(updatedAt);
  static Insertable<InventoryRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<double>? quantityOnHand,
    Expression<String>? unit,
    Expression<double>? refillThreshold,
    Expression<double>? initialQuantity,
    Expression<DateTime>? lastRefillAt,
    Expression<DateTime>? expiryDate,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (quantityOnHand != null) 'quantity_on_hand': quantityOnHand,
      if (unit != null) 'unit': unit,
      if (refillThreshold != null) 'refill_threshold': refillThreshold,
      if (initialQuantity != null) 'initial_quantity': initialQuantity,
      if (lastRefillAt != null) 'last_refill_at': lastRefillAt,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<double>? quantityOnHand,
    Value<String>? unit,
    Value<double>? refillThreshold,
    Value<double>? initialQuantity,
    Value<DateTime?>? lastRefillAt,
    Value<DateTime?>? expiryDate,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return InventoriesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      quantityOnHand: quantityOnHand ?? this.quantityOnHand,
      unit: unit ?? this.unit,
      refillThreshold: refillThreshold ?? this.refillThreshold,
      initialQuantity: initialQuantity ?? this.initialQuantity,
      lastRefillAt: lastRefillAt ?? this.lastRefillAt,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (quantityOnHand.present) {
      map['quantity_on_hand'] = Variable<double>(quantityOnHand.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (refillThreshold.present) {
      map['refill_threshold'] = Variable<double>(refillThreshold.value);
    }
    if (initialQuantity.present) {
      map['initial_quantity'] = Variable<double>(initialQuantity.value);
    }
    if (lastRefillAt.present) {
      map['last_refill_at'] = Variable<DateTime>(lastRefillAt.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoriesCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('quantityOnHand: $quantityOnHand, ')
          ..write('unit: $unit, ')
          ..write('refillThreshold: $refillThreshold, ')
          ..write('initialQuantity: $initialQuantity, ')
          ..write('lastRefillAt: $lastRefillAt, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryTransactionsTable extends InventoryTransactions
    with TableInfo<$InventoryTransactionsTable, InventoryTransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityDeltaMeta = const VerificationMeta(
    'quantityDelta',
  );
  @override
  late final GeneratedColumn<double> quantityDelta = GeneratedColumn<double>(
    'quantity_delta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityAfterMeta = const VerificationMeta(
    'quantityAfter',
  );
  @override
  late final GeneratedColumn<double> quantityAfter = GeneratedColumn<double>(
    'quantity_after',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseLogIdMeta = const VerificationMeta(
    'doseLogId',
  );
  @override
  late final GeneratedColumn<String> doseLogId = GeneratedColumn<String>(
    'dose_log_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    type,
    quantityDelta,
    quantityAfter,
    unit,
    createdAt,
    doseLogId,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryTransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('quantity_delta')) {
      context.handle(
        _quantityDeltaMeta,
        quantityDelta.isAcceptableOrUnknown(
          data['quantity_delta']!,
          _quantityDeltaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityDeltaMeta);
    }
    if (data.containsKey('quantity_after')) {
      context.handle(
        _quantityAfterMeta,
        quantityAfter.isAcceptableOrUnknown(
          data['quantity_after']!,
          _quantityAfterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityAfterMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('dose_log_id')) {
      context.handle(
        _doseLogIdMeta,
        doseLogId.isAcceptableOrUnknown(data['dose_log_id']!, _doseLogIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {doseLogId},
  ];
  @override
  InventoryTransactionRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryTransactionRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      medicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}medication_id'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      quantityDelta:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}quantity_delta'],
          )!,
      quantityAfter:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}quantity_after'],
          )!,
      unit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      doseLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose_log_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $InventoryTransactionsTable createAlias(String alias) {
    return $InventoryTransactionsTable(attachedDatabase, alias);
  }
}

class InventoryTransactionRow extends DataClass
    implements Insertable<InventoryTransactionRow> {
  final String id;
  final String medicationId;
  final String type;
  final double quantityDelta;
  final double quantityAfter;
  final String unit;
  final DateTime createdAt;

  /// Links the movement to the dose that caused it. The unique constraint is
  /// the hard guarantee that a retried dose action can never deduct twice.
  final String? doseLogId;
  final String? note;
  const InventoryTransactionRow({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['type'] = Variable<String>(type);
    map['quantity_delta'] = Variable<double>(quantityDelta);
    map['quantity_after'] = Variable<double>(quantityAfter);
    map['unit'] = Variable<String>(unit);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || doseLogId != null) {
      map['dose_log_id'] = Variable<String>(doseLogId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  InventoryTransactionsCompanion toCompanion(bool nullToAbsent) {
    return InventoryTransactionsCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      type: Value(type),
      quantityDelta: Value(quantityDelta),
      quantityAfter: Value(quantityAfter),
      unit: Value(unit),
      createdAt: Value(createdAt),
      doseLogId:
          doseLogId == null && nullToAbsent
              ? const Value.absent()
              : Value(doseLogId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory InventoryTransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryTransactionRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      type: serializer.fromJson<String>(json['type']),
      quantityDelta: serializer.fromJson<double>(json['quantityDelta']),
      quantityAfter: serializer.fromJson<double>(json['quantityAfter']),
      unit: serializer.fromJson<String>(json['unit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      doseLogId: serializer.fromJson<String?>(json['doseLogId']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'type': serializer.toJson<String>(type),
      'quantityDelta': serializer.toJson<double>(quantityDelta),
      'quantityAfter': serializer.toJson<double>(quantityAfter),
      'unit': serializer.toJson<String>(unit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'doseLogId': serializer.toJson<String?>(doseLogId),
      'note': serializer.toJson<String?>(note),
    };
  }

  InventoryTransactionRow copyWith({
    String? id,
    String? medicationId,
    String? type,
    double? quantityDelta,
    double? quantityAfter,
    String? unit,
    DateTime? createdAt,
    Value<String?> doseLogId = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => InventoryTransactionRow(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    type: type ?? this.type,
    quantityDelta: quantityDelta ?? this.quantityDelta,
    quantityAfter: quantityAfter ?? this.quantityAfter,
    unit: unit ?? this.unit,
    createdAt: createdAt ?? this.createdAt,
    doseLogId: doseLogId.present ? doseLogId.value : this.doseLogId,
    note: note.present ? note.value : this.note,
  );
  InventoryTransactionRow copyWithCompanion(
    InventoryTransactionsCompanion data,
  ) {
    return InventoryTransactionRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      type: data.type.present ? data.type.value : this.type,
      quantityDelta:
          data.quantityDelta.present
              ? data.quantityDelta.value
              : this.quantityDelta,
      quantityAfter:
          data.quantityAfter.present
              ? data.quantityAfter.value
              : this.quantityAfter,
      unit: data.unit.present ? data.unit.value : this.unit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      doseLogId: data.doseLogId.present ? data.doseLogId.value : this.doseLogId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryTransactionRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('type: $type, ')
          ..write('quantityDelta: $quantityDelta, ')
          ..write('quantityAfter: $quantityAfter, ')
          ..write('unit: $unit, ')
          ..write('createdAt: $createdAt, ')
          ..write('doseLogId: $doseLogId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    type,
    quantityDelta,
    quantityAfter,
    unit,
    createdAt,
    doseLogId,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryTransactionRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.type == this.type &&
          other.quantityDelta == this.quantityDelta &&
          other.quantityAfter == this.quantityAfter &&
          other.unit == this.unit &&
          other.createdAt == this.createdAt &&
          other.doseLogId == this.doseLogId &&
          other.note == this.note);
}

class InventoryTransactionsCompanion
    extends UpdateCompanion<InventoryTransactionRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> type;
  final Value<double> quantityDelta;
  final Value<double> quantityAfter;
  final Value<String> unit;
  final Value<DateTime> createdAt;
  final Value<String?> doseLogId;
  final Value<String?> note;
  final Value<int> rowid;
  const InventoryTransactionsCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.type = const Value.absent(),
    this.quantityDelta = const Value.absent(),
    this.quantityAfter = const Value.absent(),
    this.unit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.doseLogId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryTransactionsCompanion.insert({
    required String id,
    required String medicationId,
    required String type,
    required double quantityDelta,
    required double quantityAfter,
    required String unit,
    required DateTime createdAt,
    this.doseLogId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       type = Value(type),
       quantityDelta = Value(quantityDelta),
       quantityAfter = Value(quantityAfter),
       unit = Value(unit),
       createdAt = Value(createdAt);
  static Insertable<InventoryTransactionRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? type,
    Expression<double>? quantityDelta,
    Expression<double>? quantityAfter,
    Expression<String>? unit,
    Expression<DateTime>? createdAt,
    Expression<String>? doseLogId,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (type != null) 'type': type,
      if (quantityDelta != null) 'quantity_delta': quantityDelta,
      if (quantityAfter != null) 'quantity_after': quantityAfter,
      if (unit != null) 'unit': unit,
      if (createdAt != null) 'created_at': createdAt,
      if (doseLogId != null) 'dose_log_id': doseLogId,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<String>? type,
    Value<double>? quantityDelta,
    Value<double>? quantityAfter,
    Value<String>? unit,
    Value<DateTime>? createdAt,
    Value<String?>? doseLogId,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return InventoryTransactionsCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      type: type ?? this.type,
      quantityDelta: quantityDelta ?? this.quantityDelta,
      quantityAfter: quantityAfter ?? this.quantityAfter,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      doseLogId: doseLogId ?? this.doseLogId,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (quantityDelta.present) {
      map['quantity_delta'] = Variable<double>(quantityDelta.value);
    }
    if (quantityAfter.present) {
      map['quantity_after'] = Variable<double>(quantityAfter.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (doseLogId.present) {
      map['dose_log_id'] = Variable<String>(doseLogId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('type: $type, ')
          ..write('quantityDelta: $quantityDelta, ')
          ..write('quantityAfter: $quantityAfter, ')
          ..write('unit: $unit, ')
          ..write('createdAt: $createdAt, ')
          ..write('doseLogId: $doseLogId, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationPreferencesTable extends NotificationPreferences
    with TableInfo<$NotificationPreferencesTable, NotificationPreferenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _remindersEnabledMeta = const VerificationMeta(
    'remindersEnabled',
  );
  @override
  late final GeneratedColumn<bool> remindersEnabled = GeneratedColumn<bool>(
    'reminders_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminders_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _preReminderMinutesMeta =
      const VerificationMeta('preReminderMinutes');
  @override
  late final GeneratedColumn<int> preReminderMinutes = GeneratedColumn<int>(
    'pre_reminder_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _missedFollowUpEnabledMeta =
      const VerificationMeta('missedFollowUpEnabled');
  @override
  late final GeneratedColumn<bool> missedFollowUpEnabled =
      GeneratedColumn<bool>(
        'missed_follow_up_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("missed_follow_up_enabled" IN (0, 1))',
        ),
      );
  static const VerificationMeta _missedFollowUpMinutesMeta =
      const VerificationMeta('missedFollowUpMinutes');
  @override
  late final GeneratedColumn<int> missedFollowUpMinutes = GeneratedColumn<int>(
    'missed_follow_up_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soundEnabledMeta = const VerificationMeta(
    'soundEnabled',
  );
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
    'sound_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _vibrationEnabledMeta = const VerificationMeta(
    'vibrationEnabled',
  );
  @override
  late final GeneratedColumn<bool> vibrationEnabled = GeneratedColumn<bool>(
    'vibration_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vibration_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _privacyMeta = const VerificationMeta(
    'privacy',
  );
  @override
  late final GeneratedColumn<String> privacy = GeneratedColumn<String>(
    'privacy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lowStockAlertEnabledMeta =
      const VerificationMeta('lowStockAlertEnabled');
  @override
  late final GeneratedColumn<bool> lowStockAlertEnabled = GeneratedColumn<bool>(
    'low_stock_alert_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("low_stock_alert_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _runOutAlertEnabledMeta =
      const VerificationMeta('runOutAlertEnabled');
  @override
  late final GeneratedColumn<bool> runOutAlertEnabled = GeneratedColumn<bool>(
    'run_out_alert_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("run_out_alert_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _refillAlertEnabledMeta =
      const VerificationMeta('refillAlertEnabled');
  @override
  late final GeneratedColumn<bool> refillAlertEnabled = GeneratedColumn<bool>(
    'refill_alert_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("refill_alert_enabled" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    remindersEnabled,
    preReminderMinutes,
    missedFollowUpEnabled,
    missedFollowUpMinutes,
    soundEnabled,
    vibrationEnabled,
    privacy,
    lowStockAlertEnabled,
    runOutAlertEnabled,
    refillAlertEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationPreferenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    }
    if (data.containsKey('reminders_enabled')) {
      context.handle(
        _remindersEnabledMeta,
        remindersEnabled.isAcceptableOrUnknown(
          data['reminders_enabled']!,
          _remindersEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remindersEnabledMeta);
    }
    if (data.containsKey('pre_reminder_minutes')) {
      context.handle(
        _preReminderMinutesMeta,
        preReminderMinutes.isAcceptableOrUnknown(
          data['pre_reminder_minutes']!,
          _preReminderMinutesMeta,
        ),
      );
    }
    if (data.containsKey('missed_follow_up_enabled')) {
      context.handle(
        _missedFollowUpEnabledMeta,
        missedFollowUpEnabled.isAcceptableOrUnknown(
          data['missed_follow_up_enabled']!,
          _missedFollowUpEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_missedFollowUpEnabledMeta);
    }
    if (data.containsKey('missed_follow_up_minutes')) {
      context.handle(
        _missedFollowUpMinutesMeta,
        missedFollowUpMinutes.isAcceptableOrUnknown(
          data['missed_follow_up_minutes']!,
          _missedFollowUpMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_missedFollowUpMinutesMeta);
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
        _soundEnabledMeta,
        soundEnabled.isAcceptableOrUnknown(
          data['sound_enabled']!,
          _soundEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_soundEnabledMeta);
    }
    if (data.containsKey('vibration_enabled')) {
      context.handle(
        _vibrationEnabledMeta,
        vibrationEnabled.isAcceptableOrUnknown(
          data['vibration_enabled']!,
          _vibrationEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vibrationEnabledMeta);
    }
    if (data.containsKey('privacy')) {
      context.handle(
        _privacyMeta,
        privacy.isAcceptableOrUnknown(data['privacy']!, _privacyMeta),
      );
    } else if (isInserting) {
      context.missing(_privacyMeta);
    }
    if (data.containsKey('low_stock_alert_enabled')) {
      context.handle(
        _lowStockAlertEnabledMeta,
        lowStockAlertEnabled.isAcceptableOrUnknown(
          data['low_stock_alert_enabled']!,
          _lowStockAlertEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lowStockAlertEnabledMeta);
    }
    if (data.containsKey('run_out_alert_enabled')) {
      context.handle(
        _runOutAlertEnabledMeta,
        runOutAlertEnabled.isAcceptableOrUnknown(
          data['run_out_alert_enabled']!,
          _runOutAlertEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_runOutAlertEnabledMeta);
    }
    if (data.containsKey('refill_alert_enabled')) {
      context.handle(
        _refillAlertEnabledMeta,
        refillAlertEnabled.isAcceptableOrUnknown(
          data['refill_alert_enabled']!,
          _refillAlertEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_refillAlertEnabledMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationPreferenceRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationPreferenceRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_id'],
      ),
      remindersEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}reminders_enabled'],
          )!,
      preReminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pre_reminder_minutes'],
      ),
      missedFollowUpEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}missed_follow_up_enabled'],
          )!,
      missedFollowUpMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}missed_follow_up_minutes'],
          )!,
      soundEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}sound_enabled'],
          )!,
      vibrationEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}vibration_enabled'],
          )!,
      privacy:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}privacy'],
          )!,
      lowStockAlertEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}low_stock_alert_enabled'],
          )!,
      runOutAlertEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}run_out_alert_enabled'],
          )!,
      refillAlertEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}refill_alert_enabled'],
          )!,
    );
  }

  @override
  $NotificationPreferencesTable createAlias(String alias) {
    return $NotificationPreferencesTable(attachedDatabase, alias);
  }
}

class NotificationPreferenceRow extends DataClass
    implements Insertable<NotificationPreferenceRow> {
  final String id;
  final String? medicationId;
  final bool remindersEnabled;
  final int? preReminderMinutes;
  final bool missedFollowUpEnabled;
  final int missedFollowUpMinutes;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String privacy;
  final bool lowStockAlertEnabled;
  final bool runOutAlertEnabled;
  final bool refillAlertEnabled;
  const NotificationPreferenceRow({
    required this.id,
    this.medicationId,
    required this.remindersEnabled,
    this.preReminderMinutes,
    required this.missedFollowUpEnabled,
    required this.missedFollowUpMinutes,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.privacy,
    required this.lowStockAlertEnabled,
    required this.runOutAlertEnabled,
    required this.refillAlertEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || medicationId != null) {
      map['medication_id'] = Variable<String>(medicationId);
    }
    map['reminders_enabled'] = Variable<bool>(remindersEnabled);
    if (!nullToAbsent || preReminderMinutes != null) {
      map['pre_reminder_minutes'] = Variable<int>(preReminderMinutes);
    }
    map['missed_follow_up_enabled'] = Variable<bool>(missedFollowUpEnabled);
    map['missed_follow_up_minutes'] = Variable<int>(missedFollowUpMinutes);
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['vibration_enabled'] = Variable<bool>(vibrationEnabled);
    map['privacy'] = Variable<String>(privacy);
    map['low_stock_alert_enabled'] = Variable<bool>(lowStockAlertEnabled);
    map['run_out_alert_enabled'] = Variable<bool>(runOutAlertEnabled);
    map['refill_alert_enabled'] = Variable<bool>(refillAlertEnabled);
    return map;
  }

  NotificationPreferencesCompanion toCompanion(bool nullToAbsent) {
    return NotificationPreferencesCompanion(
      id: Value(id),
      medicationId:
          medicationId == null && nullToAbsent
              ? const Value.absent()
              : Value(medicationId),
      remindersEnabled: Value(remindersEnabled),
      preReminderMinutes:
          preReminderMinutes == null && nullToAbsent
              ? const Value.absent()
              : Value(preReminderMinutes),
      missedFollowUpEnabled: Value(missedFollowUpEnabled),
      missedFollowUpMinutes: Value(missedFollowUpMinutes),
      soundEnabled: Value(soundEnabled),
      vibrationEnabled: Value(vibrationEnabled),
      privacy: Value(privacy),
      lowStockAlertEnabled: Value(lowStockAlertEnabled),
      runOutAlertEnabled: Value(runOutAlertEnabled),
      refillAlertEnabled: Value(refillAlertEnabled),
    );
  }

  factory NotificationPreferenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationPreferenceRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String?>(json['medicationId']),
      remindersEnabled: serializer.fromJson<bool>(json['remindersEnabled']),
      preReminderMinutes: serializer.fromJson<int?>(json['preReminderMinutes']),
      missedFollowUpEnabled: serializer.fromJson<bool>(
        json['missedFollowUpEnabled'],
      ),
      missedFollowUpMinutes: serializer.fromJson<int>(
        json['missedFollowUpMinutes'],
      ),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      vibrationEnabled: serializer.fromJson<bool>(json['vibrationEnabled']),
      privacy: serializer.fromJson<String>(json['privacy']),
      lowStockAlertEnabled: serializer.fromJson<bool>(
        json['lowStockAlertEnabled'],
      ),
      runOutAlertEnabled: serializer.fromJson<bool>(json['runOutAlertEnabled']),
      refillAlertEnabled: serializer.fromJson<bool>(json['refillAlertEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String?>(medicationId),
      'remindersEnabled': serializer.toJson<bool>(remindersEnabled),
      'preReminderMinutes': serializer.toJson<int?>(preReminderMinutes),
      'missedFollowUpEnabled': serializer.toJson<bool>(missedFollowUpEnabled),
      'missedFollowUpMinutes': serializer.toJson<int>(missedFollowUpMinutes),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'vibrationEnabled': serializer.toJson<bool>(vibrationEnabled),
      'privacy': serializer.toJson<String>(privacy),
      'lowStockAlertEnabled': serializer.toJson<bool>(lowStockAlertEnabled),
      'runOutAlertEnabled': serializer.toJson<bool>(runOutAlertEnabled),
      'refillAlertEnabled': serializer.toJson<bool>(refillAlertEnabled),
    };
  }

  NotificationPreferenceRow copyWith({
    String? id,
    Value<String?> medicationId = const Value.absent(),
    bool? remindersEnabled,
    Value<int?> preReminderMinutes = const Value.absent(),
    bool? missedFollowUpEnabled,
    int? missedFollowUpMinutes,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? privacy,
    bool? lowStockAlertEnabled,
    bool? runOutAlertEnabled,
    bool? refillAlertEnabled,
  }) => NotificationPreferenceRow(
    id: id ?? this.id,
    medicationId: medicationId.present ? medicationId.value : this.medicationId,
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    preReminderMinutes:
        preReminderMinutes.present
            ? preReminderMinutes.value
            : this.preReminderMinutes,
    missedFollowUpEnabled: missedFollowUpEnabled ?? this.missedFollowUpEnabled,
    missedFollowUpMinutes: missedFollowUpMinutes ?? this.missedFollowUpMinutes,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    privacy: privacy ?? this.privacy,
    lowStockAlertEnabled: lowStockAlertEnabled ?? this.lowStockAlertEnabled,
    runOutAlertEnabled: runOutAlertEnabled ?? this.runOutAlertEnabled,
    refillAlertEnabled: refillAlertEnabled ?? this.refillAlertEnabled,
  );
  NotificationPreferenceRow copyWithCompanion(
    NotificationPreferencesCompanion data,
  ) {
    return NotificationPreferenceRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      remindersEnabled:
          data.remindersEnabled.present
              ? data.remindersEnabled.value
              : this.remindersEnabled,
      preReminderMinutes:
          data.preReminderMinutes.present
              ? data.preReminderMinutes.value
              : this.preReminderMinutes,
      missedFollowUpEnabled:
          data.missedFollowUpEnabled.present
              ? data.missedFollowUpEnabled.value
              : this.missedFollowUpEnabled,
      missedFollowUpMinutes:
          data.missedFollowUpMinutes.present
              ? data.missedFollowUpMinutes.value
              : this.missedFollowUpMinutes,
      soundEnabled:
          data.soundEnabled.present
              ? data.soundEnabled.value
              : this.soundEnabled,
      vibrationEnabled:
          data.vibrationEnabled.present
              ? data.vibrationEnabled.value
              : this.vibrationEnabled,
      privacy: data.privacy.present ? data.privacy.value : this.privacy,
      lowStockAlertEnabled:
          data.lowStockAlertEnabled.present
              ? data.lowStockAlertEnabled.value
              : this.lowStockAlertEnabled,
      runOutAlertEnabled:
          data.runOutAlertEnabled.present
              ? data.runOutAlertEnabled.value
              : this.runOutAlertEnabled,
      refillAlertEnabled:
          data.refillAlertEnabled.present
              ? data.refillAlertEnabled.value
              : this.refillAlertEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationPreferenceRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('preReminderMinutes: $preReminderMinutes, ')
          ..write('missedFollowUpEnabled: $missedFollowUpEnabled, ')
          ..write('missedFollowUpMinutes: $missedFollowUpMinutes, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('privacy: $privacy, ')
          ..write('lowStockAlertEnabled: $lowStockAlertEnabled, ')
          ..write('runOutAlertEnabled: $runOutAlertEnabled, ')
          ..write('refillAlertEnabled: $refillAlertEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    remindersEnabled,
    preReminderMinutes,
    missedFollowUpEnabled,
    missedFollowUpMinutes,
    soundEnabled,
    vibrationEnabled,
    privacy,
    lowStockAlertEnabled,
    runOutAlertEnabled,
    refillAlertEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationPreferenceRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.remindersEnabled == this.remindersEnabled &&
          other.preReminderMinutes == this.preReminderMinutes &&
          other.missedFollowUpEnabled == this.missedFollowUpEnabled &&
          other.missedFollowUpMinutes == this.missedFollowUpMinutes &&
          other.soundEnabled == this.soundEnabled &&
          other.vibrationEnabled == this.vibrationEnabled &&
          other.privacy == this.privacy &&
          other.lowStockAlertEnabled == this.lowStockAlertEnabled &&
          other.runOutAlertEnabled == this.runOutAlertEnabled &&
          other.refillAlertEnabled == this.refillAlertEnabled);
}

class NotificationPreferencesCompanion
    extends UpdateCompanion<NotificationPreferenceRow> {
  final Value<String> id;
  final Value<String?> medicationId;
  final Value<bool> remindersEnabled;
  final Value<int?> preReminderMinutes;
  final Value<bool> missedFollowUpEnabled;
  final Value<int> missedFollowUpMinutes;
  final Value<bool> soundEnabled;
  final Value<bool> vibrationEnabled;
  final Value<String> privacy;
  final Value<bool> lowStockAlertEnabled;
  final Value<bool> runOutAlertEnabled;
  final Value<bool> refillAlertEnabled;
  final Value<int> rowid;
  const NotificationPreferencesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.preReminderMinutes = const Value.absent(),
    this.missedFollowUpEnabled = const Value.absent(),
    this.missedFollowUpMinutes = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.vibrationEnabled = const Value.absent(),
    this.privacy = const Value.absent(),
    this.lowStockAlertEnabled = const Value.absent(),
    this.runOutAlertEnabled = const Value.absent(),
    this.refillAlertEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationPreferencesCompanion.insert({
    required String id,
    this.medicationId = const Value.absent(),
    required bool remindersEnabled,
    this.preReminderMinutes = const Value.absent(),
    required bool missedFollowUpEnabled,
    required int missedFollowUpMinutes,
    required bool soundEnabled,
    required bool vibrationEnabled,
    required String privacy,
    required bool lowStockAlertEnabled,
    required bool runOutAlertEnabled,
    required bool refillAlertEnabled,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       remindersEnabled = Value(remindersEnabled),
       missedFollowUpEnabled = Value(missedFollowUpEnabled),
       missedFollowUpMinutes = Value(missedFollowUpMinutes),
       soundEnabled = Value(soundEnabled),
       vibrationEnabled = Value(vibrationEnabled),
       privacy = Value(privacy),
       lowStockAlertEnabled = Value(lowStockAlertEnabled),
       runOutAlertEnabled = Value(runOutAlertEnabled),
       refillAlertEnabled = Value(refillAlertEnabled);
  static Insertable<NotificationPreferenceRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<bool>? remindersEnabled,
    Expression<int>? preReminderMinutes,
    Expression<bool>? missedFollowUpEnabled,
    Expression<int>? missedFollowUpMinutes,
    Expression<bool>? soundEnabled,
    Expression<bool>? vibrationEnabled,
    Expression<String>? privacy,
    Expression<bool>? lowStockAlertEnabled,
    Expression<bool>? runOutAlertEnabled,
    Expression<bool>? refillAlertEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (remindersEnabled != null) 'reminders_enabled': remindersEnabled,
      if (preReminderMinutes != null)
        'pre_reminder_minutes': preReminderMinutes,
      if (missedFollowUpEnabled != null)
        'missed_follow_up_enabled': missedFollowUpEnabled,
      if (missedFollowUpMinutes != null)
        'missed_follow_up_minutes': missedFollowUpMinutes,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (vibrationEnabled != null) 'vibration_enabled': vibrationEnabled,
      if (privacy != null) 'privacy': privacy,
      if (lowStockAlertEnabled != null)
        'low_stock_alert_enabled': lowStockAlertEnabled,
      if (runOutAlertEnabled != null)
        'run_out_alert_enabled': runOutAlertEnabled,
      if (refillAlertEnabled != null)
        'refill_alert_enabled': refillAlertEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationPreferencesCompanion copyWith({
    Value<String>? id,
    Value<String?>? medicationId,
    Value<bool>? remindersEnabled,
    Value<int?>? preReminderMinutes,
    Value<bool>? missedFollowUpEnabled,
    Value<int>? missedFollowUpMinutes,
    Value<bool>? soundEnabled,
    Value<bool>? vibrationEnabled,
    Value<String>? privacy,
    Value<bool>? lowStockAlertEnabled,
    Value<bool>? runOutAlertEnabled,
    Value<bool>? refillAlertEnabled,
    Value<int>? rowid,
  }) {
    return NotificationPreferencesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      preReminderMinutes: preReminderMinutes ?? this.preReminderMinutes,
      missedFollowUpEnabled:
          missedFollowUpEnabled ?? this.missedFollowUpEnabled,
      missedFollowUpMinutes:
          missedFollowUpMinutes ?? this.missedFollowUpMinutes,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      privacy: privacy ?? this.privacy,
      lowStockAlertEnabled: lowStockAlertEnabled ?? this.lowStockAlertEnabled,
      runOutAlertEnabled: runOutAlertEnabled ?? this.runOutAlertEnabled,
      refillAlertEnabled: refillAlertEnabled ?? this.refillAlertEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (remindersEnabled.present) {
      map['reminders_enabled'] = Variable<bool>(remindersEnabled.value);
    }
    if (preReminderMinutes.present) {
      map['pre_reminder_minutes'] = Variable<int>(preReminderMinutes.value);
    }
    if (missedFollowUpEnabled.present) {
      map['missed_follow_up_enabled'] = Variable<bool>(
        missedFollowUpEnabled.value,
      );
    }
    if (missedFollowUpMinutes.present) {
      map['missed_follow_up_minutes'] = Variable<int>(
        missedFollowUpMinutes.value,
      );
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (vibrationEnabled.present) {
      map['vibration_enabled'] = Variable<bool>(vibrationEnabled.value);
    }
    if (privacy.present) {
      map['privacy'] = Variable<String>(privacy.value);
    }
    if (lowStockAlertEnabled.present) {
      map['low_stock_alert_enabled'] = Variable<bool>(
        lowStockAlertEnabled.value,
      );
    }
    if (runOutAlertEnabled.present) {
      map['run_out_alert_enabled'] = Variable<bool>(runOutAlertEnabled.value);
    }
    if (refillAlertEnabled.present) {
      map['refill_alert_enabled'] = Variable<bool>(refillAlertEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('preReminderMinutes: $preReminderMinutes, ')
          ..write('missedFollowUpEnabled: $missedFollowUpEnabled, ')
          ..write('missedFollowUpMinutes: $missedFollowUpMinutes, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('privacy: $privacy, ')
          ..write('lowStockAlertEnabled: $lowStockAlertEnabled, ')
          ..write('runOutAlertEnabled: $runOutAlertEnabled, ')
          ..write('refillAlertEnabled: $refillAlertEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RefillRemindersTable extends RefillReminders
    with TableInfo<$RefillRemindersTable, RefillReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RefillRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _thresholdMeta = const VerificationMeta(
    'threshold',
  );
  @override
  late final GeneratedColumn<double> threshold = GeneratedColumn<double>(
    'threshold',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _lastNotifiedAtMeta = const VerificationMeta(
    'lastNotifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastNotifiedAt =
      GeneratedColumn<DateTime>(
        'last_notified_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _leadDaysMeta = const VerificationMeta(
    'leadDays',
  );
  @override
  late final GeneratedColumn<int> leadDays = GeneratedColumn<int>(
    'lead_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    threshold,
    enabled,
    lastNotifiedAt,
    leadDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'refill_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<RefillReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('threshold')) {
      context.handle(
        _thresholdMeta,
        threshold.isAcceptableOrUnknown(data['threshold']!, _thresholdMeta),
      );
    } else if (isInserting) {
      context.missing(_thresholdMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('last_notified_at')) {
      context.handle(
        _lastNotifiedAtMeta,
        lastNotifiedAt.isAcceptableOrUnknown(
          data['last_notified_at']!,
          _lastNotifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('lead_days')) {
      context.handle(
        _leadDaysMeta,
        leadDays.isAcceptableOrUnknown(data['lead_days']!, _leadDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_leadDaysMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RefillReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RefillReminderRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      medicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}medication_id'],
          )!,
      threshold:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}threshold'],
          )!,
      enabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}enabled'],
          )!,
      lastNotifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_notified_at'],
      ),
      leadDays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}lead_days'],
          )!,
    );
  }

  @override
  $RefillRemindersTable createAlias(String alias) {
    return $RefillRemindersTable(attachedDatabase, alias);
  }
}

class RefillReminderRow extends DataClass
    implements Insertable<RefillReminderRow> {
  final String id;
  final String medicationId;
  final double threshold;
  final bool enabled;
  final DateTime? lastNotifiedAt;
  final int leadDays;
  const RefillReminderRow({
    required this.id,
    required this.medicationId,
    required this.threshold,
    required this.enabled,
    this.lastNotifiedAt,
    required this.leadDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['threshold'] = Variable<double>(threshold);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || lastNotifiedAt != null) {
      map['last_notified_at'] = Variable<DateTime>(lastNotifiedAt);
    }
    map['lead_days'] = Variable<int>(leadDays);
    return map;
  }

  RefillRemindersCompanion toCompanion(bool nullToAbsent) {
    return RefillRemindersCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      threshold: Value(threshold),
      enabled: Value(enabled),
      lastNotifiedAt:
          lastNotifiedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lastNotifiedAt),
      leadDays: Value(leadDays),
    );
  }

  factory RefillReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RefillReminderRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      threshold: serializer.fromJson<double>(json['threshold']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      lastNotifiedAt: serializer.fromJson<DateTime?>(json['lastNotifiedAt']),
      leadDays: serializer.fromJson<int>(json['leadDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'threshold': serializer.toJson<double>(threshold),
      'enabled': serializer.toJson<bool>(enabled),
      'lastNotifiedAt': serializer.toJson<DateTime?>(lastNotifiedAt),
      'leadDays': serializer.toJson<int>(leadDays),
    };
  }

  RefillReminderRow copyWith({
    String? id,
    String? medicationId,
    double? threshold,
    bool? enabled,
    Value<DateTime?> lastNotifiedAt = const Value.absent(),
    int? leadDays,
  }) => RefillReminderRow(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    threshold: threshold ?? this.threshold,
    enabled: enabled ?? this.enabled,
    lastNotifiedAt:
        lastNotifiedAt.present ? lastNotifiedAt.value : this.lastNotifiedAt,
    leadDays: leadDays ?? this.leadDays,
  );
  RefillReminderRow copyWithCompanion(RefillRemindersCompanion data) {
    return RefillReminderRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      threshold: data.threshold.present ? data.threshold.value : this.threshold,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      lastNotifiedAt:
          data.lastNotifiedAt.present
              ? data.lastNotifiedAt.value
              : this.lastNotifiedAt,
      leadDays: data.leadDays.present ? data.leadDays.value : this.leadDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RefillReminderRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('threshold: $threshold, ')
          ..write('enabled: $enabled, ')
          ..write('lastNotifiedAt: $lastNotifiedAt, ')
          ..write('leadDays: $leadDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    threshold,
    enabled,
    lastNotifiedAt,
    leadDays,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RefillReminderRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.threshold == this.threshold &&
          other.enabled == this.enabled &&
          other.lastNotifiedAt == this.lastNotifiedAt &&
          other.leadDays == this.leadDays);
}

class RefillRemindersCompanion extends UpdateCompanion<RefillReminderRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<double> threshold;
  final Value<bool> enabled;
  final Value<DateTime?> lastNotifiedAt;
  final Value<int> leadDays;
  final Value<int> rowid;
  const RefillRemindersCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.threshold = const Value.absent(),
    this.enabled = const Value.absent(),
    this.lastNotifiedAt = const Value.absent(),
    this.leadDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RefillRemindersCompanion.insert({
    required String id,
    required String medicationId,
    required double threshold,
    required bool enabled,
    this.lastNotifiedAt = const Value.absent(),
    required int leadDays,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       threshold = Value(threshold),
       enabled = Value(enabled),
       leadDays = Value(leadDays);
  static Insertable<RefillReminderRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<double>? threshold,
    Expression<bool>? enabled,
    Expression<DateTime>? lastNotifiedAt,
    Expression<int>? leadDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (threshold != null) 'threshold': threshold,
      if (enabled != null) 'enabled': enabled,
      if (lastNotifiedAt != null) 'last_notified_at': lastNotifiedAt,
      if (leadDays != null) 'lead_days': leadDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RefillRemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<double>? threshold,
    Value<bool>? enabled,
    Value<DateTime?>? lastNotifiedAt,
    Value<int>? leadDays,
    Value<int>? rowid,
  }) {
    return RefillRemindersCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      threshold: threshold ?? this.threshold,
      enabled: enabled ?? this.enabled,
      lastNotifiedAt: lastNotifiedAt ?? this.lastNotifiedAt,
      leadDays: leadDays ?? this.leadDays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (threshold.present) {
      map['threshold'] = Variable<double>(threshold.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (lastNotifiedAt.present) {
      map['last_notified_at'] = Variable<DateTime>(lastNotifiedAt.value);
    }
    if (leadDays.present) {
      map['lead_days'] = Variable<int>(leadDays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RefillRemindersCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('threshold: $threshold, ')
          ..write('enabled: $enabled, ')
          ..write('lastNotifiedAt: $lastNotifiedAt, ')
          ..write('leadDays: $leadDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicineInformationCacheTable extends MedicineInformationCache
    with TableInfo<$MedicineInformationCacheTable, MedicineInformationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicineInformationCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genericNameMeta = const VerificationMeta(
    'genericName',
  );
  @override
  late final GeneratedColumn<String> genericName = GeneratedColumn<String>(
    'generic_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandNamesMeta = const VerificationMeta(
    'brandNames',
  );
  @override
  late final GeneratedColumn<String> brandNames = GeneratedColumn<String>(
    'brand_names',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeIngredientsMeta = const VerificationMeta(
    'activeIngredients',
  );
  @override
  late final GeneratedColumn<String> activeIngredients =
      GeneratedColumn<String>(
        'active_ingredients',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _indicationsMeta = const VerificationMeta(
    'indications',
  );
  @override
  late final GeneratedColumn<String> indications = GeneratedColumn<String>(
    'indications',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warningsMeta = const VerificationMeta(
    'warnings',
  );
  @override
  late final GeneratedColumn<String> warnings = GeneratedColumn<String>(
    'warnings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contraindicationsMeta = const VerificationMeta(
    'contraindications',
  );
  @override
  late final GeneratedColumn<String> contraindications =
      GeneratedColumn<String>(
        'contraindications',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sideEffectsMeta = const VerificationMeta(
    'sideEffects',
  );
  @override
  late final GeneratedColumn<String> sideEffects = GeneratedColumn<String>(
    'side_effects',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storageMeta = const VerificationMeta(
    'storage',
  );
  @override
  late final GeneratedColumn<String> storage = GeneratedColumn<String>(
    'storage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dosageFormMeta = const VerificationMeta(
    'dosageForm',
  );
  @override
  late final GeneratedColumn<String> dosageForm = GeneratedColumn<String>(
    'dosage_form',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strengthsMeta = const VerificationMeta(
    'strengths',
  );
  @override
  late final GeneratedColumn<String> strengths = GeneratedColumn<String>(
    'strengths',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodInteractionsMeta = const VerificationMeta(
    'foodInteractions',
  );
  @override
  late final GeneratedColumn<String> foodInteractions = GeneratedColumn<String>(
    'food_interactions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientAdviceMeta = const VerificationMeta(
    'patientAdvice',
  );
  @override
  late final GeneratedColumn<String> patientAdvice = GeneratedColumn<String>(
    'patient_advice',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    medicationId,
    sourceName,
    sourceUrl,
    lastUpdated,
    genericName,
    brandNames,
    activeIngredients,
    indications,
    warnings,
    contraindications,
    sideEffects,
    storage,
    dosageForm,
    strengths,
    foodInteractions,
    patientAdvice,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicine_information_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicineInformationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceNameMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('generic_name')) {
      context.handle(
        _genericNameMeta,
        genericName.isAcceptableOrUnknown(
          data['generic_name']!,
          _genericNameMeta,
        ),
      );
    }
    if (data.containsKey('brand_names')) {
      context.handle(
        _brandNamesMeta,
        brandNames.isAcceptableOrUnknown(data['brand_names']!, _brandNamesMeta),
      );
    } else if (isInserting) {
      context.missing(_brandNamesMeta);
    }
    if (data.containsKey('active_ingredients')) {
      context.handle(
        _activeIngredientsMeta,
        activeIngredients.isAcceptableOrUnknown(
          data['active_ingredients']!,
          _activeIngredientsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeIngredientsMeta);
    }
    if (data.containsKey('indications')) {
      context.handle(
        _indicationsMeta,
        indications.isAcceptableOrUnknown(
          data['indications']!,
          _indicationsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_indicationsMeta);
    }
    if (data.containsKey('warnings')) {
      context.handle(
        _warningsMeta,
        warnings.isAcceptableOrUnknown(data['warnings']!, _warningsMeta),
      );
    } else if (isInserting) {
      context.missing(_warningsMeta);
    }
    if (data.containsKey('contraindications')) {
      context.handle(
        _contraindicationsMeta,
        contraindications.isAcceptableOrUnknown(
          data['contraindications']!,
          _contraindicationsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contraindicationsMeta);
    }
    if (data.containsKey('side_effects')) {
      context.handle(
        _sideEffectsMeta,
        sideEffects.isAcceptableOrUnknown(
          data['side_effects']!,
          _sideEffectsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sideEffectsMeta);
    }
    if (data.containsKey('storage')) {
      context.handle(
        _storageMeta,
        storage.isAcceptableOrUnknown(data['storage']!, _storageMeta),
      );
    }
    if (data.containsKey('dosage_form')) {
      context.handle(
        _dosageFormMeta,
        dosageForm.isAcceptableOrUnknown(data['dosage_form']!, _dosageFormMeta),
      );
    }
    if (data.containsKey('strengths')) {
      context.handle(
        _strengthsMeta,
        strengths.isAcceptableOrUnknown(data['strengths']!, _strengthsMeta),
      );
    } else if (isInserting) {
      context.missing(_strengthsMeta);
    }
    if (data.containsKey('food_interactions')) {
      context.handle(
        _foodInteractionsMeta,
        foodInteractions.isAcceptableOrUnknown(
          data['food_interactions']!,
          _foodInteractionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foodInteractionsMeta);
    }
    if (data.containsKey('patient_advice')) {
      context.handle(
        _patientAdviceMeta,
        patientAdvice.isAcceptableOrUnknown(
          data['patient_advice']!,
          _patientAdviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patientAdviceMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {medicationId};
  @override
  MedicineInformationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicineInformationRow(
      medicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}medication_id'],
          )!,
      sourceName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source_name'],
          )!,
      sourceUrl:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source_url'],
          )!,
      lastUpdated:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}last_updated'],
          )!,
      genericName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generic_name'],
      ),
      brandNames:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}brand_names'],
          )!,
      activeIngredients:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}active_ingredients'],
          )!,
      indications:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}indications'],
          )!,
      warnings:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}warnings'],
          )!,
      contraindications:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}contraindications'],
          )!,
      sideEffects:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}side_effects'],
          )!,
      storage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage'],
      ),
      dosageForm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage_form'],
      ),
      strengths:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}strengths'],
          )!,
      foodInteractions:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}food_interactions'],
          )!,
      patientAdvice:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}patient_advice'],
          )!,
      cachedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}cached_at'],
          )!,
    );
  }

  @override
  $MedicineInformationCacheTable createAlias(String alias) {
    return $MedicineInformationCacheTable(attachedDatabase, alias);
  }
}

class MedicineInformationRow extends DataClass
    implements Insertable<MedicineInformationRow> {
  final String medicationId;
  final String sourceName;
  final String sourceUrl;
  final DateTime lastUpdated;
  final String? genericName;
  final String brandNames;
  final String activeIngredients;
  final String indications;
  final String warnings;
  final String contraindications;
  final String sideEffects;
  final String? storage;
  final String? dosageForm;
  final String strengths;
  final String foodInteractions;
  final String patientAdvice;
  final DateTime cachedAt;
  const MedicineInformationRow({
    required this.medicationId,
    required this.sourceName,
    required this.sourceUrl,
    required this.lastUpdated,
    this.genericName,
    required this.brandNames,
    required this.activeIngredients,
    required this.indications,
    required this.warnings,
    required this.contraindications,
    required this.sideEffects,
    this.storage,
    this.dosageForm,
    required this.strengths,
    required this.foodInteractions,
    required this.patientAdvice,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['medication_id'] = Variable<String>(medicationId);
    map['source_name'] = Variable<String>(sourceName);
    map['source_url'] = Variable<String>(sourceUrl);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    if (!nullToAbsent || genericName != null) {
      map['generic_name'] = Variable<String>(genericName);
    }
    map['brand_names'] = Variable<String>(brandNames);
    map['active_ingredients'] = Variable<String>(activeIngredients);
    map['indications'] = Variable<String>(indications);
    map['warnings'] = Variable<String>(warnings);
    map['contraindications'] = Variable<String>(contraindications);
    map['side_effects'] = Variable<String>(sideEffects);
    if (!nullToAbsent || storage != null) {
      map['storage'] = Variable<String>(storage);
    }
    if (!nullToAbsent || dosageForm != null) {
      map['dosage_form'] = Variable<String>(dosageForm);
    }
    map['strengths'] = Variable<String>(strengths);
    map['food_interactions'] = Variable<String>(foodInteractions);
    map['patient_advice'] = Variable<String>(patientAdvice);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  MedicineInformationCacheCompanion toCompanion(bool nullToAbsent) {
    return MedicineInformationCacheCompanion(
      medicationId: Value(medicationId),
      sourceName: Value(sourceName),
      sourceUrl: Value(sourceUrl),
      lastUpdated: Value(lastUpdated),
      genericName:
          genericName == null && nullToAbsent
              ? const Value.absent()
              : Value(genericName),
      brandNames: Value(brandNames),
      activeIngredients: Value(activeIngredients),
      indications: Value(indications),
      warnings: Value(warnings),
      contraindications: Value(contraindications),
      sideEffects: Value(sideEffects),
      storage:
          storage == null && nullToAbsent
              ? const Value.absent()
              : Value(storage),
      dosageForm:
          dosageForm == null && nullToAbsent
              ? const Value.absent()
              : Value(dosageForm),
      strengths: Value(strengths),
      foodInteractions: Value(foodInteractions),
      patientAdvice: Value(patientAdvice),
      cachedAt: Value(cachedAt),
    );
  }

  factory MedicineInformationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicineInformationRow(
      medicationId: serializer.fromJson<String>(json['medicationId']),
      sourceName: serializer.fromJson<String>(json['sourceName']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      genericName: serializer.fromJson<String?>(json['genericName']),
      brandNames: serializer.fromJson<String>(json['brandNames']),
      activeIngredients: serializer.fromJson<String>(json['activeIngredients']),
      indications: serializer.fromJson<String>(json['indications']),
      warnings: serializer.fromJson<String>(json['warnings']),
      contraindications: serializer.fromJson<String>(json['contraindications']),
      sideEffects: serializer.fromJson<String>(json['sideEffects']),
      storage: serializer.fromJson<String?>(json['storage']),
      dosageForm: serializer.fromJson<String?>(json['dosageForm']),
      strengths: serializer.fromJson<String>(json['strengths']),
      foodInteractions: serializer.fromJson<String>(json['foodInteractions']),
      patientAdvice: serializer.fromJson<String>(json['patientAdvice']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'medicationId': serializer.toJson<String>(medicationId),
      'sourceName': serializer.toJson<String>(sourceName),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'genericName': serializer.toJson<String?>(genericName),
      'brandNames': serializer.toJson<String>(brandNames),
      'activeIngredients': serializer.toJson<String>(activeIngredients),
      'indications': serializer.toJson<String>(indications),
      'warnings': serializer.toJson<String>(warnings),
      'contraindications': serializer.toJson<String>(contraindications),
      'sideEffects': serializer.toJson<String>(sideEffects),
      'storage': serializer.toJson<String?>(storage),
      'dosageForm': serializer.toJson<String?>(dosageForm),
      'strengths': serializer.toJson<String>(strengths),
      'foodInteractions': serializer.toJson<String>(foodInteractions),
      'patientAdvice': serializer.toJson<String>(patientAdvice),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  MedicineInformationRow copyWith({
    String? medicationId,
    String? sourceName,
    String? sourceUrl,
    DateTime? lastUpdated,
    Value<String?> genericName = const Value.absent(),
    String? brandNames,
    String? activeIngredients,
    String? indications,
    String? warnings,
    String? contraindications,
    String? sideEffects,
    Value<String?> storage = const Value.absent(),
    Value<String?> dosageForm = const Value.absent(),
    String? strengths,
    String? foodInteractions,
    String? patientAdvice,
    DateTime? cachedAt,
  }) => MedicineInformationRow(
    medicationId: medicationId ?? this.medicationId,
    sourceName: sourceName ?? this.sourceName,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    genericName: genericName.present ? genericName.value : this.genericName,
    brandNames: brandNames ?? this.brandNames,
    activeIngredients: activeIngredients ?? this.activeIngredients,
    indications: indications ?? this.indications,
    warnings: warnings ?? this.warnings,
    contraindications: contraindications ?? this.contraindications,
    sideEffects: sideEffects ?? this.sideEffects,
    storage: storage.present ? storage.value : this.storage,
    dosageForm: dosageForm.present ? dosageForm.value : this.dosageForm,
    strengths: strengths ?? this.strengths,
    foodInteractions: foodInteractions ?? this.foodInteractions,
    patientAdvice: patientAdvice ?? this.patientAdvice,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  MedicineInformationRow copyWithCompanion(
    MedicineInformationCacheCompanion data,
  ) {
    return MedicineInformationRow(
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      sourceName:
          data.sourceName.present ? data.sourceName.value : this.sourceName,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      genericName:
          data.genericName.present ? data.genericName.value : this.genericName,
      brandNames:
          data.brandNames.present ? data.brandNames.value : this.brandNames,
      activeIngredients:
          data.activeIngredients.present
              ? data.activeIngredients.value
              : this.activeIngredients,
      indications:
          data.indications.present ? data.indications.value : this.indications,
      warnings: data.warnings.present ? data.warnings.value : this.warnings,
      contraindications:
          data.contraindications.present
              ? data.contraindications.value
              : this.contraindications,
      sideEffects:
          data.sideEffects.present ? data.sideEffects.value : this.sideEffects,
      storage: data.storage.present ? data.storage.value : this.storage,
      dosageForm:
          data.dosageForm.present ? data.dosageForm.value : this.dosageForm,
      strengths: data.strengths.present ? data.strengths.value : this.strengths,
      foodInteractions:
          data.foodInteractions.present
              ? data.foodInteractions.value
              : this.foodInteractions,
      patientAdvice:
          data.patientAdvice.present
              ? data.patientAdvice.value
              : this.patientAdvice,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicineInformationRow(')
          ..write('medicationId: $medicationId, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('genericName: $genericName, ')
          ..write('brandNames: $brandNames, ')
          ..write('activeIngredients: $activeIngredients, ')
          ..write('indications: $indications, ')
          ..write('warnings: $warnings, ')
          ..write('contraindications: $contraindications, ')
          ..write('sideEffects: $sideEffects, ')
          ..write('storage: $storage, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('strengths: $strengths, ')
          ..write('foodInteractions: $foodInteractions, ')
          ..write('patientAdvice: $patientAdvice, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    medicationId,
    sourceName,
    sourceUrl,
    lastUpdated,
    genericName,
    brandNames,
    activeIngredients,
    indications,
    warnings,
    contraindications,
    sideEffects,
    storage,
    dosageForm,
    strengths,
    foodInteractions,
    patientAdvice,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicineInformationRow &&
          other.medicationId == this.medicationId &&
          other.sourceName == this.sourceName &&
          other.sourceUrl == this.sourceUrl &&
          other.lastUpdated == this.lastUpdated &&
          other.genericName == this.genericName &&
          other.brandNames == this.brandNames &&
          other.activeIngredients == this.activeIngredients &&
          other.indications == this.indications &&
          other.warnings == this.warnings &&
          other.contraindications == this.contraindications &&
          other.sideEffects == this.sideEffects &&
          other.storage == this.storage &&
          other.dosageForm == this.dosageForm &&
          other.strengths == this.strengths &&
          other.foodInteractions == this.foodInteractions &&
          other.patientAdvice == this.patientAdvice &&
          other.cachedAt == this.cachedAt);
}

class MedicineInformationCacheCompanion
    extends UpdateCompanion<MedicineInformationRow> {
  final Value<String> medicationId;
  final Value<String> sourceName;
  final Value<String> sourceUrl;
  final Value<DateTime> lastUpdated;
  final Value<String?> genericName;
  final Value<String> brandNames;
  final Value<String> activeIngredients;
  final Value<String> indications;
  final Value<String> warnings;
  final Value<String> contraindications;
  final Value<String> sideEffects;
  final Value<String?> storage;
  final Value<String?> dosageForm;
  final Value<String> strengths;
  final Value<String> foodInteractions;
  final Value<String> patientAdvice;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const MedicineInformationCacheCompanion({
    this.medicationId = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.genericName = const Value.absent(),
    this.brandNames = const Value.absent(),
    this.activeIngredients = const Value.absent(),
    this.indications = const Value.absent(),
    this.warnings = const Value.absent(),
    this.contraindications = const Value.absent(),
    this.sideEffects = const Value.absent(),
    this.storage = const Value.absent(),
    this.dosageForm = const Value.absent(),
    this.strengths = const Value.absent(),
    this.foodInteractions = const Value.absent(),
    this.patientAdvice = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicineInformationCacheCompanion.insert({
    required String medicationId,
    required String sourceName,
    required String sourceUrl,
    required DateTime lastUpdated,
    this.genericName = const Value.absent(),
    required String brandNames,
    required String activeIngredients,
    required String indications,
    required String warnings,
    required String contraindications,
    required String sideEffects,
    this.storage = const Value.absent(),
    this.dosageForm = const Value.absent(),
    required String strengths,
    required String foodInteractions,
    required String patientAdvice,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : medicationId = Value(medicationId),
       sourceName = Value(sourceName),
       sourceUrl = Value(sourceUrl),
       lastUpdated = Value(lastUpdated),
       brandNames = Value(brandNames),
       activeIngredients = Value(activeIngredients),
       indications = Value(indications),
       warnings = Value(warnings),
       contraindications = Value(contraindications),
       sideEffects = Value(sideEffects),
       strengths = Value(strengths),
       foodInteractions = Value(foodInteractions),
       patientAdvice = Value(patientAdvice),
       cachedAt = Value(cachedAt);
  static Insertable<MedicineInformationRow> custom({
    Expression<String>? medicationId,
    Expression<String>? sourceName,
    Expression<String>? sourceUrl,
    Expression<DateTime>? lastUpdated,
    Expression<String>? genericName,
    Expression<String>? brandNames,
    Expression<String>? activeIngredients,
    Expression<String>? indications,
    Expression<String>? warnings,
    Expression<String>? contraindications,
    Expression<String>? sideEffects,
    Expression<String>? storage,
    Expression<String>? dosageForm,
    Expression<String>? strengths,
    Expression<String>? foodInteractions,
    Expression<String>? patientAdvice,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (medicationId != null) 'medication_id': medicationId,
      if (sourceName != null) 'source_name': sourceName,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (genericName != null) 'generic_name': genericName,
      if (brandNames != null) 'brand_names': brandNames,
      if (activeIngredients != null) 'active_ingredients': activeIngredients,
      if (indications != null) 'indications': indications,
      if (warnings != null) 'warnings': warnings,
      if (contraindications != null) 'contraindications': contraindications,
      if (sideEffects != null) 'side_effects': sideEffects,
      if (storage != null) 'storage': storage,
      if (dosageForm != null) 'dosage_form': dosageForm,
      if (strengths != null) 'strengths': strengths,
      if (foodInteractions != null) 'food_interactions': foodInteractions,
      if (patientAdvice != null) 'patient_advice': patientAdvice,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicineInformationCacheCompanion copyWith({
    Value<String>? medicationId,
    Value<String>? sourceName,
    Value<String>? sourceUrl,
    Value<DateTime>? lastUpdated,
    Value<String?>? genericName,
    Value<String>? brandNames,
    Value<String>? activeIngredients,
    Value<String>? indications,
    Value<String>? warnings,
    Value<String>? contraindications,
    Value<String>? sideEffects,
    Value<String?>? storage,
    Value<String?>? dosageForm,
    Value<String>? strengths,
    Value<String>? foodInteractions,
    Value<String>? patientAdvice,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return MedicineInformationCacheCompanion(
      medicationId: medicationId ?? this.medicationId,
      sourceName: sourceName ?? this.sourceName,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      genericName: genericName ?? this.genericName,
      brandNames: brandNames ?? this.brandNames,
      activeIngredients: activeIngredients ?? this.activeIngredients,
      indications: indications ?? this.indications,
      warnings: warnings ?? this.warnings,
      contraindications: contraindications ?? this.contraindications,
      sideEffects: sideEffects ?? this.sideEffects,
      storage: storage ?? this.storage,
      dosageForm: dosageForm ?? this.dosageForm,
      strengths: strengths ?? this.strengths,
      foodInteractions: foodInteractions ?? this.foodInteractions,
      patientAdvice: patientAdvice ?? this.patientAdvice,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (genericName.present) {
      map['generic_name'] = Variable<String>(genericName.value);
    }
    if (brandNames.present) {
      map['brand_names'] = Variable<String>(brandNames.value);
    }
    if (activeIngredients.present) {
      map['active_ingredients'] = Variable<String>(activeIngredients.value);
    }
    if (indications.present) {
      map['indications'] = Variable<String>(indications.value);
    }
    if (warnings.present) {
      map['warnings'] = Variable<String>(warnings.value);
    }
    if (contraindications.present) {
      map['contraindications'] = Variable<String>(contraindications.value);
    }
    if (sideEffects.present) {
      map['side_effects'] = Variable<String>(sideEffects.value);
    }
    if (storage.present) {
      map['storage'] = Variable<String>(storage.value);
    }
    if (dosageForm.present) {
      map['dosage_form'] = Variable<String>(dosageForm.value);
    }
    if (strengths.present) {
      map['strengths'] = Variable<String>(strengths.value);
    }
    if (foodInteractions.present) {
      map['food_interactions'] = Variable<String>(foodInteractions.value);
    }
    if (patientAdvice.present) {
      map['patient_advice'] = Variable<String>(patientAdvice.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicineInformationCacheCompanion(')
          ..write('medicationId: $medicationId, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('genericName: $genericName, ')
          ..write('brandNames: $brandNames, ')
          ..write('activeIngredients: $activeIngredients, ')
          ..write('indications: $indications, ')
          ..write('warnings: $warnings, ')
          ..write('contraindications: $contraindications, ')
          ..write('sideEffects: $sideEffects, ')
          ..write('storage: $storage, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('strengths: $strengths, ')
          ..write('foodInteractions: $foodInteractions, ')
          ..write('patientAdvice: $patientAdvice, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AllergyRecordsTable extends AllergyRecords
    with TableInfo<$AllergyRecordsTable, AllergyRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllergyRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _substanceMeta = const VerificationMeta(
    'substance',
  );
  @override
  late final GeneratedColumn<String> substance = GeneratedColumn<String>(
    'substance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reactionMeta = const VerificationMeta(
    'reaction',
  );
  @override
  late final GeneratedColumn<String> reaction = GeneratedColumn<String>(
    'reaction',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    substance,
    reaction,
    severity,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allergy_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<AllergyRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('substance')) {
      context.handle(
        _substanceMeta,
        substance.isAcceptableOrUnknown(data['substance']!, _substanceMeta),
      );
    } else if (isInserting) {
      context.missing(_substanceMeta);
    }
    if (data.containsKey('reaction')) {
      context.handle(
        _reactionMeta,
        reaction.isAcceptableOrUnknown(data['reaction']!, _reactionMeta),
      );
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AllergyRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllergyRecordRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      substance:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}substance'],
          )!,
      reaction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reaction'],
      ),
      severity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}severity'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $AllergyRecordsTable createAlias(String alias) {
    return $AllergyRecordsTable(attachedDatabase, alias);
  }
}

class AllergyRecordRow extends DataClass
    implements Insertable<AllergyRecordRow> {
  final String id;
  final String substance;
  final String? reaction;
  final String severity;
  final String? notes;
  final DateTime createdAt;
  const AllergyRecordRow({
    required this.id,
    required this.substance,
    this.reaction,
    required this.severity,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['substance'] = Variable<String>(substance);
    if (!nullToAbsent || reaction != null) {
      map['reaction'] = Variable<String>(reaction);
    }
    map['severity'] = Variable<String>(severity);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AllergyRecordsCompanion toCompanion(bool nullToAbsent) {
    return AllergyRecordsCompanion(
      id: Value(id),
      substance: Value(substance),
      reaction:
          reaction == null && nullToAbsent
              ? const Value.absent()
              : Value(reaction),
      severity: Value(severity),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory AllergyRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllergyRecordRow(
      id: serializer.fromJson<String>(json['id']),
      substance: serializer.fromJson<String>(json['substance']),
      reaction: serializer.fromJson<String?>(json['reaction']),
      severity: serializer.fromJson<String>(json['severity']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'substance': serializer.toJson<String>(substance),
      'reaction': serializer.toJson<String?>(reaction),
      'severity': serializer.toJson<String>(severity),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AllergyRecordRow copyWith({
    String? id,
    String? substance,
    Value<String?> reaction = const Value.absent(),
    String? severity,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => AllergyRecordRow(
    id: id ?? this.id,
    substance: substance ?? this.substance,
    reaction: reaction.present ? reaction.value : this.reaction,
    severity: severity ?? this.severity,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  AllergyRecordRow copyWithCompanion(AllergyRecordsCompanion data) {
    return AllergyRecordRow(
      id: data.id.present ? data.id.value : this.id,
      substance: data.substance.present ? data.substance.value : this.substance,
      reaction: data.reaction.present ? data.reaction.value : this.reaction,
      severity: data.severity.present ? data.severity.value : this.severity,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllergyRecordRow(')
          ..write('id: $id, ')
          ..write('substance: $substance, ')
          ..write('reaction: $reaction, ')
          ..write('severity: $severity, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, substance, reaction, severity, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllergyRecordRow &&
          other.id == this.id &&
          other.substance == this.substance &&
          other.reaction == this.reaction &&
          other.severity == this.severity &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class AllergyRecordsCompanion extends UpdateCompanion<AllergyRecordRow> {
  final Value<String> id;
  final Value<String> substance;
  final Value<String?> reaction;
  final Value<String> severity;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AllergyRecordsCompanion({
    this.id = const Value.absent(),
    this.substance = const Value.absent(),
    this.reaction = const Value.absent(),
    this.severity = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AllergyRecordsCompanion.insert({
    required String id,
    required String substance,
    this.reaction = const Value.absent(),
    required String severity,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       substance = Value(substance),
       severity = Value(severity),
       createdAt = Value(createdAt);
  static Insertable<AllergyRecordRow> custom({
    Expression<String>? id,
    Expression<String>? substance,
    Expression<String>? reaction,
    Expression<String>? severity,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (substance != null) 'substance': substance,
      if (reaction != null) 'reaction': reaction,
      if (severity != null) 'severity': severity,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AllergyRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? substance,
    Value<String?>? reaction,
    Value<String>? severity,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AllergyRecordsCompanion(
      id: id ?? this.id,
      substance: substance ?? this.substance,
      reaction: reaction ?? this.reaction,
      severity: severity ?? this.severity,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (substance.present) {
      map['substance'] = Variable<String>(substance.value);
    }
    if (reaction.present) {
      map['reaction'] = Variable<String>(reaction.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllergyRecordsCompanion(')
          ..write('id: $id, ')
          ..write('substance: $substance, ')
          ..write('reaction: $reaction, ')
          ..write('severity: $severity, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InteractionAlertsTable extends InteractionAlerts
    with TableInfo<$InteractionAlertsTable, InteractionAlertRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InteractionAlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdsMeta = const VerificationMeta(
    'medicationIds',
  );
  @override
  late final GeneratedColumn<String> medicationIds = GeneratedColumn<String>(
    'medication_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detectedAtMeta = const VerificationMeta(
    'detectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
    'detected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationIds,
    severity,
    description,
    sourceName,
    sourceUrl,
    detectedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interaction_alerts';
  @override
  VerificationContext validateIntegrity(
    Insertable<InteractionAlertRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_ids')) {
      context.handle(
        _medicationIdsMeta,
        medicationIds.isAcceptableOrUnknown(
          data['medication_ids']!,
          _medicationIdsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdsMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceNameMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('detected_at')) {
      context.handle(
        _detectedAtMeta,
        detectedAt.isAcceptableOrUnknown(data['detected_at']!, _detectedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_detectedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InteractionAlertRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InteractionAlertRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      medicationIds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}medication_ids'],
          )!,
      severity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}severity'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      sourceName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source_name'],
          )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      detectedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}detected_at'],
          )!,
    );
  }

  @override
  $InteractionAlertsTable createAlias(String alias) {
    return $InteractionAlertsTable(attachedDatabase, alias);
  }
}

class InteractionAlertRow extends DataClass
    implements Insertable<InteractionAlertRow> {
  final String id;
  final String medicationIds;
  final String severity;
  final String description;
  final String sourceName;
  final String? sourceUrl;
  final DateTime detectedAt;
  const InteractionAlertRow({
    required this.id,
    required this.medicationIds,
    required this.severity,
    required this.description,
    required this.sourceName,
    this.sourceUrl,
    required this.detectedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_ids'] = Variable<String>(medicationIds);
    map['severity'] = Variable<String>(severity);
    map['description'] = Variable<String>(description);
    map['source_name'] = Variable<String>(sourceName);
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    map['detected_at'] = Variable<DateTime>(detectedAt);
    return map;
  }

  InteractionAlertsCompanion toCompanion(bool nullToAbsent) {
    return InteractionAlertsCompanion(
      id: Value(id),
      medicationIds: Value(medicationIds),
      severity: Value(severity),
      description: Value(description),
      sourceName: Value(sourceName),
      sourceUrl:
          sourceUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(sourceUrl),
      detectedAt: Value(detectedAt),
    );
  }

  factory InteractionAlertRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InteractionAlertRow(
      id: serializer.fromJson<String>(json['id']),
      medicationIds: serializer.fromJson<String>(json['medicationIds']),
      severity: serializer.fromJson<String>(json['severity']),
      description: serializer.fromJson<String>(json['description']),
      sourceName: serializer.fromJson<String>(json['sourceName']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationIds': serializer.toJson<String>(medicationIds),
      'severity': serializer.toJson<String>(severity),
      'description': serializer.toJson<String>(description),
      'sourceName': serializer.toJson<String>(sourceName),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
    };
  }

  InteractionAlertRow copyWith({
    String? id,
    String? medicationIds,
    String? severity,
    String? description,
    String? sourceName,
    Value<String?> sourceUrl = const Value.absent(),
    DateTime? detectedAt,
  }) => InteractionAlertRow(
    id: id ?? this.id,
    medicationIds: medicationIds ?? this.medicationIds,
    severity: severity ?? this.severity,
    description: description ?? this.description,
    sourceName: sourceName ?? this.sourceName,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    detectedAt: detectedAt ?? this.detectedAt,
  );
  InteractionAlertRow copyWithCompanion(InteractionAlertsCompanion data) {
    return InteractionAlertRow(
      id: data.id.present ? data.id.value : this.id,
      medicationIds:
          data.medicationIds.present
              ? data.medicationIds.value
              : this.medicationIds,
      severity: data.severity.present ? data.severity.value : this.severity,
      description:
          data.description.present ? data.description.value : this.description,
      sourceName:
          data.sourceName.present ? data.sourceName.value : this.sourceName,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      detectedAt:
          data.detectedAt.present ? data.detectedAt.value : this.detectedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InteractionAlertRow(')
          ..write('id: $id, ')
          ..write('medicationIds: $medicationIds, ')
          ..write('severity: $severity, ')
          ..write('description: $description, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('detectedAt: $detectedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationIds,
    severity,
    description,
    sourceName,
    sourceUrl,
    detectedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InteractionAlertRow &&
          other.id == this.id &&
          other.medicationIds == this.medicationIds &&
          other.severity == this.severity &&
          other.description == this.description &&
          other.sourceName == this.sourceName &&
          other.sourceUrl == this.sourceUrl &&
          other.detectedAt == this.detectedAt);
}

class InteractionAlertsCompanion extends UpdateCompanion<InteractionAlertRow> {
  final Value<String> id;
  final Value<String> medicationIds;
  final Value<String> severity;
  final Value<String> description;
  final Value<String> sourceName;
  final Value<String?> sourceUrl;
  final Value<DateTime> detectedAt;
  final Value<int> rowid;
  const InteractionAlertsCompanion({
    this.id = const Value.absent(),
    this.medicationIds = const Value.absent(),
    this.severity = const Value.absent(),
    this.description = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InteractionAlertsCompanion.insert({
    required String id,
    required String medicationIds,
    required String severity,
    required String description,
    required String sourceName,
    this.sourceUrl = const Value.absent(),
    required DateTime detectedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationIds = Value(medicationIds),
       severity = Value(severity),
       description = Value(description),
       sourceName = Value(sourceName),
       detectedAt = Value(detectedAt);
  static Insertable<InteractionAlertRow> custom({
    Expression<String>? id,
    Expression<String>? medicationIds,
    Expression<String>? severity,
    Expression<String>? description,
    Expression<String>? sourceName,
    Expression<String>? sourceUrl,
    Expression<DateTime>? detectedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationIds != null) 'medication_ids': medicationIds,
      if (severity != null) 'severity': severity,
      if (description != null) 'description': description,
      if (sourceName != null) 'source_name': sourceName,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InteractionAlertsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationIds,
    Value<String>? severity,
    Value<String>? description,
    Value<String>? sourceName,
    Value<String?>? sourceUrl,
    Value<DateTime>? detectedAt,
    Value<int>? rowid,
  }) {
    return InteractionAlertsCompanion(
      id: id ?? this.id,
      medicationIds: medicationIds ?? this.medicationIds,
      severity: severity ?? this.severity,
      description: description ?? this.description,
      sourceName: sourceName ?? this.sourceName,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      detectedAt: detectedAt ?? this.detectedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationIds.present) {
      map['medication_ids'] = Variable<String>(medicationIds.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InteractionAlertsCompanion(')
          ..write('id: $id, ')
          ..write('medicationIds: $medicationIds, ')
          ..write('severity: $severity, ')
          ..write('description: $description, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrescriptionAttachmentsTable extends PrescriptionAttachments
    with TableInfo<$PrescriptionAttachmentsTable, PrescriptionAttachmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrescriptionAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    filePath,
    type,
    caption,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prescription_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrescriptionAttachmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrescriptionAttachmentRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrescriptionAttachmentRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      medicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}medication_id'],
          )!,
      filePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}file_path'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $PrescriptionAttachmentsTable createAlias(String alias) {
    return $PrescriptionAttachmentsTable(attachedDatabase, alias);
  }
}

class PrescriptionAttachmentRow extends DataClass
    implements Insertable<PrescriptionAttachmentRow> {
  final String id;
  final String medicationId;
  final String filePath;
  final String type;
  final String? caption;
  final DateTime createdAt;
  const PrescriptionAttachmentRow({
    required this.id,
    required this.medicationId,
    required this.filePath,
    required this.type,
    this.caption,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['file_path'] = Variable<String>(filePath);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PrescriptionAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return PrescriptionAttachmentsCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      filePath: Value(filePath),
      type: Value(type),
      caption:
          caption == null && nullToAbsent
              ? const Value.absent()
              : Value(caption),
      createdAt: Value(createdAt),
    );
  }

  factory PrescriptionAttachmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrescriptionAttachmentRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      type: serializer.fromJson<String>(json['type']),
      caption: serializer.fromJson<String?>(json['caption']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'filePath': serializer.toJson<String>(filePath),
      'type': serializer.toJson<String>(type),
      'caption': serializer.toJson<String?>(caption),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PrescriptionAttachmentRow copyWith({
    String? id,
    String? medicationId,
    String? filePath,
    String? type,
    Value<String?> caption = const Value.absent(),
    DateTime? createdAt,
  }) => PrescriptionAttachmentRow(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    filePath: filePath ?? this.filePath,
    type: type ?? this.type,
    caption: caption.present ? caption.value : this.caption,
    createdAt: createdAt ?? this.createdAt,
  );
  PrescriptionAttachmentRow copyWithCompanion(
    PrescriptionAttachmentsCompanion data,
  ) {
    return PrescriptionAttachmentRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      type: data.type.present ? data.type.value : this.type,
      caption: data.caption.present ? data.caption.value : this.caption,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrescriptionAttachmentRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('filePath: $filePath, ')
          ..write('type: $type, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, medicationId, filePath, type, caption, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrescriptionAttachmentRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.filePath == this.filePath &&
          other.type == this.type &&
          other.caption == this.caption &&
          other.createdAt == this.createdAt);
}

class PrescriptionAttachmentsCompanion
    extends UpdateCompanion<PrescriptionAttachmentRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> filePath;
  final Value<String> type;
  final Value<String?> caption;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PrescriptionAttachmentsCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.type = const Value.absent(),
    this.caption = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrescriptionAttachmentsCompanion.insert({
    required String id,
    required String medicationId,
    required String filePath,
    required String type,
    this.caption = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       filePath = Value(filePath),
       type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<PrescriptionAttachmentRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? filePath,
    Expression<String>? type,
    Expression<String>? caption,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (filePath != null) 'file_path': filePath,
      if (type != null) 'type': type,
      if (caption != null) 'caption': caption,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrescriptionAttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<String>? filePath,
    Value<String>? type,
    Value<String?>? caption,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PrescriptionAttachmentsCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      filePath: filePath ?? this.filePath,
      type: type ?? this.type,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrescriptionAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('filePath: $filePath, ')
          ..write('type: $type, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CaregiverAccessTable extends CaregiverAccess
    with TableInfo<$CaregiverAccessTable, CaregiverAccessRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaregiverAccessTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _caregiverNameMeta = const VerificationMeta(
    'caregiverName',
  );
  @override
  late final GeneratedColumn<String> caregiverName = GeneratedColumn<String>(
    'caregiver_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactMeta = const VerificationMeta(
    'contact',
  );
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
    'contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canEditMeta = const VerificationMeta(
    'canEdit',
  );
  @override
  late final GeneratedColumn<bool> canEdit = GeneratedColumn<bool>(
    'can_edit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("can_edit" IN (0, 1))',
    ),
  );
  static const VerificationMeta _grantedAtMeta = const VerificationMeta(
    'grantedAt',
  );
  @override
  late final GeneratedColumn<DateTime> grantedAt = GeneratedColumn<DateTime>(
    'granted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    caregiverName,
    contact,
    canEdit,
    grantedAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'caregiver_access';
  @override
  VerificationContext validateIntegrity(
    Insertable<CaregiverAccessRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('caregiver_name')) {
      context.handle(
        _caregiverNameMeta,
        caregiverName.isAcceptableOrUnknown(
          data['caregiver_name']!,
          _caregiverNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caregiverNameMeta);
    }
    if (data.containsKey('contact')) {
      context.handle(
        _contactMeta,
        contact.isAcceptableOrUnknown(data['contact']!, _contactMeta),
      );
    }
    if (data.containsKey('can_edit')) {
      context.handle(
        _canEditMeta,
        canEdit.isAcceptableOrUnknown(data['can_edit']!, _canEditMeta),
      );
    } else if (isInserting) {
      context.missing(_canEditMeta);
    }
    if (data.containsKey('granted_at')) {
      context.handle(
        _grantedAtMeta,
        grantedAt.isAcceptableOrUnknown(data['granted_at']!, _grantedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_grantedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaregiverAccessRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaregiverAccessRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      medicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}medication_id'],
          )!,
      caregiverName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}caregiver_name'],
          )!,
      contact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact'],
      ),
      canEdit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}can_edit'],
          )!,
      grantedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}granted_at'],
          )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $CaregiverAccessTable createAlias(String alias) {
    return $CaregiverAccessTable(attachedDatabase, alias);
  }
}

class CaregiverAccessRow extends DataClass
    implements Insertable<CaregiverAccessRow> {
  final String id;
  final String medicationId;
  final String caregiverName;
  final String? contact;

  /// The caregiver may see the schedule but not change it.
  final bool canEdit;
  final DateTime grantedAt;
  final DateTime? expiresAt;
  const CaregiverAccessRow({
    required this.id,
    required this.medicationId,
    required this.caregiverName,
    this.contact,
    required this.canEdit,
    required this.grantedAt,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['caregiver_name'] = Variable<String>(caregiverName);
    if (!nullToAbsent || contact != null) {
      map['contact'] = Variable<String>(contact);
    }
    map['can_edit'] = Variable<bool>(canEdit);
    map['granted_at'] = Variable<DateTime>(grantedAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  CaregiverAccessCompanion toCompanion(bool nullToAbsent) {
    return CaregiverAccessCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      caregiverName: Value(caregiverName),
      contact:
          contact == null && nullToAbsent
              ? const Value.absent()
              : Value(contact),
      canEdit: Value(canEdit),
      grantedAt: Value(grantedAt),
      expiresAt:
          expiresAt == null && nullToAbsent
              ? const Value.absent()
              : Value(expiresAt),
    );
  }

  factory CaregiverAccessRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaregiverAccessRow(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      caregiverName: serializer.fromJson<String>(json['caregiverName']),
      contact: serializer.fromJson<String?>(json['contact']),
      canEdit: serializer.fromJson<bool>(json['canEdit']),
      grantedAt: serializer.fromJson<DateTime>(json['grantedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'caregiverName': serializer.toJson<String>(caregiverName),
      'contact': serializer.toJson<String?>(contact),
      'canEdit': serializer.toJson<bool>(canEdit),
      'grantedAt': serializer.toJson<DateTime>(grantedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  CaregiverAccessRow copyWith({
    String? id,
    String? medicationId,
    String? caregiverName,
    Value<String?> contact = const Value.absent(),
    bool? canEdit,
    DateTime? grantedAt,
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => CaregiverAccessRow(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    caregiverName: caregiverName ?? this.caregiverName,
    contact: contact.present ? contact.value : this.contact,
    canEdit: canEdit ?? this.canEdit,
    grantedAt: grantedAt ?? this.grantedAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  CaregiverAccessRow copyWithCompanion(CaregiverAccessCompanion data) {
    return CaregiverAccessRow(
      id: data.id.present ? data.id.value : this.id,
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      caregiverName:
          data.caregiverName.present
              ? data.caregiverName.value
              : this.caregiverName,
      contact: data.contact.present ? data.contact.value : this.contact,
      canEdit: data.canEdit.present ? data.canEdit.value : this.canEdit,
      grantedAt: data.grantedAt.present ? data.grantedAt.value : this.grantedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaregiverAccessRow(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('caregiverName: $caregiverName, ')
          ..write('contact: $contact, ')
          ..write('canEdit: $canEdit, ')
          ..write('grantedAt: $grantedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    caregiverName,
    contact,
    canEdit,
    grantedAt,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaregiverAccessRow &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.caregiverName == this.caregiverName &&
          other.contact == this.contact &&
          other.canEdit == this.canEdit &&
          other.grantedAt == this.grantedAt &&
          other.expiresAt == this.expiresAt);
}

class CaregiverAccessCompanion extends UpdateCompanion<CaregiverAccessRow> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> caregiverName;
  final Value<String?> contact;
  final Value<bool> canEdit;
  final Value<DateTime> grantedAt;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const CaregiverAccessCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.caregiverName = const Value.absent(),
    this.contact = const Value.absent(),
    this.canEdit = const Value.absent(),
    this.grantedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CaregiverAccessCompanion.insert({
    required String id,
    required String medicationId,
    required String caregiverName,
    this.contact = const Value.absent(),
    required bool canEdit,
    required DateTime grantedAt,
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       caregiverName = Value(caregiverName),
       canEdit = Value(canEdit),
       grantedAt = Value(grantedAt);
  static Insertable<CaregiverAccessRow> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? caregiverName,
    Expression<String>? contact,
    Expression<bool>? canEdit,
    Expression<DateTime>? grantedAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (caregiverName != null) 'caregiver_name': caregiverName,
      if (contact != null) 'contact': contact,
      if (canEdit != null) 'can_edit': canEdit,
      if (grantedAt != null) 'granted_at': grantedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CaregiverAccessCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<String>? caregiverName,
    Value<String?>? contact,
    Value<bool>? canEdit,
    Value<DateTime>? grantedAt,
    Value<DateTime?>? expiresAt,
    Value<int>? rowid,
  }) {
    return CaregiverAccessCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      caregiverName: caregiverName ?? this.caregiverName,
      contact: contact ?? this.contact,
      canEdit: canEdit ?? this.canEdit,
      grantedAt: grantedAt ?? this.grantedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (caregiverName.present) {
      map['caregiver_name'] = Variable<String>(caregiverName.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (canEdit.present) {
      map['can_edit'] = Variable<bool>(canEdit.value);
    }
    if (grantedAt.present) {
      map['granted_at'] = Variable<DateTime>(grantedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaregiverAccessCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('caregiverName: $caregiverName, ')
          ..write('contact: $contact, ')
          ..write('canEdit: $canEdit, ')
          ..write('grantedAt: $grantedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationSchedulesTable extends NotificationSchedules
    with TableInfo<$NotificationSchedulesTable, NotificationScheduleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseIdMeta = const VerificationMeta('doseId');
  @override
  late final GeneratedColumn<String> doseId = GeneratedColumn<String>(
    'dose_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    notificationId,
    kind,
    medicationId,
    scheduledAt,
    doseId,
    payload,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationScheduleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('dose_id')) {
      context.handle(
        _doseIdMeta,
        doseId.isAcceptableOrUnknown(data['dose_id']!, _doseIdMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {notificationId};
  @override
  NotificationScheduleRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationScheduleRow(
      notificationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}notification_id'],
          )!,
      kind:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}kind'],
          )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_id'],
      ),
      scheduledAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}scheduled_at'],
          )!,
      doseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose_id'],
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $NotificationSchedulesTable createAlias(String alias) {
    return $NotificationSchedulesTable(attachedDatabase, alias);
  }
}

class NotificationScheduleRow extends DataClass
    implements Insertable<NotificationScheduleRow> {
  /// The numeric notification id used on the platform.
  final int notificationId;
  final String kind;
  final String? medicationId;
  final DateTime scheduledAt;
  final String? doseId;
  final String? payload;
  final DateTime createdAt;
  const NotificationScheduleRow({
    required this.notificationId,
    required this.kind,
    this.medicationId,
    required this.scheduledAt,
    this.doseId,
    this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['notification_id'] = Variable<int>(notificationId);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || medicationId != null) {
      map['medication_id'] = Variable<String>(medicationId);
    }
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || doseId != null) {
      map['dose_id'] = Variable<String>(doseId);
    }
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NotificationSchedulesCompanion toCompanion(bool nullToAbsent) {
    return NotificationSchedulesCompanion(
      notificationId: Value(notificationId),
      kind: Value(kind),
      medicationId:
          medicationId == null && nullToAbsent
              ? const Value.absent()
              : Value(medicationId),
      scheduledAt: Value(scheduledAt),
      doseId:
          doseId == null && nullToAbsent ? const Value.absent() : Value(doseId),
      payload:
          payload == null && nullToAbsent
              ? const Value.absent()
              : Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory NotificationScheduleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationScheduleRow(
      notificationId: serializer.fromJson<int>(json['notificationId']),
      kind: serializer.fromJson<String>(json['kind']),
      medicationId: serializer.fromJson<String?>(json['medicationId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      doseId: serializer.fromJson<String?>(json['doseId']),
      payload: serializer.fromJson<String?>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'notificationId': serializer.toJson<int>(notificationId),
      'kind': serializer.toJson<String>(kind),
      'medicationId': serializer.toJson<String?>(medicationId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'doseId': serializer.toJson<String?>(doseId),
      'payload': serializer.toJson<String?>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NotificationScheduleRow copyWith({
    int? notificationId,
    String? kind,
    Value<String?> medicationId = const Value.absent(),
    DateTime? scheduledAt,
    Value<String?> doseId = const Value.absent(),
    Value<String?> payload = const Value.absent(),
    DateTime? createdAt,
  }) => NotificationScheduleRow(
    notificationId: notificationId ?? this.notificationId,
    kind: kind ?? this.kind,
    medicationId: medicationId.present ? medicationId.value : this.medicationId,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    doseId: doseId.present ? doseId.value : this.doseId,
    payload: payload.present ? payload.value : this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  NotificationScheduleRow copyWithCompanion(
    NotificationSchedulesCompanion data,
  ) {
    return NotificationScheduleRow(
      notificationId:
          data.notificationId.present
              ? data.notificationId.value
              : this.notificationId,
      kind: data.kind.present ? data.kind.value : this.kind,
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      doseId: data.doseId.present ? data.doseId.value : this.doseId,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationScheduleRow(')
          ..write('notificationId: $notificationId, ')
          ..write('kind: $kind, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('doseId: $doseId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    notificationId,
    kind,
    medicationId,
    scheduledAt,
    doseId,
    payload,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationScheduleRow &&
          other.notificationId == this.notificationId &&
          other.kind == this.kind &&
          other.medicationId == this.medicationId &&
          other.scheduledAt == this.scheduledAt &&
          other.doseId == this.doseId &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class NotificationSchedulesCompanion
    extends UpdateCompanion<NotificationScheduleRow> {
  final Value<int> notificationId;
  final Value<String> kind;
  final Value<String?> medicationId;
  final Value<DateTime> scheduledAt;
  final Value<String?> doseId;
  final Value<String?> payload;
  final Value<DateTime> createdAt;
  const NotificationSchedulesCompanion({
    this.notificationId = const Value.absent(),
    this.kind = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.doseId = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  NotificationSchedulesCompanion.insert({
    this.notificationId = const Value.absent(),
    required String kind,
    this.medicationId = const Value.absent(),
    required DateTime scheduledAt,
    this.doseId = const Value.absent(),
    this.payload = const Value.absent(),
    required DateTime createdAt,
  }) : kind = Value(kind),
       scheduledAt = Value(scheduledAt),
       createdAt = Value(createdAt);
  static Insertable<NotificationScheduleRow> custom({
    Expression<int>? notificationId,
    Expression<String>? kind,
    Expression<String>? medicationId,
    Expression<DateTime>? scheduledAt,
    Expression<String>? doseId,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (notificationId != null) 'notification_id': notificationId,
      if (kind != null) 'kind': kind,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (doseId != null) 'dose_id': doseId,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  NotificationSchedulesCompanion copyWith({
    Value<int>? notificationId,
    Value<String>? kind,
    Value<String?>? medicationId,
    Value<DateTime>? scheduledAt,
    Value<String?>? doseId,
    Value<String?>? payload,
    Value<DateTime>? createdAt,
  }) {
    return NotificationSchedulesCompanion(
      notificationId: notificationId ?? this.notificationId,
      kind: kind ?? this.kind,
      medicationId: medicationId ?? this.medicationId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      doseId: doseId ?? this.doseId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (doseId.present) {
      map['dose_id'] = Variable<String>(doseId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSchedulesCompanion(')
          ..write('notificationId: $notificationId, ')
          ..write('kind: $kind, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('doseId: $doseId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ScheduleAuditLogTable extends ScheduleAuditLog
    with TableInfo<$ScheduleAuditLogTable, ScheduleAuditRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleAuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _beforeJsonMeta = const VerificationMeta(
    'beforeJson',
  );
  @override
  late final GeneratedColumn<String> beforeJson = GeneratedColumn<String>(
    'before_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _undoneMeta = const VerificationMeta('undone');
  @override
  late final GeneratedColumn<bool> undone = GeneratedColumn<bool>(
    'undone',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("undone" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _resumeOnMeta = const VerificationMeta(
    'resumeOn',
  );
  @override
  late final GeneratedColumn<DateTime> resumeOn = GeneratedColumn<DateTime>(
    'resume_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resumedMeta = const VerificationMeta(
    'resumed',
  );
  @override
  late final GeneratedColumn<bool> resumed = GeneratedColumn<bool>(
    'resumed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("resumed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    medicationId,
    summary,
    beforeJson,
    createdAt,
    undone,
    resumeOn,
    resumed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleAuditRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('before_json')) {
      context.handle(
        _beforeJsonMeta,
        beforeJson.isAcceptableOrUnknown(data['before_json']!, _beforeJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_beforeJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('undone')) {
      context.handle(
        _undoneMeta,
        undone.isAcceptableOrUnknown(data['undone']!, _undoneMeta),
      );
    }
    if (data.containsKey('resume_on')) {
      context.handle(
        _resumeOnMeta,
        resumeOn.isAcceptableOrUnknown(data['resume_on']!, _resumeOnMeta),
      );
    }
    if (data.containsKey('resumed')) {
      context.handle(
        _resumedMeta,
        resumed.isAcceptableOrUnknown(data['resumed']!, _resumedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleAuditRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleAuditRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      kind:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}kind'],
          )!,
      medicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}medication_id'],
          )!,
      summary:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}summary'],
          )!,
      beforeJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}before_json'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      undone:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}undone'],
          )!,
      resumeOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resume_on'],
      ),
      resumed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}resumed'],
          )!,
    );
  }

  @override
  $ScheduleAuditLogTable createAlias(String alias) {
    return $ScheduleAuditLogTable(attachedDatabase, alias);
  }
}

class ScheduleAuditRow extends DataClass
    implements Insertable<ScheduleAuditRow> {
  /// The proposal id, so a proposal can only ever be applied once.
  final String id;
  final String kind;
  final String medicationId;
  final String summary;

  /// JSON snapshot of what the change replaced (empty when nothing to restore).
  final String beforeJson;
  final DateTime createdAt;
  final bool undone;

  /// For a timed pause: when reminders should come back.
  final DateTime? resumeOn;
  final bool resumed;
  const ScheduleAuditRow({
    required this.id,
    required this.kind,
    required this.medicationId,
    required this.summary,
    required this.beforeJson,
    required this.createdAt,
    required this.undone,
    this.resumeOn,
    required this.resumed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['medication_id'] = Variable<String>(medicationId);
    map['summary'] = Variable<String>(summary);
    map['before_json'] = Variable<String>(beforeJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['undone'] = Variable<bool>(undone);
    if (!nullToAbsent || resumeOn != null) {
      map['resume_on'] = Variable<DateTime>(resumeOn);
    }
    map['resumed'] = Variable<bool>(resumed);
    return map;
  }

  ScheduleAuditLogCompanion toCompanion(bool nullToAbsent) {
    return ScheduleAuditLogCompanion(
      id: Value(id),
      kind: Value(kind),
      medicationId: Value(medicationId),
      summary: Value(summary),
      beforeJson: Value(beforeJson),
      createdAt: Value(createdAt),
      undone: Value(undone),
      resumeOn:
          resumeOn == null && nullToAbsent
              ? const Value.absent()
              : Value(resumeOn),
      resumed: Value(resumed),
    );
  }

  factory ScheduleAuditRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleAuditRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      summary: serializer.fromJson<String>(json['summary']),
      beforeJson: serializer.fromJson<String>(json['beforeJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      undone: serializer.fromJson<bool>(json['undone']),
      resumeOn: serializer.fromJson<DateTime?>(json['resumeOn']),
      resumed: serializer.fromJson<bool>(json['resumed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'medicationId': serializer.toJson<String>(medicationId),
      'summary': serializer.toJson<String>(summary),
      'beforeJson': serializer.toJson<String>(beforeJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'undone': serializer.toJson<bool>(undone),
      'resumeOn': serializer.toJson<DateTime?>(resumeOn),
      'resumed': serializer.toJson<bool>(resumed),
    };
  }

  ScheduleAuditRow copyWith({
    String? id,
    String? kind,
    String? medicationId,
    String? summary,
    String? beforeJson,
    DateTime? createdAt,
    bool? undone,
    Value<DateTime?> resumeOn = const Value.absent(),
    bool? resumed,
  }) => ScheduleAuditRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    medicationId: medicationId ?? this.medicationId,
    summary: summary ?? this.summary,
    beforeJson: beforeJson ?? this.beforeJson,
    createdAt: createdAt ?? this.createdAt,
    undone: undone ?? this.undone,
    resumeOn: resumeOn.present ? resumeOn.value : this.resumeOn,
    resumed: resumed ?? this.resumed,
  );
  ScheduleAuditRow copyWithCompanion(ScheduleAuditLogCompanion data) {
    return ScheduleAuditRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      medicationId:
          data.medicationId.present
              ? data.medicationId.value
              : this.medicationId,
      summary: data.summary.present ? data.summary.value : this.summary,
      beforeJson:
          data.beforeJson.present ? data.beforeJson.value : this.beforeJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      undone: data.undone.present ? data.undone.value : this.undone,
      resumeOn: data.resumeOn.present ? data.resumeOn.value : this.resumeOn,
      resumed: data.resumed.present ? data.resumed.value : this.resumed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleAuditRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('medicationId: $medicationId, ')
          ..write('summary: $summary, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('undone: $undone, ')
          ..write('resumeOn: $resumeOn, ')
          ..write('resumed: $resumed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    medicationId,
    summary,
    beforeJson,
    createdAt,
    undone,
    resumeOn,
    resumed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleAuditRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.medicationId == this.medicationId &&
          other.summary == this.summary &&
          other.beforeJson == this.beforeJson &&
          other.createdAt == this.createdAt &&
          other.undone == this.undone &&
          other.resumeOn == this.resumeOn &&
          other.resumed == this.resumed);
}

class ScheduleAuditLogCompanion extends UpdateCompanion<ScheduleAuditRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> medicationId;
  final Value<String> summary;
  final Value<String> beforeJson;
  final Value<DateTime> createdAt;
  final Value<bool> undone;
  final Value<DateTime?> resumeOn;
  final Value<bool> resumed;
  final Value<int> rowid;
  const ScheduleAuditLogCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.summary = const Value.absent(),
    this.beforeJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.undone = const Value.absent(),
    this.resumeOn = const Value.absent(),
    this.resumed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleAuditLogCompanion.insert({
    required String id,
    required String kind,
    required String medicationId,
    required String summary,
    required String beforeJson,
    required DateTime createdAt,
    this.undone = const Value.absent(),
    this.resumeOn = const Value.absent(),
    this.resumed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       medicationId = Value(medicationId),
       summary = Value(summary),
       beforeJson = Value(beforeJson),
       createdAt = Value(createdAt);
  static Insertable<ScheduleAuditRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? medicationId,
    Expression<String>? summary,
    Expression<String>? beforeJson,
    Expression<DateTime>? createdAt,
    Expression<bool>? undone,
    Expression<DateTime>? resumeOn,
    Expression<bool>? resumed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (medicationId != null) 'medication_id': medicationId,
      if (summary != null) 'summary': summary,
      if (beforeJson != null) 'before_json': beforeJson,
      if (createdAt != null) 'created_at': createdAt,
      if (undone != null) 'undone': undone,
      if (resumeOn != null) 'resume_on': resumeOn,
      if (resumed != null) 'resumed': resumed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduleAuditLogCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? medicationId,
    Value<String>? summary,
    Value<String>? beforeJson,
    Value<DateTime>? createdAt,
    Value<bool>? undone,
    Value<DateTime?>? resumeOn,
    Value<bool>? resumed,
    Value<int>? rowid,
  }) {
    return ScheduleAuditLogCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      medicationId: medicationId ?? this.medicationId,
      summary: summary ?? this.summary,
      beforeJson: beforeJson ?? this.beforeJson,
      createdAt: createdAt ?? this.createdAt,
      undone: undone ?? this.undone,
      resumeOn: resumeOn ?? this.resumeOn,
      resumed: resumed ?? this.resumed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (beforeJson.present) {
      map['before_json'] = Variable<String>(beforeJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (undone.present) {
      map['undone'] = Variable<bool>(undone.value);
    }
    if (resumeOn.present) {
      map['resume_on'] = Variable<DateTime>(resumeOn.value);
    }
    if (resumed.present) {
      map['resumed'] = Variable<bool>(resumed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleAuditLogCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('medicationId: $medicationId, ')
          ..write('summary: $summary, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('undone: $undone, ')
          ..write('resumeOn: $resumeOn, ')
          ..write('resumed: $resumed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $SchedulePhasesTable schedulePhases = $SchedulePhasesTable(this);
  late final $ScheduledDosesTable scheduledDoses = $ScheduledDosesTable(this);
  late final $DoseLogsTable doseLogs = $DoseLogsTable(this);
  late final $InventoriesTable inventories = $InventoriesTable(this);
  late final $InventoryTransactionsTable inventoryTransactions =
      $InventoryTransactionsTable(this);
  late final $NotificationPreferencesTable notificationPreferences =
      $NotificationPreferencesTable(this);
  late final $RefillRemindersTable refillReminders = $RefillRemindersTable(
    this,
  );
  late final $MedicineInformationCacheTable medicineInformationCache =
      $MedicineInformationCacheTable(this);
  late final $AllergyRecordsTable allergyRecords = $AllergyRecordsTable(this);
  late final $InteractionAlertsTable interactionAlerts =
      $InteractionAlertsTable(this);
  late final $PrescriptionAttachmentsTable prescriptionAttachments =
      $PrescriptionAttachmentsTable(this);
  late final $CaregiverAccessTable caregiverAccess = $CaregiverAccessTable(
    this,
  );
  late final $NotificationSchedulesTable notificationSchedules =
      $NotificationSchedulesTable(this);
  late final $ScheduleAuditLogTable scheduleAuditLog = $ScheduleAuditLogTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    medications,
    schedulePhases,
    scheduledDoses,
    doseLogs,
    inventories,
    inventoryTransactions,
    notificationPreferences,
    refillReminders,
    medicineInformationCache,
    allergyRecords,
    interactionAlerts,
    prescriptionAttachments,
    caregiverAccess,
    notificationSchedules,
    scheduleAuditLog,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('schedule_phases', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('scheduled_doses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dose_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inventories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inventory_transactions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('notification_preferences', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('refill_reminders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('prescription_attachments', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('caregiver_access', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('notification_schedules', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      Value<String?> displayName,
      Value<String?> timezoneId,
      required String timeFormat,
      required String themeMode,
      required bool notificationsEnabled,
      required bool defaultReminderEnabled,
      Value<int?> preReminderMinutes,
      required bool missedFollowUpEnabled,
      required int missedFollowUpMinutes,
      required bool quietHoursEnabled,
      required int quietHoursStartMinutes,
      required int quietHoursEndMinutes,
      required bool dailySummaryEnabled,
      required int dailySummaryMinutes,
      required String notificationPrivacy,
      required bool onboardingCompleted,
      required bool demoMode,
      required bool appLockEnabled,
      required double textScale,
      required String appearance,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<String?> displayName,
      Value<String?> timezoneId,
      Value<String> timeFormat,
      Value<String> themeMode,
      Value<bool> notificationsEnabled,
      Value<bool> defaultReminderEnabled,
      Value<int?> preReminderMinutes,
      Value<bool> missedFollowUpEnabled,
      Value<int> missedFollowUpMinutes,
      Value<bool> quietHoursEnabled,
      Value<int> quietHoursStartMinutes,
      Value<int> quietHoursEndMinutes,
      Value<bool> dailySummaryEnabled,
      Value<int> dailySummaryMinutes,
      Value<String> notificationPrivacy,
      Value<bool> onboardingCompleted,
      Value<bool> demoMode,
      Value<bool> appLockEnabled,
      Value<double> textScale,
      Value<String> appearance,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeFormat => $composableBuilder(
    column: $table.timeFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get defaultReminderEnabled => $composableBuilder(
    column: $table.defaultReminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preReminderMinutes => $composableBuilder(
    column: $table.preReminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get missedFollowUpEnabled => $composableBuilder(
    column: $table.missedFollowUpEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get missedFollowUpMinutes => $composableBuilder(
    column: $table.missedFollowUpMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get quietHoursEnabled => $composableBuilder(
    column: $table.quietHoursEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dailySummaryEnabled => $composableBuilder(
    column: $table.dailySummaryEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailySummaryMinutes => $composableBuilder(
    column: $table.dailySummaryMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notificationPrivacy => $composableBuilder(
    column: $table.notificationPrivacy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get demoMode => $composableBuilder(
    column: $table.demoMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get textScale => $composableBuilder(
    column: $table.textScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeFormat => $composableBuilder(
    column: $table.timeFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get defaultReminderEnabled => $composableBuilder(
    column: $table.defaultReminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preReminderMinutes => $composableBuilder(
    column: $table.preReminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get missedFollowUpEnabled => $composableBuilder(
    column: $table.missedFollowUpEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get missedFollowUpMinutes => $composableBuilder(
    column: $table.missedFollowUpMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get quietHoursEnabled => $composableBuilder(
    column: $table.quietHoursEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dailySummaryEnabled => $composableBuilder(
    column: $table.dailySummaryEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailySummaryMinutes => $composableBuilder(
    column: $table.dailySummaryMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notificationPrivacy => $composableBuilder(
    column: $table.notificationPrivacy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get demoMode => $composableBuilder(
    column: $table.demoMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get textScale => $composableBuilder(
    column: $table.textScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeFormat => $composableBuilder(
    column: $table.timeFormat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get defaultReminderEnabled => $composableBuilder(
    column: $table.defaultReminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preReminderMinutes => $composableBuilder(
    column: $table.preReminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get missedFollowUpEnabled => $composableBuilder(
    column: $table.missedFollowUpEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get missedFollowUpMinutes => $composableBuilder(
    column: $table.missedFollowUpMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get quietHoursEnabled => $composableBuilder(
    column: $table.quietHoursEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dailySummaryEnabled => $composableBuilder(
    column: $table.dailySummaryEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailySummaryMinutes => $composableBuilder(
    column: $table.dailySummaryMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notificationPrivacy => $composableBuilder(
    column: $table.notificationPrivacy,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get demoMode =>
      $composableBuilder(column: $table.demoMode, builder: (column) => column);

  GeneratedColumn<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<double> get textScale =>
      $composableBuilder(column: $table.textScale, builder: (column) => column);

  GeneratedColumn<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfileRow,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfileRow,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfileRow>,
          ),
          UserProfileRow,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> timezoneId = const Value.absent(),
                Value<String> timeFormat = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<bool> defaultReminderEnabled = const Value.absent(),
                Value<int?> preReminderMinutes = const Value.absent(),
                Value<bool> missedFollowUpEnabled = const Value.absent(),
                Value<int> missedFollowUpMinutes = const Value.absent(),
                Value<bool> quietHoursEnabled = const Value.absent(),
                Value<int> quietHoursStartMinutes = const Value.absent(),
                Value<int> quietHoursEndMinutes = const Value.absent(),
                Value<bool> dailySummaryEnabled = const Value.absent(),
                Value<int> dailySummaryMinutes = const Value.absent(),
                Value<String> notificationPrivacy = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<bool> demoMode = const Value.absent(),
                Value<bool> appLockEnabled = const Value.absent(),
                Value<double> textScale = const Value.absent(),
                Value<String> appearance = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                displayName: displayName,
                timezoneId: timezoneId,
                timeFormat: timeFormat,
                themeMode: themeMode,
                notificationsEnabled: notificationsEnabled,
                defaultReminderEnabled: defaultReminderEnabled,
                preReminderMinutes: preReminderMinutes,
                missedFollowUpEnabled: missedFollowUpEnabled,
                missedFollowUpMinutes: missedFollowUpMinutes,
                quietHoursEnabled: quietHoursEnabled,
                quietHoursStartMinutes: quietHoursStartMinutes,
                quietHoursEndMinutes: quietHoursEndMinutes,
                dailySummaryEnabled: dailySummaryEnabled,
                dailySummaryMinutes: dailySummaryMinutes,
                notificationPrivacy: notificationPrivacy,
                onboardingCompleted: onboardingCompleted,
                demoMode: demoMode,
                appLockEnabled: appLockEnabled,
                textScale: textScale,
                appearance: appearance,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> displayName = const Value.absent(),
                Value<String?> timezoneId = const Value.absent(),
                required String timeFormat,
                required String themeMode,
                required bool notificationsEnabled,
                required bool defaultReminderEnabled,
                Value<int?> preReminderMinutes = const Value.absent(),
                required bool missedFollowUpEnabled,
                required int missedFollowUpMinutes,
                required bool quietHoursEnabled,
                required int quietHoursStartMinutes,
                required int quietHoursEndMinutes,
                required bool dailySummaryEnabled,
                required int dailySummaryMinutes,
                required String notificationPrivacy,
                required bool onboardingCompleted,
                required bool demoMode,
                required bool appLockEnabled,
                required double textScale,
                required String appearance,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                displayName: displayName,
                timezoneId: timezoneId,
                timeFormat: timeFormat,
                themeMode: themeMode,
                notificationsEnabled: notificationsEnabled,
                defaultReminderEnabled: defaultReminderEnabled,
                preReminderMinutes: preReminderMinutes,
                missedFollowUpEnabled: missedFollowUpEnabled,
                missedFollowUpMinutes: missedFollowUpMinutes,
                quietHoursEnabled: quietHoursEnabled,
                quietHoursStartMinutes: quietHoursStartMinutes,
                quietHoursEndMinutes: quietHoursEndMinutes,
                dailySummaryEnabled: dailySummaryEnabled,
                dailySummaryMinutes: dailySummaryMinutes,
                notificationPrivacy: notificationPrivacy,
                onboardingCompleted: onboardingCompleted,
                demoMode: demoMode,
                appLockEnabled: appLockEnabled,
                textScale: textScale,
                appearance: appearance,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfileRow,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfileRow,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfileRow>,
      ),
      UserProfileRow,
      PrefetchHooks Function()
    >;
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      required String id,
      required String name,
      Value<String?> genericName,
      Value<String?> brandName,
      required String category,
      required String form,
      Value<double?> strength,
      required String strengthUnit,
      required String route,
      required String foodInstruction,
      Value<String?> instructions,
      Value<String?> prescriber,
      Value<String?> pharmacyName,
      Value<String?> pharmacyPhone,
      required String status,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      required bool isAsNeeded,
      Value<String?> photoPath,
      Value<String?> barcode,
      Value<String?> notes,
      required bool isFavorite,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> genericName,
      Value<String?> brandName,
      Value<String> category,
      Value<String> form,
      Value<double?> strength,
      Value<String> strengthUnit,
      Value<String> route,
      Value<String> foodInstruction,
      Value<String?> instructions,
      Value<String?> prescriber,
      Value<String?> pharmacyName,
      Value<String?> pharmacyPhone,
      Value<String> status,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      Value<bool> isAsNeeded,
      Value<String?> photoPath,
      Value<String?> barcode,
      Value<String?> notes,
      Value<bool> isFavorite,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, MedicationRow> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SchedulePhasesTable, List<SchedulePhaseRow>>
  _schedulePhasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.schedulePhases,
    aliasName: $_aliasNameGenerator(
      db.medications.id,
      db.schedulePhases.medicationId,
    ),
  );

  $$SchedulePhasesTableProcessedTableManager get schedulePhasesRefs {
    final manager = $$SchedulePhasesTableTableManager(
      $_db,
      $_db.schedulePhases,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_schedulePhasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScheduledDosesTable, List<ScheduledDoseRow>>
  _scheduledDosesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scheduledDoses,
    aliasName: $_aliasNameGenerator(
      db.medications.id,
      db.scheduledDoses.medicationId,
    ),
  );

  $$ScheduledDosesTableProcessedTableManager get scheduledDosesRefs {
    final manager = $$ScheduledDosesTableTableManager(
      $_db,
      $_db.scheduledDoses,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_scheduledDosesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DoseLogsTable, List<DoseLogRow>>
  _doseLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.doseLogs,
    aliasName: $_aliasNameGenerator(
      db.medications.id,
      db.doseLogs.medicationId,
    ),
  );

  $$DoseLogsTableProcessedTableManager get doseLogsRefs {
    final manager = $$DoseLogsTableTableManager(
      $_db,
      $_db.doseLogs,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doseLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InventoriesTable, List<InventoryRow>>
  _inventoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventories,
    aliasName: $_aliasNameGenerator(
      db.medications.id,
      db.inventories.medicationId,
    ),
  );

  $$InventoriesTableProcessedTableManager get inventoriesRefs {
    final manager = $$InventoriesTableTableManager(
      $_db,
      $_db.inventories,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $InventoryTransactionsTable,
    List<InventoryTransactionRow>
  >
  _inventoryTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inventoryTransactions,
        aliasName: $_aliasNameGenerator(
          db.medications.id,
          db.inventoryTransactions.medicationId,
        ),
      );

  $$InventoryTransactionsTableProcessedTableManager
  get inventoryTransactionsRefs {
    final manager = $$InventoryTransactionsTableTableManager(
      $_db,
      $_db.inventoryTransactions,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inventoryTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $NotificationPreferencesTable,
    List<NotificationPreferenceRow>
  >
  _notificationPreferencesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.notificationPreferences,
        aliasName: $_aliasNameGenerator(
          db.medications.id,
          db.notificationPreferences.medicationId,
        ),
      );

  $$NotificationPreferencesTableProcessedTableManager
  get notificationPreferencesRefs {
    final manager = $$NotificationPreferencesTableTableManager(
      $_db,
      $_db.notificationPreferences,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _notificationPreferencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RefillRemindersTable, List<RefillReminderRow>>
  _refillRemindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.refillReminders,
    aliasName: $_aliasNameGenerator(
      db.medications.id,
      db.refillReminders.medicationId,
    ),
  );

  $$RefillRemindersTableProcessedTableManager get refillRemindersRefs {
    final manager = $$RefillRemindersTableTableManager(
      $_db,
      $_db.refillReminders,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _refillRemindersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PrescriptionAttachmentsTable,
    List<PrescriptionAttachmentRow>
  >
  _prescriptionAttachmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.prescriptionAttachments,
        aliasName: $_aliasNameGenerator(
          db.medications.id,
          db.prescriptionAttachments.medicationId,
        ),
      );

  $$PrescriptionAttachmentsTableProcessedTableManager
  get prescriptionAttachmentsRefs {
    final manager = $$PrescriptionAttachmentsTableTableManager(
      $_db,
      $_db.prescriptionAttachments,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _prescriptionAttachmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CaregiverAccessTable, List<CaregiverAccessRow>>
  _caregiverAccessRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.caregiverAccess,
    aliasName: $_aliasNameGenerator(
      db.medications.id,
      db.caregiverAccess.medicationId,
    ),
  );

  $$CaregiverAccessTableProcessedTableManager get caregiverAccessRefs {
    final manager = $$CaregiverAccessTableTableManager(
      $_db,
      $_db.caregiverAccess,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _caregiverAccessRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $NotificationSchedulesTable,
    List<NotificationScheduleRow>
  >
  _notificationSchedulesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.notificationSchedules,
        aliasName: $_aliasNameGenerator(
          db.medications.id,
          db.notificationSchedules.medicationId,
        ),
      );

  $$NotificationSchedulesTableProcessedTableManager
  get notificationSchedulesRefs {
    final manager = $$NotificationSchedulesTableTableManager(
      $_db,
      $_db.notificationSchedules,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _notificationSchedulesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strengthUnit => $composableBuilder(
    column: $table.strengthUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get route => $composableBuilder(
    column: $table.route,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodInstruction => $composableBuilder(
    column: $table.foodInstruction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prescriber => $composableBuilder(
    column: $table.prescriber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pharmacyName => $composableBuilder(
    column: $table.pharmacyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pharmacyPhone => $composableBuilder(
    column: $table.pharmacyPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAsNeeded => $composableBuilder(
    column: $table.isAsNeeded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> schedulePhasesRefs(
    Expression<bool> Function($$SchedulePhasesTableFilterComposer f) f,
  ) {
    final $$SchedulePhasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schedulePhases,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulePhasesTableFilterComposer(
            $db: $db,
            $table: $db.schedulePhases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scheduledDosesRefs(
    Expression<bool> Function($$ScheduledDosesTableFilterComposer f) f,
  ) {
    final $$ScheduledDosesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduledDoses,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduledDosesTableFilterComposer(
            $db: $db,
            $table: $db.scheduledDoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> doseLogsRefs(
    Expression<bool> Function($$DoseLogsTableFilterComposer f) f,
  ) {
    final $$DoseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLogs,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoseLogsTableFilterComposer(
            $db: $db,
            $table: $db.doseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inventoriesRefs(
    Expression<bool> Function($$InventoriesTableFilterComposer f) f,
  ) {
    final $$InventoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventories,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoriesTableFilterComposer(
            $db: $db,
            $table: $db.inventories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inventoryTransactionsRefs(
    Expression<bool> Function($$InventoryTransactionsTableFilterComposer f) f,
  ) {
    final $$InventoryTransactionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inventoryTransactions,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryTransactionsTableFilterComposer(
                $db: $db,
                $table: $db.inventoryTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> notificationPreferencesRefs(
    Expression<bool> Function($$NotificationPreferencesTableFilterComposer f) f,
  ) {
    final $$NotificationPreferencesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.notificationPreferences,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$NotificationPreferencesTableFilterComposer(
                $db: $db,
                $table: $db.notificationPreferences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> refillRemindersRefs(
    Expression<bool> Function($$RefillRemindersTableFilterComposer f) f,
  ) {
    final $$RefillRemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.refillReminders,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefillRemindersTableFilterComposer(
            $db: $db,
            $table: $db.refillReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> prescriptionAttachmentsRefs(
    Expression<bool> Function($$PrescriptionAttachmentsTableFilterComposer f) f,
  ) {
    final $$PrescriptionAttachmentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.prescriptionAttachments,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PrescriptionAttachmentsTableFilterComposer(
                $db: $db,
                $table: $db.prescriptionAttachments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> caregiverAccessRefs(
    Expression<bool> Function($$CaregiverAccessTableFilterComposer f) f,
  ) {
    final $$CaregiverAccessTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.caregiverAccess,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaregiverAccessTableFilterComposer(
            $db: $db,
            $table: $db.caregiverAccess,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notificationSchedulesRefs(
    Expression<bool> Function($$NotificationSchedulesTableFilterComposer f) f,
  ) {
    final $$NotificationSchedulesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.notificationSchedules,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$NotificationSchedulesTableFilterComposer(
                $db: $db,
                $table: $db.notificationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strengthUnit => $composableBuilder(
    column: $table.strengthUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get route => $composableBuilder(
    column: $table.route,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodInstruction => $composableBuilder(
    column: $table.foodInstruction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prescriber => $composableBuilder(
    column: $table.prescriber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pharmacyName => $composableBuilder(
    column: $table.pharmacyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pharmacyPhone => $composableBuilder(
    column: $table.pharmacyPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAsNeeded => $composableBuilder(
    column: $table.isAsNeeded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brandName =>
      $composableBuilder(column: $table.brandName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<double> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get strengthUnit => $composableBuilder(
    column: $table.strengthUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get route =>
      $composableBuilder(column: $table.route, builder: (column) => column);

  GeneratedColumn<String> get foodInstruction => $composableBuilder(
    column: $table.foodInstruction,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prescriber => $composableBuilder(
    column: $table.prescriber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pharmacyName => $composableBuilder(
    column: $table.pharmacyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pharmacyPhone => $composableBuilder(
    column: $table.pharmacyPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isAsNeeded => $composableBuilder(
    column: $table.isAsNeeded,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> schedulePhasesRefs<T extends Object>(
    Expression<T> Function($$SchedulePhasesTableAnnotationComposer a) f,
  ) {
    final $$SchedulePhasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schedulePhases,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulePhasesTableAnnotationComposer(
            $db: $db,
            $table: $db.schedulePhases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scheduledDosesRefs<T extends Object>(
    Expression<T> Function($$ScheduledDosesTableAnnotationComposer a) f,
  ) {
    final $$ScheduledDosesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduledDoses,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduledDosesTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduledDoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> doseLogsRefs<T extends Object>(
    Expression<T> Function($$DoseLogsTableAnnotationComposer a) f,
  ) {
    final $$DoseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLogs,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.doseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inventoriesRefs<T extends Object>(
    Expression<T> Function($$InventoriesTableAnnotationComposer a) f,
  ) {
    final $$InventoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventories,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.inventories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inventoryTransactionsRefs<T extends Object>(
    Expression<T> Function($$InventoryTransactionsTableAnnotationComposer a) f,
  ) {
    final $$InventoryTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inventoryTransactions,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.inventoryTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> notificationPreferencesRefs<T extends Object>(
    Expression<T> Function($$NotificationPreferencesTableAnnotationComposer a)
    f,
  ) {
    final $$NotificationPreferencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.notificationPreferences,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$NotificationPreferencesTableAnnotationComposer(
                $db: $db,
                $table: $db.notificationPreferences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> refillRemindersRefs<T extends Object>(
    Expression<T> Function($$RefillRemindersTableAnnotationComposer a) f,
  ) {
    final $$RefillRemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.refillReminders,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefillRemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.refillReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> prescriptionAttachmentsRefs<T extends Object>(
    Expression<T> Function($$PrescriptionAttachmentsTableAnnotationComposer a)
    f,
  ) {
    final $$PrescriptionAttachmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.prescriptionAttachments,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PrescriptionAttachmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.prescriptionAttachments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> caregiverAccessRefs<T extends Object>(
    Expression<T> Function($$CaregiverAccessTableAnnotationComposer a) f,
  ) {
    final $$CaregiverAccessTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.caregiverAccess,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaregiverAccessTableAnnotationComposer(
            $db: $db,
            $table: $db.caregiverAccess,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notificationSchedulesRefs<T extends Object>(
    Expression<T> Function($$NotificationSchedulesTableAnnotationComposer a) f,
  ) {
    final $$NotificationSchedulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.notificationSchedules,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$NotificationSchedulesTableAnnotationComposer(
                $db: $db,
                $table: $db.notificationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          MedicationRow,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (MedicationRow, $$MedicationsTableReferences),
          MedicationRow,
          PrefetchHooks Function({
            bool schedulePhasesRefs,
            bool scheduledDosesRefs,
            bool doseLogsRefs,
            bool inventoriesRefs,
            bool inventoryTransactionsRefs,
            bool notificationPreferencesRefs,
            bool refillRemindersRefs,
            bool prescriptionAttachmentsRefs,
            bool caregiverAccessRefs,
            bool notificationSchedulesRefs,
          })
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> genericName = const Value.absent(),
                Value<String?> brandName = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> form = const Value.absent(),
                Value<double?> strength = const Value.absent(),
                Value<String> strengthUnit = const Value.absent(),
                Value<String> route = const Value.absent(),
                Value<String> foodInstruction = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<String?> prescriber = const Value.absent(),
                Value<String?> pharmacyName = const Value.absent(),
                Value<String?> pharmacyPhone = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isAsNeeded = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                name: name,
                genericName: genericName,
                brandName: brandName,
                category: category,
                form: form,
                strength: strength,
                strengthUnit: strengthUnit,
                route: route,
                foodInstruction: foodInstruction,
                instructions: instructions,
                prescriber: prescriber,
                pharmacyName: pharmacyName,
                pharmacyPhone: pharmacyPhone,
                status: status,
                startDate: startDate,
                endDate: endDate,
                isAsNeeded: isAsNeeded,
                photoPath: photoPath,
                barcode: barcode,
                notes: notes,
                isFavorite: isFavorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> genericName = const Value.absent(),
                Value<String?> brandName = const Value.absent(),
                required String category,
                required String form,
                Value<double?> strength = const Value.absent(),
                required String strengthUnit,
                required String route,
                required String foodInstruction,
                Value<String?> instructions = const Value.absent(),
                Value<String?> prescriber = const Value.absent(),
                Value<String?> pharmacyName = const Value.absent(),
                Value<String?> pharmacyPhone = const Value.absent(),
                required String status,
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                required bool isAsNeeded,
                Value<String?> photoPath = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required bool isFavorite,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                name: name,
                genericName: genericName,
                brandName: brandName,
                category: category,
                form: form,
                strength: strength,
                strengthUnit: strengthUnit,
                route: route,
                foodInstruction: foodInstruction,
                instructions: instructions,
                prescriber: prescriber,
                pharmacyName: pharmacyName,
                pharmacyPhone: pharmacyPhone,
                status: status,
                startDate: startDate,
                endDate: endDate,
                isAsNeeded: isAsNeeded,
                photoPath: photoPath,
                barcode: barcode,
                notes: notes,
                isFavorite: isFavorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$MedicationsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            schedulePhasesRefs = false,
            scheduledDosesRefs = false,
            doseLogsRefs = false,
            inventoriesRefs = false,
            inventoryTransactionsRefs = false,
            notificationPreferencesRefs = false,
            refillRemindersRefs = false,
            prescriptionAttachmentsRefs = false,
            caregiverAccessRefs = false,
            notificationSchedulesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (schedulePhasesRefs) db.schedulePhases,
                if (scheduledDosesRefs) db.scheduledDoses,
                if (doseLogsRefs) db.doseLogs,
                if (inventoriesRefs) db.inventories,
                if (inventoryTransactionsRefs) db.inventoryTransactions,
                if (notificationPreferencesRefs) db.notificationPreferences,
                if (refillRemindersRefs) db.refillReminders,
                if (prescriptionAttachmentsRefs) db.prescriptionAttachments,
                if (caregiverAccessRefs) db.caregiverAccess,
                if (notificationSchedulesRefs) db.notificationSchedules,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (schedulePhasesRefs)
                    await $_getPrefetchedData<
                      MedicationRow,
                      $MedicationsTable,
                      SchedulePhaseRow
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._schedulePhasesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).schedulePhasesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (scheduledDosesRefs)
                    await $_getPrefetchedData<
                      MedicationRow,
                      $MedicationsTable,
                      ScheduledDoseRow
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._scheduledDosesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduledDosesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (doseLogsRefs)
                    await $_getPrefetchedData<
                      MedicationRow,
                      $MedicationsTable,
                      DoseLogRow
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._doseLogsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).doseLogsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (inventoriesRefs)
                    await $_getPrefetchedData<
                      MedicationRow,
                      $MedicationsTable,
                      InventoryRow
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._inventoriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).inventoriesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (inventoryTransactionsRefs)
                    await $_getPrefetchedData<
                      MedicationRow,
                      $MedicationsTable,
                      InventoryTransactionRow
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._inventoryTransactionsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).inventoryTransactionsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (notificationPreferencesRefs)
                    await $_getPrefetchedData<
                      MedicationRow,
                      $MedicationsTable,
                      NotificationPreferenceRow
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._notificationPreferencesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).notificationPreferencesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (refillRemindersRefs)
                    await $_getPrefetchedData<
                      MedicationRow,
                      $MedicationsTable,
                      RefillReminderRow
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._refillRemindersRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).refillRemindersRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (prescriptionAttachmentsRefs)
                    await $_getPrefetchedData<
                      MedicationRow,
                      $MedicationsTable,
                      PrescriptionAttachmentRow
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._prescriptionAttachmentsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).prescriptionAttachmentsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (caregiverAccessRefs)
                    await $_getPrefetchedData<
                      MedicationRow,
                      $MedicationsTable,
                      CaregiverAccessRow
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._caregiverAccessRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).caregiverAccessRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (notificationSchedulesRefs)
                    await $_getPrefetchedData<
                      MedicationRow,
                      $MedicationsTable,
                      NotificationScheduleRow
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._notificationSchedulesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).notificationSchedulesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      MedicationRow,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (MedicationRow, $$MedicationsTableReferences),
      MedicationRow,
      PrefetchHooks Function({
        bool schedulePhasesRefs,
        bool scheduledDosesRefs,
        bool doseLogsRefs,
        bool inventoriesRefs,
        bool inventoryTransactionsRefs,
        bool notificationPreferencesRefs,
        bool refillRemindersRefs,
        bool prescriptionAttachmentsRefs,
        bool caregiverAccessRefs,
        bool notificationSchedulesRefs,
      })
    >;
typedef $$SchedulePhasesTableCreateCompanionBuilder =
    SchedulePhasesCompanion Function({
      required String id,
      required String medicationId,
      required int phaseOrder,
      required String kind,
      required DateTime startDate,
      Value<DateTime?> endDate,
      required String timesMinutes,
      required String weekdays,
      required int intervalDays,
      required int intervalHours,
      required String monthlyDays,
      required double doseQuantity,
      required String unit,
      Value<String?> foodInstruction,
      Value<String?> instructions,
      required bool isActive,
      Value<int> rowid,
    });
typedef $$SchedulePhasesTableUpdateCompanionBuilder =
    SchedulePhasesCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<int> phaseOrder,
      Value<String> kind,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<String> timesMinutes,
      Value<String> weekdays,
      Value<int> intervalDays,
      Value<int> intervalHours,
      Value<String> monthlyDays,
      Value<double> doseQuantity,
      Value<String> unit,
      Value<String?> foodInstruction,
      Value<String?> instructions,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$SchedulePhasesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SchedulePhasesTable, SchedulePhaseRow> {
  $$SchedulePhasesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(db.schedulePhases.medicationId, db.medications.id),
      );

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SchedulePhasesTableFilterComposer
    extends Composer<_$AppDatabase, $SchedulePhasesTable> {
  $$SchedulePhasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phaseOrder => $composableBuilder(
    column: $table.phaseOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timesMinutes => $composableBuilder(
    column: $table.timesMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalHours => $composableBuilder(
    column: $table.intervalHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get monthlyDays => $composableBuilder(
    column: $table.monthlyDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get doseQuantity => $composableBuilder(
    column: $table.doseQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodInstruction => $composableBuilder(
    column: $table.foodInstruction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchedulePhasesTableOrderingComposer
    extends Composer<_$AppDatabase, $SchedulePhasesTable> {
  $$SchedulePhasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phaseOrder => $composableBuilder(
    column: $table.phaseOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timesMinutes => $composableBuilder(
    column: $table.timesMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalHours => $composableBuilder(
    column: $table.intervalHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get monthlyDays => $composableBuilder(
    column: $table.monthlyDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get doseQuantity => $composableBuilder(
    column: $table.doseQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodInstruction => $composableBuilder(
    column: $table.foodInstruction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchedulePhasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchedulePhasesTable> {
  $$SchedulePhasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get phaseOrder => $composableBuilder(
    column: $table.phaseOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get timesMinutes => $composableBuilder(
    column: $table.timesMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalHours => $composableBuilder(
    column: $table.intervalHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get monthlyDays => $composableBuilder(
    column: $table.monthlyDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get doseQuantity => $composableBuilder(
    column: $table.doseQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get foodInstruction => $composableBuilder(
    column: $table.foodInstruction,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchedulePhasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchedulePhasesTable,
          SchedulePhaseRow,
          $$SchedulePhasesTableFilterComposer,
          $$SchedulePhasesTableOrderingComposer,
          $$SchedulePhasesTableAnnotationComposer,
          $$SchedulePhasesTableCreateCompanionBuilder,
          $$SchedulePhasesTableUpdateCompanionBuilder,
          (SchedulePhaseRow, $$SchedulePhasesTableReferences),
          SchedulePhaseRow,
          PrefetchHooks Function({bool medicationId})
        > {
  $$SchedulePhasesTableTableManager(
    _$AppDatabase db,
    $SchedulePhasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SchedulePhasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$SchedulePhasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SchedulePhasesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<int> phaseOrder = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<String> timesMinutes = const Value.absent(),
                Value<String> weekdays = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> intervalHours = const Value.absent(),
                Value<String> monthlyDays = const Value.absent(),
                Value<double> doseQuantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String?> foodInstruction = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchedulePhasesCompanion(
                id: id,
                medicationId: medicationId,
                phaseOrder: phaseOrder,
                kind: kind,
                startDate: startDate,
                endDate: endDate,
                timesMinutes: timesMinutes,
                weekdays: weekdays,
                intervalDays: intervalDays,
                intervalHours: intervalHours,
                monthlyDays: monthlyDays,
                doseQuantity: doseQuantity,
                unit: unit,
                foodInstruction: foodInstruction,
                instructions: instructions,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required int phaseOrder,
                required String kind,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                required String timesMinutes,
                required String weekdays,
                required int intervalDays,
                required int intervalHours,
                required String monthlyDays,
                required double doseQuantity,
                required String unit,
                Value<String?> foodInstruction = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                required bool isActive,
                Value<int> rowid = const Value.absent(),
              }) => SchedulePhasesCompanion.insert(
                id: id,
                medicationId: medicationId,
                phaseOrder: phaseOrder,
                kind: kind,
                startDate: startDate,
                endDate: endDate,
                timesMinutes: timesMinutes,
                weekdays: weekdays,
                intervalDays: intervalDays,
                intervalHours: intervalHours,
                monthlyDays: monthlyDays,
                doseQuantity: doseQuantity,
                unit: unit,
                foodInstruction: foodInstruction,
                instructions: instructions,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SchedulePhasesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (medicationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable: $$SchedulePhasesTableReferences
                                ._medicationIdTable(db),
                            referencedColumn:
                                $$SchedulePhasesTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SchedulePhasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchedulePhasesTable,
      SchedulePhaseRow,
      $$SchedulePhasesTableFilterComposer,
      $$SchedulePhasesTableOrderingComposer,
      $$SchedulePhasesTableAnnotationComposer,
      $$SchedulePhasesTableCreateCompanionBuilder,
      $$SchedulePhasesTableUpdateCompanionBuilder,
      (SchedulePhaseRow, $$SchedulePhasesTableReferences),
      SchedulePhaseRow,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$ScheduledDosesTableCreateCompanionBuilder =
    ScheduledDosesCompanion Function({
      required String id,
      required String medicationId,
      required String phaseId,
      required DateTime scheduledAt,
      required DateTime localDate,
      required int scheduledMinutes,
      required double doseQuantity,
      required String unit,
      required String status,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ScheduledDosesTableUpdateCompanionBuilder =
    ScheduledDosesCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<String> phaseId,
      Value<DateTime> scheduledAt,
      Value<DateTime> localDate,
      Value<int> scheduledMinutes,
      Value<double> doseQuantity,
      Value<String> unit,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ScheduledDosesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ScheduledDosesTable, ScheduledDoseRow> {
  $$ScheduledDosesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(db.scheduledDoses.medicationId, db.medications.id),
      );

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScheduledDosesTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledDosesTable> {
  $$ScheduledDosesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phaseId => $composableBuilder(
    column: $table.phaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledMinutes => $composableBuilder(
    column: $table.scheduledMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get doseQuantity => $composableBuilder(
    column: $table.doseQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledDosesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledDosesTable> {
  $$ScheduledDosesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phaseId => $composableBuilder(
    column: $table.phaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledMinutes => $composableBuilder(
    column: $table.scheduledMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get doseQuantity => $composableBuilder(
    column: $table.doseQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledDosesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledDosesTable> {
  $$ScheduledDosesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phaseId =>
      $composableBuilder(column: $table.phaseId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<int> get scheduledMinutes => $composableBuilder(
    column: $table.scheduledMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get doseQuantity => $composableBuilder(
    column: $table.doseQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledDosesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduledDosesTable,
          ScheduledDoseRow,
          $$ScheduledDosesTableFilterComposer,
          $$ScheduledDosesTableOrderingComposer,
          $$ScheduledDosesTableAnnotationComposer,
          $$ScheduledDosesTableCreateCompanionBuilder,
          $$ScheduledDosesTableUpdateCompanionBuilder,
          (ScheduledDoseRow, $$ScheduledDosesTableReferences),
          ScheduledDoseRow,
          PrefetchHooks Function({bool medicationId})
        > {
  $$ScheduledDosesTableTableManager(
    _$AppDatabase db,
    $ScheduledDosesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ScheduledDosesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ScheduledDosesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ScheduledDosesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<String> phaseId = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<DateTime> localDate = const Value.absent(),
                Value<int> scheduledMinutes = const Value.absent(),
                Value<double> doseQuantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduledDosesCompanion(
                id: id,
                medicationId: medicationId,
                phaseId: phaseId,
                scheduledAt: scheduledAt,
                localDate: localDate,
                scheduledMinutes: scheduledMinutes,
                doseQuantity: doseQuantity,
                unit: unit,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required String phaseId,
                required DateTime scheduledAt,
                required DateTime localDate,
                required int scheduledMinutes,
                required double doseQuantity,
                required String unit,
                required String status,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ScheduledDosesCompanion.insert(
                id: id,
                medicationId: medicationId,
                phaseId: phaseId,
                scheduledAt: scheduledAt,
                localDate: localDate,
                scheduledMinutes: scheduledMinutes,
                doseQuantity: doseQuantity,
                unit: unit,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ScheduledDosesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (medicationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable: $$ScheduledDosesTableReferences
                                ._medicationIdTable(db),
                            referencedColumn:
                                $$ScheduledDosesTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScheduledDosesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduledDosesTable,
      ScheduledDoseRow,
      $$ScheduledDosesTableFilterComposer,
      $$ScheduledDosesTableOrderingComposer,
      $$ScheduledDosesTableAnnotationComposer,
      $$ScheduledDosesTableCreateCompanionBuilder,
      $$ScheduledDosesTableUpdateCompanionBuilder,
      (ScheduledDoseRow, $$ScheduledDosesTableReferences),
      ScheduledDoseRow,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$DoseLogsTableCreateCompanionBuilder =
    DoseLogsCompanion Function({
      required String id,
      required String medicationId,
      required String scheduledDoseId,
      required String status,
      required DateTime scheduledAt,
      required DateTime actedAt,
      Value<double?> amountTaken,
      Value<String?> unit,
      Value<String?> note,
      Value<String?> inventoryTransactionId,
      Value<String?> supersedesLogId,
      required bool isActive,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$DoseLogsTableUpdateCompanionBuilder =
    DoseLogsCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<String> scheduledDoseId,
      Value<String> status,
      Value<DateTime> scheduledAt,
      Value<DateTime> actedAt,
      Value<double?> amountTaken,
      Value<String?> unit,
      Value<String?> note,
      Value<String?> inventoryTransactionId,
      Value<String?> supersedesLogId,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$DoseLogsTableReferences
    extends BaseReferences<_$AppDatabase, $DoseLogsTable, DoseLogRow> {
  $$DoseLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(db.doseLogs.medicationId, db.medications.id),
      );

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DoseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledDoseId => $composableBuilder(
    column: $table.scheduledDoseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actedAt => $composableBuilder(
    column: $table.actedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountTaken => $composableBuilder(
    column: $table.amountTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inventoryTransactionId => $composableBuilder(
    column: $table.inventoryTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supersedesLogId => $composableBuilder(
    column: $table.supersedesLogId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledDoseId => $composableBuilder(
    column: $table.scheduledDoseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actedAt => $composableBuilder(
    column: $table.actedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountTaken => $composableBuilder(
    column: $table.amountTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inventoryTransactionId => $composableBuilder(
    column: $table.inventoryTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supersedesLogId => $composableBuilder(
    column: $table.supersedesLogId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scheduledDoseId => $composableBuilder(
    column: $table.scheduledDoseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actedAt =>
      $composableBuilder(column: $table.actedAt, builder: (column) => column);

  GeneratedColumn<double> get amountTaken => $composableBuilder(
    column: $table.amountTaken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get inventoryTransactionId => $composableBuilder(
    column: $table.inventoryTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supersedesLogId => $composableBuilder(
    column: $table.supersedesLogId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoseLogsTable,
          DoseLogRow,
          $$DoseLogsTableFilterComposer,
          $$DoseLogsTableOrderingComposer,
          $$DoseLogsTableAnnotationComposer,
          $$DoseLogsTableCreateCompanionBuilder,
          $$DoseLogsTableUpdateCompanionBuilder,
          (DoseLogRow, $$DoseLogsTableReferences),
          DoseLogRow,
          PrefetchHooks Function({bool medicationId})
        > {
  $$DoseLogsTableTableManager(_$AppDatabase db, $DoseLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DoseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$DoseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$DoseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<String> scheduledDoseId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<DateTime> actedAt = const Value.absent(),
                Value<double?> amountTaken = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> inventoryTransactionId = const Value.absent(),
                Value<String?> supersedesLogId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoseLogsCompanion(
                id: id,
                medicationId: medicationId,
                scheduledDoseId: scheduledDoseId,
                status: status,
                scheduledAt: scheduledAt,
                actedAt: actedAt,
                amountTaken: amountTaken,
                unit: unit,
                note: note,
                inventoryTransactionId: inventoryTransactionId,
                supersedesLogId: supersedesLogId,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required String scheduledDoseId,
                required String status,
                required DateTime scheduledAt,
                required DateTime actedAt,
                Value<double?> amountTaken = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> inventoryTransactionId = const Value.absent(),
                Value<String?> supersedesLogId = const Value.absent(),
                required bool isActive,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DoseLogsCompanion.insert(
                id: id,
                medicationId: medicationId,
                scheduledDoseId: scheduledDoseId,
                status: status,
                scheduledAt: scheduledAt,
                actedAt: actedAt,
                amountTaken: amountTaken,
                unit: unit,
                note: note,
                inventoryTransactionId: inventoryTransactionId,
                supersedesLogId: supersedesLogId,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$DoseLogsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (medicationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable: $$DoseLogsTableReferences
                                ._medicationIdTable(db),
                            referencedColumn:
                                $$DoseLogsTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DoseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoseLogsTable,
      DoseLogRow,
      $$DoseLogsTableFilterComposer,
      $$DoseLogsTableOrderingComposer,
      $$DoseLogsTableAnnotationComposer,
      $$DoseLogsTableCreateCompanionBuilder,
      $$DoseLogsTableUpdateCompanionBuilder,
      (DoseLogRow, $$DoseLogsTableReferences),
      DoseLogRow,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$InventoriesTableCreateCompanionBuilder =
    InventoriesCompanion Function({
      required String id,
      required String medicationId,
      required double quantityOnHand,
      required String unit,
      required double refillThreshold,
      required double initialQuantity,
      Value<DateTime?> lastRefillAt,
      Value<DateTime?> expiryDate,
      Value<String?> notes,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$InventoriesTableUpdateCompanionBuilder =
    InventoriesCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<double> quantityOnHand,
      Value<String> unit,
      Value<double> refillThreshold,
      Value<double> initialQuantity,
      Value<DateTime?> lastRefillAt,
      Value<DateTime?> expiryDate,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$InventoriesTableReferences
    extends BaseReferences<_$AppDatabase, $InventoriesTable, InventoryRow> {
  $$InventoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(db.inventories.medicationId, db.medications.id),
      );

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InventoriesTableFilterComposer
    extends Composer<_$AppDatabase, $InventoriesTable> {
  $$InventoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityOnHand => $composableBuilder(
    column: $table.quantityOnHand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get refillThreshold => $composableBuilder(
    column: $table.refillThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get initialQuantity => $composableBuilder(
    column: $table.initialQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastRefillAt => $composableBuilder(
    column: $table.lastRefillAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoriesTable> {
  $$InventoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityOnHand => $composableBuilder(
    column: $table.quantityOnHand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get refillThreshold => $composableBuilder(
    column: $table.refillThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get initialQuantity => $composableBuilder(
    column: $table.initialQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastRefillAt => $composableBuilder(
    column: $table.lastRefillAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoriesTable> {
  $$InventoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantityOnHand => $composableBuilder(
    column: $table.quantityOnHand,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get refillThreshold => $composableBuilder(
    column: $table.refillThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<double> get initialQuantity => $composableBuilder(
    column: $table.initialQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastRefillAt => $composableBuilder(
    column: $table.lastRefillAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoriesTable,
          InventoryRow,
          $$InventoriesTableFilterComposer,
          $$InventoriesTableOrderingComposer,
          $$InventoriesTableAnnotationComposer,
          $$InventoriesTableCreateCompanionBuilder,
          $$InventoriesTableUpdateCompanionBuilder,
          (InventoryRow, $$InventoriesTableReferences),
          InventoryRow,
          PrefetchHooks Function({bool medicationId})
        > {
  $$InventoriesTableTableManager(_$AppDatabase db, $InventoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$InventoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$InventoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$InventoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<double> quantityOnHand = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> refillThreshold = const Value.absent(),
                Value<double> initialQuantity = const Value.absent(),
                Value<DateTime?> lastRefillAt = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoriesCompanion(
                id: id,
                medicationId: medicationId,
                quantityOnHand: quantityOnHand,
                unit: unit,
                refillThreshold: refillThreshold,
                initialQuantity: initialQuantity,
                lastRefillAt: lastRefillAt,
                expiryDate: expiryDate,
                notes: notes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required double quantityOnHand,
                required String unit,
                required double refillThreshold,
                required double initialQuantity,
                Value<DateTime?> lastRefillAt = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InventoriesCompanion.insert(
                id: id,
                medicationId: medicationId,
                quantityOnHand: quantityOnHand,
                unit: unit,
                refillThreshold: refillThreshold,
                initialQuantity: initialQuantity,
                lastRefillAt: lastRefillAt,
                expiryDate: expiryDate,
                notes: notes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$InventoriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (medicationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable: $$InventoriesTableReferences
                                ._medicationIdTable(db),
                            referencedColumn:
                                $$InventoriesTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InventoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoriesTable,
      InventoryRow,
      $$InventoriesTableFilterComposer,
      $$InventoriesTableOrderingComposer,
      $$InventoriesTableAnnotationComposer,
      $$InventoriesTableCreateCompanionBuilder,
      $$InventoriesTableUpdateCompanionBuilder,
      (InventoryRow, $$InventoriesTableReferences),
      InventoryRow,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$InventoryTransactionsTableCreateCompanionBuilder =
    InventoryTransactionsCompanion Function({
      required String id,
      required String medicationId,
      required String type,
      required double quantityDelta,
      required double quantityAfter,
      required String unit,
      required DateTime createdAt,
      Value<String?> doseLogId,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$InventoryTransactionsTableUpdateCompanionBuilder =
    InventoryTransactionsCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<String> type,
      Value<double> quantityDelta,
      Value<double> quantityAfter,
      Value<String> unit,
      Value<DateTime> createdAt,
      Value<String?> doseLogId,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$InventoryTransactionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InventoryTransactionsTable,
          InventoryTransactionRow
        > {
  $$InventoryTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(
          db.inventoryTransactions.medicationId,
          db.medications.id,
        ),
      );

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InventoryTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryTransactionsTable> {
  $$InventoryTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityDelta => $composableBuilder(
    column: $table.quantityDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityAfter => $composableBuilder(
    column: $table.quantityAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doseLogId => $composableBuilder(
    column: $table.doseLogId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryTransactionsTable> {
  $$InventoryTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityDelta => $composableBuilder(
    column: $table.quantityDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityAfter => $composableBuilder(
    column: $table.quantityAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doseLogId => $composableBuilder(
    column: $table.doseLogId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryTransactionsTable> {
  $$InventoryTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get quantityDelta => $composableBuilder(
    column: $table.quantityDelta,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantityAfter => $composableBuilder(
    column: $table.quantityAfter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get doseLogId =>
      $composableBuilder(column: $table.doseLogId, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryTransactionsTable,
          InventoryTransactionRow,
          $$InventoryTransactionsTableFilterComposer,
          $$InventoryTransactionsTableOrderingComposer,
          $$InventoryTransactionsTableAnnotationComposer,
          $$InventoryTransactionsTableCreateCompanionBuilder,
          $$InventoryTransactionsTableUpdateCompanionBuilder,
          (InventoryTransactionRow, $$InventoryTransactionsTableReferences),
          InventoryTransactionRow,
          PrefetchHooks Function({bool medicationId})
        > {
  $$InventoryTransactionsTableTableManager(
    _$AppDatabase db,
    $InventoryTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$InventoryTransactionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$InventoryTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$InventoryTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> quantityDelta = const Value.absent(),
                Value<double> quantityAfter = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> doseLogId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryTransactionsCompanion(
                id: id,
                medicationId: medicationId,
                type: type,
                quantityDelta: quantityDelta,
                quantityAfter: quantityAfter,
                unit: unit,
                createdAt: createdAt,
                doseLogId: doseLogId,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required String type,
                required double quantityDelta,
                required double quantityAfter,
                required String unit,
                required DateTime createdAt,
                Value<String?> doseLogId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryTransactionsCompanion.insert(
                id: id,
                medicationId: medicationId,
                type: type,
                quantityDelta: quantityDelta,
                quantityAfter: quantityAfter,
                unit: unit,
                createdAt: createdAt,
                doseLogId: doseLogId,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$InventoryTransactionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (medicationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable:
                                $$InventoryTransactionsTableReferences
                                    ._medicationIdTable(db),
                            referencedColumn:
                                $$InventoryTransactionsTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InventoryTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryTransactionsTable,
      InventoryTransactionRow,
      $$InventoryTransactionsTableFilterComposer,
      $$InventoryTransactionsTableOrderingComposer,
      $$InventoryTransactionsTableAnnotationComposer,
      $$InventoryTransactionsTableCreateCompanionBuilder,
      $$InventoryTransactionsTableUpdateCompanionBuilder,
      (InventoryTransactionRow, $$InventoryTransactionsTableReferences),
      InventoryTransactionRow,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$NotificationPreferencesTableCreateCompanionBuilder =
    NotificationPreferencesCompanion Function({
      required String id,
      Value<String?> medicationId,
      required bool remindersEnabled,
      Value<int?> preReminderMinutes,
      required bool missedFollowUpEnabled,
      required int missedFollowUpMinutes,
      required bool soundEnabled,
      required bool vibrationEnabled,
      required String privacy,
      required bool lowStockAlertEnabled,
      required bool runOutAlertEnabled,
      required bool refillAlertEnabled,
      Value<int> rowid,
    });
typedef $$NotificationPreferencesTableUpdateCompanionBuilder =
    NotificationPreferencesCompanion Function({
      Value<String> id,
      Value<String?> medicationId,
      Value<bool> remindersEnabled,
      Value<int?> preReminderMinutes,
      Value<bool> missedFollowUpEnabled,
      Value<int> missedFollowUpMinutes,
      Value<bool> soundEnabled,
      Value<bool> vibrationEnabled,
      Value<String> privacy,
      Value<bool> lowStockAlertEnabled,
      Value<bool> runOutAlertEnabled,
      Value<bool> refillAlertEnabled,
      Value<int> rowid,
    });

final class $$NotificationPreferencesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $NotificationPreferencesTable,
          NotificationPreferenceRow
        > {
  $$NotificationPreferencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(
          db.notificationPreferences.medicationId,
          db.medications.id,
        ),
      );

  $$MedicationsTableProcessedTableManager? get medicationId {
    final $_column = $_itemColumn<String>('medication_id');
    if ($_column == null) return null;
    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NotificationPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationPreferencesTable> {
  $$NotificationPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preReminderMinutes => $composableBuilder(
    column: $table.preReminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get missedFollowUpEnabled => $composableBuilder(
    column: $table.missedFollowUpEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get missedFollowUpMinutes => $composableBuilder(
    column: $table.missedFollowUpMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get privacy => $composableBuilder(
    column: $table.privacy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get lowStockAlertEnabled => $composableBuilder(
    column: $table.lowStockAlertEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get runOutAlertEnabled => $composableBuilder(
    column: $table.runOutAlertEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get refillAlertEnabled => $composableBuilder(
    column: $table.refillAlertEnabled,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotificationPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationPreferencesTable> {
  $$NotificationPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preReminderMinutes => $composableBuilder(
    column: $table.preReminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get missedFollowUpEnabled => $composableBuilder(
    column: $table.missedFollowUpEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get missedFollowUpMinutes => $composableBuilder(
    column: $table.missedFollowUpMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get privacy => $composableBuilder(
    column: $table.privacy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get lowStockAlertEnabled => $composableBuilder(
    column: $table.lowStockAlertEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get runOutAlertEnabled => $composableBuilder(
    column: $table.runOutAlertEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get refillAlertEnabled => $composableBuilder(
    column: $table.refillAlertEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotificationPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationPreferencesTable> {
  $$NotificationPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preReminderMinutes => $composableBuilder(
    column: $table.preReminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get missedFollowUpEnabled => $composableBuilder(
    column: $table.missedFollowUpEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get missedFollowUpMinutes => $composableBuilder(
    column: $table.missedFollowUpMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get privacy =>
      $composableBuilder(column: $table.privacy, builder: (column) => column);

  GeneratedColumn<bool> get lowStockAlertEnabled => $composableBuilder(
    column: $table.lowStockAlertEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get runOutAlertEnabled => $composableBuilder(
    column: $table.runOutAlertEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get refillAlertEnabled => $composableBuilder(
    column: $table.refillAlertEnabled,
    builder: (column) => column,
  );

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotificationPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationPreferencesTable,
          NotificationPreferenceRow,
          $$NotificationPreferencesTableFilterComposer,
          $$NotificationPreferencesTableOrderingComposer,
          $$NotificationPreferencesTableAnnotationComposer,
          $$NotificationPreferencesTableCreateCompanionBuilder,
          $$NotificationPreferencesTableUpdateCompanionBuilder,
          (NotificationPreferenceRow, $$NotificationPreferencesTableReferences),
          NotificationPreferenceRow,
          PrefetchHooks Function({bool medicationId})
        > {
  $$NotificationPreferencesTableTableManager(
    _$AppDatabase db,
    $NotificationPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$NotificationPreferencesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$NotificationPreferencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$NotificationPreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> medicationId = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<int?> preReminderMinutes = const Value.absent(),
                Value<bool> missedFollowUpEnabled = const Value.absent(),
                Value<int> missedFollowUpMinutes = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> vibrationEnabled = const Value.absent(),
                Value<String> privacy = const Value.absent(),
                Value<bool> lowStockAlertEnabled = const Value.absent(),
                Value<bool> runOutAlertEnabled = const Value.absent(),
                Value<bool> refillAlertEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationPreferencesCompanion(
                id: id,
                medicationId: medicationId,
                remindersEnabled: remindersEnabled,
                preReminderMinutes: preReminderMinutes,
                missedFollowUpEnabled: missedFollowUpEnabled,
                missedFollowUpMinutes: missedFollowUpMinutes,
                soundEnabled: soundEnabled,
                vibrationEnabled: vibrationEnabled,
                privacy: privacy,
                lowStockAlertEnabled: lowStockAlertEnabled,
                runOutAlertEnabled: runOutAlertEnabled,
                refillAlertEnabled: refillAlertEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> medicationId = const Value.absent(),
                required bool remindersEnabled,
                Value<int?> preReminderMinutes = const Value.absent(),
                required bool missedFollowUpEnabled,
                required int missedFollowUpMinutes,
                required bool soundEnabled,
                required bool vibrationEnabled,
                required String privacy,
                required bool lowStockAlertEnabled,
                required bool runOutAlertEnabled,
                required bool refillAlertEnabled,
                Value<int> rowid = const Value.absent(),
              }) => NotificationPreferencesCompanion.insert(
                id: id,
                medicationId: medicationId,
                remindersEnabled: remindersEnabled,
                preReminderMinutes: preReminderMinutes,
                missedFollowUpEnabled: missedFollowUpEnabled,
                missedFollowUpMinutes: missedFollowUpMinutes,
                soundEnabled: soundEnabled,
                vibrationEnabled: vibrationEnabled,
                privacy: privacy,
                lowStockAlertEnabled: lowStockAlertEnabled,
                runOutAlertEnabled: runOutAlertEnabled,
                refillAlertEnabled: refillAlertEnabled,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$NotificationPreferencesTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (medicationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable:
                                $$NotificationPreferencesTableReferences
                                    ._medicationIdTable(db),
                            referencedColumn:
                                $$NotificationPreferencesTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NotificationPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationPreferencesTable,
      NotificationPreferenceRow,
      $$NotificationPreferencesTableFilterComposer,
      $$NotificationPreferencesTableOrderingComposer,
      $$NotificationPreferencesTableAnnotationComposer,
      $$NotificationPreferencesTableCreateCompanionBuilder,
      $$NotificationPreferencesTableUpdateCompanionBuilder,
      (NotificationPreferenceRow, $$NotificationPreferencesTableReferences),
      NotificationPreferenceRow,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$RefillRemindersTableCreateCompanionBuilder =
    RefillRemindersCompanion Function({
      required String id,
      required String medicationId,
      required double threshold,
      required bool enabled,
      Value<DateTime?> lastNotifiedAt,
      required int leadDays,
      Value<int> rowid,
    });
typedef $$RefillRemindersTableUpdateCompanionBuilder =
    RefillRemindersCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<double> threshold,
      Value<bool> enabled,
      Value<DateTime?> lastNotifiedAt,
      Value<int> leadDays,
      Value<int> rowid,
    });

final class $$RefillRemindersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RefillRemindersTable,
          RefillReminderRow
        > {
  $$RefillRemindersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(
          db.refillReminders.medicationId,
          db.medications.id,
        ),
      );

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RefillRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RefillRemindersTable> {
  $$RefillRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leadDays => $composableBuilder(
    column: $table.leadDays,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefillRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RefillRemindersTable> {
  $$RefillRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leadDays => $composableBuilder(
    column: $table.leadDays,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefillRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RefillRemindersTable> {
  $$RefillRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get threshold =>
      $composableBuilder(column: $table.threshold, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leadDays =>
      $composableBuilder(column: $table.leadDays, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefillRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RefillRemindersTable,
          RefillReminderRow,
          $$RefillRemindersTableFilterComposer,
          $$RefillRemindersTableOrderingComposer,
          $$RefillRemindersTableAnnotationComposer,
          $$RefillRemindersTableCreateCompanionBuilder,
          $$RefillRemindersTableUpdateCompanionBuilder,
          (RefillReminderRow, $$RefillRemindersTableReferences),
          RefillReminderRow,
          PrefetchHooks Function({bool medicationId})
        > {
  $$RefillRemindersTableTableManager(
    _$AppDatabase db,
    $RefillRemindersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$RefillRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RefillRemindersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$RefillRemindersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<double> threshold = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime?> lastNotifiedAt = const Value.absent(),
                Value<int> leadDays = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RefillRemindersCompanion(
                id: id,
                medicationId: medicationId,
                threshold: threshold,
                enabled: enabled,
                lastNotifiedAt: lastNotifiedAt,
                leadDays: leadDays,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required double threshold,
                required bool enabled,
                Value<DateTime?> lastNotifiedAt = const Value.absent(),
                required int leadDays,
                Value<int> rowid = const Value.absent(),
              }) => RefillRemindersCompanion.insert(
                id: id,
                medicationId: medicationId,
                threshold: threshold,
                enabled: enabled,
                lastNotifiedAt: lastNotifiedAt,
                leadDays: leadDays,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$RefillRemindersTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (medicationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable: $$RefillRemindersTableReferences
                                ._medicationIdTable(db),
                            referencedColumn:
                                $$RefillRemindersTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RefillRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RefillRemindersTable,
      RefillReminderRow,
      $$RefillRemindersTableFilterComposer,
      $$RefillRemindersTableOrderingComposer,
      $$RefillRemindersTableAnnotationComposer,
      $$RefillRemindersTableCreateCompanionBuilder,
      $$RefillRemindersTableUpdateCompanionBuilder,
      (RefillReminderRow, $$RefillRemindersTableReferences),
      RefillReminderRow,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$MedicineInformationCacheTableCreateCompanionBuilder =
    MedicineInformationCacheCompanion Function({
      required String medicationId,
      required String sourceName,
      required String sourceUrl,
      required DateTime lastUpdated,
      Value<String?> genericName,
      required String brandNames,
      required String activeIngredients,
      required String indications,
      required String warnings,
      required String contraindications,
      required String sideEffects,
      Value<String?> storage,
      Value<String?> dosageForm,
      required String strengths,
      required String foodInteractions,
      required String patientAdvice,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$MedicineInformationCacheTableUpdateCompanionBuilder =
    MedicineInformationCacheCompanion Function({
      Value<String> medicationId,
      Value<String> sourceName,
      Value<String> sourceUrl,
      Value<DateTime> lastUpdated,
      Value<String?> genericName,
      Value<String> brandNames,
      Value<String> activeIngredients,
      Value<String> indications,
      Value<String> warnings,
      Value<String> contraindications,
      Value<String> sideEffects,
      Value<String?> storage,
      Value<String?> dosageForm,
      Value<String> strengths,
      Value<String> foodInteractions,
      Value<String> patientAdvice,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$MedicineInformationCacheTableFilterComposer
    extends Composer<_$AppDatabase, $MedicineInformationCacheTable> {
  $$MedicineInformationCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandNames => $composableBuilder(
    column: $table.brandNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeIngredients => $composableBuilder(
    column: $table.activeIngredients,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get indications => $composableBuilder(
    column: $table.indications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get warnings => $composableBuilder(
    column: $table.warnings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contraindications => $composableBuilder(
    column: $table.contraindications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sideEffects => $composableBuilder(
    column: $table.sideEffects,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storage => $composableBuilder(
    column: $table.storage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strengths => $composableBuilder(
    column: $table.strengths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodInteractions => $composableBuilder(
    column: $table.foodInteractions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientAdvice => $composableBuilder(
    column: $table.patientAdvice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicineInformationCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicineInformationCacheTable> {
  $$MedicineInformationCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandNames => $composableBuilder(
    column: $table.brandNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeIngredients => $composableBuilder(
    column: $table.activeIngredients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get indications => $composableBuilder(
    column: $table.indications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get warnings => $composableBuilder(
    column: $table.warnings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contraindications => $composableBuilder(
    column: $table.contraindications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sideEffects => $composableBuilder(
    column: $table.sideEffects,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storage => $composableBuilder(
    column: $table.storage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strengths => $composableBuilder(
    column: $table.strengths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodInteractions => $composableBuilder(
    column: $table.foodInteractions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientAdvice => $composableBuilder(
    column: $table.patientAdvice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicineInformationCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicineInformationCacheTable> {
  $$MedicineInformationCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brandNames => $composableBuilder(
    column: $table.brandNames,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeIngredients => $composableBuilder(
    column: $table.activeIngredients,
    builder: (column) => column,
  );

  GeneratedColumn<String> get indications => $composableBuilder(
    column: $table.indications,
    builder: (column) => column,
  );

  GeneratedColumn<String> get warnings =>
      $composableBuilder(column: $table.warnings, builder: (column) => column);

  GeneratedColumn<String> get contraindications => $composableBuilder(
    column: $table.contraindications,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sideEffects => $composableBuilder(
    column: $table.sideEffects,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storage =>
      $composableBuilder(column: $table.storage, builder: (column) => column);

  GeneratedColumn<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get strengths =>
      $composableBuilder(column: $table.strengths, builder: (column) => column);

  GeneratedColumn<String> get foodInteractions => $composableBuilder(
    column: $table.foodInteractions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get patientAdvice => $composableBuilder(
    column: $table.patientAdvice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$MedicineInformationCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicineInformationCacheTable,
          MedicineInformationRow,
          $$MedicineInformationCacheTableFilterComposer,
          $$MedicineInformationCacheTableOrderingComposer,
          $$MedicineInformationCacheTableAnnotationComposer,
          $$MedicineInformationCacheTableCreateCompanionBuilder,
          $$MedicineInformationCacheTableUpdateCompanionBuilder,
          (
            MedicineInformationRow,
            BaseReferences<
              _$AppDatabase,
              $MedicineInformationCacheTable,
              MedicineInformationRow
            >,
          ),
          MedicineInformationRow,
          PrefetchHooks Function()
        > {
  $$MedicineInformationCacheTableTableManager(
    _$AppDatabase db,
    $MedicineInformationCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MedicineInformationCacheTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$MedicineInformationCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$MedicineInformationCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> medicationId = const Value.absent(),
                Value<String> sourceName = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<String?> genericName = const Value.absent(),
                Value<String> brandNames = const Value.absent(),
                Value<String> activeIngredients = const Value.absent(),
                Value<String> indications = const Value.absent(),
                Value<String> warnings = const Value.absent(),
                Value<String> contraindications = const Value.absent(),
                Value<String> sideEffects = const Value.absent(),
                Value<String?> storage = const Value.absent(),
                Value<String?> dosageForm = const Value.absent(),
                Value<String> strengths = const Value.absent(),
                Value<String> foodInteractions = const Value.absent(),
                Value<String> patientAdvice = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicineInformationCacheCompanion(
                medicationId: medicationId,
                sourceName: sourceName,
                sourceUrl: sourceUrl,
                lastUpdated: lastUpdated,
                genericName: genericName,
                brandNames: brandNames,
                activeIngredients: activeIngredients,
                indications: indications,
                warnings: warnings,
                contraindications: contraindications,
                sideEffects: sideEffects,
                storage: storage,
                dosageForm: dosageForm,
                strengths: strengths,
                foodInteractions: foodInteractions,
                patientAdvice: patientAdvice,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String medicationId,
                required String sourceName,
                required String sourceUrl,
                required DateTime lastUpdated,
                Value<String?> genericName = const Value.absent(),
                required String brandNames,
                required String activeIngredients,
                required String indications,
                required String warnings,
                required String contraindications,
                required String sideEffects,
                Value<String?> storage = const Value.absent(),
                Value<String?> dosageForm = const Value.absent(),
                required String strengths,
                required String foodInteractions,
                required String patientAdvice,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => MedicineInformationCacheCompanion.insert(
                medicationId: medicationId,
                sourceName: sourceName,
                sourceUrl: sourceUrl,
                lastUpdated: lastUpdated,
                genericName: genericName,
                brandNames: brandNames,
                activeIngredients: activeIngredients,
                indications: indications,
                warnings: warnings,
                contraindications: contraindications,
                sideEffects: sideEffects,
                storage: storage,
                dosageForm: dosageForm,
                strengths: strengths,
                foodInteractions: foodInteractions,
                patientAdvice: patientAdvice,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicineInformationCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicineInformationCacheTable,
      MedicineInformationRow,
      $$MedicineInformationCacheTableFilterComposer,
      $$MedicineInformationCacheTableOrderingComposer,
      $$MedicineInformationCacheTableAnnotationComposer,
      $$MedicineInformationCacheTableCreateCompanionBuilder,
      $$MedicineInformationCacheTableUpdateCompanionBuilder,
      (
        MedicineInformationRow,
        BaseReferences<
          _$AppDatabase,
          $MedicineInformationCacheTable,
          MedicineInformationRow
        >,
      ),
      MedicineInformationRow,
      PrefetchHooks Function()
    >;
typedef $$AllergyRecordsTableCreateCompanionBuilder =
    AllergyRecordsCompanion Function({
      required String id,
      required String substance,
      Value<String?> reaction,
      required String severity,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AllergyRecordsTableUpdateCompanionBuilder =
    AllergyRecordsCompanion Function({
      Value<String> id,
      Value<String> substance,
      Value<String?> reaction,
      Value<String> severity,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AllergyRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AllergyRecordsTable> {
  $$AllergyRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get substance => $composableBuilder(
    column: $table.substance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AllergyRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AllergyRecordsTable> {
  $$AllergyRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get substance => $composableBuilder(
    column: $table.substance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AllergyRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllergyRecordsTable> {
  $$AllergyRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get substance =>
      $composableBuilder(column: $table.substance, builder: (column) => column);

  GeneratedColumn<String> get reaction =>
      $composableBuilder(column: $table.reaction, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AllergyRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AllergyRecordsTable,
          AllergyRecordRow,
          $$AllergyRecordsTableFilterComposer,
          $$AllergyRecordsTableOrderingComposer,
          $$AllergyRecordsTableAnnotationComposer,
          $$AllergyRecordsTableCreateCompanionBuilder,
          $$AllergyRecordsTableUpdateCompanionBuilder,
          (
            AllergyRecordRow,
            BaseReferences<
              _$AppDatabase,
              $AllergyRecordsTable,
              AllergyRecordRow
            >,
          ),
          AllergyRecordRow,
          PrefetchHooks Function()
        > {
  $$AllergyRecordsTableTableManager(
    _$AppDatabase db,
    $AllergyRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AllergyRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$AllergyRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AllergyRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> substance = const Value.absent(),
                Value<String?> reaction = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllergyRecordsCompanion(
                id: id,
                substance: substance,
                reaction: reaction,
                severity: severity,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String substance,
                Value<String?> reaction = const Value.absent(),
                required String severity,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AllergyRecordsCompanion.insert(
                id: id,
                substance: substance,
                reaction: reaction,
                severity: severity,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AllergyRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AllergyRecordsTable,
      AllergyRecordRow,
      $$AllergyRecordsTableFilterComposer,
      $$AllergyRecordsTableOrderingComposer,
      $$AllergyRecordsTableAnnotationComposer,
      $$AllergyRecordsTableCreateCompanionBuilder,
      $$AllergyRecordsTableUpdateCompanionBuilder,
      (
        AllergyRecordRow,
        BaseReferences<_$AppDatabase, $AllergyRecordsTable, AllergyRecordRow>,
      ),
      AllergyRecordRow,
      PrefetchHooks Function()
    >;
typedef $$InteractionAlertsTableCreateCompanionBuilder =
    InteractionAlertsCompanion Function({
      required String id,
      required String medicationIds,
      required String severity,
      required String description,
      required String sourceName,
      Value<String?> sourceUrl,
      required DateTime detectedAt,
      Value<int> rowid,
    });
typedef $$InteractionAlertsTableUpdateCompanionBuilder =
    InteractionAlertsCompanion Function({
      Value<String> id,
      Value<String> medicationIds,
      Value<String> severity,
      Value<String> description,
      Value<String> sourceName,
      Value<String?> sourceUrl,
      Value<DateTime> detectedAt,
      Value<int> rowid,
    });

class $$InteractionAlertsTableFilterComposer
    extends Composer<_$AppDatabase, $InteractionAlertsTable> {
  $$InteractionAlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicationIds => $composableBuilder(
    column: $table.medicationIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InteractionAlertsTableOrderingComposer
    extends Composer<_$AppDatabase, $InteractionAlertsTable> {
  $$InteractionAlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicationIds => $composableBuilder(
    column: $table.medicationIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InteractionAlertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InteractionAlertsTable> {
  $$InteractionAlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medicationIds => $composableBuilder(
    column: $table.medicationIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => column,
  );
}

class $$InteractionAlertsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InteractionAlertsTable,
          InteractionAlertRow,
          $$InteractionAlertsTableFilterComposer,
          $$InteractionAlertsTableOrderingComposer,
          $$InteractionAlertsTableAnnotationComposer,
          $$InteractionAlertsTableCreateCompanionBuilder,
          $$InteractionAlertsTableUpdateCompanionBuilder,
          (
            InteractionAlertRow,
            BaseReferences<
              _$AppDatabase,
              $InteractionAlertsTable,
              InteractionAlertRow
            >,
          ),
          InteractionAlertRow,
          PrefetchHooks Function()
        > {
  $$InteractionAlertsTableTableManager(
    _$AppDatabase db,
    $InteractionAlertsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$InteractionAlertsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$InteractionAlertsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$InteractionAlertsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationIds = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> sourceName = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<DateTime> detectedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InteractionAlertsCompanion(
                id: id,
                medicationIds: medicationIds,
                severity: severity,
                description: description,
                sourceName: sourceName,
                sourceUrl: sourceUrl,
                detectedAt: detectedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationIds,
                required String severity,
                required String description,
                required String sourceName,
                Value<String?> sourceUrl = const Value.absent(),
                required DateTime detectedAt,
                Value<int> rowid = const Value.absent(),
              }) => InteractionAlertsCompanion.insert(
                id: id,
                medicationIds: medicationIds,
                severity: severity,
                description: description,
                sourceName: sourceName,
                sourceUrl: sourceUrl,
                detectedAt: detectedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InteractionAlertsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InteractionAlertsTable,
      InteractionAlertRow,
      $$InteractionAlertsTableFilterComposer,
      $$InteractionAlertsTableOrderingComposer,
      $$InteractionAlertsTableAnnotationComposer,
      $$InteractionAlertsTableCreateCompanionBuilder,
      $$InteractionAlertsTableUpdateCompanionBuilder,
      (
        InteractionAlertRow,
        BaseReferences<
          _$AppDatabase,
          $InteractionAlertsTable,
          InteractionAlertRow
        >,
      ),
      InteractionAlertRow,
      PrefetchHooks Function()
    >;
typedef $$PrescriptionAttachmentsTableCreateCompanionBuilder =
    PrescriptionAttachmentsCompanion Function({
      required String id,
      required String medicationId,
      required String filePath,
      required String type,
      Value<String?> caption,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PrescriptionAttachmentsTableUpdateCompanionBuilder =
    PrescriptionAttachmentsCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<String> filePath,
      Value<String> type,
      Value<String?> caption,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PrescriptionAttachmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PrescriptionAttachmentsTable,
          PrescriptionAttachmentRow
        > {
  $$PrescriptionAttachmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(
          db.prescriptionAttachments.medicationId,
          db.medications.id,
        ),
      );

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PrescriptionAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $PrescriptionAttachmentsTable> {
  $$PrescriptionAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrescriptionAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrescriptionAttachmentsTable> {
  $$PrescriptionAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrescriptionAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrescriptionAttachmentsTable> {
  $$PrescriptionAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrescriptionAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrescriptionAttachmentsTable,
          PrescriptionAttachmentRow,
          $$PrescriptionAttachmentsTableFilterComposer,
          $$PrescriptionAttachmentsTableOrderingComposer,
          $$PrescriptionAttachmentsTableAnnotationComposer,
          $$PrescriptionAttachmentsTableCreateCompanionBuilder,
          $$PrescriptionAttachmentsTableUpdateCompanionBuilder,
          (PrescriptionAttachmentRow, $$PrescriptionAttachmentsTableReferences),
          PrescriptionAttachmentRow,
          PrefetchHooks Function({bool medicationId})
        > {
  $$PrescriptionAttachmentsTableTableManager(
    _$AppDatabase db,
    $PrescriptionAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PrescriptionAttachmentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$PrescriptionAttachmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$PrescriptionAttachmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrescriptionAttachmentsCompanion(
                id: id,
                medicationId: medicationId,
                filePath: filePath,
                type: type,
                caption: caption,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required String filePath,
                required String type,
                Value<String?> caption = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PrescriptionAttachmentsCompanion.insert(
                id: id,
                medicationId: medicationId,
                filePath: filePath,
                type: type,
                caption: caption,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PrescriptionAttachmentsTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (medicationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable:
                                $$PrescriptionAttachmentsTableReferences
                                    ._medicationIdTable(db),
                            referencedColumn:
                                $$PrescriptionAttachmentsTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PrescriptionAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrescriptionAttachmentsTable,
      PrescriptionAttachmentRow,
      $$PrescriptionAttachmentsTableFilterComposer,
      $$PrescriptionAttachmentsTableOrderingComposer,
      $$PrescriptionAttachmentsTableAnnotationComposer,
      $$PrescriptionAttachmentsTableCreateCompanionBuilder,
      $$PrescriptionAttachmentsTableUpdateCompanionBuilder,
      (PrescriptionAttachmentRow, $$PrescriptionAttachmentsTableReferences),
      PrescriptionAttachmentRow,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$CaregiverAccessTableCreateCompanionBuilder =
    CaregiverAccessCompanion Function({
      required String id,
      required String medicationId,
      required String caregiverName,
      Value<String?> contact,
      required bool canEdit,
      required DateTime grantedAt,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });
typedef $$CaregiverAccessTableUpdateCompanionBuilder =
    CaregiverAccessCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<String> caregiverName,
      Value<String?> contact,
      Value<bool> canEdit,
      Value<DateTime> grantedAt,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });

final class $$CaregiverAccessTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CaregiverAccessTable,
          CaregiverAccessRow
        > {
  $$CaregiverAccessTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(
          db.caregiverAccess.medicationId,
          db.medications.id,
        ),
      );

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CaregiverAccessTableFilterComposer
    extends Composer<_$AppDatabase, $CaregiverAccessTable> {
  $$CaregiverAccessTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caregiverName => $composableBuilder(
    column: $table.caregiverName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get canEdit => $composableBuilder(
    column: $table.canEdit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get grantedAt => $composableBuilder(
    column: $table.grantedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CaregiverAccessTableOrderingComposer
    extends Composer<_$AppDatabase, $CaregiverAccessTable> {
  $$CaregiverAccessTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caregiverName => $composableBuilder(
    column: $table.caregiverName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get canEdit => $composableBuilder(
    column: $table.canEdit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get grantedAt => $composableBuilder(
    column: $table.grantedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CaregiverAccessTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaregiverAccessTable> {
  $$CaregiverAccessTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get caregiverName => $composableBuilder(
    column: $table.caregiverName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<bool> get canEdit =>
      $composableBuilder(column: $table.canEdit, builder: (column) => column);

  GeneratedColumn<DateTime> get grantedAt =>
      $composableBuilder(column: $table.grantedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CaregiverAccessTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CaregiverAccessTable,
          CaregiverAccessRow,
          $$CaregiverAccessTableFilterComposer,
          $$CaregiverAccessTableOrderingComposer,
          $$CaregiverAccessTableAnnotationComposer,
          $$CaregiverAccessTableCreateCompanionBuilder,
          $$CaregiverAccessTableUpdateCompanionBuilder,
          (CaregiverAccessRow, $$CaregiverAccessTableReferences),
          CaregiverAccessRow,
          PrefetchHooks Function({bool medicationId})
        > {
  $$CaregiverAccessTableTableManager(
    _$AppDatabase db,
    $CaregiverAccessTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$CaregiverAccessTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CaregiverAccessTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$CaregiverAccessTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<String> caregiverName = const Value.absent(),
                Value<String?> contact = const Value.absent(),
                Value<bool> canEdit = const Value.absent(),
                Value<DateTime> grantedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CaregiverAccessCompanion(
                id: id,
                medicationId: medicationId,
                caregiverName: caregiverName,
                contact: contact,
                canEdit: canEdit,
                grantedAt: grantedAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required String caregiverName,
                Value<String?> contact = const Value.absent(),
                required bool canEdit,
                required DateTime grantedAt,
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CaregiverAccessCompanion.insert(
                id: id,
                medicationId: medicationId,
                caregiverName: caregiverName,
                contact: contact,
                canEdit: canEdit,
                grantedAt: grantedAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CaregiverAccessTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (medicationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable: $$CaregiverAccessTableReferences
                                ._medicationIdTable(db),
                            referencedColumn:
                                $$CaregiverAccessTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CaregiverAccessTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CaregiverAccessTable,
      CaregiverAccessRow,
      $$CaregiverAccessTableFilterComposer,
      $$CaregiverAccessTableOrderingComposer,
      $$CaregiverAccessTableAnnotationComposer,
      $$CaregiverAccessTableCreateCompanionBuilder,
      $$CaregiverAccessTableUpdateCompanionBuilder,
      (CaregiverAccessRow, $$CaregiverAccessTableReferences),
      CaregiverAccessRow,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$NotificationSchedulesTableCreateCompanionBuilder =
    NotificationSchedulesCompanion Function({
      Value<int> notificationId,
      required String kind,
      Value<String?> medicationId,
      required DateTime scheduledAt,
      Value<String?> doseId,
      Value<String?> payload,
      required DateTime createdAt,
    });
typedef $$NotificationSchedulesTableUpdateCompanionBuilder =
    NotificationSchedulesCompanion Function({
      Value<int> notificationId,
      Value<String> kind,
      Value<String?> medicationId,
      Value<DateTime> scheduledAt,
      Value<String?> doseId,
      Value<String?> payload,
      Value<DateTime> createdAt,
    });

final class $$NotificationSchedulesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $NotificationSchedulesTable,
          NotificationScheduleRow
        > {
  $$NotificationSchedulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(
          db.notificationSchedules.medicationId,
          db.medications.id,
        ),
      );

  $$MedicationsTableProcessedTableManager? get medicationId {
    final $_column = $_itemColumn<String>('medication_id');
    if ($_column == null) return null;
    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NotificationSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationSchedulesTable> {
  $$NotificationSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doseId => $composableBuilder(
    column: $table.doseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotificationSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationSchedulesTable> {
  $$NotificationSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doseId => $composableBuilder(
    column: $table.doseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotificationSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationSchedulesTable> {
  $$NotificationSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doseId =>
      $composableBuilder(column: $table.doseId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotificationSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationSchedulesTable,
          NotificationScheduleRow,
          $$NotificationSchedulesTableFilterComposer,
          $$NotificationSchedulesTableOrderingComposer,
          $$NotificationSchedulesTableAnnotationComposer,
          $$NotificationSchedulesTableCreateCompanionBuilder,
          $$NotificationSchedulesTableUpdateCompanionBuilder,
          (NotificationScheduleRow, $$NotificationSchedulesTableReferences),
          NotificationScheduleRow,
          PrefetchHooks Function({bool medicationId})
        > {
  $$NotificationSchedulesTableTableManager(
    _$AppDatabase db,
    $NotificationSchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$NotificationSchedulesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$NotificationSchedulesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$NotificationSchedulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> notificationId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> medicationId = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<String?> doseId = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => NotificationSchedulesCompanion(
                notificationId: notificationId,
                kind: kind,
                medicationId: medicationId,
                scheduledAt: scheduledAt,
                doseId: doseId,
                payload: payload,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> notificationId = const Value.absent(),
                required String kind,
                Value<String?> medicationId = const Value.absent(),
                required DateTime scheduledAt,
                Value<String?> doseId = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                required DateTime createdAt,
              }) => NotificationSchedulesCompanion.insert(
                notificationId: notificationId,
                kind: kind,
                medicationId: medicationId,
                scheduledAt: scheduledAt,
                doseId: doseId,
                payload: payload,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$NotificationSchedulesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (medicationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable:
                                $$NotificationSchedulesTableReferences
                                    ._medicationIdTable(db),
                            referencedColumn:
                                $$NotificationSchedulesTableReferences
                                    ._medicationIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NotificationSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationSchedulesTable,
      NotificationScheduleRow,
      $$NotificationSchedulesTableFilterComposer,
      $$NotificationSchedulesTableOrderingComposer,
      $$NotificationSchedulesTableAnnotationComposer,
      $$NotificationSchedulesTableCreateCompanionBuilder,
      $$NotificationSchedulesTableUpdateCompanionBuilder,
      (NotificationScheduleRow, $$NotificationSchedulesTableReferences),
      NotificationScheduleRow,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$ScheduleAuditLogTableCreateCompanionBuilder =
    ScheduleAuditLogCompanion Function({
      required String id,
      required String kind,
      required String medicationId,
      required String summary,
      required String beforeJson,
      required DateTime createdAt,
      Value<bool> undone,
      Value<DateTime?> resumeOn,
      Value<bool> resumed,
      Value<int> rowid,
    });
typedef $$ScheduleAuditLogTableUpdateCompanionBuilder =
    ScheduleAuditLogCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<String> medicationId,
      Value<String> summary,
      Value<String> beforeJson,
      Value<DateTime> createdAt,
      Value<bool> undone,
      Value<DateTime?> resumeOn,
      Value<bool> resumed,
      Value<int> rowid,
    });

class $$ScheduleAuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleAuditLogTable> {
  $$ScheduleAuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get undone => $composableBuilder(
    column: $table.undone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resumeOn => $composableBuilder(
    column: $table.resumeOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get resumed => $composableBuilder(
    column: $table.resumed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScheduleAuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleAuditLogTable> {
  $$ScheduleAuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get undone => $composableBuilder(
    column: $table.undone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resumeOn => $composableBuilder(
    column: $table.resumeOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get resumed => $composableBuilder(
    column: $table.resumed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScheduleAuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleAuditLogTable> {
  $$ScheduleAuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get undone =>
      $composableBuilder(column: $table.undone, builder: (column) => column);

  GeneratedColumn<DateTime> get resumeOn =>
      $composableBuilder(column: $table.resumeOn, builder: (column) => column);

  GeneratedColumn<bool> get resumed =>
      $composableBuilder(column: $table.resumed, builder: (column) => column);
}

class $$ScheduleAuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduleAuditLogTable,
          ScheduleAuditRow,
          $$ScheduleAuditLogTableFilterComposer,
          $$ScheduleAuditLogTableOrderingComposer,
          $$ScheduleAuditLogTableAnnotationComposer,
          $$ScheduleAuditLogTableCreateCompanionBuilder,
          $$ScheduleAuditLogTableUpdateCompanionBuilder,
          (
            ScheduleAuditRow,
            BaseReferences<
              _$AppDatabase,
              $ScheduleAuditLogTable,
              ScheduleAuditRow
            >,
          ),
          ScheduleAuditRow,
          PrefetchHooks Function()
        > {
  $$ScheduleAuditLogTableTableManager(
    _$AppDatabase db,
    $ScheduleAuditLogTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$ScheduleAuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ScheduleAuditLogTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ScheduleAuditLogTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> beforeJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> undone = const Value.absent(),
                Value<DateTime?> resumeOn = const Value.absent(),
                Value<bool> resumed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleAuditLogCompanion(
                id: id,
                kind: kind,
                medicationId: medicationId,
                summary: summary,
                beforeJson: beforeJson,
                createdAt: createdAt,
                undone: undone,
                resumeOn: resumeOn,
                resumed: resumed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required String medicationId,
                required String summary,
                required String beforeJson,
                required DateTime createdAt,
                Value<bool> undone = const Value.absent(),
                Value<DateTime?> resumeOn = const Value.absent(),
                Value<bool> resumed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleAuditLogCompanion.insert(
                id: id,
                kind: kind,
                medicationId: medicationId,
                summary: summary,
                beforeJson: beforeJson,
                createdAt: createdAt,
                undone: undone,
                resumeOn: resumeOn,
                resumed: resumed,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScheduleAuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduleAuditLogTable,
      ScheduleAuditRow,
      $$ScheduleAuditLogTableFilterComposer,
      $$ScheduleAuditLogTableOrderingComposer,
      $$ScheduleAuditLogTableAnnotationComposer,
      $$ScheduleAuditLogTableCreateCompanionBuilder,
      $$ScheduleAuditLogTableUpdateCompanionBuilder,
      (
        ScheduleAuditRow,
        BaseReferences<_$AppDatabase, $ScheduleAuditLogTable, ScheduleAuditRow>,
      ),
      ScheduleAuditRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$SchedulePhasesTableTableManager get schedulePhases =>
      $$SchedulePhasesTableTableManager(_db, _db.schedulePhases);
  $$ScheduledDosesTableTableManager get scheduledDoses =>
      $$ScheduledDosesTableTableManager(_db, _db.scheduledDoses);
  $$DoseLogsTableTableManager get doseLogs =>
      $$DoseLogsTableTableManager(_db, _db.doseLogs);
  $$InventoriesTableTableManager get inventories =>
      $$InventoriesTableTableManager(_db, _db.inventories);
  $$InventoryTransactionsTableTableManager get inventoryTransactions =>
      $$InventoryTransactionsTableTableManager(_db, _db.inventoryTransactions);
  $$NotificationPreferencesTableTableManager get notificationPreferences =>
      $$NotificationPreferencesTableTableManager(
        _db,
        _db.notificationPreferences,
      );
  $$RefillRemindersTableTableManager get refillReminders =>
      $$RefillRemindersTableTableManager(_db, _db.refillReminders);
  $$MedicineInformationCacheTableTableManager get medicineInformationCache =>
      $$MedicineInformationCacheTableTableManager(
        _db,
        _db.medicineInformationCache,
      );
  $$AllergyRecordsTableTableManager get allergyRecords =>
      $$AllergyRecordsTableTableManager(_db, _db.allergyRecords);
  $$InteractionAlertsTableTableManager get interactionAlerts =>
      $$InteractionAlertsTableTableManager(_db, _db.interactionAlerts);
  $$PrescriptionAttachmentsTableTableManager get prescriptionAttachments =>
      $$PrescriptionAttachmentsTableTableManager(
        _db,
        _db.prescriptionAttachments,
      );
  $$CaregiverAccessTableTableManager get caregiverAccess =>
      $$CaregiverAccessTableTableManager(_db, _db.caregiverAccess);
  $$NotificationSchedulesTableTableManager get notificationSchedules =>
      $$NotificationSchedulesTableTableManager(_db, _db.notificationSchedules);
  $$ScheduleAuditLogTableTableManager get scheduleAuditLog =>
      $$ScheduleAuditLogTableTableManager(_db, _db.scheduleAuditLog);
}
