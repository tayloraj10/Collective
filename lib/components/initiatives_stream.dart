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

  final List<String> categories = [];

  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: DropdownButton<String>(
        //     dropdownColor: Colors.blue,
        //     // Dropdown items
        //     items: (['Remove Filter'] + categories).map((String value) {
        //       return DropdownMenuItem<String>(
        //         value: value,
        //         child: Text(value, style: TextStyle(color: Colors.white)),
        //       );
        //     }).toList(),

        //     // Value of the selected item
        //     value: selectedFilter,

        //     // Hint displayed when no item is selected
        //     hint: Text('Filter By Category',
        //         style: TextStyle(color: Colors.white)),

        //     // Action when an item is selected
        //     onChanged: (String? newValue) {
        //       setState(() {
        //         selectedFilter = newValue;
        //       });
        //       if (selectedFilter == 'Remove Filter') {
        //         projects = FirebaseFirestore.instance
        //             .collection('initiatives')
        //             .where('active', isEqualTo: true)
        //             .orderBy('complete', descending: true);
        //         selectedFilter = null;
        //       } else {
        //         projects = FirebaseFirestore.instance
        //             .collection('initiatives')
        //             .where('active', isEqualTo: true)
        //             .where('category', isEqualTo: selectedFilter)
        //             .orderBy('complete', descending: true);
        //       }
        //     },
        //   ),
        // ),
        StreamBuilder<QuerySnapshot>(
          stream: projects.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Something went wrong',
                  style: TextStyle(color: Colors.white));
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
                if (colorMapping.containsKey(data['title'])) {
                  color = colorMapping[data['title']]!;
                } else {
                  colorMapping[data['title']] = colors[colorIndex];
                  color = colors[colorIndex];
                  colorIndex++;
                  if (colorIndex == colors.length) {
                    colorIndex = 0;
                  }
                }
                if (data['category'] != null &&
                    !categories.contains(data['category']) &&
                    selectedFilter == null) {
                  categories.add(data['category']);
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
        ),
      ],
    );
  }
}
