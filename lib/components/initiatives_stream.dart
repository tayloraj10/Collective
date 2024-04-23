import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/initiatives_card.dart';
import 'package:flutter/material.dart';

class InitiativesStream extends StatefulWidget {
  // final Function showDetails;
  // InitiativesStream(this.showDetails);

  @override
  _InitiativesStreamState createState() => _InitiativesStreamState();
}

class _InitiativesStreamState extends State<InitiativesStream> {
  var projects = FirebaseFirestore.instance
      .collection('initiatives')
      .where('active', isEqualTo: true)
      .orderBy('complete', descending: true);

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.yellow,
      Colors.grey,
      Colors.purple,
    ];
    int colorIndex = 0;
    Map<String, Color> colorMapping = {};

    return StreamBuilder<QuerySnapshot>(
      stream: projects.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // if (snapshot.hasError) {
        //   print(snapshot.error);
        //   return Text('Something went wrong');
        // }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Column(
          children: snapshot.data.docs.map((DocumentSnapshot<Object> document) {
            // print(document.data());
            Color color;
            Map data = document.data() as Map;
            data['id'] = document.id;
            if (colorMapping.containsKey(data['title'])) {
              color = colorMapping[data['title']];
            } else {
              colorMapping[data['title']] = colors[colorIndex];
              color = colors[colorIndex];
              colorIndex++;
              if (colorIndex == colors.length) {
                colorIndex = 0;
              }
            }
            return GestureDetector(
              // onTap: () => {widget.showDetails(data)},
              child: InitiativeCard(
                data: data,
                color: color,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
