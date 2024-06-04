import 'package:collective/models/app_data.dart';
import 'package:collective/screens/home.dart';
import 'package:collective/screens/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_web_plugins/url_strategy.dart';

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
  // usePathUrlStrategy();
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
        // StreamProvider<User>.value(
        //   value: FirebaseAuth.instance.authStateChanges(),
        // ),
      ],
      child: MaterialApp(
        routes: {
          '/home': (_) => Home(),
        },
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: 'Collective',
        theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Oxygen',
          // dialogTheme: const DialogTheme(
          //     surfaceTintColor: Colors.white, backgroundColor: Colors.white),
          // cardTheme: const CardTheme(
          //   surfaceTintColor: Colors.white,
          // ),
          // appBarTheme: const AppBarTheme(
          //     color: Colors.blue, foregroundColor: Colors.white),
          // tabBarTheme: TabBarTheme(
          //   labelColor: Colors.white,
          //   dividerColor: Colors.white,
          //   indicatorColor: Colors.white,
          //   unselectedLabelColor: Colors.white,
          // ),
          // buttonTheme: ButtonThemeData(
          //   buttonColor: Colors.blue,
          // ),
          // primaryColor: Colors.blue,
          // primaryColorDark: Colors.blue,
          // colorScheme: ColorScheme.light(
          //     primary: PrimaryColor,
          //     background: Colors.blue,
          //     surface: Colors.white,
          //     surfaceTint: Colors.white),
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

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
