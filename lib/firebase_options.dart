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
    apiKey: 'AIzaSyCFRdFogHtvfgEZk-_6b2UnoxXENlK7KSE',
    appId: '1:170074061215:web:b80d6a8ce0bfc62ae025aa',
    messagingSenderId: '170074061215',
    projectId: 'be-fit-cz',
    authDomain: 'be-fit-cz.firebaseapp.com',
    storageBucket: 'be-fit-cz.appspot.com',
    measurementId: 'G-MMWEDXRRTF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjoemr_Un2uXWX1CfE-gCqFR61dzesnbg',
    appId: '1:170074061215:android:f23f7de8e7f94024e025aa',
    messagingSenderId: '170074061215',
    projectId: 'be-fit-cz',
    storageBucket: 'be-fit-cz.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBEw2RuksowYiHP9cIKt6ioGtiuA_OwYgU',
    appId: '1:170074061215:ios:10b23bd21212519fe025aa',
    messagingSenderId: '170074061215',
    projectId: 'be-fit-cz',
    storageBucket: 'be-fit-cz.appspot.com',
    iosBundleId: 'com.example.kalorickeTabulky02',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBEw2RuksowYiHP9cIKt6ioGtiuA_OwYgU',
    appId: '1:170074061215:ios:ab538fd2ce0549eee025aa',
    messagingSenderId: '170074061215',
    projectId: 'be-fit-cz',
    storageBucket: 'be-fit-cz.appspot.com',
    iosBundleId: 'com.example.kalorickeTabulky02.RunnerTests',
  );
}
