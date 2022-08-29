import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/calendar.dart';
import 'package:collective/screens/projects.dart';
import 'package:collective/screens/resources.dart';
import 'package:collective/screens/sign_in.dart';
import 'package:collective/screens/topics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AppData>(context, listen: false).getFirebaseAuth();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AppData>(context, listen: false).getFirebaseAuth();

    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: SecondaryColor,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.calendar_today),
                  text: 'Events',
                ),
                Tab(
                  icon: Icon(Icons.lightbulb),
                  text: 'Ideas',
                ),
                Tab(
                  icon: Icon(Icons.handyman),
                  text: 'Projects',
                ),
                Tab(
                  icon: Icon(Icons.file_copy),
                  text: 'Info',
                ),
              ],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(
                  flex: 2,
                ),
                Text(
                  'Collective',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      fontSize: 40,
                      fontStyle: FontStyle.italic),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: ElevatedButton(
                      child: Text(
                        auth.currentUser == null
                            ? "Log In"
                            : "Logged In As: ${auth.currentUser.email}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        if (auth.currentUser == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignIn(auth: auth),
                            ),
                          );
                        } else {
                          // auth.signOut();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content:
                                      const Text('Do you want to sign out?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => {
                                        auth.signOut(),
                                        setState(() {}),
                                        Navigator.pop(context, 'OK')
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.white)),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Calendar(),
              Topics(),
              Projects(),
              Resources(),
            ],
          ),
        ),
      ),
    );
  }
}
