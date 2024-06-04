import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/project_card.dart';
import 'package:flutter/material.dart';

class ProjectsStream extends StatefulWidget {
  final Function showDetails;
  ProjectsStream(this.showDetails);

  @override
  _ProjectsStreamState createState() => _ProjectsStreamState();
}

class _ProjectsStreamState extends State<ProjectsStream> {
  var projects = FirebaseFirestore.instance
      .collection('projects')
      .where('active', isEqualTo: true)
      .orderBy('topic');

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.yellow.shade600,
      Colors.grey,
    ];
    int colorIndex = 0;
    Map<String, Color> colorMapping = {};

    return StreamBuilder<QuerySnapshot>(
      stream: projects.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            // print(document.data());
            Color color;
            Map data = document.data() as Map<String, dynamic>;
            data['id'] = document.id;
            if (colorMapping.containsKey(data['topic'])) {
              color = colorMapping[data['topic']]!;
            } else {
              colorMapping[data['topic']] = colors[colorIndex];
              color = colors[colorIndex];
              colorIndex++;
              if (colorIndex == colors.length) {
                colorIndex = 0;
              }
            }
            return GestureDetector(
              onTap: () => {widget.showDetails(data)},
              child: ProjectCard(
                data: document.data() as Map<String, dynamic>,
                color: color,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
