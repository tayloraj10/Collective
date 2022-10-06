import 'package:collective/components/projects_stream.dart';
import 'package:collective/constants.dart';
import 'package:collective/screens/groups.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Projects extends StatefulWidget {
  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  var projects = FirebaseFirestore.instance.collection('projects');

  bool showGroups = false;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: Scrollbar(
            child: Container(
              color: SecondaryColor,
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    if (user != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showGroups = !showGroups;
                              });
                            },
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      'View ${showGroups ? 'Projects' : 'Groups'}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    )
                                  ],
                                ))),
                      ),
                    showGroups
                        ? Groups()
                        : Column(
                            children: [
                              Text(
                                'These are the currently ongoing projects',
                                style: pageTextStyle,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              ProjectsStream()
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
