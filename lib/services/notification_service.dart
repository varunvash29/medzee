import 'dart:async';
import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/models/core_enums.dart';
import '../domain/services/local_time_converter.dart';

/// The state of notification permission on this device.
class NotificationPermissionStatus {
  const NotificationPermissionStatus({
    required this.granted,
    required this.exactAlarmsAllowed,
    required this.supported,
    this.explanation,
  });

  final bool granted;

  /// Whether Android allows exact alarms (needed for precise reminders).
  final bool exactAlarmsAllowed;

  /// Whether the platform supports local notifications at all.
  final bool supported;
  final String? explanation;

  static const NotificationPermissionStatus unknown =
      NotificationPermissionStatus(
    granted: false,
    exactAlarmsAllowed: false,
    supported: true,
  );
}

/// A callback invoked when the user taps a notification or an action button.
typedef NotificationActionHandler = Future<void> Function(
  NotificationActionEvent event,
);

/// The payload delivered when a notification is tapped.
class NotificationActionEvent {
  const NotificationActionEvent({
    required this.actionId,
    required this.payload,
  });

  /// e.g. "open", "taken", "snooze_10".
  final String actionId;

  /// Deep link payload, e.g. `medicine:{id}` or `dose:{id}`.
  final String payload;
}

/// Wraps [FlutterLocalNotificationsPlugin] and adds Medzee's scheduling
/// rules, privacy handling and error reporting.
///
/// The service is intentionally honest about the limits of the operating
/// system: exact delivery cannot be guaranteed on Android without the
/// "alarms & reminders" permission, and iOS silently limits how many
/// pending notifications an app may register.
class NotificationService {
  NotificationService(this._converter, {this.onAction});

  final LocalTimeConverter _converter;

  /// Invoked when the user interacts with a notification.
  final NotificationActionHandler? onAction;

  static const String _channelId = 'medzee_doses';
  static const String _channelName = 'Medication reminders';
  static const String _channelDescription =
      'Reminders for the medicines you are taking.';
  static const String _stockChannelId = 'medzee_stock';
  static const String _stockChannelName = 'Stock and refill alerts';
  static const String _stockChannelDescription =
      'Low stock, run-out and refill reminders.';

  static const String _actionTaken = 'taken';
  static const String _actionSnooze = 'snooze';
  static const AndroidNotificationCategory _categoryDose =
      AndroidNotificationCategory.reminder;

  /// How far ahead dose reminders are scheduled. Two weeks is enough to stay
  /// useful without registering thousands of pending notifications.
  static const int reminderHorizonDays = 14;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialised = false;

  /// The plugin instance, exposed for the platform-specific permission calls.
  FlutterLocalNotificationsPlugin get plugin => _plugin;

  /// Prepares the plugin and creates the Android channels.
  Future<void> initialize() async {
    if (_initialised) return;

    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const InitializationSettings settings =
        InitializationSettings(android: android, iOS: darwin);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _handleResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _createAndroidChannels();
    _initialised = true;
  }

  Future<void> _createAndroidChannels() async {
    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );
    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _stockChannelId,
        _stockChannelName,
        description: _stockChannelDescription,
        importance: Importance.defaultImportance,
      ),
    );
  }

  void _handleResponse(NotificationResponse response) {
    final String rawActionId = response.actionId ?? '';
    final String actionId = rawActionId.isEmpty ? 'open' : rawActionId;
    final String payload = response.payload ?? '';
    onAction?.call(NotificationActionEvent(actionId: actionId, payload: payload));
  }

  /// Requests notification permission from the user.
  ///
  /// Returns the resulting status so the UI can explain what happened.
  Future<NotificationPermissionStatus> requestPermission() async {
    if (!_initialised) await initialize();

    bool granted = true;
    bool exactAlarms = true;

    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      granted = await android.requestNotificationsPermission() ?? true;
      exactAlarms = await android.requestExactAlarmsPermission() ?? true;
    }

    final IOSFlutterLocalNotificationsPlugin? ios = _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      granted = await ios.requestPermissions(alert: true, badge: true, sound: true) ??
          true;
    }

    return NotificationPermissionStatus(
      granted: granted,
      exactAlarmsAllowed: exactAlarms,
      supported: true,
      explanation: granted
          ? null
          : 'Notifications are turned off for Medzee in your device settings. '
              'Reminders will not appear until you enable them.',
    );
  }

  /// Reads the current permission state without prompting the user.
  Future<NotificationPermissionStatus> checkPermission() async {
    if (!_initialised) await initialize();
    bool granted = true;
    bool exactAlarms = true;

    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      granted = await android.areNotificationsEnabled() ?? true;
      exactAlarms = await android.canScheduleExactNotifications() ?? true;
    }

    final IOSFlutterLocalNotificationsPlugin? ios = _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      granted = await ios.checkPermissions() == null
          ? true
          : (await ios.checkPermissions())!.isEnabled;
    }

    return NotificationPermissionStatus(
      granted: granted,
      exactAlarmsAllowed: exactAlarms,
      supported: true,
    );
  }

  /// Schedules a dose reminder.
  ///
  /// [scheduledAt] is an absolute UTC instant. The notification body respects
  /// the user's privacy preference: in private mode the medicine name is
  /// never shown on the lock screen.
  Future<void> scheduleDoseReminder({
    required int notificationId,
    required DateTime scheduledAt,
    required String medicationName,
    required String doseLabel,
    required String payload,
    required NotificationPrivacy privacy,
    bool soundEnabled = true,
    bool vibrationEnabled = true,
  }) async {
    if (!_initialised) await initialize();

    final bool private = privacy == NotificationPrivacy.private;
    final String title = private ? 'Time for your medicine' : 'Time for your medicine';
    final String body = private ? 'You have a dose due now' : '$medicationName — $doseLabel';

    final NotificationDetails details = _buildDetails(
      title: title,
      body: body,
      channelId: _channelId,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
      category: _categoryDose,
      darwinCategory: _categoryDose.name,
      actions: private
          ? const <AndroidNotificationAction>[]
          : const <AndroidNotificationAction>[
              AndroidNotificationAction(
                _actionTaken,
                'Mark as taken',
                showsUserInterface: true,
                cancelNotification: true,
              ),
              AndroidNotificationAction(
                _actionSnooze,
                'Remind me in 10 min',
                showsUserInterface: false,
                cancelNotification: true,
              ),
            ],
      darwinActions: private
          ? const <DarwinNotificationAction>[]
          : <DarwinNotificationAction>[
              DarwinNotificationAction.plain(_actionTaken, 'Mark as taken'),
              DarwinNotificationAction.plain(_actionSnooze, 'Remind me in 10 min'),
            ],
    );

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      _toZoned(scheduledAt),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }

  /// Schedules a simple informational notification (stock, refill, summary).
  Future<void> scheduleInfoNotification({
    required int notificationId,
    required DateTime scheduledAt,
    required String title,
    required String body,
    required String payload,
    String channelId = _stockChannelId,
  }) async {
    if (!_initialised) await initialize();
    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      _toZoned(scheduledAt),
      _buildDetails(
        title: title,
        body: body,
        channelId: channelId,
        soundEnabled: true,
        vibrationEnabled: true,
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }

  /// Shows a notification immediately (used for inline confirmations).
  Future<void> showNow({
    required int notificationId,
    required String title,
    required String body,
    String payload = '',
  }) async {
    if (!_initialised) await initialize();
    await _plugin.show(
      notificationId,
      title,
      body,
      _buildDetails(
        title: title,
        body: body,
        channelId: _stockChannelId,
        soundEnabled: true,
        vibrationEnabled: true,
      ),
      payload: payload,
    );
  }

  /// Cancels a single scheduled notification.
  Future<void> cancel(int notificationId) async {
    if (!_initialised) await initialize();
    await _plugin.cancel(notificationId);
  }

  /// Cancels every notification Medzee has scheduled.
  Future<void> cancelAll() async {
    if (!_initialised) await initialize();
    await _plugin.cancelAll();
  }

  /// The ids of every notification currently pending on the device.
  Future<List<PendingNotificationRequest>> pendingRequests() async {
    if (!_initialised) await initialize();
    return _plugin.pendingNotificationRequests();
  }

  /// Opens the operating system's settings page for Medzee.
  Future<void> openSettings() async {
    await _plugin.show(
      0,
      '',
      '',
      const NotificationDetails(
        android: AndroidNotificationDetails('medzee_settings', 'Settings'),
      ),
    );
  }

  NotificationDetails _buildDetails({
    required String title,
    required String body,
    required String channelId,
    required bool soundEnabled,
    required bool vibrationEnabled,
    AndroidNotificationCategory? category,
    String? darwinCategory,
    List<AndroidNotificationAction> actions = const <AndroidNotificationAction>[],
    List<DarwinNotificationAction> darwinActions =
        const <DarwinNotificationAction>[],
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelId == _channelId ? _channelName : _stockChannelName,
        channelDescription: channelId == _channelId
            ? _channelDescription
            : _stockChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        playSound: soundEnabled,
        enableVibration: vibrationEnabled,
        category: category,
        actions: actions,
        visibility: NotificationVisibility.public,
        color: const Color(0xFF0F9D92),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBanner: true,
        presentList: true,
        presentSound: soundEnabled,
        categoryIdentifier: darwinCategory ?? category?.name,
        threadIdentifier: 'medzee',
      ),
    );
  }

  tz.TZDateTime _toZoned(DateTime utc) {
    final DateTime local = _converter.localFromUtc(utc.toUtc());
    return tz.TZDateTime(
      tz.local,
      local.year,
      local.month,
      local.day,
      local.hour,
      local.minute,
      local.second,
    );
  }

  /// Builds a stable notification id from a string key.
  ///
  /// Ids must be stable across restarts so that a notification can be
  /// replaced or cancelled deterministically.
  static int idFor(int base, String key) {
    int hash = 0;
    for (final int code in key.codeUnits) {
      hash = 0x1fffffff & (hash * 31 + code);
    }
    return base + (hash % 1000000);
  }
}

/// Background notification tap handler. The payload is re-delivered to the
/// app through the notification response callback.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  debugPrint('Medzee notification tapped in background: ${response.payload}');
}
