import 'package:flutter/material.dart';

class AccordionContent extends StatelessWidget {
  final String title;
  final List subtopics;

  AccordionContent({required this.title, required this.subtopics});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: this.subtopics.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${e['title']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Wrap(
                children: [
                  Text(
                    "${e['description']}",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Divider(
                  thickness: 5,
                  height: 5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
