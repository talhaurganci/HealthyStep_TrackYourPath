import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_maps/dataList.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter_maps/screens/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter_maps/screens/loginpage.dart';
import 'package:flutter_maps/dataList.dart';


/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection('Test')
        .snapshots()
        .listen((data) => data.docs.forEach((doc) => print(doc['ghs'])));
    FirebaseFirestore.instance
        .collection('Test')
        .snapshots()
        .listen((data) => data.docs.forEach((doc) => print(doc['koordinat'])));
    return MaterialApp(
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapView(),
    );
  }
}
*/
class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;

  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  String _placeDistance;
  Set<Marker> markers = {};
  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Timer timer;
  bool durum;
  Position startCoordinates;
  Position finishCoordinates;
  Stopwatch s = new Stopwatch();
  int saat;
  int dk;
  int sn;
  double ortalamahiz;
  double MET;
  double calories;
  String cal;
  Geoflutterfire geo = Geoflutterfire();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String kosuadi;
  final myController = TextEditingController();
  int nb1 = 0;
  LatLng lat;
  LatLng lng;
  Map<String, dynamic> list;
  static List runList = [];

  _showMyDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("Lütfen koşunuza isim veriniz"),
            content: TextField(
              controller: myController,
            ),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: MaterialButton(
                    // When the user presses the button, show an alert dialog containing the
                    // text that the user has entered into the text field.
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            // Retrieve the text the user has entered by using the
                            // TextEditingController.
                            content: Text(myController.text),
                          );
                        },
                      );
                      kosuadi = myController.text;
                    },
                    child: Icon(Icons.text_fields),
                  ))
            ],
          );
        });
  }

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
        // databaseSave();
      });
    });
  }

/*
  databaseSave() async {
    final User user = auth.currentUser;
    //final uid = user.uid;
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        //print('CURRENT POS: $_currentPosition');
        //List<Map<String,dynamic>> result = new List<Map<String,dynamic>>();
        GeoFirePoint point = geo.point(
            latitude: position.latitude, longitude: position.longitude);
        return FirebaseFirestore.instance.collection('Test').add({
          'Liste': FieldValue.arrayUnion(liste),
          'position': point.data,
          'name': kosuadi,
          'uId': user.uid,
        });
      });
    });
  }
*/
  dataBaseSave() async {
    final User user = auth.currentUser;
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        DataList data = DataList(nb1, user.uid, kosuadi, position.latitude, position.longitude);
        /*GeoFirePoint point = geo.point(
            latitude: position.latitude, longitude: position.longitude);

            */
        FirebaseFirestore.instance.collection('Test').add(
            {
              "id": nb1,
              "userId": user.uid,
              "name": kosuadi,
              "latitude": position.latitude,
              "longitude": position.longitude
            }
        );
        nb1++;
      });
    });
  }

  databaseSave2() async {
        FirebaseFirestore.instance.collection('Aktivite Verileri').add(
            {
              "userId": user.uid,
              "name": kosuadi,
              "mesafe": _placeDistance,
              "yakılan kalori": cal,
              "aktivite saati": saat,
              "aktivite dakikası": dk,
              "aktivite saniyesi": sn,
              "Ortalama hız": ortalamahiz.toStringAsFixed(2) + 'km/h'
            });
  }

  getData() async {

    FirebaseFirestore.instance
        .collection('Test')
       // .orderBy("id", descending: false)
       // .where('name', isEqualTo: "kosum")
        .where('userId', isEqualTo: uid)
        .get()
        .then((value) {
      value.docs.forEach((result) {
       list = result.data();
       var list2 = list.values.toList();
       //print(list2[0].toString());
       //print(list2[1].toString());
       //print(list2[2].toString());
      // print(list2[3].toString());
       //print(list2[4].toString());
      // print("-------------------------------------");
       
       if(!runList.contains(list2[1].toString())){
          runList.add(list2[1]);
         //Geçmiş aktivite ekranında bu sorgu ile isimler alınacak
       }
       
      });
      print(runList.length);
    });
  }


/*
  void getData2() {
    FirebaseFirestore.instance
        .collection("stores").where(('Liste'), arrayContains: "kosum1")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot..forEach((f) {
        print('${f.data}}');
        GeoPoint pos = f.data['position'];
        LatLng latLng = new LatLng(pos.latitude, pos.longitude);

      });
    });
  }
*/

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    double totalDistance = 0.0;

    // Calculating the total distance by adding the distance
    // between small segments
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }
    setState(() {
      _placeDistance = totalDistance.toStringAsFixed(2);
      print('DISTANCE: $_placeDistance km');
      ortalamahiz = totalDistance / (s.elapsed.inSeconds / 3600);
      print('Ortalama Hız:' + ortalamahiz.toStringAsFixed(2) + 'km/h');
    });
    return true;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    //deneme();
    //print(uid);
  }

  void drawPolylines() {
    _geolocator
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.best, timeInterval: 3000))
        .listen((position) {
      if (durum == true) {
        _getCurrentLocation();
        createPolylines(_currentPosition);
        saat = s.elapsed.inHours;
        dk = s.elapsed.inMinutes % 60;
        sn = s.elapsed.inSeconds % 60;
        //dataBaseSave();
      }
    });
    if (durum == false) print("durum false");
  }

  createPolylines(Position start) {
    _currentPosition = start;
    polylinePoints = PolylinePoints();
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

  addMarker1() {
    Marker startMarker = Marker(
      markerId: MarkerId('marker1'),
      position: LatLng(
        startCoordinates.latitude,
        startCoordinates.longitude,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    markers.add(startMarker);
  }

  addMarker2() {
    Marker destinationMarker = Marker(
      markerId: MarkerId('marker2'),
      position: LatLng(
        finishCoordinates.latitude,
        finishCoordinates.longitude,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    markers.add(destinationMarker);
  }

  Future<bool> calculateCalories() async {
    if (ortalamahiz < 4)
      MET = 3.5;
    else if (4 <= ortalamahiz && ortalamahiz < 7)
      MET = 4.3;
    else if (7 <= ortalamahiz && ortalamahiz < 10)
      MET = 8.5;
    else if (10 <= ortalamahiz && ortalamahiz < 13)
      MET = 11;
    else if (13 <= ortalamahiz && ortalamahiz < 16)
      MET = 12.8;
    else if (16 <= ortalamahiz && ortalamahiz < 19)
      MET = 15.5;
    else if (19 <= ortalamahiz && ortalamahiz < 22)
      MET = 19;
    else if (22 <= ortalamahiz) MET = 24;
    setState(() {
      calories = MET * 3.5 * 70 / 12000 * s.elapsed.inSeconds;
      cal = calories.toStringAsFixed(1);
      print('Yakılan kalori: ' + calories.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            Container(
                height: height / 1.4,
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
                        visible: _placeDistance == null ? false : true,
                        child: Text(
                          'Mesafe: ' '$_placeDistance km',
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
                  width: width * 0.4,
                  height: height * 0.03,
                  child: Row(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Visibility(
                        visible: _placeDistance == null ? false : true,
                        child: Text(
                          'Zaman: ' '$saat:$dk:$sn',
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
                        visible: _placeDistance == null ? false : true,
                        child: Text(
                          'Yakılan Kalori: ' '$cal' ' kcal',
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
        ));
  }

  Widget googleMap() => GoogleMap(
        markers: markers != null ? Set<Marker>.from(markers) : null,
        initialCameraPosition: _initialLocation,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        polylines: Set<Polyline>.of(polylines.values),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      );

  Widget customGoogleMaps(var height, var width) => Stack(
        children: <Widget>[
          // Map View
          googleMap(),
          // Show zoom buttons
          SafeArea(
            child: Padding(
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
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, right: 250.0),
                child: Container(
                  width: width * 0.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 0),
                      RaisedButton(
                        onPressed: () {
                          if (kosuadi == null) _showMyDialog();
                          if (kosuadi != null) {
                            s.start();
                            _getCurrentLocation();
                            startCoordinates = _currentPosition;
                            addMarker1();
                            durum = true;
                            drawPolylines();
                            //dataBaseSave();
                            //getData();

                          }
                        },
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Başla",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, right: 75.0),
                child: Container(
                  width: width * 0.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 0),
                      RaisedButton(
                        onPressed: () {
                          _getCurrentLocation();
                          finishCoordinates = _currentPosition;
                          addMarker2();
                          durum = false;
                          drawPolylines();
                          _calculateDistance();
                          calculateCalories();
                          getData();
                          databaseSave2();
                        },
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Bitir",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Show current location button
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.orange[100], // button color
                    child: InkWell(
                      splashColor: Colors.orange, // inkwell color
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.my_location),
                      ),
                      onTap: () {
                        _getCurrentLocation();
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                _currentPosition.latitude,
                                _currentPosition.longitude,
                              ),
                              zoom: 18.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()));
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
}
