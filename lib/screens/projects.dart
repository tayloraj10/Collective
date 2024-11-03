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
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Scrollbar(
                  child: Container(
                    color: SecondaryColor,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 75),
                      child: !showProject
                          ? Column(
                              children: [
                                // if (user != null)
                                //   Padding(
                                //     padding: const EdgeInsets.only(bottom: 20),
                                //     child: ElevatedButton(
                                //         onPressed: () {
                                //           setState(() {
                                //             showGroups = !showGroups;
                                //           });
                                //         },
                                //         child: Padding(
                                //             padding:
                                //                 EdgeInsets.symmetric(vertical: 16),
                                //             child: Wrap(
                                //               crossAxisAlignment:
                                //                   WrapCrossAlignment.center,
                                //               children: [
                                //                 Text(
                                //                   'View ${showGroups ? 'Projects' : 'Groups'}',
                                //                   style: TextStyle(
                                //                     fontWeight: FontWeight.bold,
                                //                     fontSize: 22,
                                //                   ),
                                //                 )
                                //               ],
                                //             ))),
                                //   ),
                                showGroups && !showProject
                                    ? Groups()
                                    : Column(
                                        children: [
                                          Wrap(
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
                                                onPressed: () => {
                                                  setState(() {
                                                    showIdeas = !showIdeas;
                                                  })
                                                },
                                                icon: Icon(Icons.lightbulb),
                                                label: Text(
                                                  "Ideas",
                                                  style: TextStyle(
                                                      fontSize: mediumTextSize,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          ProjectsStream(
                                              this.showProjectDetails)
                                        ],
                                      ),
                              ],
                            )
                          : Column(
                              children: [
                                ElevatedButton(
                                    onPressed: backToProjects,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
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
            );
          });
  }
}
