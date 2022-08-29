import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final Map data;
  final Color color;
  ProjectCard({this.data, this.color});

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
              Text(
                data['title'],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
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
              Text(
                data['topic'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
