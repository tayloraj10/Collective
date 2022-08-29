import 'package:collective/models/app_data.dart';
import 'package:collective/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  FirebaseAuth auth;

  SignIn({this.auth});

  @override
  Widget build(BuildContext context) {
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
              AuthStateChangeAction<SignedIn>((context, state) {
                Provider.of<appData>(context, listen: false)
                    .updateFirebaseAuth(auth);
                print(Provider.of<appData>(context, listen: false)
                    .getFirebaseAuth());

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              }),
              AuthStateChangeAction<UserCreated>((context, state) {
                print('USER CREATED');
              })
            ],
          )))
        ]),
      ),
    );
  }
}
