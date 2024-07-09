import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCXAh_lXL7bxg_QfqzkYavUEQIEmVhQGZM",
    authDomain: "intellido--flutter-version.firebaseapp.com",
    projectId: "intellido--flutter-version",
    storageBucket: "intellido--flutter-version.appspot.com",
    messagingSenderId: "885967776843",
    appId: "1:885967776843:web:b8e244867bf53d0c30b1ce",
    measurementId: "G-JFK27W2SK2",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyCXAh_lXL7bxg_QfqzkYavUEQIEmVhQGZM",
    authDomain: "intellido--flutter-version.firebaseapp.com",
    projectId: "intellido--flutter-version",
    storageBucket: "intellido--flutter-version.appspot.com",
    messagingSenderId: "885967776843",
    appId: "1:885967776843:web:b8e244867bf53d0c30b1ce",
    measurementId: "G-JFK27W2SK2",
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else {
      return android;
    }
  }
}
