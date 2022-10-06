import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/models/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupCard extends StatelessWidget {
  final Map data;
  GroupCard({this.data});

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

    groupRef.update({
      "users": groupData['users'] == null ? [uid] : groupData['users'].add(uid)
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  leaveGroup(uid, groupData) {
    final groupRef =
        FirebaseFirestore.instance.collection("groups").doc(groupData['id']);

    groupRef.update({
      "users": groupData['users'].removeWhere((id) => id == uid)
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    var userData = Provider.of<AppData>(context, listen: true).userData;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                data['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              subtitle: Text(
                data['description'],
                style: TextStyle(fontSize: 22),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  height: double.infinity,
                  child: ElevatedButton(
                    child: Text(isInGroup(data, userData)
                        ? 'Leave Group'
                        : 'Join Group'),
                    onPressed: () {
                      if (isInGroup(data, userData)) {
                        leaveGroup(user.uid, data);
                      } else {
                        joinGroup(user.uid, data);
                      }
                    },
                  ),
                ),
              ),
              trailing: Text(
                (data['users'] == null
                        ? '0'
                        : data['users'].length.toString()) +
                    "\nMembers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
