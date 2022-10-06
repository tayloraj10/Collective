import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'group_card.dart';

class GroupsStream extends StatefulWidget {
  @override
  _GroupsStreamState createState() => _GroupsStreamState();
}

class _GroupsStreamState extends State<GroupsStream> {
  var projects = FirebaseFirestore.instance.collection('groups');

  @override
  Widget build(BuildContext context) {
    // List<Color> colors = [
    //   Colors.blue,
    //   Colors.red,
    //   Colors.orange,
    //   Colors.green,
    //   Colors.yellow,
    //   Colors.grey,
    // ];
    // int colorIndex = 0;
    // Map<String, Color> colorMapping = {};

    return StreamBuilder<QuerySnapshot>(
      stream: projects.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // if (snapshot.hasError) {
        //   return Text('Something went wrong');
        // }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Column(
          children: snapshot.data.docs.map((DocumentSnapshot<Object> document) {
            Map docData = document.data();
            docData['id'] = document.id;
            return GroupCard(
              data: docData,
            );
          }).toList(),
        );
      },
    );
  }
}
