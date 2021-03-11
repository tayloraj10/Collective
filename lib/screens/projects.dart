import 'package:collective/components/projects_stream.dart';
import 'package:collective/constants.dart';
import 'package:flutter/material.dart';

class Projects extends StatefulWidget {
  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: Scrollbar(
            child: Container(
              color: SecondaryColor,
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Text(
                      'These are the currently ongoing projects',
                      style: pageTextStyle,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ProjectsStream()
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
