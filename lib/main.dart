import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/home.dart';
import 'package:collective/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<appData>(
      create: (context) => appData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Oxygen',
          primaryColor: PrimaryColor,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: AccentColor),
        ),
        home: Scaffold(
          // appBar: UPickAppBar(),
          body: SafeArea(
            child: LoadingScreen(),
          ),
        ),
      ),
    );
  }
}
