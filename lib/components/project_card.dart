import 'package:collective/components/topic_chip.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final Map data;
  final Color color;
  ProjectCard({required this.data, required this.color});

  getColor(status) {
    if (status == 'Active')
      return Colors.green;
    else if (status == 'Inactive') return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: getColor(data['status'])),
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
    );
  }
}
