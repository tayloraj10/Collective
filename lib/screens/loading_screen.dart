import 'package:cloud_firestore/cloud_firestore.dart';
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
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    FetchURL fetch = new FetchURL();
    var data = await fetch.getData(calendarAPI);
    // print(data);
    Provider.of<AppData>(context, listen: false).updateCalendarEvents(data);

    var userID = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: Provider.of<User>(context, listen: false).uid)
        .get();
    var docId = userID.docs.first.id;
    var userData =
        await FirebaseFirestore.instance.collection('users').doc(docId).get();

    Provider.of<AppData>(context, listen: false)
        .updateUserData(userData.data());
    print(Provider.of<AppData>(context, listen: false).getUserData());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    // print(Provider.of<User>(context, listen: false));
    if (Provider.of<User>(context) != null) {
      getData();
      return Container();
    } else {
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
