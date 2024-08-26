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
    apiKey: 'AIzaSyBduUl9FLWBzy_sHa0F6Y7fE5F5MTmzdqo',
    appId: '1:200884864027:web:3df02bf964214f9be2a4be',
    messagingSenderId: '200884864027',
    projectId: 'food-ordering-app-f89c6',
    authDomain: 'food-ordering-app-f89c6.firebaseapp.com',
    storageBucket: 'food-ordering-app-f89c6.appspot.com',
    measurementId: 'G-9NL2HBX1PX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnGYxnbE22_IGlXVeHEXpJHkx5EhoxAEc',
    appId: '1:200884864027:android:8990e972f2561514e2a4be',
    messagingSenderId: '200884864027',
    projectId: 'food-ordering-app-f89c6',
    storageBucket: 'food-ordering-app-f89c6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjCKVVq4sGyROpN-CapT3CcZ3vCThWIKo',
    appId: '1:200884864027:ios:14a3fb88d0e21189e2a4be',
    messagingSenderId: '200884864027',
    projectId: 'food-ordering-app-f89c6',
    storageBucket: 'food-ordering-app-f89c6.appspot.com',
    androidClientId: '200884864027-fr9ul5iolvai4vcb6q0dmq361l6m0388.apps.googleusercontent.com',
    iosClientId: '200884864027-k6dkhah3crp45rhgqlj4edhhv6c630nh.apps.googleusercontent.com',
    iosBundleId: 'com.example.quranTutorial',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjCKVVq4sGyROpN-CapT3CcZ3vCThWIKo',
    appId: '1:200884864027:ios:b660340300552564e2a4be',
    messagingSenderId: '200884864027',
    projectId: 'food-ordering-app-f89c6',
    storageBucket: 'food-ordering-app-f89c6.appspot.com',
    androidClientId: '200884864027-fr9ul5iolvai4vcb6q0dmq361l6m0388.apps.googleusercontent.com',
    iosClientId: '200884864027-k78613fh34beblap8e79sviofj9p21bm.apps.googleusercontent.com',
    iosBundleId: 'com.example.foodOrderingApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBduUl9FLWBzy_sHa0F6Y7fE5F5MTmzdqo',
    appId: '1:200884864027:web:b47ff9b5ae13bc5de2a4be',
    messagingSenderId: '200884864027',
    projectId: 'food-ordering-app-f89c6',
    authDomain: 'food-ordering-app-f89c6.firebaseapp.com',
    storageBucket: 'food-ordering-app-f89c6.appspot.com',
    measurementId: 'G-2CSYN9TYXH',
  );
}
