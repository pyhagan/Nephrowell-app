import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;

FirebaseOptions get firebaseOptions {
  if (kIsWeb) {
    // Web specific options
    return FirebaseOptions(
      apiKey: "AIzaSyDH0wivl_UZVp-edafXoEeehTv5m1pkP1I",
      authDomain: "flutter-project-f6335.firebaseapp.com",
      projectId: "flutter-project-f6335",
      storageBucket: "flutter-project-f6335.appspot.com",
      messagingSenderId: "826360291230",
      appId: "1:826360291230:web:c02ca30f2596bd61e8808f",
    );
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    // Android specific options
    return FirebaseOptions(
      apiKey: "AIzaSyDt6jkGgLw-brqPLvI2TxI0Ypjltf0qt9I",
       appId: "1:826360291230:android:5f457c7861fa2b0ce8808f",
       messagingSenderId: "826360291230",
      projectId: "flutter-project-f6335",
      storageBucket: "flutter-project-f6335.appspot.com",

    );
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    // iOS specific options
    return FirebaseOptions(
      apiKey: "AIzaSyAHFnP6yei1Klj8vcFbfSA-fCzC-zTi1h4",
      projectId: "flutter-project-f6335",
      storageBucket: "flutter-project-f6335.appspot.com",
      messagingSenderId: "826360291230",
      appId: "1:826360291230:ios:d1713b38ea6fc028e8808f",
      iosBundleId: "com.example.ckdMobile" ,

    
    );
  } else {
    throw UnsupportedError('DefaultTargetPlatform is not supported.');
  }
}
