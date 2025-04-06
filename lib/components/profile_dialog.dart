import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/topic_chip.dart';
import 'package:collective/constants.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ProfileDialog extends StatefulWidget {
  final String userId;
  ProfileDialog(this.userId);

  @override
  State<ProfileDialog> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProfileDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      backgroundColor: Colors.grey.shade900,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white70,
      ),
      title: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: widget.userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map docData = document.data() as Map<String, dynamic>;
                docData['id'] = document.id;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      docData['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          }),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uid', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map docData = document.data() as Map<String, dynamic>;
                      docData['id'] = document.id;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (docData['profilePicture'] != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: CircleAvatar(
                                radius: 60.0,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                        docData['profilePicture'])),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          if (docData['city'] != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: SelectableText(
                                docData['city'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          if (docData['tiktok'] != null &&
                              docData['tiktok'] != '')
                            GestureDetector(
                              onTap: () => launchURL(
                                  'https://www.tiktok.com/@' +
                                      docData['tiktok']),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          Image.asset('images/' + 'tiktok.png'),
                                      onPressed: () => {},
                                    ),
                                    Text(
                                      docData['tiktok'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (docData['instagram'] != null &&
                              docData['instagram'] != '')
                            GestureDetector(
                              onTap: () => launchURL(
                                  'https://www.instagram.com/' +
                                      docData['instagram']),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Image.asset(
                                          'images/' + 'instagram.png'),
                                      onPressed: () => {},
                                    ),
                                    Text(
                                      docData['instagram'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (docData['youtube'] != null &&
                              docData['youtube'] != '')
                            GestureDetector(
                              onTap: () => launchURL(
                                  'https://www.youtube.com/@' +
                                      docData['youtube']),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Image.asset(
                                          'images/' + 'youtube.png'),
                                      onPressed: () => {},
                                    ),
                                    Text(
                                      docData['youtube'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Projects: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      )),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('projects')
                        .where('active', isEqualTo: true)
                        .where('users', arrayContains: widget.userId)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('No projects joined yet',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              )),
                        );
                      }

                      return Container(
                        width: MediaQuery.of(context).size.width > 1000
                            ? MediaQuery.of(context).size.width * .3
                            : MediaQuery.of(context).size.width * .4,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: snapshot.data!.docs
                              .mapIndexed((index, DocumentSnapshot document) {
                            Map docData =
                                document.data() as Map<String, dynamic>;
                            docData['id'] = document.id;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: TopicChip(docData['title']),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
