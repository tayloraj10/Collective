import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/home.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getDataLoggedIn(userID) async {
    FetchURL fetch = new FetchURL();
    var data = await fetch.getData(calendarAPI);
    // print(data);

    Provider.of<AppData>(context, listen: false).updateCalendarEvents(data);
    Provider.of<AppData>(context, listen: false).fetchUserData(userID);

    // Navigator.pushNamed(context, '/home');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }

  Future<void> getDataLoggedOut() async {
    FetchURL fetch = new FetchURL();
    var data = await fetch.getData(calendarAPI);
    Provider.of<AppData>(context, listen: false).updateCalendarEvents(data);

    // Navigator.pushNamed(context, '/home');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (Provider.of<User>(context) != null) {
    if (FirebaseAuth.instance.currentUser != null) {
      // getDataLoggedIn(Provider.of<User>(context, listen: false).uid);
      getDataLoggedIn(FirebaseAuth.instance.currentUser!.uid);
      return Container();
    } else {
      getDataLoggedOut();
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
          ));
    }
  }
}
