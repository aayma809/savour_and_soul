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
    apiKey: 'AIzaSyAejEigTErsvFXwDbPg3uCJP4pImpyJtmw',
    appId: '1:66545249642:web:0d2366d270d3a013918913',
    messagingSenderId: '66545249642',
    projectId: 'savourandsoul-16d8f',
    authDomain: 'savourandsoul-16d8f.firebaseapp.com',
    storageBucket: 'savourandsoul-16d8f.firebasestorage.app',
    measurementId: 'G-CMPV7N9V83',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAAXy9MWoxmKa4Pmnj14VrddQp2nr3yG2w',
    appId: '1:66545249642:android:e92675ea48e35cfc918913',
    messagingSenderId: '66545249642',
    projectId: 'savourandsoul-16d8f',
    storageBucket: 'savourandsoul-16d8f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBAW8y8Or3BHblhVInG_h3zBJYW2hZVHns',
    appId: '1:66545249642:ios:0ac7e9dc4c26f8aa918913',
    messagingSenderId: '66545249642',
    projectId: 'savourandsoul-16d8f',
    storageBucket: 'savourandsoul-16d8f.firebasestorage.app',
    iosBundleId: 'com.example.savourAndSoul',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBAW8y8Or3BHblhVInG_h3zBJYW2hZVHns',
    appId: '1:66545249642:ios:0ac7e9dc4c26f8aa918913',
    messagingSenderId: '66545249642',
    projectId: 'savourandsoul-16d8f',
    storageBucket: 'savourandsoul-16d8f.firebasestorage.app',
    iosBundleId: 'com.example.savourAndSoul',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAejEigTErsvFXwDbPg3uCJP4pImpyJtmw',
    appId: '1:66545249642:web:e076902c5cffb881918913',
    messagingSenderId: '66545249642',
    projectId: 'savourandsoul-16d8f',
    authDomain: 'savourandsoul-16d8f.firebaseapp.com',
    storageBucket: 'savourandsoul-16d8f.firebasestorage.app',
    measurementId: 'G-GMPELPQHZJ',
  );
}
