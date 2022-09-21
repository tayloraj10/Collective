import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AppData extends ChangeNotifier {
  FirebaseAuth auth;
  Map<dynamic, dynamic> userData = {};

  Map calendarEvents = {};

  // List<Map<dynamic, dynamic>> homeBanners = [];
  // String sessionID = '';
  get getCalendarEvents {
    return calendarEvents;
  }

  void updateFirebaseAuth(FirebaseAuth newAuth) {
    auth = newAuth;
    notifyListeners();
  }

  void updateUserData(Map<dynamic, dynamic> newData) {
    userData = newData;
    notifyListeners();
  }

  void updateCalendarEvents(Map newData) {
    calendarEvents = newData;
    notifyListeners();
  }

  FirebaseAuth getFirebaseAuth() {
    return auth;
  }

  Map<dynamic, dynamic> getUserData() {
    return userData;
  }

// List getNMovies(int n) {
  //   return getRandomMovies(n, movieData);
  // }
  //
  // get getMovies {
  //   return movieData;
  // }
  //
  // void updateBannerData(List<Map<dynamic, dynamic>> newData) {
  //   homeBanners = newData;
  //   notifyListeners();
  // }

}
