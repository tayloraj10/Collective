import 'package:collective/components/projects_stream.dart';
import 'package:collective/constants.dart';
import 'package:collective/screens/groups.dart';
import 'package:collective/screens/ideas.dart';
import 'package:collective/screens/project_detail.dart';
import 'package:flutter/material.dart';

class Projects extends StatefulWidget {
  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  // var projects = FirebaseFirestore.instance.collection('projects');

  bool showGroups = false;
  bool showProject = false;
  bool showIdeas = false;
  late Map projectData;

  void showProjectDetails(data) {
    setState(() {
      this.showProject = true;
      this.projectData = data;
    });
    print(data);
  }

  void backToProjects() {
    setState(() {
      this.showProject = false;
    });
  }

  void backToProjectsFromIdeas() {
    setState(() {
      this.showIdeas = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var user = FirebaseAuth.instance.currentUser;

    return showIdeas
        ? Ideas(
            exitFunction: backToProjectsFromIdeas,
          )
        : LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
            return Container(
              color: SecondaryColor,
              child: Column(
                children: [
                  // Header section always visible
                  !showProject
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 16),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              Text(
                                'These are the currently ongoing projects (click for more info)',
                                style: pageTextStyle,
                                textAlign: TextAlign.center,
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    showIdeas = !showIdeas;
                                  });
                                },
                                icon: Icon(Icons.lightbulb),
                                label: Text(
                                  "Ideas",
                                  style: TextStyle(
                                      fontSize: mediumTextSize,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: Scrollbar(
                        child: !showProject
                            ? (showGroups
                                ? Groups()
                                : SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 15),
                                        ProjectsStream(this.showProjectDetails),
                                      ],
                                    ),
                                  ))
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                          onPressed: backToProjects,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Text(
                                              'Back to Projects',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ProjectDetail(this.projectData),
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
          });
  }
}
