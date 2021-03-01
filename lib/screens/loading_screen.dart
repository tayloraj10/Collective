import 'package:collective/constants.dart';
import 'package:collective/screens/calendar.dart';
import 'package:flutter/material.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Calendar(),
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
