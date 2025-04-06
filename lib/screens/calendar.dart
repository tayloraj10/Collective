import 'package:collective/components/resource_link.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:collective/models/calendar_event.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  getCalendarEvents() {
    var events = Provider.of<AppData>(context, listen: true).getCalendarEvents;
    var data = getCalendarDataSource(events['items']);
    // print(data);
    return data;
  }

  calendarTap(details) {
    print(details.targetElement);
    if (details.targetElement == CalendarElement.appointment) {
      var eventDetails = details.appointments[0];
      showDialog(
          context: context,
          builder: (BuildContext context) {
            String url;
            String locationUrl = 'https://www.google.com/maps/search/';
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Event Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (eventDetails.subject != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Event:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          SelectableText(
                            "${eventDetails.subject.split(' - ')[0].trim()}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    if (eventDetails.subject.contains(' - '))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Location:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          InkWell(
                            mouseCursor: SystemMouseCursors.click,
                            onTap: () => launchURL(
                              locationUrl +
                                  "${eventDetails.subject.split(' - ')[1].trim()}",
                            ),
                            child: Text(
                              "${eventDetails.subject.split(' - ')[1].trim()}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Time:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        SelectableText(
                          "${DateFormat('EEEE, MMM dd, h:mm a').format(eventDetails.startTime)} - ${DateFormat('EEEE, MMM dd, h:mm a').format(eventDetails.endTime)}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (eventDetails.notes != null &&
                        eventDetails.notes.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          if (eventDetails.notes.contains('http'))
                            InkWell(
                              mouseCursor: SystemMouseCursors.click,
                              onTap: () {
                                url = 'http' +
                                    eventDetails.notes
                                        .replaceAll(RegExp(r'<a[^>]*>'), '')
                                        .split('http')[1]
                                        .split(' ')[0];
                                launchURL(url);
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: eventDetails.notes
                                          .replaceAll(RegExp(r'<a[^>]*>'), '')
                                          .replaceAll('</a>', '')
                                          .split('http')[0],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700),
                                    ),
                                    TextSpan(
                                      text: 'http' +
                                          eventDetails.notes
                                              .replaceAll(
                                                  RegExp(r'<a[^>]*>'), '')
                                              .split('http')[1]
                                              .split(' ')[0],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: eventDetails.notes
                                          .replaceAll(RegExp(r'<a[^>]*>'), '')
                                          .replaceAll('</a>', '')
                                          .split('http')
                                          .skip(1)
                                          .join(' ')
                                          .split(' ')
                                          .skip(1)
                                          .join(' '),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Text(
                              "${eventDetails.notes}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  showTodayButton: true,
                  backgroundColor: Colors.white,
                  view: CalendarView.month,
                  showNavigationArrow: true,
                  showDatePickerButton: true,
                  monthViewSettings: MonthViewSettings(
                      numberOfWeeksInView: 4,
                      showAgenda: true,
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment),
                  dataSource: getCalendarEvents(),
                  onTap: calendarTap,
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
