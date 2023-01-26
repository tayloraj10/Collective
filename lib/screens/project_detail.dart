import 'package:flutter/material.dart';

class ProjectDetail extends StatelessWidget {
  final Map data;

  ProjectDetail(this.data);

  @override
  Widget build(BuildContext context) {
    // print(data);
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Text(
              data['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              data['description'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              data['topic'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
