import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Firebase configuration for the `medzee-c3f79` project.
///
/// These values identify the project; they are not secrets. Access to data is
/// controlled by `firestore.rules`, not by hiding these keys.
class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  /// Null on platforms without a configured app (e.g. iOS), in which case
  /// Medzee runs fully offline.
  static FirebaseOptions? get currentPlatform {
    if (kIsWeb) return web;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      _ => null,
    };
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB-zXeC8zd0wBR0xcv1zP_pfWpzIYzHxW4',
    appId: '1:879162196925:web:c9c385e397d5fb208f88d4',
    messagingSenderId: '879162196925',
    projectId: 'medzee-c3f79',
    authDomain: 'medzee-c3f79.firebaseapp.com',
    storageBucket: 'medzee-c3f79.firebasestorage.app',
    measurementId: 'G-HX0Y7GD2N4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAFXtAziKOUmVFFTvQng9MlVnXPRmXhqtA',
    appId: '1:879162196925:android:0f7425da9bae1f3c8f88d4',
    messagingSenderId: '879162196925',
    projectId: 'medzee-c3f79',
    storageBucket: 'medzee-c3f79.firebasestorage.app',
  );
}
