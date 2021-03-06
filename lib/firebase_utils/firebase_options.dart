// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCjKxjQQzUFzHmlsYKmhUpvJyYAnUMt258',
    appId: '1:538498400034:web:6c70be9ce55518e6f2ef7b',
    messagingSenderId: '538498400034',
    projectId: 'cz2006-fb101',
    authDomain: 'cz2006-fb101.firebaseapp.com',
    storageBucket: 'cz2006-fb101.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAS0_jxEaxJhtf8ncdNxMod4w1LKUnxrMw',
    appId: '1:538498400034:android:d0f3eb8c7c0f7f38f2ef7b',
    messagingSenderId: '538498400034',
    projectId: 'cz2006-fb101',
    storageBucket: 'cz2006-fb101.appspot.com',
  );
}
