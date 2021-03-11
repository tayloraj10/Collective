import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/project_card.dart';
import 'package:collective/components/topic_card.dart';
import 'package:flutter/material.dart';

class ProjectsStream extends StatefulWidget {
  @override
  _ProjectsStreamState createState() => _ProjectsStreamState();
}

class _ProjectsStreamState extends State<ProjectsStream> {
  var topics = FirebaseFirestore.instance.collection('projects');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: topics.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // if (snapshot.hasError) {
        //   return Text('Something went wrong');
        // }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Column(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            // print(document.data());
            return ProjectCard(
              data: document.data(),
            );
          }).toList(),
        );
      },
    );
    ;
  }
}
