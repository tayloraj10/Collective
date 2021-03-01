import 'package:collective/components/resource_link.dart';
import 'package:collective/constants.dart';
import 'package:flutter/material.dart';

class Resources extends StatefulWidget {
  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scrollbar(
        child: Container(
          color: SecondaryColor,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Text(
                    "Looking for something to do after being locked indoors for a year? \n\nCollective is a place to find interesting and fun things going on and to meet like minded people in the process \n\nAnything is allowed on collective from finding people to volunteer with to looking for people to start a new project/business venture to finding talent for a viral tiktok video",
                    style: pageTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Resources',
                    style: pageTextStyle.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ResourceLink(
                    text: 'Volunteer Opportunities',
                    url:
                        'https://docs.google.com/spreadsheets/d/1tjOrcGyvZ9yVKB8QLvHV-ZrNb0wtwedlDJgpEneL5hc/edit?usp=sharing',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
