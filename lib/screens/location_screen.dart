import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double? lat;

  double? long;

  String address = "";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    print("print");
    Future<Position> data = _determinePosition();
    data.then((value) {
      print("value $value");
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });

      getAddress(value.latitude, value.longitude);
    }).catchError((error) {
      print("Error $error");
    });
  }

//For convert lat long to address
  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    setState(() {
      address = placemarks[0].administrativeArea! +
          placemarks[0].street! +
          "," +
          placemarks[0].country!;
    });

    for (int i = 0; i < placemarks.length; i++) {
      print("INDEX $i ${placemarks[i]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Location",
          style: TextStyle(
              fontFamily: "Josefin Sans",
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.white),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "Latitude:",
                  style: TextStyle(fontFamily: "Josefin Sans", fontSize: 16),
                ),
              ),
              SizedBox(
                width: width * 0.2,
              ),
              Container(
                  child: Text(
                lat.toString(),
                style: TextStyle(
                  fontFamily: "Josefin Sans",
                  fontSize: 16,
                  color: Color.fromARGB(255, 248, 101, 148),
                ),
              )),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Text(
                "Longitude:",
                style: TextStyle(fontFamily: "Josefin Sans", fontSize: 16),
              )),
              SizedBox(
                width: width * 0.2,
              ),
              Container(
                child: Text(
                  long.toString(),
                  style: TextStyle(
                    fontFamily: "Josefin Sans",
                    fontSize: 16,
                    color: Color.fromARGB(255, 248, 101, 148),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Color.fromARGB(255, 248, 101, 148),
            indent: width * 0.2,
            endIndent: width * 0.2,
            height: height * 0.1,
          ),
          Row(
            children: [
              SizedBox(
                width: width * 0.05,
              ),
              Container(
                child: Text(
                  "Address:",
                  style: TextStyle(fontFamily: "Josefin Sans", fontSize: 27),
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.05,
                ),
                Container(
                  child: Text(
                    address,
                    style: TextStyle(
                        fontFamily: "Josefin Sans",
                        fontSize: 17,
                        color: Color.fromARGB(255, 248, 101, 148)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              getLatLong();
            },
            child: Container(
              height: height * 0.07,
              margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 248, 101, 148),
                    Color.fromARGB(255, 255, 202, 166),
                  ]),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 207, 207, 207),
                        offset: Offset(0, 2),
                        blurRadius: 2,
                        spreadRadius: 2)
                  ],
                  color: Color.fromARGB(255, 255, 202, 166),
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Live Location ",
                    style: TextStyle(fontFamily: "Josefin Sans", fontSize: 27),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
        ],
      ),
    );
  }
}
