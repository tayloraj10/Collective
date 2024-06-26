import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/screens/loading_screen.dart';
import 'package:collective/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class SignIn extends StatelessWidget {
  final FirebaseAuth auth;

  SignIn({required this.auth});

  @override
  Widget build(BuildContext context) {
    bool newUser = false;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Column(children: [
          Expanded(
              child: Container(
                  child: SignInScreen(
            auth: auth,
            providerConfigs: [EmailProviderConfiguration()],
            actions: [
              AuthStateChangeAction<UserCreated>((context, state) async {
                newUser = true;
                CollectionReference users =
                    FirebaseFirestore.instance.collection('users');
                await users
                    .add({
                      'name': "",
                      'phone': "",
                      'email': auth.currentUser!.email,
                      'uid': auth.currentUser!.uid
                    })
                    .then((value) => print("User Added"))
                    .catchError((error) => print("Failed to add user: $error"));
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                if (newUser) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingScreen(),
                    ),
                  );
                }
              }),
            ],
          )))
        ]),
      ),
    );
  }
}
