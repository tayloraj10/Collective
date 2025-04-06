import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/resource_link.dart';
import 'package:collective/components/topic_chip.dart';
import 'package:collective/components/user_list.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            Text(
                              widget.data['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: Colors.black),
                            ),
                            if (widget.data['status'] != null)
                              Container(
                                decoration: BoxDecoration(
                                  color: getProjectColor(widget.data['status']),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Text(
                                    widget.data['status'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: TopicChip(widget.data['topic']),
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.data['description'],
                          style: TextStyle(fontSize: 18, color: Colors.black87),
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
                        if (widget.data['roles'] != null)
                          if (widget.data['roles']['leaders'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Project Leaders',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  SizedBox(height: 4),
                                  UserList(widget.data['roles']['leaders']),
                                ],
                              ),
                            ),
                        if (widget.data['roles'] != null)
                          if (widget.data['roles']['devs'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Developers',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  SizedBox(height: 4),
                                  UserList(widget.data['roles']['devs']),
                                ],
                              ),
                            ),
                        if (isInGroup(widget.data, userData))
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Members',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 8),
                                UserList(widget.data['users'].sublist(1)),
                              ],
                            ),
                          ),
                        SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isInGroup(widget.data, userData)
                                  ? Colors.red
                                  : Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                            ),
                            child: Text(
                              isInGroup(widget.data, userData)
                                  ? 'Leave Project'
                                  : 'Join Project',
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              if (isInGroup(widget.data, userData)) {
                                leaveGroup(user!.uid, widget.data);
                              } else {
                                joinGroup(user!.uid, widget.data);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
