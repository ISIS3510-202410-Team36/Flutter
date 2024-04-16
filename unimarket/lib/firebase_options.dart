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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDVap1T0yeBpP3yvqlDwSHCToFo4dcgbCk',
    appId: '1:120994639030:web:37fac20093bf1caaf54a17',
    messagingSenderId: '120994639030',
    projectId: 'unimarket-174b9',
    authDomain: 'unimarket-174b9.firebaseapp.com',
    storageBucket: 'unimarket-174b9.appspot.com',
    measurementId: 'G-1JMT4BY8KQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZkOQ6Fx6qjM8PW0lvkUZ36hK4bsbUYLc',
    appId: '1:120994639030:android:db2685d2e9bd1bc7f54a17',
    messagingSenderId: '120994639030',
    projectId: 'unimarket-174b9',
    storageBucket: 'unimarket-174b9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMRyMoi7ycGbVxdM0EPQOyogaR4ADfkV0',
    appId: '1:120994639030:ios:6366745fb1029ffff54a17',
    messagingSenderId: '120994639030',
    projectId: 'unimarket-174b9',
    storageBucket: 'unimarket-174b9.appspot.com',
    iosBundleId: 'com.example.unimarket',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMRyMoi7ycGbVxdM0EPQOyogaR4ADfkV0',
    appId: '1:120994639030:ios:6366745fb1029ffff54a17',
    messagingSenderId: '120994639030',
    projectId: 'unimarket-174b9',
    storageBucket: 'unimarket-174b9.appspot.com',
    iosBundleId: 'com.example.unimarket',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDVap1T0yeBpP3yvqlDwSHCToFo4dcgbCk',
    appId: '1:120994639030:web:7c1c11b85e2ef232f54a17',
    messagingSenderId: '120994639030',
    projectId: 'unimarket-174b9',
    authDomain: 'unimarket-174b9.firebaseapp.com',
    storageBucket: 'unimarket-174b9.appspot.com',
    measurementId: 'G-GBCKP9TMG9',
  );

}