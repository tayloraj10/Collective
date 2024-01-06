import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/social_link.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:collective/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutterfire_ui/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crop_your_image/crop_your_image.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void initState() {
    super.initState();
  }

  Uint8List bytesFromPicker;
  bool showCrop = false;

  var placeController = TextEditingController();
  List<dynamic> placeList = [];

  void getSuggestion(String input) async {
    const String PLACES_API_KEY = placesAPIkey;
    String type = '(cities)';
    String request =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$PLACES_API_KEY&types=$type';
    // print(request);
    var response = await http.get(Uri.parse(request), headers: {
      "content-type": "application/json",
      "x-requested-with": "XMLHttpRequest"
    });
    if (response.statusCode == 200) {
      setState(() {
        placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    FirebaseAuth auth = FirebaseAuth.instance;
    // print(auth.currentUser);

    var userData = Provider.of<AppData>(context).userData;

    TextEditingController phoneController = new TextEditingController();
    TextEditingController nameController = new TextEditingController();
    TextEditingController tiktokController = new TextEditingController();
    TextEditingController instagramController = new TextEditingController();
    TextEditingController youtubeController = new TextEditingController();

    userData['phone'] == null
        ? phoneController.text = ""
        : phoneController.text = userData['phone'];

    if (userData['city'] == null && placeController.text == '')
      placeController.text = "";
    else if (userData['city'] != null && placeController.text == '')
      placeController.text = userData['city'];

    userData['tiktok'] == null
        ? tiktokController.text = ""
        : tiktokController.text = userData['tiktok'];

    userData['youtube'] == null
        ? youtubeController.text = ""
        : youtubeController.text = userData['youtube'];

    userData['instagram'] == null
        ? instagramController.text = ""
        : instagramController.text = userData['instagram'];

    auth.currentUser.displayName == null
        ? nameController.text = ""
        : nameController.text = auth.currentUser.displayName;

    final cropController = CropController();

    Future<void> uploadFile() async {
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

      //delete old file
      // Create a reference to the file to delete
      try {
        print("images/" +
            userData['profilePicture'].split('?')[0].split('images%2F')[1]);
        final deleteRef = FirebaseStorage.instance.ref().child("images/" +
            userData['profilePicture'].split('?')[0].split('images%2F')[1]);
        // Delete the file
        await deleteRef.delete();
      } catch (e) {
        print(e);
        // print("couldn't delete old image");
      }

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

    cropImage(image) {
      showCrop = false;
      bytesFromPicker = image;
      setState(() {});
      uploadFile();
    }

    Future<void> pickImage(auth) async {
      bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
      if (bytesFromPicker.isNotEmpty) {
        showCrop = true;
        setState(() {});
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .6,
                height: MediaQuery.of(context).size.height * .9,
                child: showCrop
                    ? Crop(
                        image: bytesFromPicker,
                        controller: cropController,
                        withCircleUi: true,
                        onCropped: (image) {
                          cropImage(image);
                        })
                    : SingleChildScrollView(
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
                              padding: const EdgeInsets.only(bottom: 24),
                              child: ElevatedButton(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      'Go Home',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    )),
                                onPressed: (() => {Navigator.pop(context)}),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                decoration: InputDecoration(hintText: 'Name'),
                                controller: nameController,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[a-zA-Z]'))
                                ],
                              ),
                            ),
                            if (userData['profilePicture'] != null)
                              CircleAvatar(
                                radius: 60.0,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                        userData['profilePicture'])),
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
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 0),
                              child: Text(
                                'Phone Number',
                                style: TextStyle(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TextFormField(
                                decoration:
                                    InputDecoration(hintText: 'Phone Number'),
                                controller: phoneController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 0),
                              child: Text(
                                'Location (City)',
                                style: TextStyle(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TextFormField(
                                onChanged: (value) => getSuggestion(value),
                                controller: placeController,
                              ),
                            ),
                            // FlutterGooglePlacesWeb(
                            //   apiKey: placesAPIkey,
                            //   proxyURL: 'https://cors-anywhere.herokuapp.com/',
                            //   components: 'country:us',
                            //   required: true,
                            // ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) => ListTile(
                                // we will display the data returned from our future here
                                title: Text(placeList[index]['description']),
                                onTap: () {
                                  placeController.text =
                                      placeList[index]['description'];
                                  placeList = [];
                                  setState(() {});
                                },
                              ),
                              itemCount: placeList.length,
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 0),
                              child: Text(
                                'Social Links (username)',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            SocialLink(
                                tiktokController, 'tiktok', 'tiktok.png'),
                            SocialLink(instagramController, 'Instagram',
                                'instagram.png'),
                            SocialLink(
                                youtubeController, 'YouTube', 'youtube.png'),
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
                                      .where('uid',
                                          isEqualTo: auth.currentUser.uid)
                                      .get();
                                  var docId = userID.docs.first.id;
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(docId)
                                      .update({
                                    'name': auth.currentUser.displayName != null
                                        ? auth.currentUser.displayName
                                        : "",
                                    'phone': phoneController.text,
                                    'city': placeController.text,
                                    'tiktok': tiktokController.text,
                                    'instagram': instagramController.text,
                                    'youtube': youtubeController.text
                                  }).then((documentSnapshot) => {
                                            Provider.of<AppData>(context,
                                                    listen: false)
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
                                    backgroundColor: Colors.green),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Save Changes',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (auth.currentUser.displayName == "" ||
                                      auth.currentUser.displayName == null) {
                                    Fluttertoast.showToast(
                                        msg: "Missing Name",
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
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await FirebaseAuth.instance.signOut();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Sign out',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await FirebaseAuth.instance.currentUser
                                      .delete();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Delete Account',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
              if (showCrop)
                SizedBox(
                  height: 10,
                ),
              if (showCrop)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(
                        'Crop Your Image',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: cropController.crop,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () => {showCrop = false, setState(() {})},
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
