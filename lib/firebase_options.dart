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
    apiKey: 'AIzaSyB1lTxUXBA_G53f1VEA_CqSNfkdN8DPRjA',
    appId: '1:920763255507:web:1bd016373c2dcf6d7ae226',
    messagingSenderId: '920763255507',
    projectId: 'locoali-demo',
    authDomain: 'locoali-demo.firebaseapp.com',
    storageBucket: 'locoali-demo.firebasestorage.app',
    measurementId: 'G-0ELM05BW54',
    
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcmjnzDkVKUNvALy7DIdKbL3qEE78yMhU',
    appId: '1:920763255507:android:ef42f9bcb5053b2c7ae226',
    messagingSenderId: '920763255507',
    projectId: 'locoali-demo',
    storageBucket: 'locoali-demo.firebasestorage.app',
    
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCu72jZbOL7e3S7VLHDMxrbuGXEauw4y_E',
    appId: '1:920763255507:ios:fb11cd21c75a286f7ae226',
    messagingSenderId: '920763255507',
    projectId: 'locoali-demo',
    storageBucket: 'locoali-demo.firebasestorage.app',
    iosBundleId: 'com.example.locoaliDemo',
  );
}
