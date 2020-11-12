import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wayfinder/services/location.dart';
import 'package:wayfinder/screens/homescreen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  void getLocation() async {
    Location loc = Location();
    await loc.getCurrentLocation();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomeScreen(latitude: loc.latitude, longtitude: loc.longtitude);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitRipple(
          color: Colors.deepOrange,
          size: 250.0,
        ),
      ),
    );
  }
}
