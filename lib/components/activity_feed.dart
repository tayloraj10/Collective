import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/user_list.dart';
import 'package:collective/constants.dart';
import 'package:flutter/material.dart';
import 'package:instant/instant.dart';

class ActivityFeed extends StatefulWidget {
  const ActivityFeed({Key? key}) : super(key: key);

  @override
  State<ActivityFeed> createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text('Activity Feed',
                style: TextStyle(
                    fontSize: largeTextSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('goal_submissions')
                  .where('date',
                      isGreaterThanOrEqualTo:
                          DateTime.now().subtract(Duration(days: 7)))
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Something went wrong',
                      style: TextStyle(color: Colors.white));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  var data = (snapshot.data as QuerySnapshot).docs;

                  if (data.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('No activities in the last week',
                          style: TextStyle(
                              color: Colors.white, fontSize: mediumTextSize)),
                    );
                  }

                  // Group data by date
                  Map<String, List<QueryDocumentSnapshot>> groupedData = {};
                  for (var doc in data) {
                    String date = formatDate(
                        date: doc['date'].toDate(),
                        format: 'YYYYMMDD',
                        divider: '-');

                    if (groupedData[date] == null) {
                      groupedData[date] = [];
                    }
                    groupedData[date]!.add(doc);
                  }
                  print(groupedData);

                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * .75,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: groupedData.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${DateTime.parse(entry.key).month}/${DateTime.parse(entry.key).day} - ${DateTime.parse(entry.key).weekday == 1 ? 'Monday' : DateTime.parse(entry.key).weekday == 2 ? 'Tuesday' : DateTime.parse(entry.key).weekday == 3 ? 'Wednesday' : DateTime.parse(entry.key).weekday == 4 ? 'Thursday' : DateTime.parse(entry.key).weekday == 5 ? 'Friday' : DateTime.parse(entry.key).weekday == 6 ? 'Saturday' : 'Sunday'}",
                                  style: TextStyle(
                                      fontSize: mediumTextSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              ...entry.value.map((doc) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade700,
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.only(
                                          left: 4, right: 1, top: 2, bottom: 2),
                                      dense: true,
                                      leading: doc['userID'] != null
                                          ? UserList([doc['userID']])
                                          : Tooltip(
                                              message: 'Anonymous',
                                              child: CircleAvatar(
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 40,
                                                    )),
                                                backgroundColor:
                                                    Colors.transparent,
                                                foregroundColor: Colors.white,
                                              ),
                                            ),
                                      title: Text(
                                        "${doc['amount'].toString()} ${doc['action'].toString()}",
                                        // "${doc['amount'].toString()} Completed",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // subtitle: Text(
                                      //     doc['initiative'].toString(),
                                      //     style: TextStyle(
                                      //         color: Colors.grey.shade300)),
                                      trailing: (doc.data()
                                                      as Map<String, dynamic>)
                                                  .containsKey('images') &&
                                              doc['images'] != null
                                          ? Tooltip(
                                              message: 'View Images',
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Icon(Icons.image),
                                                color: Colors.white,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor: Colors
                                                            .grey.shade900,
                                                        content: Container(
                                                          width: double
                                                              .minPositive,
                                                          child:
                                                              ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                (doc['images']
                                                                        as List)
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Image
                                                                    .network(
                                                                  doc['images']
                                                                      [index],
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  width: 200,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child: Text(
                                                              'Close',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
