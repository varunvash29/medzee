import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app.dart';
import '../services/firebase_service.dart';
import '../services/notification_action_dispatcher.dart';
import '../services/people/people_controller.dart';
import '../state/providers.dart';
import 'app_session.dart';
import 'other_people.dart';

/// Holds whoever's session is open and swaps it when the person changes.
///
/// A session is closed completely (its widgets, providers and database) before
/// the next one opens, so nothing a person sees or syncs can carry over to
/// someone else.
class MedzeeHost extends StatefulWidget {
  const MedzeeHost({
    super.key,
    required this.people,
    required this.firebase,
    required this.dispatcher,
  });

  final PeopleController people;
  final FirebaseGateway firebase;

  /// Shared by every session: notification taps and push messages are routed
  /// by whichever session is open.
  final NotificationActionDispatcher dispatcher;

  @override
  State<MedzeeHost> createState() => _MedzeeHostState();
}

class _MedzeeHostState extends State<MedzeeHost> {
  AppSession? _session;
  Object? _failure;
  bool _pushStarted = false;

  /// Switches are applied one at a time, in the order they were asked for.
  Future<void> _queue = Future<void>.value();

  @override
  void initState() {
    super.initState();
    widget.people.onSwitch = _switchTo;
    widget.people.onForget = _forget;
    _queue = _open(widget.people.active);
  }

  @override
  void dispose() {
    widget.people.onSwitch = null;
    widget.people.onForget = null;
    _session?.close();
    super.dispose();
  }

  Future<void> _switchTo(Person person) {
    _queue = _queue.then((_) => _swap(person));
    return _queue;
  }

  Future<void> _swap(Person person) async {
    final AppSession? old = _session;
    if (old != null && old.person.id == person.id) return;
    // Take the old session off screen first: its container must not be
    // disposed while widgets are still watching it.
    if (mounted) {
      setState(() {
        _session = null;
        _failure = null;
      });
      await WidgetsBinding.instance.endOfFrame;
    }
    await old?.close();
    await _open(person);
  }

  Future<void> _open(Person person) async {
    try {
      final AppSession session = await AppSession.open(
        person: person,
        firebase: widget.firebase,
        dispatcher: widget.dispatcher,
        people: widget.people,
      );
      if (!mounted) {
        await session.close();
        return;
      }
      setState(() => _session = session);
      session.startBackgroundWork(widget.people);
      _startPushOnce(session);
    } catch (e, st) {
      debugPrint('Could not open ${person.id}: $e\n$st');
      if (mounted) setState(() => _failure = e);
    }
  }

  /// Push is best-effort and set up once: permission denial or an absent
  /// config must never block startup, and it does not depend on who is open.
  void _startPushOnce(AppSession session) {
    if (_pushStarted || kIsWeb || !widget.firebase.isAvailable) return;
    _pushStarted = true;
    session.container.read(pushServiceProvider).initialize().catchError(
          (Object _) => PushStatus.unavailable,
        );
  }

  Future<void> _forget(Person person) async {
    final AppSession? session = _session;
    if (session == null) return;
    await OtherPeople.forget(
      person: person,
      notifications: session.container.read(notificationServiceProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppSession? session = _session;
    if (session == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: _failure == null
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Medzee could not open this person\'s data. '
                      'Please restart the app.\n\n$_failure',
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        ),
      );
    }
    return UncontrolledProviderScope(
      key: ValueKey<String>(session.person.id),
      container: session.container,
      child: MedzeeApp(router: session.router),
    );
  }
}
