import 'package:collective/models/app_data.dart';
import 'package:collective/screens/home.dart';
import 'package:collective/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  final FirebaseAuth auth;

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
              AuthStateChangeAction<UserCreated>((context, state) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(),
                  ),
                );
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                Provider.of<AppData>(context, listen: false)
                    .updateFirebaseAuth(auth);
                print(Provider.of<AppData>(context, listen: false)
                    .getFirebaseAuth());

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              }),
            ],
          )))
        ]),
      ),
    );
  }
}
