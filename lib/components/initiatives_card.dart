import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;
// import 'package:googleapis_auth/auth_browser.dart';
// import 'package:collective/secrets.dart';
// import 'package:googleapis/drive/v3.dart' as gdrive;
// import 'package:googleapis_auth/auth_io.dart';

class InitiativeCard extends StatefulWidget {
  final Map data;
  final Color color;
  InitiativeCard({required this.data, required this.color});

  @override
  State<InitiativeCard> createState() => _InitiativeCardState();
}

class _InitiativeCardState extends State<InitiativeCard> {
  final TextEditingController contributionController = TextEditingController();
  int streak = 0;
  List<PlatformFile> uploadedImages = [];

  @override
  void initState() {
    super.initState();
    runUpdates();
  }

  runUpdates() {
    calculateCompleted();
    getUserStreak();
  }

  // num calculateCompleted() {
  //   num total = 0;
  //   if (this.widget.data['submissions'] != null) {
  //     this.widget.data['submissions'].forEach((x) => {total += x['amount']});
  //     return total;
  //   } else
  //     return 0;
  // }

  Future<void> calculateCompleted() async {
    num total = 0;
    await FirebaseFirestore.instance
        .collection('goal_submissions')
        .where('initiativeID', isEqualTo: this.widget.data['id'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        total += doc['amount'];
      });
    });
    FirebaseFirestore.instance
        .collection('initiatives')
        .doc(this.widget.data['id'])
        .update({'complete': total}).then(
      (value) => print("Initiative successfully updated!"),
      onError: (e) => print("Error updating initiative: $e"),
    );
  }

  // List<DateTime> getUserSubmissionDates() {
  //   List<DateTime> userSubmissions = [];
  //   if (FirebaseAuth.instance.currentUser != null &&
  //       this.widget.data['submissions'] != null) {
  //     String user = FirebaseAuth.instance.currentUser!.uid;
  //     this.widget.data['submissions'].forEach((x) => {
  //           if (x['userID'] == user)
  //             {
  //               userSubmissions.add(DateTime.fromMillisecondsSinceEpoch(
  //                   x['date'].seconds * 1000))
  //             }
  //         });
  //   }
  //   return userSubmissions;
  // }

  Future<List<DateTime>> getUserSubmissionDates() async {
    List<DateTime> userSubmissions = [];
    if (FirebaseAuth.instance.currentUser != null) {
      String user = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('goal_submissions')
          .where('userID', isEqualTo: user)
          .where('initiativeID', isEqualTo: this.widget.data['id'])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          userSubmissions.add(
              DateTime.fromMillisecondsSinceEpoch(doc['date'].seconds * 1000));
        });
      });
    }
    return userSubmissions;
  }

  Future<void> getUserStreak() async {
    int userStreak = 0;
    List<DateTime> dates = await getUserSubmissionDates();
    DateTime currentDateTime = DateTime.now();
    List days = [];

    if (dates.length > 0) {
      dates.sort((a, b) {
        return b.compareTo(a);
      });

      for (var x in dates) {
        if (currentDateTime.difference(x).inHours <= 24) {
          if (days.contains(DateFormat.yMd().format(x))) {
            currentDateTime = x;
          } else {
            days.add(DateFormat.yMd().format(x));
            userStreak += 1;
            currentDateTime = x;
          }
        } else
          break;
      }
      print(userStreak);
      setState(() {
        this.streak = userStreak;
      });
    }
    // return 0;
  }

  // void addContribution(Map userData) {
  //   var ref = FirebaseFirestore.instance
  //       .collection("initiatives")
  //       .doc(this.widget.data['id']);

  //   ref.update({
  //     "complete": this.widget.data['complete'] +
  //         int.tryParse(contributionController.text)
  //   }).then(
  //       (value) => {
  //             print("DocumentSnapshot successfully updated!"),
  //           },
  //       onError: (e) => print("Error updating document $e"));

  //   ref.update({
  //     'submissions': FieldValue.arrayUnion([
  //       {
  //         'userName': userData['name'],
  //         'userID': userData['uid'],
  //         'amount': int.tryParse(contributionController.text),
  //         'date': DateTime.now()
  //       }mmm
  //     ])
  //   }).then(
  //       (value) => {
  //             print("Submissions successfully updated!"),
  //           },
  //       onError: (e) => print("Error updating document $e"));
  // }

  void addContribution(Map userData) async {
    var ref = FirebaseFirestore.instance.collection("goal_submissions");
    ref.add({
      'userName': userData['name'],
      'userID': userData['uid'],
      'initiative': this.widget.data['title'],
      'initiativeID': this.widget.data['id'],
      'action': this.widget.data['action'],
      'amount': int.tryParse(contributionController.text),
      'date': DateTime.now(),
    }).then(
        (value) => {
              if (uploadedImages.length > 0)
                {
                  uploadedImages.forEach((element) async {
                    await uploadFile(element, value.id);
                  })
                }
            },
        onError: (e) => print("Error updating document $e"));

    runUpdates();
  }

  Future<void> addFile(Function setState) async {
    // authenticate();
    // final FilePickerResult? result = await FilePicker.platform
    //     .pickFiles(type: FileType.image, allowMultiple: true);
    // if (result != null && result.files.isNotEmpty) {
    //   // final file = File(result.files.single.path!);

    //   setState(() {
    //     uploadedImages = [...uploadedImages, ...result.files];
    //   });
    // }
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.multiple = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          final reader = html.FileReader();
          reader.onLoadEnd.listen((e) {
            setState(() {
              print(file.name);
              uploadedImages.add(PlatformFile(
                name: file.name,
                size: file.size,
                bytes: reader.result as Uint8List?,
              ));
            });
          });
          reader.readAsArrayBuffer(file);
        }
      }
    });
  }

  uploadFile(PlatformFile file, String docId) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(
        'initiatives/${docId + "_" + DateTime.now().millisecondsSinceEpoch.toString() + "_" + file.name}');
    UploadTask uploadTask = ref.putData(file.bytes!);

    return await uploadTask.then((res) async {
      String downloadUrl = await res.ref.getDownloadURL();
      print("File uploaded successfully. Download URL: $downloadUrl");

      FirebaseFirestore.instance
          .collection('goal_submissions')
          .doc(docId)
          .update({
        'images': FieldValue.arrayUnion([downloadUrl])
      });
    }).catchError((error) {
      print("Error uploading file: $error");
    });
    // final driveFile = gdrive.File()..name = file.name;
    // final media = gdrive.Media(Stream.fromIterable([file.bytes!]), file.size);
    // await driveApi!.files.create(driveFile, uploadMedia: media);
  }

  // gdrive.DriveApi? driveApi;
  // Future<void> authenticate() async {
  //   final _scopes = [gdrive.DriveApi.driveFileScope];
  //   final id = ClientId(client_id, null);
  //   final authClient = await createImplicitBrowserFlow(id, _scopes)
  //       .then((flow) => flow.clientViaUserConsent());
  //   setState(() {
  //     driveApi = gdrive.DriveApi(authClient);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<AppData>(context).userData;

    bool checkInputError() {
      if (contributionController.text.length > 0 &&
          int.tryParse(contributionController.text)! > 10) {
        return true;
      } else {
        return false;
      }
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        width: isMobile(context)
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * 0.75,
        child: GestureDetector(
          onTap: () => {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  uploadedImages = [];
                  return AlertDialog(
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Make a Contribution",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22)),
                            TextField(
                              controller: contributionController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          if (!checkInputError() &&
                                              contributionController
                                                      .text.length !=
                                                  0)
                                            {
                                              addContribution(userData),
                                              Navigator.pop(context)
                                            }
                                        },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () => {
                                          addFile(setState),
                                        },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Add Image",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if (uploadedImages.length > 0)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  children: uploadedImages.map((file) {
                                    return Image.memory(
                                      Uint8List.fromList(file.bytes!),
                                      height: 200,
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  );
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
                    height: 2,
                  ),
                  if (FirebaseAuth.instance.currentUser != null && streak > 0)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Wrap(
                        children: [
                          Text(
                            'You are on a ${streak} day Streak',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18),
                          ),
                          Icon(
                            Icons.local_fire_department,
                            color: widget.color == Colors.orange
                                ? Colors.red
                                : Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: new LinearPercentIndicator(
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2000,
                      percent: widget.data['complete'] / widget.data['goal'],
                      center: Text(
                          ((widget.data['complete'] / widget.data['goal']) *
                                      100)
                                  .toStringAsFixed(2) +
                              "%"),
                      progressColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
