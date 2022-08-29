import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AppData extends ChangeNotifier {
  FirebaseAuth auth;

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

  void updateCalendarEvents(Map newData) {
    calendarEvents = newData;
    notifyListeners();
  }

  FirebaseAuth getFirebaseAuth() {
    return auth;
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
