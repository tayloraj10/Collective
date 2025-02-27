import 'package:collective/components/topic_chip.dart';
import 'package:collective/constants.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final Map data;
  final Color color;
  ProjectCard({required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Card(
          color: color,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                    Container(
                      color: getProjectColor(data['status'], color),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['status'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  data['description'],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                TopicChip(data['topic'])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
