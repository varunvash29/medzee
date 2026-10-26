import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'services/firebase_service.dart';
import 'services/notification_action_dispatcher.dart';
import 'services/people/people_controller.dart';
import 'session/medzee_host.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Firebase is optional: without google-services.json the gateway reports
  // itself unavailable and the app stays fully offline. Attempted before any
  // session so providers receive the resolved instance.
  final FirebaseGateway firebase = await FirebaseGateway.tryInitialize();

  // Who shares this device, and who was open last.
  final PeopleController people = await PeopleController.load();

  runApp(
    MedzeeHost(
      people: people,
      firebase: firebase,
      dispatcher: NotificationActionDispatcher(),
    ),
  );
}
