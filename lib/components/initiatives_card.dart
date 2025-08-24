import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/resource_link.dart';
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
  final TextEditingController contributionController =
      TextEditingController(text: '1');
  int streak = 0;
  List<PlatformFile> uploadedImages = [];
  DateTime? selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    runUpdates();
  }

  runUpdates() {
    // calculateCompleted(this.widget.data['id']);
    getUserStreak();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // num calculateCompleted() {
  //   num total = 0;
  //   if (this.widget.data['submissions'] != null) {
  //     this.widget.data['submissions'].forEach((x) => {total += x['amount']});
  //     return total;
  //   } else
  //     return 0;
  // }

  Future<void> calculateCompleted(String initiativeID) async {
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
    FirebaseFirestore.instance
        .collection('initiatives')
        .doc(initiativeID)
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
    var goalRef = FirebaseFirestore.instance.collection("initiatives");
    ref.add({
      'userName': userData['name'],
      'userID': userData['uid'],
      'initiative': this.widget.data['title'],
      'initiativeID': this.widget.data['id'],
      'action': this.widget.data['action'],
      'amount': int.tryParse(contributionController.text),
      'date': selectedDate,
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
    goalRef.doc(this.widget.data['id']).update({
      "complete": this.widget.data['complete'] +
          int.tryParse(contributionController.text)
    }).then(
        (value) => {
              print("DocumentSnapshot successfully updated!"),
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
      if (contributionController.text.isNotEmpty &&
          int.tryParse(contributionController.text) != null &&
          (int.tryParse(contributionController.text)! > 10 ||
              int.tryParse(contributionController.text)! <= 0)) {
        return true;
      } else {
        return false;
      }
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        width: isMobile(context)
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * 0.75,
        child: GestureDetector(
          onTap: () {
            uploadedImages = [];
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.grey.shade900,
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Make a Contribution",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: contributionController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: 'Amount',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                errorText: checkInputError()
                                    ? "Please enter a value that is 10 or less"
                                    : null,
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => addFile(setState),
                                  icon: const Icon(Icons.image),
                                  label: const Text(
                                    "Add Image",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (!checkInputError() &&
                                        contributionController
                                            .text.isNotEmpty) {
                                      addContribution(userData);
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  icon: const Icon(Icons.check),
                                  label: const Text(
                                    "Submit",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (uploadedImages.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: uploadedImages.map((file) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      Uint8List.fromList(file.bytes!),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                selectDate(context).then((_) {
                                  setState(() {});
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                              icon: const Icon(Icons.calendar_today),
                              label: Text(
                                DateFormat('MM/dd/yy').format(selectedDate!),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
          child: Card(
            color: widget.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.data['description'] != null &&
                      widget.data['description'].isNotEmpty)
                    Text(
                      widget.data['description'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  const SizedBox(height: 8),
                  if (widget.data['link'] != null &&
                      widget.data['link'].isNotEmpty)
                    ResourceLink(
                      text: widget.data['link'],
                      url: widget.data['link'],
                      fontSize: 16,
                    ),
                  const SizedBox(height: 8),
                  if (FirebaseAuth.instance.currentUser != null && streak > 0)
                    Wrap(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: widget.color == Colors.orange
                              ? Colors.red
                              : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'You are on a $streak day Streak',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  LinearPercentIndicator(
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 2000,
                    percent: widget.data['complete'] / widget.data['goal'],
                    center: Text(
                      '${((widget.data['complete'] / widget.data['goal']) * 100).toStringAsFixed(2)}%',
                      style: const TextStyle(color: Colors.black),
                    ),
                    progressColor: Colors.white,
                    backgroundColor: Colors.grey.shade300,
                    barRadius: const Radius.circular(10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
