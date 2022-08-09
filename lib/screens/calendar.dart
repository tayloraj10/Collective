import 'package:collective/components/resource_link.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:collective/models/calendar_event.dart';
import 'package:provider/provider.dart';
import 'package:collective/models/calendar_event.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  getCalendarEvents() {
    var events = Provider.of<appData>(context, listen: false).getCalendarEvents;
    var data = getCalendarDataSource(events['items']);
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    print(getCalendarEvents());
    return SingleChildScrollView(
      child: Scrollbar(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: ResourceLink(
                text: 'View in Google Calendar',
                url:
                    'https://calendar.google.com/calendar/u/0?cid=NDk0ZXVkYjNuM3JzcWliMGlkNzdjamtsY29AZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ',
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1.25,
              child: Container(
                margin: EdgeInsets.all(20),
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 2,
                // color: SecondaryColor,
                child: SfCalendar(
                  view: CalendarView.month,
                  showNavigationArrow: true,
                  showDatePickerButton: true,
                  monthViewSettings: MonthViewSettings(
                      numberOfWeeksInView: 4,
                      showAgenda: true,
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment),
                  dataSource: getCalendarEvents(),
                  // dataSource: CalendarDataSource,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
