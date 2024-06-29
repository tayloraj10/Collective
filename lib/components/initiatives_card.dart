import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/models/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class InitiativeCard extends StatefulWidget {
  final Map data;
  final Color color;
  InitiativeCard({required this.data, required this.color});

  @override
  State<InitiativeCard> createState() => _InitiativeCardState();
}

class _InitiativeCardState extends State<InitiativeCard> {
  final TextEditingController contributionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<AppData>(context).userData;

    void addContribution() {
      var ref = FirebaseFirestore.instance
          .collection("initiatives")
          .doc(this.widget.data['id']);

      ref.update({
        "complete": this.widget.data['complete'] +
            int.tryParse(contributionController.text)
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
        'initiative': this.widget.data['title'],
        'initiativeID': this.widget.data['id'],
        'amount': int.tryParse(contributionController.text),
        'date': DateTime.now()
      });
    }

    bool checkInputError() {
      if (contributionController.text.length > 0 &&
          int.tryParse(contributionController.text)! > 10) {
        return true;
      } else {
        return false;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width * 0.8,
      child: GestureDetector(
        onTap: () => {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                      content: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Make a Contribution",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        TextField(
                          controller: contributionController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              labelText: 'Amount',
                              errorText: checkInputError()
                                  ? "Please enter a value that is 10 or less"
                                  : null),
                          textAlign: TextAlign.center,
                          onChanged: (_) => setState(() {}),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () => {
                                  if (!checkInputError())
                                    {
                                      addContribution(),
                                      addContributionData(),
                                      Navigator.pop(context)
                                    }
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
                });
              })
        },
        child: Card(
          color: widget.color,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    widget.data['title'],
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
                    percent: widget.data['complete'] / widget.data['goal'],
                    center: Text(
                        ((widget.data['complete'] / widget.data['goal']) * 100)
                                .toString() +
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
