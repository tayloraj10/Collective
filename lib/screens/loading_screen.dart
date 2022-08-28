import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/home.dart';
import 'package:collective/screens/sign_in.dart';
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
    Provider.of<appData>(context, listen: false).updateCalendarEvents(data);
    if (auth.currentUser == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
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
                color: TitleColor,
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
