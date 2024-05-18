// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDMXBp8C39jxM5jbKqUIAUZ4tT0v2j8FqM',
    appId: '1:7786249160:web:46a286bd1b7dde4a9e9efd',
    messagingSenderId: '7786249160',
    projectId: 'otlp-101c8',
    authDomain: 'otlp-101c8.firebaseapp.com',
    storageBucket: 'otlp-101c8.appspot.com',
    measurementId: 'G-4VBPGT811F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMTtWNfJ0WNFUwzGMlwseY_jNQMxN-Py0',
    appId: '1:7786249160:android:ca853122f68bd9cd9e9efd',
    messagingSenderId: '7786249160',
    projectId: 'otlp-101c8',
    storageBucket: 'otlp-101c8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB50FljSHiAcS5XHBsbMIRM4z6rmD-F4dA',
    appId: '1:7786249160:ios:7b16e6a249ee2a199e9efd',
    messagingSenderId: '7786249160',
    projectId: 'otlp-101c8',
    storageBucket: 'otlp-101c8.appspot.com',
    iosBundleId: 'pa.otlup.customerapp',
  );
}