import 'package:collective/components/topics_stream.dart';
import 'package:collective/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Ideas extends StatefulWidget {
  final Function exitFunction;

  const Ideas({Key? key, required this.exitFunction}) : super(key: key);
  @override
  _IdeasState createState() => _IdeasState();
}

class _IdeasState extends State<Ideas> {
  var ideas = FirebaseFirestore.instance.collection('topics');
  List<String> topicList = [];
  bool newTopic = false;
  String? topic = null;
  bool topicError = false;
  String topicErrorText = '';
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
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return Container(
        color: SecondaryColor,
        child: Padding(
          padding: EdgeInsets.only(top: 15, bottom: 60),
          child: Column(
            children: [
              // ElevatedButton(
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(vertical: 8),
              //     child: Wrap(
              //       crossAxisAlignment: WrapCrossAlignment.center,
              //       children: [
              //         Icon(Icons.pin_drop),
              //         SizedBox(
              //           width: 6,
              //         ),
              //         Text(
              //           'View Interesting Locations',
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 18,
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              //   onPressed: (() => {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => InterestingLocations(),
              //           ),
              //         )
              //       }),
              // ),
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 10,
                spacing: 10,
                children: [
                  Text(
                    'These are potential topics for new projects or events',
                    style: pageTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => {
                      widget.exitFunction(),
                    },
                    icon: Icon(Icons.handyman),
                    label: Text(
                      "Projects",
                      style: TextStyle(
                          fontSize: mediumTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              if (user != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ElevatedButton(
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
                                      MediaQuery.of(context).size.height * .5,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (topicError)
                                          Text(
                                            topicErrorText,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 150,
                                          child: DropdownSearch<String>(
                                            items: topicList,
                                            onChanged: (value) {
                                              setState(() {
                                                topic = value!;
                                                value == 'New Topic'
                                                    ? newTopic = true
                                                    : newTopic = false;
                                              });
                                            },
                                          ),
                                        ),
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
                                                labelText: 'Idea Description'),
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
                                                    setState(
                                                      () {
                                                        topicErrorText =
                                                            "Please pick a topic option";
                                                        topicError = true;
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
                                                            topicCont.text)) {
                                                      setState(
                                                        () {
                                                          topicErrorText =
                                                              "Topic cannot be empty or already exist";
                                                          topicError = true;
                                                        },
                                                      );
                                                    } else {
                                                      setState(
                                                        () {
                                                          topicErrorText = "";
                                                          topicError = false;
                                                        },
                                                      );
                                                      ideas.doc().set({
                                                        'topic': topicCont.text,
                                                        'subtopics': [
                                                          {
                                                            'title':
                                                                titleCont.text,
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
                                                            isEqualTo: topic)
                                                        .get()
                                                        .then((value) {
                                                      id = value.docs.first.id;
                                                      data = value.docs.first
                                                          .data();
                                                      data['subtopics'].add({
                                                        'description':
                                                            descriptionCont
                                                                .text,
                                                        'title': titleCont.text
                                                      });
                                                      ideas.doc(id).set(data
                                                          as Map<String,
                                                              dynamic>);
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                }),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
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
                ),
              Expanded(
                child: Scrollbar(
                  child: TopicsStream(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
