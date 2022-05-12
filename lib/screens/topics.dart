import 'package:collective/components/topics_stream.dart';
import 'package:collective/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/topic_card.dart';
import 'package:accordion/accordion.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Topics extends StatefulWidget {
  @override
  _TopicsState createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {
  var topics = FirebaseFirestore.instance.collection('topics');
  List<String> topicList = [];

  String topic;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  Future<void> getTopics() async {
    var t = await topics.get();
    t.docs.forEach((e) {
      if (!topicList.contains(e.data()['topic'])) {
        setState(() {
          topicList.add(e.data()['topic']);
        });
      }
    });
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
                    ElevatedButton(
                      onPressed: () async {
                        await getTopics();
                        showModalBottomSheet<void>(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * .5,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    Container(
                                      width: 150,
                                      child: TextField(
                                        controller: title,
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
                                        controller: description,
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
                                              String id;
                                              Map data;
                                              topics
                                                  .where('topic',
                                                      isEqualTo: topic)
                                                  .get()
                                                  .then((value) {
                                                id = value.docs.first.id;
                                                data = value.docs.first.data();
                                                data['subtopics'].add({
                                                  'description':
                                                      description.text,
                                                  'title': title.text
                                                });
                                                topics.doc(id).set(data);
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red),
                                          child: Text('Cancel'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
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
