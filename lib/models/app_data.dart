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
    return userData;
  }

  fetchUserData(auth) async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: auth.currentUser.uid)
        .get();
    var docId = user.docs.first.id;
    var userData =
        await FirebaseFirestore.instance.collection('users').doc(docId).get();
    updateUserData(userData.data());
    // return userData.data();
  }
}
