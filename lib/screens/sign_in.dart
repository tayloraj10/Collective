import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Container(child: SignInScreen())]),
    );
  }
}
