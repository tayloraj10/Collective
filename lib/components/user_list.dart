import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/profile_dialog.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final List userList;

  UserList(this.userList);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: userList)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map docData = document.data() as Map<String, dynamic>;
                print(docData);
                docData['id'] = document.id;
                return Tooltip(
                    message: docData['name'],
                    child: GestureDetector(
                      onTap: (() => {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    ProfileDialog(docData['uid']))
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         UserDetails(docData['uid']),
                            //   ),
                            // )
                          }),
                      child: CircleAvatar(
                        child: docData['profilePicture'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(docData['profilePicture']))
                            : Text(docData['name'].split(' ')[0][0] +
                                docData['name'].split(' ')[1][0]),
                        backgroundColor: Colors.transparent,
                      ),
                    ));
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
