import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/resource_link.dart';
import 'package:collective/models/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/profile_dialog.dart';

class ProjectDetail extends StatefulWidget {
  final Map data;

  ProjectDetail(this.data);

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
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
        FirebaseFirestore.instance.collection("projects").doc(groupData['id']);
    var users = groupData['users'];
    users.add(uid);

    groupRef.update({"users": users}).then(
        (value) =>
            {print("DocumentSnapshot successfully updated!"), setState(() {})},
        onError: (e) => print("Error updating document $e"));
  }

  leaveGroup(uid, groupData) {
    final groupRef =
        FirebaseFirestore.instance.collection("projects").doc(groupData['id']);

    var users = groupData['users'];
    users.removeWhere((id) => id == uid);

    groupRef.update({"users": users}).then(
        (value) =>
            {print("DocumentSnapshot successfully updated!"), setState(() {})},
        onError: (e) => print("Error updating document $e"));
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    var userData = Provider.of<AppData>(context, listen: true).userData;

    getColor(status) {
      if (status == 'Active')
        return Colors.green;
      else if (status == 'Inactive') return Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          if (isInGroup(widget.data, userData))
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'You are a member of this project',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          Container(
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
                          child: Text(isInGroup(widget.data, userData)
                              ? 'Leave Project'
                              : 'Join Project'),
                          onPressed: () {
                            if (isInGroup(widget.data, userData)) {
                              leaveGroup(user!.uid, widget.data);
                            } else {
                              joinGroup(user!.uid, widget.data);
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            // mainAxisSize: MainAxisSize.min,
                            spacing: 20,
                            children: [
                              Text(
                                widget.data['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 28),
                              ),
                              if (widget.data['status'] != null)
                                Text(
                                  widget.data['status'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      color: getColor(widget.data['status'])),
                                )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              widget.data['description'],
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          if (widget.data['projectUrl'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ResourceLink(
                                text: widget.data['projectUrl'],
                                url: widget.data['projectUrl'],
                              ),
                            ),
                          if (widget.data['documentationUrl'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ResourceLink(
                                text: widget.data['documentationUrl'],
                                url: widget.data['documentationUrl'],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              widget.data['topic'],
                              style: TextStyle(fontSize: 18),
                            ),
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
                            ((widget.data['users'].length - 1).toString()) +
                                "\nMembers",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isInGroup(widget.data, userData))
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Members',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('uid', whereIn: widget.data['users'].sublist(1))
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map docData =
                                  document.data() as Map<String, dynamic>;
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
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.network(
                                                  docData['profilePicture']))
                                          : Text(docData['name'].split(' ')[0]
                                                  [0] +
                                              docData['name'].split(' ')[1][0]),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ));
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
