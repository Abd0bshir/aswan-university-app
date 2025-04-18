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
    apiKey: 'AIzaSyB_VK2v4eUS2v4sutaUgvD60tStwHQo8Hs',
    appId: '1:978261967287:web:9807ebcaef2a5708dce832',
    messagingSenderId: '978261967287',
    projectId: 'finalau-bd9c3',
    authDomain: 'finalau-bd9c3.firebaseapp.com',
    storageBucket: 'finalau-bd9c3.firebasestorage.app',
    measurementId: 'G-S4WGX0D09K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0jjio2XBbRAgdbpk12M7ICfvwXs085Rk',
    appId: '1:978261967287:android:100891e87ec0a1a4dce832',
    messagingSenderId: '978261967287',
    projectId: 'finalau-bd9c3',
    storageBucket: 'finalau-bd9c3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCkg9WixbDHaTfsp5IEQ0N6P56NH0Nsv_U',
    appId: '1:978261967287:ios:19be251dd0e04ce0dce832',
    messagingSenderId: '978261967287',
    projectId: 'finalau-bd9c3',
    storageBucket: 'finalau-bd9c3.firebasestorage.app',
    iosBundleId: 'com.example.au',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCkg9WixbDHaTfsp5IEQ0N6P56NH0Nsv_U',
    appId: '1:978261967287:ios:19be251dd0e04ce0dce832',
    messagingSenderId: '978261967287',
    projectId: 'finalau-bd9c3',
    storageBucket: 'finalau-bd9c3.firebasestorage.app',
    iosBundleId: 'com.example.au',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB_VK2v4eUS2v4sutaUgvD60tStwHQo8Hs',
    appId: '1:978261967287:web:8ba3e8eea5bf3148dce832',
    messagingSenderId: '978261967287',
    projectId: 'finalau-bd9c3',
    authDomain: 'finalau-bd9c3.firebaseapp.com',
    storageBucket: 'finalau-bd9c3.firebasestorage.app',
    measurementId: 'G-TB9S3L79WJ',
  );
}
