import 'package:collective/constants.dart';
import 'package:collective/screens/calendar.dart';
import 'package:collective/screens/projects.dart';
import 'package:collective/screens/resources.dart';
import 'package:collective/screens/topics.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 1,
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: SecondaryColor,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.calendar_today),
                  text: 'Events',
                ),
                Tab(
                  icon: Icon(Icons.lightbulb),
                  text: 'Ideas',
                ),
                Tab(
                  icon: Icon(Icons.handyman),
                  text: 'Projects',
                ),
                Tab(
                  icon: Icon(Icons.file_copy),
                  text: 'Info',
                ),
              ],
            ),
            title: Align(
              alignment: Alignment.center,
              child: Text(
                'Collective',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: TitleColor,
                    fontSize: 40,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Calendar(),
              Topics(),
              Projects(),
              Resources(),
            ],
          ),
        ),
      ),
    );
  }
}
