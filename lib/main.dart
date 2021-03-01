import 'package:collective/constants.dart';
import 'package:collective/screens/home.dart';
import 'package:collective/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() {
//   runApp(MyApp());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Oxygen',
        accentColor: AccentColor,
        primaryColor: PrimaryColor,
      ),
      home: Scaffold(
        // appBar: UPickAppBar(),
        body: SafeArea(
          child: Home(),
        ),
      ),
    );
  }
}
