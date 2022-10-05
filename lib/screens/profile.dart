import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    FirebaseAuth auth = FirebaseAuth.instance;

    var userData = Provider.of<AppData>(context).userData;

    TextEditingController phoneController = new TextEditingController();

    userData['phone'] == null
        ? phoneController.text = ""
        : phoneController.text = userData['phone'];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Column(children: [
          Expanded(
            child: Container(
              child: ProfileScreen(
                auth: auth,
                providerConfigs: [
                  EmailProviderConfiguration(),
                ],
                actions: [
                  SignedOutAction((context) {
                    print('signed out');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Home(),
                    //   ),
                    // );
                  }),
                ],
                avatarSize: 0,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 0),
                    child: Text(
                      'Phone Number',
                      style: TextStyle(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'Phone Number'),
                      controller: phoneController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        var userID = await FirebaseFirestore.instance
                            .collection('users')
                            .where('uid', isEqualTo: auth.currentUser.uid)
                            .get();
                        var docId = userID.docs.first.id;
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(docId)
                            .update({
                          'name': auth.currentUser.displayName != null
                              ? auth.currentUser.displayName
                              : "",
                          'phone': phoneController.text
                        }).then((documentSnapshot) => {
                                  Provider.of<AppData>(context, listen: false)
                                      .fetchUserData(user.uid),
                                  Fluttertoast.showToast(
                                      msg: "Profile Updated",
                                      toastLength: Toast.LENGTH_LONG,
                                      fontSize: 16.0,
                                      webBgColor: '#55aaff',
                                      webPosition: 'center',
                                      timeInSecForIosWeb: 3),
                                });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Save Changes',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (auth.currentUser.displayName == "" ||
                            auth.currentUser.displayName == null ||
                            phoneController.text == "") {
                          Fluttertoast.showToast(
                              msg: "Missing Name or Phone Number",
                              toastLength: Toast.LENGTH_LONG,
                              fontSize: 16.0,
                              webBgColor: '#FF0000',
                              webPosition: 'center',
                              timeInSecForIosWeb: 3);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Go Home',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
