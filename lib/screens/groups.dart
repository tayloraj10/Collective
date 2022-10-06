import 'package:collective/components/groups_stream.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/constants.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  var projects = FirebaseFirestore.instance.collection('projects');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'These are the currently joinable groups',
          style: pageTextStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 25,
        ),
        GroupsStream()
      ],
    );
  }
}
