import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/project_card.dart';
import 'package:collective/components/topic_card.dart';
import 'package:flutter/material.dart';

class ProjectsStream extends StatefulWidget {
  @override
  _ProjectsStreamState createState() => _ProjectsStreamState();
}

class _ProjectsStreamState extends State<ProjectsStream> {
  var projects = FirebaseFirestore.instance.collection('projects');

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.yellow,
      Colors.grey,
    ];
    int colorIndex = 0;
    Map<String, Color> colorMapping = {};

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
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            // print(document.data());
            Color color;
            if (colorMapping.containsKey(document.data()['topic'])) {
              color = colorMapping[document.data()['topic']];
            } else {
              colorMapping[document.data()['topic']] = colors[colorIndex];
              color = colors[colorIndex];
              colorIndex++;
              if (colorIndex == colors.length) {
                colorIndex = 0;
              }
            }
            return ProjectCard(
              data: document.data(),
              color: color,
            );
          }).toList(),
        );
      },
    );
  }
}
