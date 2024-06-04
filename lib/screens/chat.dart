import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/profile_dialog.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat({required Key key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final Stream<QuerySnapshot> _chatStream = FirebaseFirestore.instance
      .collection('chat')
      .orderBy('timestamp', descending: true)
      .snapshots();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    var userData = Provider.of<AppData>(context).userData;

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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Welcome to Open Chat!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 32)),
                  ),
                  if (user != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            TextEditingController messageController =
                                new TextEditingController();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            "What's your message?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              controller: messageController,
                                              autofocus: true,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Map<String, dynamic> data = {
                                                    'text':
                                                        messageController.text,
                                                    'timestamp':
                                                        Timestamp.now(),
                                                    'user_id': user.uid,
                                                    'name': userData
                                                            .containsKey('name')
                                                        ? userData['name']
                                                        : "",
                                                    'profilePicture': userData
                                                            .containsKey(
                                                                'profilePicture')
                                                        ? userData[
                                                            'profilePicture']
                                                        : null
                                                  };
                                                  FirebaseFirestore.instance
                                                      .collection('chat')
                                                      .add(data)
                                                      .then(
                                                          (documentSnapshot) =>
                                                              Navigator.pop(
                                                                  context));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Submit',
                                                    style:
                                                        TextStyle(fontSize: 24),
                                                  ),
                                                )),
                                          )
                                        ],
                                        mainAxisSize: MainAxisSize.min,
                                      ),
                                    ),
                                    actions: <Widget>[],
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Add a chat',
                              style: TextStyle(fontSize: 24),
                            ),
                          )),
                    ),
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 25),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _chatStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;
                                  return Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: ListTile(
                                        title: Text(
                                          data['text'],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        subtitle: Text(
                                            DateFormat('MM/dd/yyyy, hh:mm a')
                                                .format(
                                                    data['timestamp'].toDate()),
                                            style:
                                                TextStyle(color: Colors.black)),
                                        trailing: Tooltip(
                                          message: data['name'],
                                          child: GestureDetector(
                                            onTap: (() => {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          ProfileDialog(
                                                              data['user_id']))
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         UserDetails(
                                                  //             data['user_id']),
                                                  //   ),
                                                  // )
                                                }),
                                            child: data['profilePicture'] !=
                                                    null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image.network(
                                                        data['profilePicture']))
                                                : CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Text(getInitials(
                                                        data['name'])),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                .toList()
                                .cast(),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
