import 'package:collective/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:collective/models/calendar_event.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'Show Full Calendar',
            style: pageTextStyle.copyWith(color: Colors.blue),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(20),
            color: SecondaryColor,
            child: SfCalendar(
              view: CalendarView.month,
              showNavigationArrow: true,
              showDatePickerButton: true,
              monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment),
              dataSource: getCalendarDataSource(),
              // dataSource: CalendarDataSource,
            ),
          ),
        ),
      ],
    );
  }
}
