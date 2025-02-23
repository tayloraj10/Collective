import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/screens/loading_screen.dart';
import 'package:collective/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:collective/firebase_options.dart';

class SignIn extends StatelessWidget {
  final FirebaseAuth auth;

  SignIn({required this.auth});

  createUser(User user) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Save user data in Firestore
    await userRef
        .set({
          'name': "",
          'phone': "",
          'email': user.email,
          'uid': user.uid,
        })
        .then((_) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

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
            providerConfigs: [
              EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                  clientId: DefaultFirebaseOptions.googleClientID)
            ],
            actions: [
              //email user create
              AuthStateChangeAction<UserCreated>((context, state) async {
                final user = auth.currentUser;
                newUser = true;
                if (user != null) {
                  createUser(user);
                }
              }),
              AuthStateChangeAction<SignedIn>((context, state) async {
                final user = auth.currentUser;
                if (user != null) {
                  final userRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid);

                  final userDoc = await userRef.get();
                  if (!newUser &&
                      userDoc.exists &&
                      userDoc.data()!['name'] != '') {
                    // Existing user → Navigate to LoadingScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoadingScreen()),
                    );
                  } else if (!userDoc.exists) {
                    // New user from google sign in → Navigate to Profile setup
                    createUser(user);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  } else if (userDoc.data()!['name'] == '') {
                    // New user missing name → Navigate to Profile setup
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  } else {
                    // New user → Navigate to Profile setup
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  }
                }
              }),
            ],
          )))
        ]),
      ),
    );
  }
}
