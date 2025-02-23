import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/activity_feed.dart';
import 'package:collective/components/initiatives_stream.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Initiatives extends StatefulWidget {
  @override
  State<Initiatives> createState() => _InitiativesState();
}

class _InitiativesState extends State<Initiatives> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  checkAdmin() {
    final userData = Provider.of<AppData>(context, listen: false).userData;
    if (userData['permissions'] != null &&
        userData['permissions']['admin'] == true) {
      setState(() {
        isAdmin = true;
      });
    }
  }

  updateTotals() {
    List updatedList = [];
    FirebaseFirestore.instance
        .collection('initiatives')
        .where('active', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      Future.wait(querySnapshot.docs.map((doc) async {
        bool updated = await calculateCompleted(doc.id);
        if (updated) {
          updatedList.add((doc.data() as Map<String, dynamic>)['title']);
        }
      })).then((_) {
        if (updatedList.isNotEmpty) {
          Fluttertoast.showToast(
              msg: 'Updated totals for ${updatedList.join(', ')}',
              toastLength: Toast.LENGTH_LONG,
              fontSize: 16.0,
              webBgColor: '#000000',
              webPosition: 'center',
              timeInSecForIosWeb: 5);
        } else {
          Fluttertoast.showToast(
              msg: 'No Updates Needed',
              toastLength: Toast.LENGTH_LONG,
              fontSize: 16.0,
              webBgColor: '#000000',
              webPosition: 'center',
              timeInSecForIosWeb: 5);
        }
      });
    });
  }

  Future<bool> calculateCompleted(String initiativeID) async {
    num total = 0;
    await FirebaseFirestore.instance
        .collection('goal_submissions')
        .where('initiativeID', isEqualTo: initiativeID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        total += doc['amount'];
      });
    });
    DocumentSnapshot initiativeDoc = await FirebaseFirestore.instance
        .collection('initiatives')
        .doc(initiativeID)
        .get();

    if (initiativeDoc.exists && initiativeDoc['complete'] != total) {
      FirebaseFirestore.instance
          .collection('initiatives')
          .doc(initiativeID)
          .update({'complete': total}).then(
        (value) => print("Initiative successfully updated!"),
        onError: (e) => print("Error updating initiative: $e"),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
            // maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Scrollbar(
            child: Container(
              color: SecondaryColor,
              child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 75),
                  child: Column(
                    children: [
                      // Text(
                      //   'Main Initiatives: Trash Cleanups, Animal Welfare, Fitness',
                      //   style: pageTextStyle,
                      //   textAlign: TextAlign.center,
                      // ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'These are the currently ongoing initiatives (click to contribute)',
                            style: pageTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          if (isAdmin)
                            Tooltip(
                              message: 'Sync Totals',
                              child: IconButton(
                                icon: Icon(
                                  Icons.update,
                                  color: Colors.white,
                                ),
                                onPressed: () => updateTotals(),
                              ),
                            )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InitiativesStream(),
                            ActivityFeed(),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      );
    });
  }
}
