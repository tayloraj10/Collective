import 'package:collective/components/topics_stream.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';

class Ideas extends StatefulWidget {
  @override
  _IdeasState createState() => _IdeasState();
}

class _IdeasState extends State<Ideas> {
  FirebaseAuth auth;

  var ideas = FirebaseFirestore.instance.collection('topics');
  List<String> topicList = [];
  bool newTopic = false;
  String topic;
  TextEditingController topicCont = TextEditingController();
  TextEditingController titleCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  Future<void> getTopics() async {
    topicList = [];
    var t = await ideas.get();
    t.docs.forEach((e) {
      if (!topicList.contains(e.data()['topic'])) {
        setState(() {
          topicList.add(e.data()['topic']);
        });
      }
    });
    topicList.add('New Topic');
  }

  void initState() {
    super.initState();
    auth = Provider.of<AppData>(context, listen: false).getFirebaseAuth();
  }

  @override
  Widget build(BuildContext context) {
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
                    if (auth.currentUser != null)
                      ElevatedButton(
                        onPressed: () async {
                          await getTopics();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                        content: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .5,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 150,
                                              child: DropdownSearch<String>(
                                                mode: Mode.MENU,
                                                showSelectedItem: true,
                                                items: topicList,
                                                hint: "Choose a Topic",
                                                onChanged: (value) {
                                                  setState(() {
                                                    topic = value;
                                                    value == 'New Topic'
                                                        ? newTopic = true
                                                        : newTopic = false;
                                                  });
                                                },
                                              ),
                                            ),
                                            // DropdownButton<String>(
                                            //   value: topic,
                                            //   hint: Text("Choose a Topic"),
                                            //   items: topicList.map((String value) {
                                            //     return DropdownMenuItem<String>(
                                            //       value: value,
                                            //       child: Text(value),
                                            //     );
                                            //   }).toList(),
                                            //   onChanged: (v) {
                                            //     setState(() {
                                            //       topic = v;
                                            //     });
                                            //     // print(topic);
                                            //   },
                                            // ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            if (newTopic)
                                              Container(
                                                width: 150,
                                                child: TextField(
                                                  controller: topicCont,
                                                  decoration: InputDecoration(
                                                    labelText: 'Topic',
                                                  ),
                                                ),
                                              ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 150,
                                              child: TextField(
                                                controller: titleCont,
                                                decoration: InputDecoration(
                                                  labelText: 'Idea Name',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 150,
                                              child: TextField(
                                                controller: descriptionCont,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Idea Description'),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    child: Text('Submit'),
                                                    onPressed: () {
                                                      if (topic == null) {
                                                        AlertDialog alert =
                                                            AlertDialog(
                                                          title: Text("Error"),
                                                          content: Text(
                                                              "Please pick a topic option"),
                                                          actions: [],
                                                        );
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return alert;
                                                          },
                                                        );
                                                      } else if (newTopic ||
                                                          topic == null) {
                                                        if (topicCont.text.isEmpty ||
                                                            titleCont
                                                                .text.isEmpty ||
                                                            descriptionCont
                                                                .text.isEmpty ||
                                                            topicList.contains(
                                                                topicCont
                                                                    .text)) {
                                                          AlertDialog alert =
                                                              AlertDialog(
                                                            title:
                                                                Text("Error"),
                                                            content: Text(
                                                                "Topic cannot be empty or already exist"),
                                                            actions: [],
                                                          );
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return alert;
                                                            },
                                                          );
                                                        } else {
                                                          ideas.doc().set({
                                                            'topic':
                                                                topicCont.text,
                                                            'subtopics': [
                                                              {
                                                                'title':
                                                                    titleCont
                                                                        .text,
                                                                'description':
                                                                    descriptionCont
                                                                        .text
                                                              }
                                                            ]
                                                          });
                                                        }
                                                      } else {
                                                        String id;
                                                        Map data;
                                                        ideas
                                                            .where('topic',
                                                                isEqualTo:
                                                                    topic)
                                                            .get()
                                                            .then((value) {
                                                          id = value
                                                              .docs.first.id;
                                                          data = value
                                                              .docs.first
                                                              .data();
                                                          data['subtopics']
                                                              .add({
                                                            'description':
                                                                descriptionCont
                                                                    .text,
                                                            'title':
                                                                titleCont.text
                                                          });
                                                          ideas
                                                              .doc(id)
                                                              .set(data);
                                                        });
                                                      }
                                                      Navigator.pop(context);
                                                    }),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red),
                                                  child: Text('Cancel'),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                                  },
                                );
                              });
                          // showModalBottomSheet<void>(
                          //   context: context,
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.only(
                          //       topLeft: Radius.circular(5),
                          //       topRight: Radius.circular(5),
                          //     ),
                          //   ),
                          //   builder: (BuildContext builderContext) {
                          //     return StatefulBuilder(
                          //       builder: (BuildContext statefulBuilderContext,
                          //           StateSetter setState) {
                          //         return Container(
                          //           height:
                          //               MediaQuery.of(context).size.height * .5,
                          //           child: Center(
                          //             child: Column(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.center,
                          //               mainAxisSize: MainAxisSize.min,
                          //               children: [
                          //                 Container(
                          //                   width: 150,
                          //                   child: DropdownSearch<String>(
                          //                     mode: Mode.MENU,
                          //                     showSelectedItem: true,
                          //                     items: topicList,
                          //                     hint: "Choose a Topic",
                          //                     onChanged: (value) {
                          //                       setState(() {
                          //                         topic = value;
                          //                         value == 'New Topic'
                          //                             ? newTopic = true
                          //                             : newTopic = false;
                          //                       });
                          //                     },
                          //                   ),
                          //                 ),
                          //                 // DropdownButton<String>(
                          //                 //   value: topic,
                          //                 //   hint: Text("Choose a Topic"),
                          //                 //   items: topicList.map((String value) {
                          //                 //     return DropdownMenuItem<String>(
                          //                 //       value: value,
                          //                 //       child: Text(value),
                          //                 //     );
                          //                 //   }).toList(),
                          //                 //   onChanged: (v) {
                          //                 //     setState(() {
                          //                 //       topic = v;
                          //                 //     });
                          //                 //     // print(topic);
                          //                 //   },
                          //                 // ),
                          //                 SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 if (newTopic)
                          //                   Container(
                          //                     width: 150,
                          //                     child: TextField(
                          //                       controller: topicCont,
                          //                       decoration: InputDecoration(
                          //                         labelText: 'Topic',
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 Container(
                          //                   width: 150,
                          //                   child: TextField(
                          //                     controller: titleCont,
                          //                     decoration: InputDecoration(
                          //                       labelText: 'Idea Name',
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 Container(
                          //                   width: 150,
                          //                   child: TextField(
                          //                     controller: descriptionCont,
                          //                     decoration: InputDecoration(
                          //                         labelText:
                          //                             'Idea Description'),
                          //                   ),
                          //                 ),
                          //                 SizedBox(
                          //                   height: 20,
                          //                 ),
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.center,
                          //                   children: [
                          //                     ElevatedButton(
                          //                         child: Text('Submit'),
                          //                         onPressed: () {
                          //                           if (topic == null) {
                          //                             AlertDialog alert =
                          //                                 AlertDialog(
                          //                               title: Text("Error"),
                          //                               content: Text(
                          //                                   "Please pick a topic option"),
                          //                               actions: [],
                          //                             );
                          //                             showDialog(
                          //                               context: context,
                          //                               builder: (BuildContext
                          //                                   context) {
                          //                                 return alert;
                          //                               },
                          //                             );
                          //                           } else if (newTopic ||
                          //                               topic == null) {
                          //                             if (topicCont.text.isEmpty ||
                          //                                 titleCont
                          //                                     .text.isEmpty ||
                          //                                 descriptionCont
                          //                                     .text.isEmpty ||
                          //                                 topicList.contains(
                          //                                     topicCont.text)) {
                          //                               AlertDialog alert =
                          //                                   AlertDialog(
                          //                                 title: Text("Error"),
                          //                                 content: Text(
                          //                                     "Topic cannot be empty or already exist"),
                          //                                 actions: [],
                          //                               );
                          //                               showDialog(
                          //                                 context: context,
                          //                                 builder: (BuildContext
                          //                                     context) {
                          //                                   return alert;
                          //                                 },
                          //                               );
                          //                             } else {
                          //                               ideas.doc().set({
                          //                                 'topic':
                          //                                     topicCont.text,
                          //                                 'subtopics': [
                          //                                   {
                          //                                     'title': titleCont
                          //                                         .text,
                          //                                     'description':
                          //                                         descriptionCont
                          //                                             .text
                          //                                   }
                          //                                 ]
                          //                               });
                          //                             }
                          //                           } else {
                          //                             String id;
                          //                             Map data;
                          //                             ideas
                          //                                 .where('topic',
                          //                                     isEqualTo: topic)
                          //                                 .get()
                          //                                 .then((value) {
                          //                               id =
                          //                                   value.docs.first.id;
                          //                               data = value.docs.first
                          //                                   .data();
                          //                               data['subtopics'].add({
                          //                                 'description':
                          //                                     descriptionCont
                          //                                         .text,
                          //                                 'title':
                          //                                     titleCont.text
                          //                               });
                          //                               ideas.doc(id).set(data);
                          //                             });
                          //                           }
                          //                           Navigator.pop(context);
                          //                         }),
                          //                     SizedBox(
                          //                       width: 10,
                          //                     ),
                          //                     ElevatedButton(
                          //                       style: ElevatedButton.styleFrom(
                          //                           primary: Colors.red),
                          //                       child: Text('Cancel'),
                          //                       onPressed: () =>
                          //                           Navigator.pop(context),
                          //                     )
                          //                   ],
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //     );
                          //   },
                          // );
                          // topics.add({
                          //   'description': 'test', // John Doe
                          //   'title': 'test', // Stokes and Sons
                          //   'topic': 'test'
                          // });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(Icons.add),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Add an Idea',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      'These are potential topics for new projects or events',
                      style: pageTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TopicsStream(),
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
