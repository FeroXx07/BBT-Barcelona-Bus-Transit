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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDzAP25peHy7kAQrwIBNo0s_wHy4qD3_Tw',
    appId: '1:490525439913:web:a3d28f3f3559dcda3c76b8',
    messagingSenderId: '490525439913',
    projectId: 'citm-task2-project',
    authDomain: 'citm-task2-project.firebaseapp.com',
    storageBucket: 'citm-task2-project.appspot.com',
    measurementId: 'G-VK4KY1NL02',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDURpWyqorSpj-AKk0aanyLnJq3m8VQUw4',
    appId: '1:490525439913:android:c0cbd256e0b25b033c76b8',
    messagingSenderId: '490525439913',
    projectId: 'citm-task2-project',
    storageBucket: 'citm-task2-project.appspot.com',
  );
}
