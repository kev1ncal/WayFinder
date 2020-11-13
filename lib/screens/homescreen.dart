import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

final _firestore = FirebaseFirestore.instance;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> _signOutGoogle() async {
  await googleSignIn.signOut();
  await _auth.signOut();

  print("the user parameter is : ${_auth.currentUser},yes it is now null");

  return "Signout success";
}

class HomeScreen extends StatefulWidget {
  HomeScreen({this.latitude, this.longtitude});

  final double latitude;
  final double longtitude;

  double getLocation() {
    return this.latitude;
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User user = _auth.currentUser;

  // _sendData() {
  //   _firestore.collection('user').add({
  //     'display_name': user.displayName,
  //     'email': user.email,
  //     'latitude': widget.latitude,
  //     'longtitude': widget.longtitude,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wayfinder Beta'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.account_box_rounded),
          onPressed: () {
            // show your account  details here
            // _sendData();
            print('You account details button is pressed');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              //logout here
              _signOutGoogle().then((result) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            },
          ),
        ],
      ),
      body: FireMap(
        latitude: widget.latitude,
        longtitude: widget.longtitude,
      ),
    );
  }
}

class FireMap extends StatefulWidget {
  FireMap({this.latitude, this.longtitude});

  double latitude;
  double longtitude;
  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Location location = new Location();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  BehaviorSubject<double> radius = BehaviorSubject();
  Stream<dynamic> query;

  StreamSubscription subscription;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longtitude),
            zoom: 200,
          ),
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
        ),
        Positioned(
          bottom: 100,
          right: 10,
          child: FlatButton(
            child: Icon(
              Icons.pin_drop,
              color: Colors.white,
            ),
            color: Colors.green,
            onPressed: _addGeoPoint,
          ),
        ),
      ],
    );
  }

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _animateToUser() async {
    // location.onLocationChanged;
    var pos = await location.getLocation();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 20.0,
        ),
      ),
    );
  }

  Future<DocumentReference> _addGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);
    return firestore
        .collection('locations')
        .add({'position': point.data, 'name': 'Current Position'});
  }
}

// Center(
// child: Text(
// 'render map here: ${user.displayName}  . .. . ${widget.latitude}, ${widget.longtitude} . . . .tangina'),
// ),
