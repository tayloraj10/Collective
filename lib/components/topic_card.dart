import 'package:collective/constants.dart';
import 'package:flutter/material.dart';

class TopicCard extends StatelessWidget {
  final String title;
  final List subtopics;
  TopicCard({required this.title, required this.subtopics});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 25),
        width: MediaQuery.of(context).size.width * 0.7,
        height: 100,
        child: ExpansionTile(
          title: Container(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                this.title,
                style: pageTextStyle,
              ),
            ),
          ),
          children: [
            Container(
              color: Colors.green[400],
              margin: EdgeInsets.only(left: 17, right: 56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: this.subtopics.map((e) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, left: 5, top: 15),
                        child: Align(
                          child: Text(
                            '\u2022 ' + e['title'] + ": " + e['description'],
                            style: pageTextStyle,
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Divider(
                        thickness: 4,
                      )
                    ],
                  );
                }).toList(),
              ),
            )
          ],

          // map((DocumentSnapshot document) {
          //   print(document.data());
          //   return TopicCard(
          //     title: document.data()['topic'],
          //     subtopics: document.data()['subtopics'],
          //   );
          // }).toList()
        ),
      ),
    );
  }
}
