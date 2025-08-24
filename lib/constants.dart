import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

isMobile(context) {
  return MediaQuery.of(context).size.width < 1300;
}

const double smallTextSize = 14;
const double mediumTextSize = 24;
const double largeTextSize = 30;

const Color PrimaryColor = Colors.blue;
const Color SecondaryColor = Color(0xff003566);
const Color SecondaryColorDark = Color(0xff001d3d);
const Color AccentColor = Color(0xfff5cc00);
const Color AccentColorDark = Color(0xffcca000);

const TextStyle pageTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Oxygen',
    fontWeight: FontWeight.bold,
    fontSize: 22);

Color? titleColor = Colors.grey[200];

const String calendarAPIkey = 'AIzaSyBykyx3g2Vf986Vsd4MZ2zKvNoh7XG5zLE';
const String placesAPIkey = 'AIzaSyCHPOORlE77Hm6KyZU6fjCgIZ-Epr-Dzdo';
const String calendarID =
    '494eudb3n3rsqib0id77cjklco@group.calendar.google.com';
// String calendarAPI =
//     'https://www.googleapis.com/calendar/v3/calendars/$calendarID?key=$calendarAPIkey';
var cutoffDate = DateFormat('yyyy-MM-dd')
    .format(DateTime.now().subtract(Duration(days: 60)));
String calendarAPI =
    "https://www.googleapis.com/calendar/v3/calendars/494eudb3n3rsqib0id77cjklco@group.calendar.google.com/events?key=AIzaSyDE7bbnSB-EbLI2wsn3P01uqVgf4UoaqTQ" +
        "&timeMin=" +
        cutoffDate +
        "T00:00:00-05:00";

void launchURL(String url) async {
  print(url);
  if (url.contains('">')) {
    url = url.replaceAll('">', "");
  }
  await launchUrl(Uri.parse(url));
}

class FetchURL {
  Future getData(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}

String getInitials(String name) {
  return name.split(" ")[0][0] + name.split(" ")[1][0];
}

getProjectColor(String status, [Color? color]) {
  if (status == 'Active')
    return Colors.green;
  else if (status == 'In Development')
    return Colors.black;
  else if (status == 'Inactive' && color == Colors.red)
    return Colors.orange;
  else if (status == 'Inactive') return Colors.red;
}

getCurrentWeekNumber() {
  DateTime now = DateTime.now();
  int dayOfYear = int.parse(
      DateFormat("D").format(now)); // Requires intl package for DateFormat
  int weekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();
  return "${now.year}-W${weekNumber.toString().padLeft(2, '0')}";
}

getDateRangeOfCurrentWeek() {
  DateTime now = DateTime.now();
  int currentWeekday = now.weekday;
  DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));
  DateTime endOfWeek = now.add(Duration(days: 7 - currentWeekday));
  String formattedStart =
      DateFormat('MMM d').format(startOfWeek); // e.g., "Jan 1"
  String formattedEnd = DateFormat('MMM d').format(endOfWeek); // e.g., "Jan 7"
  return "$formattedStart - $formattedEnd";
}
