import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/constants.dart';
import 'package:collective/models/app_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class InterestingLocations extends StatefulWidget {
  const InterestingLocations({Key key}) : super(key: key);

  @override
  State<InterestingLocations> createState() => _InterestingLocationsState();
}

class _InterestingLocationsState extends State<InterestingLocations> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(40.70415271515901, -73.93137539489814);
  Map<String, Marker> markers = {};

  BitmapDescriptor unvisitedIcon;
  BitmapDescriptor visitedIcon;

  void _onMapCreated(GoogleMapController controller) {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 38)), 'images/map_pin.png')
        .then((d) {
      visitedIcon = d;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 38)), 'images/map_pin2.png')
        .then((d) {
      unvisitedIcon = d;
    });
    mapController = controller;
    getLocations();
  }

  void populateMarkers(List locations) {
    markers.clear();
    var userData = Provider.of<AppData>(context, listen: false).userData;
    for (final loc in locations) {
      final marker = Marker(
        markerId: MarkerId(loc['name']),
        position: LatLng(loc['lat_lon'][0], loc['lat_lon'][1]),
        // infoWindow: InfoWindow(
        //   title: loc['name'],
        //   snippet: loc['address'],
        // ),
        icon: loc['visited'].contains(userData['uid'])
            ? visitedIcon
            : unvisitedIcon,
        onTap: () => {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    alignment: Alignment.bottomCenter,
                    content: Container(
                      width: 500,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SelectableText(
                                loc['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 28),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: loc['visited']
                                              .contains(userData['uid'])
                                          ? Colors.blue
                                          : Colors.red),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        loc['visited'].contains(userData['uid'])
                                            ? 'I have visited'
                                            : "I haven't visited",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      )),
                                  onPressed: (() => {
                                        loc['visited'].contains(userData['uid'])
                                            ? unvisit(userData['uid'], loc)
                                            : visit(userData['uid'], loc),
                                        setState(() {})
                                      }),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (loc['glink'] != null)
                            GestureDetector(
                              onTap: (() => {launchURL(loc['glink'])}),
                              child: Text(
                                loc['address'],
                                style:
                                    TextStyle(fontSize: 24, color: Colors.blue),
                              ),
                            ),
                          if (loc['glink'] == null)
                            SelectableText(
                              loc['address'],
                              style: TextStyle(fontSize: 24),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          SelectableText(
                            loc['description'],
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (loc['website'] != null)
                            GestureDetector(
                              onTap: (() => {launchURL(loc['website'])}),
                              child: Text(
                                loc['website'],
                                style:
                                    TextStyle(fontSize: 20, color: Colors.blue),
                              ),
                            ),
                          if (loc['website'] == null)
                            SelectableText(
                              loc['website'],
                              style: TextStyle(fontSize: 20),
                            ),
                        ],
                        mainAxisSize: MainAxisSize.min,
                      ),
                    ),
                    actions: <Widget>[],
                  );
                });
              })
        },
      );
      markers[loc['name']] = marker;
    }
    setState(() {});
  }

  void getLocations() {
    List locationData = [];
    Map currentData;
    FirebaseFirestore.instance.collection('locations').get().then((value) => {
          value.docs.forEach((element) {
            currentData = element.data();
            currentData['id'] = element.id;
            locationData.add(currentData);
            populateMarkers(locationData);
          }),
        });
  }

  visit(uid, locationData) {
    final groupRef = FirebaseFirestore.instance
        .collection("locations")
        .doc(locationData['id']);

    var users = locationData['visited'];
    users.add(uid);

    groupRef.update({"visited": users}).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));

    getLocations();
  }

  unvisit(uid, locationData) {
    final groupRef = FirebaseFirestore.instance
        .collection("locations")
        .doc(locationData['id']);

    var users = locationData['visited'];
    users.removeWhere((id) => id == uid);

    groupRef.update({"visited": users}).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));

    getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12,
            ),
            markers: markers.values.toSet(),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: ElevatedButton(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  )),
              onPressed: (() => {Navigator.pop(context)}),
            ),
          ),
        ]),
      ),
    );
  }
}
