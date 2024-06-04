import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/models/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupCard extends StatelessWidget {
  final Map data;
  GroupCard({required this.data});

  bool isInGroup(groupData, userData) {
    if (groupData['users'] == null)
      return false;
    else if (groupData['users'].contains(userData['uid']))
      return true;
    else
      return false;
  }

  joinGroup(uid, groupData) {
    final groupRef =
        FirebaseFirestore.instance.collection("groups").doc(groupData['id']);

    var users = groupData['users'];
    users.add(uid);

    groupRef.update({"users": users}).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  leaveGroup(uid, groupData) {
    final groupRef =
        FirebaseFirestore.instance.collection("groups").doc(groupData['id']);

    var users = groupData['users'];
    users.removeWhere((id) => id == uid);

    groupRef.update({"users": users}).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    var userData = Provider.of<AppData>(context, listen: true).userData;

    return Container(
      // width: MediaQuery.of(context).size.width * 0.6,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  child: ElevatedButton(
                    child: Text(isInGroup(data, userData)
                        ? 'Leave Group'
                        : 'Join Group'),
                    onPressed: () {
                      if (isInGroup(data, userData)) {
                        leaveGroup(user!.uid, data);
                      } else {
                        joinGroup(user!.uid, data);
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    Text(
                      data['description'],
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ((data['users'].length - 1).toString()) + "\nMembers",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ListTile(
          //   title: Column(
          //     children: [
          //       Text(
          //         data['name'],
          //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          //       ),
          //     ],
          //   ),
          //   subtitle: Column(
          //     children: [
          //       Text(
          //         data['description'],
          //         style: TextStyle(fontSize: 22),
          //       ),
          //     ],
          //   ),
          //   leading: Padding(
          //     padding: const EdgeInsets.only(right: 10),
          //     child: Container(
          //       height: double.infinity,
          //       child: ElevatedButton(
          //         child: Text(isInGroup(data, userData)
          //             ? 'Leave Group'
          //             : 'Join Group'),
          //         onPressed: () {
          //           if (isInGroup(data, userData)) {
          //             leaveGroup(user.uid, data);
          //           } else {
          //             joinGroup(user.uid, data);
          //           }
          //         },
          //       ),
          //     ),
          //   ),
          //   trailing: Column(
          //     children: [
          //       Text(
          //         (data['users'] == null
          //                 ? '0'
          //                 : data['users'].length.toString()) +
          //             "\nMembers",
          //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          //         textAlign: TextAlign.center,
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
