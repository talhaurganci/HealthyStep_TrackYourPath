import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/activity.dart';
import 'package:flutter_maps/main.dart';
import 'package:flutter_maps/screens/pastRuns.dart';
import 'package:flutter_maps/screens/showProfile.dart';

import 'loginpage.dart';

Map<String, dynamic> list;
List runList = [];
List<dynamic> list2;
List names = [];
int i = 0;
class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {

  void initState() {
    super.initState();
    getData();
    print(names);
  }
  getData() {
    FirebaseFirestore.instance
        .collection('Test')
    // .orderBy("id", descending: false)
    // .where('name', isEqualTo: "kosum")
        .where('userId', isEqualTo: uid)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        list = result.data();
        list2 = list.values.toList();
        // print(list2[0].toString());
        // print(list2[1].toString());
        // print(list2[2].toString());
        // print(list2[3].toString());
        // print(list2[4].toString());
        // print("-------------------------------------");

        if(!runList.contains(list2[1].toString())){
          runList.add(list2[1]);
          //Geçmiş aktivite ekranında bu sorgu ile isimler alınacak
        }
        for(i; i<runList.length; i++){
          //if(!runList.contains(list2[1].toString()))
            names.add(runList[i]);
            print(names);
        }
      });
      print(runList.length);
    });
  }

  navigator() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Deneme()),
    );
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        /* appBar: AppBar(
          title: new Text("Home Page"),
        ),*/
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/background.png"
              ),
              fit: BoxFit.cover,
            )
          ),
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  SizedBox(height: 70.0),
                  SizedBox(
                    height: 0.0,
                    child: new Text(
                      "Aktivite Yap",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                      elevation: 0.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      padding: EdgeInsets.only(
                          top: 7.0, bottom: 7.0, right: 40.0, left: 7.0),
                      onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MapView()),
                          ),
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: new Text(
                                "Aktivite Yap",
                                style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      textColor: Color(0xFF292929),
                      color: Colors.green),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 30.0, bottom: 0.0),
                    child: new RaisedButton(
                        elevation: 0.0,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        padding: EdgeInsets.only(
                            top: 7.0, bottom: 7.0, right: 40.0, left: 7.0),
                        onPressed: () {
                          Future.delayed(const Duration(milliseconds: 1000), () {
                            navigator();
                          });
                        },
                        child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: new Text(
                                  "Geçmiş Aktiviteleri Görüntüle",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ))
                          ],
                        ),
                        textColor: Color(0xFF292929),
                        color: Colors.blueAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 30.0, bottom: 0.0),
                    child: new RaisedButton(
                        elevation: 0.0,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        padding: EdgeInsets.only(
                            top: 7.0, bottom: 7.0, right: 25.0, left: 7.0),
                        onPressed: ()=> Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileUI2()),
                        ),
                        child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: new Text(
                                  "Profili Görüntüle",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ))
                          ],
                        ),
                        textColor: Color(0xFF292929),
                        color: Colors.red),
                  ),
                ],
              ),
              SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Healty Step-Track Your Path",
                        style: TextStyle(
                            color: Colors.white70,
                          fontWeight: FontWeight.w900,
                          fontSize: 23
                          )
                      ),
                    ),
                  ),
                  ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                        "v0.1",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w900,
                            fontSize: 18
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
