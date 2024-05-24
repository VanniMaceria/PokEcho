//link al firebase del progetto -> https://console.firebase.google.com/project/pokecho-cff59/overview?hl=it

// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyC5D-hBYstQeIm4BbhCUaZ2v_PgqWNjIOc',
    appId: '1:599177710041:web:81ea7c3e5ae6be9a35b1c8',
    messagingSenderId: '599177710041',
    projectId: 'pokecho-cff59',
    authDomain: 'pokecho-cff59.firebaseapp.com',
    storageBucket: 'pokecho-cff59.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzynE6sXG-yFMZ0Id3zMGUrXVgfmrUrIo',
    appId: '1:599177710041:android:5f57d031c6aca26535b1c8',
    messagingSenderId: '599177710041',
    projectId: 'pokecho-cff59',
    storageBucket: 'pokecho-cff59.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCl3TKrjtAIAq06UqtcJ9TraqGlYyAhtCw',
    appId: '1:599177710041:ios:9837cfd2fdd7e67535b1c8',
    messagingSenderId: '599177710041',
    projectId: 'pokecho-cff59',
    storageBucket: 'pokecho-cff59.appspot.com',
    iosBundleId: 'com.example.pokecho',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCl3TKrjtAIAq06UqtcJ9TraqGlYyAhtCw',
    appId: '1:599177710041:ios:9837cfd2fdd7e67535b1c8',
    messagingSenderId: '599177710041',
    projectId: 'pokecho-cff59',
    storageBucket: 'pokecho-cff59.appspot.com',
    iosBundleId: 'com.example.pokecho',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC5D-hBYstQeIm4BbhCUaZ2v_PgqWNjIOc',
    appId: '1:599177710041:web:367520473e75f22c35b1c8',
    messagingSenderId: '599177710041',
    projectId: 'pokecho-cff59',
    authDomain: 'pokecho-cff59.firebaseapp.com',
    storageBucket: 'pokecho-cff59.appspot.com',
  );
}