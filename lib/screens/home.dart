import 'package:collective/components/footer.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/calendar.dart';
import 'package:collective/screens/directory.dart';
import 'package:collective/screens/initiatives.dart';
import 'package:collective/screens/profile.dart';
import 'package:collective/screens/projects.dart';
import 'package:collective/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    var userData = Provider.of<AppData>(context, listen: true).userData;

    FirebaseAuth auth = FirebaseAuth.instance;

    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        bottomSheet: Footer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: PrimaryColor,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.trending_up),
                text: 'Initiatives',
              ),

              Tab(
                icon: Icon(Icons.handyman),
                child: Text(
                  'Projects',
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ),
              Tab(
                icon: Icon(Icons.calendar_today),
                text: 'Events',
              ),
              Tab(
                icon: Icon(Icons.import_contacts),
                text: 'Directory',
              ),
              // Tab(
              //   icon: Icon(Icons.file_copy),
              //   text: 'Info',
              // ),
            ],
          ),
          actions: [
            if (FirebaseAuth.instance.currentUser != null &&
                userData['name'] == '')
              Tooltip(
                message: 'Please complete your profile',
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  alignment: Alignment.center,
                  child: Text(
                    '!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 30, left: 4, top: 6, bottom: 4),
              child: ElevatedButton(
                  child: Text(
                    user == null
                        ? "Log In"
                        : "Logged In As: \n${userData['name'] != null && userData['name'] != "" ? userData['name'] : user.email}",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    if (user == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(auth: auth),
                        ),
                      );
                    } else {
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
                                  onPressed: () => {
                                    Navigator.pop(context, 'Cancel'),
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Profile(),
                                      ),
                                    ),
                                  },
                                  child: const Text('View Profile'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    auth.signOut(),
                                    Provider.of<AppData>(context, listen: false)
                                        .updateUserData({}),
                                    userData = Provider.of<AppData>(context,
                                            listen: false)
                                        .userData,
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
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white)),
            )
          ],
          centerTitle: true,
          title: GestureDetector(
            onTap: () => {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Profile(),
              //   ),
              // )
            },
            child: Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              message:
                  "Collective action refers to action taken together by a group of people whose goal is to enhance their condition and achieve a common objective",
              child: Text(
                'Collective',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    fontSize: 40,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Initiatives(),
            Projects(),
            Calendar(),
            Directory()
            // Ideas(),
            // Chat(),
            // Resources(),
          ],
        ),
      ),
    );
  }
}
