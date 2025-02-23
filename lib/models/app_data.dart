import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AppData extends ChangeNotifier {
  Map<dynamic, dynamic> userData = {};

  Map calendarEvents = {};

  get getCalendarEvents {
    return calendarEvents;
  }

  void updateUserData(Map<dynamic, dynamic> newData) {
    userData = newData;
    notifyListeners();
  }

  void updateCalendarEvents(Map newData) {
    calendarEvents = newData;
    notifyListeners();
  }

  Map<dynamic, dynamic> getUserData() {
    notifyListeners();
    return userData;
  }

  fetchUserData(userID) async {
    var user =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    updateUserData(user.data() as Map<String, dynamic>);
    return user.data();
  }
}
