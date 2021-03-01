import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const Color PrimaryColor = Color(0xff000814);
const Color SecondaryColor = Color(0xff003566);
const Color SecondaryColorDark = Color(0xff001d3d);
const Color AccentColor = Color(0xfff5cc00);
const Color AccentColorDark = Color(0xffcca000);

const TextStyle pageTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Oxygen',
    fontWeight: FontWeight.bold,
    fontSize: 22);

Color TitleColor = Colors.grey[200];

const String calendarAPIkey = 'AIzaSyBPWfQzuaUstGTfz8xRS1Sgp3no-IusUmw';
const String calendarID =
    '494eudb3n3rsqib0id77cjklco@group.calendar.google.com';
String calendarAPI =
    'https://www.googleapis.com/calendar/v3/calendars/$calendarID?key=$calendarAPIkey';

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}
