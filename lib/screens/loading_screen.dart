import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    FetchURL fetch = new FetchURL();
    var data = await fetch.getData(calendarAPI);
    // print(data);
    Provider.of<appData>(context, listen: false).updateCalendarEvents(data);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SecondaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Collective',
              style: TextStyle(
                color: TitleColor,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
