import 'package:flutter/foundation.dart';

class appData extends ChangeNotifier {
  Map calendarEvents = {};
  // List<Map<dynamic, dynamic>> homeBanners = [];
  // String sessionID = '';
  get getCalendarEvents {
    return calendarEvents;
  }

  void updateCalendarEvents(Map newData) {
    calendarEvents = newData;
    notifyListeners();
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
