import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/app_data.dart';

class InitiativeCard extends StatelessWidget {
  final Map data;
  final Color color;
  InitiativeCard({required this.data, required this.color});

  final TextEditingController contributionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<AppData>(context).userData;
    print(userData);
    print(this.data);

    void addContribution() {
      var ref = FirebaseFirestore.instance
          .collection("initiatives")
          .doc(this.data['id']);

      ref.update({
        "complete":
            this.data['complete'] + int.tryParse(contributionController.text)
      }).then(
          (value) => {
                print("DocumentSnapshot successfully updated!"),
              },
          onError: (e) => print("Error updating document $e"));
    }

    void addContributionData() {
      var ref = FirebaseFirestore.instance.collection("goal_submissions");
      ref.add({
        'userName': userData['name'],
        'userID': userData['uid'],
        'initiative': this.data['title'],
        'initiativeID': this.data['id'],
        'amount': int.tryParse(contributionController.text),
        'date': DateTime.now()
      });
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width * 0.8,
      child: GestureDetector(
        onTap: () => {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Make a Contribution",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextField(
                        controller: contributionController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Amount',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () => {
                                addContribution(),
                                addContributionData(),
                                Navigator.pop(context)
                              },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ))
                    ],
                  ),
                ));
              })
        },
        child: Card(
          color: color,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    data['title'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: new LinearPercentIndicator(
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 2000,
                    percent: data['complete'] / data['goal'],
                    center: Text(
                        ((data['complete'] / data['goal']) * 100).toString() +
                            "%"),
                    progressColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
