import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/calendar.dart';
import 'package:collective/screens/chat.dart';
import 'package:collective/screens/profile.dart';
import 'package:collective/screens/projects.dart';
import 'package:collective/screens/resources.dart';
import 'package:collective/screens/sign_in.dart';
import 'package:collective/screens/ideas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth auth;
  var userData = {};

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    Provider.of<AppData>(context, listen: false).updateFirebaseAuth(auth);

    getUser();
    print(auth.currentUser?.email);
    print(auth.currentUser);

    userData = Provider.of<AppData>(context, listen: false).getUserData();
  }

  void getUser() {
    auth = Provider.of<AppData>(context, listen: false).getFirebaseAuth();
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    print(auth.currentUser?.email);

    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 4,
        length: 5,
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
                Tab(
                  icon: Icon(Icons.chat_bubble),
                  text: 'Chat',
                ),
              ],
            ),
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                child: ElevatedButton(
                    child: Text(
                      auth.currentUser == null
                          ? "Log In"
                          : "Logged In As: \n${userData['name'] != "" ? userData['name'] : auth.currentUser.email}",
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
                                content: const Text(
                                    'Do you want to sign out or view your profile?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Profile(),
                                      ),
                                    ),
                                    child: const Text('View Profile'),
                                  ),
                                  TextButton(
                                    onPressed: () => {
                                      auth.signOut(),
                                      setState(() {}),
                                      Navigator.pop(context)
                                    },
                                    child: const Text('Sign Out'),
                                  ),
                                ],
                              );
                            });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white)),
              )
            ],
            centerTitle: true,
            title: Text(
              'Collective',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  fontSize: 40,
                  fontStyle: FontStyle.italic),
            ),
          ),
          body: TabBarView(
            children: [Calendar(), Ideas(), Projects(), Resources(), Chat()],
          ),
        ),
      ),
    );
  }
}
