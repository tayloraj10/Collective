import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/accordion_content.dart';
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';

class TopicsStream extends StatefulWidget {
  @override
  _TopicsStreamState createState() => _TopicsStreamState();
}

class _TopicsStreamState extends State<TopicsStream> {
  var topics = FirebaseFirestore.instance.collection('topics');

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

        return Container(
          margin: EdgeInsets.only(bottom: 25),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height,
          child: Accordion(
            maxOpenSections: 1,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              // print(document.data());
              Map data = document.data() as Map;

              return AccordionSection(
                isOpen: false,
                header: Text(
                  data['topic'],
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                content: AccordionContent(
                  title: data['topic'],
                  subtopics: data['subtopics'],
                ),
              );
            }).toList(),
          ),
        );
        // Column(
        //   children: snapshot.data.docs.map((DocumentSnapshot document) {
        //     // print(document.data());
        //     return TopicCard(
        //       title: document.data()['topic'],
        //       subtopics: document.data()['subtopics'],
        //     );
        //   }).toList(),
        // );
      },
    );
  }
}
