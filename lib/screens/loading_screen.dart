import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBU7AZ9mzRdYODCPUqZcwL4RLrha_opcl4",
            authDomain: "collective-e06e1.firebaseapp.com",
            projectId: "collective-e06e1",
            storageBucket: "collective-e06e1.appspot.com",
            messagingSenderId: "1097949131260",
            appId: "1:1097949131260:web:68bc0051c431e72cbe0279",
            measurementId: "G-JPHHPCC2XP"));
    FirebaseAuth auth = FirebaseAuth.instance;

    FetchURL fetch = new FetchURL();
    var data = await fetch.getData(calendarAPI);
    // print(data);
    await Provider.of<AppData>(context, listen: false)
        .updateCalendarEvents(data);
    await Provider.of<AppData>(context, listen: false).updateFirebaseAuth(auth);

    if (auth.currentUser != null) {
      var user = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: auth.currentUser.uid)
          .get();
      var docId = user.docs.first.id;
      var userData =
          await FirebaseFirestore.instance.collection('users').doc(docId).get();
      await Provider.of<AppData>(context, listen: false)
          .updateUserData(userData.data());
      print(Provider.of<AppData>(context, listen: false).getUserData());
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SecondaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Collective',
              style: TextStyle(
                color: titleColor,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
