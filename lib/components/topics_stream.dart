import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/topic_card.dart';
import 'package:flutter/material.dart';

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

        return Column(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            print(document.data());
            return TopicCard(
              title: document.data()['topic'],
              subtopics: document.data()['subtopics'],
            );
          }).toList(),
        );
      },
    );
    ;
  }
}
