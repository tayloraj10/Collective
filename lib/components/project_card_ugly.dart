import 'package:collective/constants.dart';
import 'package:flutter/material.dart';

class ProjectCardUgly extends StatelessWidget {
  final Map data;
  ProjectCardUgly({required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AccentColorDark,
            border: Border.all(
              color: AccentColor,
              width: 2,
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  data['title'],
                  style: pageTextStyle.copyWith(
                      decoration: TextDecoration.underline),
                ),
              ),
              subtitle: Text(
                  data['description'] + "\n\nTopic: " + data['topic'],
                  style: pageTextStyle.copyWith(fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }
}
