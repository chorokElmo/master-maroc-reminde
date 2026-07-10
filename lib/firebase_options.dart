// ignore_for_file: constant_identifier_names
//
// Generated from the real Firebase project "master-maroc-reminder"
// (console.firebase.google.com), transcribed from google-services.json.
//
// The `ios` block below is still a placeholder — register an iOS app in
// the same Firebase project and download GoogleService-Info.plist to fill
// it in the same way; until then, `currentPlatform` will throw if run on
// iOS (which isn't buildable from this machine yet anyway).

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

const String _placeholderApiKey = 'REPLACE_WITH_YOUR_API_KEY';

class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  static bool get isConfigured => android.apiKey != _placeholderApiKey;

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _placeholderApiKey,
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'master-maroc-reminder',
    storageBucket: 'master-maroc-reminder.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOCh5pidnbwC3_8ATj2TOdzvB3YqLh04M',
    appId: '1:91307744072:android:3fe3de7f5b8edb94aeb17d',
    messagingSenderId: '91307744072',
    projectId: 'master-maroc-reminder',
    storageBucket: 'master-maroc-reminder.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: _placeholderApiKey,
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'master-maroc-reminder',
    storageBucket: 'master-maroc-reminder.firebasestorage.app',
    iosBundleId: 'com.mastermaroc.reminder.masterMarocReminder',
  );
}
