import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      body: Center(
        child: Text(
            'render map here: ${user.displayName}  . .. . ${widget.latitude}, ${widget.longtitude} . . . .tangina'),
      ),
    );
  }
}
