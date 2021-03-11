import 'package:collective/components/topics_stream.dart';
import 'package:collective/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Topics extends StatefulWidget {
  @override
  _TopicsState createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {
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
                      'These are potential topics for new projects or events',
                      style: pageTextStyle,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TopicsStream()
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
