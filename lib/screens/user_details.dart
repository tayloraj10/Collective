import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class UserDetails extends StatelessWidget {
  final String userId;
  UserDetails(this.userId);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Container(
          // Place as the child widget of a scaffold
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: <Color>[
              Color.fromARGB(255, 8, 51, 86),
              Color.fromARGB(255, 28, 109, 174),
              Color.fromARGB(255, 93, 150, 197),
              Color.fromARGB(255, 147, 197, 238),
              Color.fromARGB(255, 93, 150, 197),
              Color.fromARGB(255, 28, 109, 174),
              Color.fromARGB(255, 8, 51, 86),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: ElevatedButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Go Back',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32),
                      ),
                    )),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('uid', isEqualTo: userId)
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
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: snapshot.data.docs
                          .map((DocumentSnapshot<Object> document) {
                        Map docData = document.data();
                        docData['id'] = document.id;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              docData['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 26),
                              child: Row(
                                children: [
                                  Text(
                                    'Email: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SelectableText(
                                    docData['email'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Phone: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SelectableText(
                                    docData['phone'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
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
                padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Groups: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28)),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('groups')
                            .where('users', arrayContains: userId)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: snapshot.data.docs.mapIndexed(
                                  (index, DocumentSnapshot<Object> document) {
                                Map docData = document.data();
                                docData['id'] = document.id;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      index == snapshot.data.docs.length - 1
                                          ? docData['name']
                                          : docData['name'] + ', ',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 40, right: 40),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Projects: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28)),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('projects')
                            .where('users', arrayContains: userId)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: snapshot.data.docs.mapIndexed(
                                  (index, DocumentSnapshot<Object> document) {
                                Map docData = document.data();
                                docData['id'] = document.id;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      index == snapshot.data.docs.length - 1
                                          ? docData['title']
                                          : docData['title'] + ', ',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
