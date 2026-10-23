import 'notification_service.dart';

/// Bridges notification action taps to navigation.
///
/// The notification layer must not import the router (that would make the
/// service graph cyclic), so this holder is the single seam: `main` assigns
/// [onEvent] once the router exists, and the service provider reads the
/// holder.
class NotificationActionDispatcher {
  NotificationActionDispatcher();

  /// Invoked for every action the user taps on a notification.
  NotificationActionHandler? onEvent;

  /// Forwards [event] to the installed handler, if any.
  Future<void> dispatch(NotificationActionEvent event) async {
    final NotificationActionHandler? handler = onEvent;
    if (handler == null) return;
    await handler(event);
  }

  /// The value handed to [NotificationService.onAction].
  NotificationActionHandler get handler => dispatch;
}
