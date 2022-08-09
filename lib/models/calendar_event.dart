import 'package:flutter/material.dart';
import 'package:instant/instant.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

_AppointmentDataSource getCalendarDataSource(List events) {
  List<Appointment> appointments = <Appointment>[];

  for (var e in events) {
    bool recur = false;
    int recurrence = 0;
    print(e);
    if (e.containsKey('recurrence')) {
      print('recur');
      recurrence = 1;
      recur = true;

      while (recurrence < 10) {
        DateTime startTime = DateTime.parse(e['start']['dateTime'])
            .subtract(Duration(hours: 4))
            .add(Duration(days: 7 * (recur ? recurrence : 0)));
        DateTime endTime = DateTime.parse(e['end']['dateTime'])
            .subtract(Duration(hours: 4))
            .add(Duration(days: 7 * (recur ? recurrence : 0)));

        appointments.add(Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: e['summary'],
            color: Colors.blue,
            startTimeZone: '',
            endTimeZone: '',
            notes: e['description'],
            isAllDay: false));
        print('adding');

        recurrence += 1;
      }
    } else {
      DateTime startTime = dateTimeToZone(
          zone: "EST",
          datetime: e['start'].containsKey("dateTime")
              ? DateTime.parse(e['start']['dateTime'])
              : DateTime.parse(e['start']['date']));
      DateTime endTime = dateTimeToZone(
          zone: "EST",
          datetime: e['end'].containsKey("dateTime")
              ? DateTime.parse(e['end']['dateTime'])
              : DateTime.parse(e['end']['date'])
                  .subtract(const Duration(minutes: 1)));

      appointments.add(Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: e['summary'],
          color: Colors.blue,
          startTimeZone: '',
          endTimeZone: '',
          notes: e['description'],
          isAllDay: false));
    }
  }

  print('returning');
  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

List<Meeting> getDataSource() {
  List meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(
      Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), true));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
