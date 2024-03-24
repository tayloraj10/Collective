import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'group_card.dart';

class GroupsStream extends StatefulWidget {
  @override
  _GroupsStreamState createState() => _GroupsStreamState();
}

class _GroupsStreamState extends State<GroupsStream> {
  var projects = FirebaseFirestore.instance.collection('groups');

  @override
  Widget build(BuildContext context) {
    // List<Color> colors = [
    //   Colors.blue,
    //   Colors.red,
    //   Colors.orange,
    //   Colors.green,
    //   Colors.yellow,
    //   Colors.grey,
    // ];
    // int colorIndex = 0;
    // Map<String, Color> colorMapping = {};

    return StreamBuilder<QuerySnapshot>(
      stream: projects.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // if (snapshot.hasError) {
        //   return Text('Something went wrong');
        // }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Column(
          children: snapshot.data.docs.map((DocumentSnapshot<Object> document) {
            Map docData = document.data();
            docData['id'] = document.id;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GroupCard(
                  data: docData,
                ),
                // Column(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(top: 20),
                //       child: Text(
                //         'Members',
                //         style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 22,
                //             fontWeight: FontWeight.bold),
                //       ),
                //     ),
                // StreamBuilder<QuerySnapshot>(
                //   stream: FirebaseFirestore.instance
                //       .collection('users')
                //       .where('uid', whereIn: docData['users'].sublist(1))
                //       .snapshots(),
                //   builder: (BuildContext context,
                //       AsyncSnapshot<QuerySnapshot> snapshot) {
                //     if (snapshot.hasError) {
                //       print('Something went wrong');
                //     }

                //     if (snapshot.connectionState ==
                //         ConnectionState.waiting) {
                //       return CircularProgressIndicator();
                //     }

                //     return Padding(
                //       padding: const EdgeInsets.only(top: 10, bottom: 50),
                //       child: SingleChildScrollView(
                //         scrollDirection: Axis.horizontal,
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: snapshot.data.docs
                //               .map((DocumentSnapshot<Object> document) {
                //             Map docData = document.data();
                //             docData['id'] = document.id;
                //             return Tooltip(
                //                 message: docData['name'],
                //                 child: GestureDetector(
                //                   onTap: (() => {
                //                         showDialog(
                //                             context: context,
                //                             builder: (context) =>
                //                                 ProfileDialog(
                //                                     docData['user_id']))
                //                         // Navigator.push(
                //                         //   context,
                //                         //   MaterialPageRoute(
                //                         //     builder: (context) =>
                //                         //         UserDetails(docData['uid']),
                //                         //   ),
                //                         // )
                //                       }),
                //                   child: CircleAvatar(
                //                     child: docData['profilePicture'] != null
                //                         ? ClipRRect(
                //                             borderRadius:
                //                                 BorderRadius.circular(100),
                //                             child: Image.network(
                //                                 docData['profilePicture']))
                //                         : Text(docData['name'].split(' ')[0]
                //                                 [0] +
                //                             docData['name'].split(' ')[1]
                //                                 [0]),
                //                     backgroundColor: Colors.transparent,
                //                   ),
                //                 ));
                //           }).toList(),
                //         ),
                //       ),
                //     );
                //   },
                // ),
                //   ],
                // ),
                SizedBox(
                  height: 20,
                )
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
