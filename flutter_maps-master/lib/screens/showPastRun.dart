import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/activity.dart';
import 'package:flutter_maps/screens/pastRuns.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter_maps/screens/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter_maps/screens/loginpage.dart';
import 'package:flutter_maps/dataList.dart';

class PastMapView extends StatefulWidget {
  @override
  _PastMapViewState createState() => _PastMapViewState();
}

class _PastMapViewState extends State<PastMapView> {
  //List points = [];
  // List points2 = [];
  //List<double> liste1 = [];
  // List<double> liste2 = [];
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> _polylines = {};
  final Geolocator _geolocator = Geolocator();
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  Stopwatch s = new Stopwatch();
  final myController = TextEditingController();
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  var list2;

  int i = 0;
  int j = 0;

/*
  getPoints() {
    FirebaseFirestore.instance
        .collection('Test')
        .orderBy("id", descending: false)
        .where('userId', isEqualTo: uid)
        .where('name', isEqualTo: kosuAdi)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        list = result.data();
        list2 = list.values.toList();
        //points.add(list2[0]);
       // points.add(list2[4]);
        //position = points[0];
       //position = points[4];
       points.add(list2[0]);
       points2.add(list2[4]);

       for(i; i<points.length; i++){
         liste1.add(points[i]);
         liste2.add(points2[i]);
       }
        print(liste1);
        print(liste2);
      });
    });
  }
*/
  setPolylines() {
    setState(() {
      for (i; i < liste1.length - 1; i++) {
        // for (j; j <liste2.length; j++) {
        polylineCoordinates.add(LatLng(liste1[i], liste2[j]));
        j++;
        //polylineCoordinates.add(LatLng(liste1[i+1],liste2[j+1]));
        //print("Liste 1 koordinatı");
        //print(liste1[i]);
        //print("Liste 2 koordinatı");
        //print(liste2[j]);
        // }
      }
      //polylineCoordinates.add(LatLng(liste1[0],liste2[0]));
      //polylineCoordinates.add(LatLng(liste1[1],liste2[1]));
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Colors.green,
          width: 2,
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
      // print(polylineCoordinates);
    });
  }

  void onMapCreated() {
    addMarker1();
    addMarker2();
    //polylineCoordinates.clear();
    setPolylines();
  }

  clear () {
    liste1.clear();
    liste2.clear();
    points.clear();
    points2.clear();
    i = 0;
    j = 0 ;
    polylineCoordinates.clear();
    markers.clear();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()));
  }

/*
  createPolylines(Position start) {
    polylinePoints = points;
    polylineCoordinates.add(LatLng(start.latitude, start.longitude));
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }
*/
  addMarker1() {
    Marker startMarker = Marker(
      markerId: MarkerId('marker1'),
      position: LatLng(
        liste1[0],liste2[0]
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    markers.add(startMarker);
  }

  addMarker2() {
    Marker destinationMarker = Marker(
      markerId: MarkerId('marker2'),
      position: LatLng(
       liste1[liste1.length-1],liste2[liste2.length-1]
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    markers.add(destinationMarker);
  }

  void initState() {
    super.initState();
    //getPoints();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      body: (Column(
        children: <Widget>[
          Container(
              height: height/1.3,
              width: width,
              child: customGoogleMaps(height, width)),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                ),
                width: width * 0.4,
                height: height * 0.03,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      child: Text(
                        'Mesafe: ' '$mesafe km',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                ),
                width: width * 0.8,
                height: height * 0.03,
                child: Row(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Visibility(
                      child: Text(
                        'Aktivite Süresi: ' '$saat sa $dk dk $sn sn',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                ),
                width: width * 0.8,
                height: height * 0.03,
                child: Row(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Visibility(
                      child: Text(
                        'Ortalama Hız: ' '$ortalamaHiz',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                ),
                width: width * 0.8,
                height: height * 0.03,
                child: Row(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Visibility(
                      child: Text(
                        'Yakılan Kalori: ' '$cal kcal',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget customGoogleMaps(var height, var width) => Stack(
        children: <Widget>[
          // Map View
          googleMap(),
          // Show zoom buttons
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.blue[100], // button color
                    child: InkWell(
                      splashColor: Colors.blue, // inkwell color
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.add),
                      ),
                      onTap: () {
                        mapController.animateCamera(
                          CameraUpdate.zoomIn(),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ClipOval(
                  child: Material(
                    color: Colors.blue[100], // button color
                    child: InkWell(
                      splashColor: Colors.blue, // inkwell color
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.remove),
                      ),
                      onTap: () {
                        mapController.animateCamera(
                          CameraUpdate.zoomOut(),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0, right: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        clear();
                      },
                      color: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(-0.0),
                        child: Text(
                          "Geri Dön",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      );

  Widget googleMap() => GoogleMap(
        markers: markers != null ? Set<Marker>.from(markers) : null,
        initialCameraPosition: _initialLocation,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          onMapCreated();
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  liste1[0],
                  liste2[0],
                ),
                zoom: 17.0,
              ),
            ),
          );
        },
      );
}
