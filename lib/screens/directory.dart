import 'package:collective/components/topic_chip.dart';
import 'package:collective/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Directory extends StatefulWidget {
  const Directory({
    Key? key,
  }) : super(key: key);
  @override
  _DirectoryState createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
  final List<String> categories = [
    'Reset',
    'Environment',
    'Trash',
    'Tech',
    'Water'
  ];
  final List<String> locations = ['Reset', 'NYC', 'Philadelphia', 'Florida'];
  String categoryFilter = '';
  String locationFilter = '';

  getStream() {
    if (categoryFilter.isNotEmpty && locationFilter.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('directory')
          .where('active', isEqualTo: true)
          .where('topics', arrayContains: categoryFilter)
          .where('location', isEqualTo: locationFilter)
          .orderBy("date_added", descending: true)
          .snapshots();
    }
    if (categoryFilter.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('directory')
          .where('active', isEqualTo: true)
          .where('topics', arrayContains: categoryFilter)
          .orderBy("date_added", descending: true)
          .snapshots();
    }
    if (locationFilter.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('directory')
          .where('active', isEqualTo: true)
          .where('location', isEqualTo: locationFilter)
          .orderBy("date_added", descending: true)
          .snapshots();
    }
    return FirebaseFirestore.instance
        .collection('directory')
        .where('active', isEqualTo: true)
        .orderBy("date_added", descending: true)
        .snapshots();
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
                padding: EdgeInsets.only(top: 15, bottom: 75),
                child: Column(
                  children: [
                    Text(
                      'Directory of Good',
                      style: pageTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              DropdownButton<String>(
                                style: TextStyle(color: Colors.white),
                                dropdownColor: Colors.grey[800],
                                hint: Text('Select Category',
                                    style: TextStyle(color: Colors.white)),
                                items: categories.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                                value: categoryFilter.isEmpty
                                    ? null
                                    : categoryFilter,
                                onChanged: (String? newValue) {
                                  if (newValue == 'Reset') {
                                    setState(() {
                                      categoryFilter = '';
                                    });
                                    return;
                                  }
                                  setState(() {
                                    categoryFilter = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              DropdownButton<String>(
                                style: TextStyle(color: Colors.white),
                                dropdownColor: Colors.grey[800],
                                hint: Text('Select Location',
                                    style: TextStyle(color: Colors.white)),
                                items: locations.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                                value: locationFilter.isEmpty
                                    ? null
                                    : locationFilter,
                                onChanged: (String? newValue) {
                                  if (newValue == 'Reset') {
                                    setState(() {
                                      locationFilter = '';
                                    });
                                    return;
                                  }
                                  setState(() {
                                    locationFilter = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: getStream(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ListView(
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  color: Colors.blue,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(data['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: largeTextSize)),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.containsKey('description')
                                                    ? data['description']
                                                    : '',
                                                style: TextStyle(
                                                    color: Colors.grey[200],
                                                    fontSize: smallTextSize),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: Wrap(
                                                  spacing: 6.0,
                                                  runSpacing: 6.0,
                                                  children: data['topics']
                                                      .map<Widget>(
                                                          (topic) => TopicChip(
                                                                topic,
                                                              ))
                                                      .toList(),
                                                ),
                                              )
                                            ],
                                          ),
                                          leading: data.containsKey('image')
                                              ? GestureDetector(
                                                  onTap: () => {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          elevation: 0,
                                                          content: CircleAvatar(
                                                            radius: 200,
                                                            backgroundImage:
                                                                NetworkImage(data[
                                                                    'image']),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            data['image']),
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          if (data.containsKey('links') &&
                                              data['links']
                                                  .containsKey('website'))
                                            Tooltip(
                                              message: 'Website',
                                              child: IconButton(
                                                onPressed: () {
                                                  launchURL(
                                                      data['links']['website']);
                                                },
                                                icon: Icon(Icons.language),
                                              ),
                                            ),
                                          if (data.containsKey('links') &&
                                              data['links']
                                                  .containsKey('instagram'))
                                            Tooltip(
                                              message: 'Instagram',
                                              child: IconButton(
                                                onPressed: () {
                                                  launchURL(
                                                      'https://www.instagram.com/' +
                                                          data['links']
                                                              ['instagram']);
                                                },
                                                icon: Image.asset('images/' +
                                                    'instagram.png'),
                                              ),
                                            ),
                                          if (data.containsKey('links') &&
                                              data['links']
                                                  .containsKey('youtube'))
                                            Tooltip(
                                              message: 'Youtube',
                                              child: IconButton(
                                                onPressed: () {
                                                  launchURL(
                                                      'https://www.youtube.com/@' +
                                                          data['links']
                                                              ['youtube']);
                                                },
                                                icon: Image.asset(
                                                    'images/' + 'youtube.png'),
                                              ),
                                            )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
          ),
        ),
      );
    });
  }
}
