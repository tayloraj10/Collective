import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
// import 'package:google_maps_webservice/places.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    FirebaseAuth auth = FirebaseAuth.instance;
    print(auth.currentUser);

    var userData = Provider.of<AppData>(context).userData;

    TextEditingController phoneController = new TextEditingController();
    TextEditingController nameController = new TextEditingController();

    userData['phone'] == null
        ? phoneController.text = ""
        : phoneController.text = userData['phone'];

    auth.currentUser.displayName == null
        ? nameController.text = ""
        : nameController.text = auth.currentUser.displayName;

    Future<void> pickImage(auth) async {
      Uint8List bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
      // print(bytesFromPicker);

      // File Upload Logic
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file to Firebase Storage
      final metadata = SettableMetadata(
        contentType: 'image/png',
      );
      UploadTask uploadTask =
          storageReference.putData(bytesFromPicker, metadata);

      // Get the download URL of the uploaded image
      String downloadURL = await (await uploadTask).ref.getDownloadURL();

      // Now you can use the download URL as needed (e.g., store in a database)
      print('Image uploaded. Download URL: $downloadURL');
      auth.currentUser.updatePhotoURL(downloadURL);
      var userID = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: auth.currentUser.uid)
          .get();
      var docId = userID.docs.first.id;
      FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .update({'profilePicture': downloadURL});
      // auth = null;
      // auth = FirebaseAuth.instance;
      Provider.of<AppData>(context, listen: false).fetchUserData(user.uid);
      setState(() {});
      // html.window.location.reload();
    }

    // Future<List<String>> fetchCities() async {
    //   final places = GoogleMapsPlaces(apiKey: calendarAPIkey);
    //   final response = await places.autocomplete('City', types: ['(cities)']);

    //   if (response.isOkay) {
    //     List<String> cities = response.predictions
    //         .map((prediction) => prediction.description)
    //         .toList();
    //     return cities;
    //   } else {
    //     throw Exception('Failed to fetch cities');
    //   }
    // }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              // auth: auth,
              // providerConfigs: [
              //   EmailProviderConfiguration(),
              // ],
              // actions: [
              //   SignedOutAction((context) {
              //     print('signed out');
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //     builder: (context) => Home(),
              //     //   ),
              //     // );
              //   }),
              // ],
              // avatarSize: userData.containsKey('profilePicture') ? 0 : null,
              children: [
                // if (userData.containsKey('profilePicture'))
                //   CircleAvatar(
                //     radius: 60.0,
                //     backgroundImage: NetworkImage(auth.currentUser.photoURL),
                //     backgroundColor: Colors.transparent,
                //   ),
                // if (!userData.containsKey('profilePicture'))
                //   CircleAvatar(
                //     radius: 60.0,
                //     backgroundImage: NetworkImage(auth.currentUser.photoURL),
                //     backgroundColor: Colors.transparent,
                //   ),
                // CircleAvatar(
                //   radius: 60.0,
                //   backgroundImage: NetworkImage(auth.currentUser.photoURL),
                //   backgroundColor: Colors.transparent,
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Name'),
                    controller: nameController,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 60.0,
                  backgroundImage: NetworkImage(userData['profilePicture']),
                  backgroundColor: Colors.transparent,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      pickImage(auth);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Change Profile Picture',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 0),
                  child: Text(
                    'Phone Number',
                    style: TextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Phone Number'),
                    controller: phoneController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),

                // Center(
                //   child: FutureBuilder<List<String>>(
                //     future: fetchCities(),
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return CircularProgressIndicator();
                //       } else if (snapshot.hasError) {
                //         return Text('Error: ${snapshot.error}');
                //       } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                //         return Text('No cities found');
                //       } else {
                //         return Padding(
                //           padding: const EdgeInsets.all(16.0),
                //           child: DropdownButton<String>(
                //             value: snapshot.data[0], // Initial selected value
                //             onChanged: (String newValue) {
                //               print('Selected city: $newValue');
                //             },
                //             items: snapshot.data
                //                 .map<DropdownMenuItem<String>>((String city) {
                //               return DropdownMenuItem<String>(
                //                 value: city,
                //                 child: Text(city),
                //               );
                //             }).toList(),
                //           ),
                //         );
                //       }
                //     },
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      var userID = await FirebaseFirestore.instance
                          .collection('users')
                          .where('uid', isEqualTo: auth.currentUser.uid)
                          .get();
                      var docId = userID.docs.first.id;
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(docId)
                          .update({
                        'name': auth.currentUser.displayName != null
                            ? auth.currentUser.displayName
                            : "",
                        'phone': phoneController.text
                      }).then((documentSnapshot) => {
                                Provider.of<AppData>(context, listen: false)
                                    .fetchUserData(user.uid),
                                Fluttertoast.showToast(
                                    msg: "Profile Updated",
                                    toastLength: Toast.LENGTH_LONG,
                                    fontSize: 16.0,
                                    webBgColor: '#55aaff',
                                    webPosition: 'center',
                                    timeInSecForIosWeb: 3),
                              });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Save Changes',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (auth.currentUser.displayName == "" ||
                          auth.currentUser.displayName == null ||
                          phoneController.text == "") {
                        Fluttertoast.showToast(
                            msg: "Missing Name or Phone Number",
                            toastLength: Toast.LENGTH_LONG,
                            fontSize: 16.0,
                            webBgColor: '#FF0000',
                            webPosition: 'center',
                            timeInSecForIosWeb: 3);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Go Home',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance
                          .signOut()
                          .then((value) => Navigator.pop(context));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Sign out',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.currentUser
                          .delete()
                          .then((value) => Navigator.pop(context));
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Delete Account',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
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
