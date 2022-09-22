import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBU7AZ9mzRdYODCPUqZcwL4RLrha_opcl4",
          authDomain: "collective-e06e1.firebaseapp.com",
          projectId: "collective-e06e1",
          storageBucket: "collective-e06e1.appspot.com",
          messagingSenderId: "1097949131260",
          appId: "1:1097949131260:web:68bc0051c431e72cbe0279",
          measurementId: "G-JPHHPCC2XP"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppData>(
          create: (_) => AppData(),
        ),
        StreamProvider<User>.value(
          value: FirebaseAuth.instance.authStateChanges(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Collective',
        theme: ThemeData(
          fontFamily: 'Oxygen',
          primaryColor: PrimaryColor,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: AccentColor),
        ),
        home: Scaffold(
          body: SafeArea(
            child: LoadingScreen(),
          ),
        ),
      ),
    );
  }
}
