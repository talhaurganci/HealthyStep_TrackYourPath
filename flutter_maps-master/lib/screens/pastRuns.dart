import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/activity.dart';
import 'package:flutter_maps/screens/homePage.dart';
import 'package:flutter_maps/screens/showPastRun.dart';

import 'loginpage.dart';

String kosuAdi;
List points = [];
List points2 = [];
List<double> liste1 = [];
List<double> liste2 = [];
List dataList = [];
String mesafe;
String ortalamaHiz;
int saat;
int dk;
int sn;
String cal;

class Deneme extends StatefulWidget {
  _Deneme createState() => _Deneme();
}

class _Deneme extends State<Deneme> {
  int i = 0;

  getPoints() {
    FirebaseFirestore.instance
        .collection('Test')
        .orderBy("id", descending: false)
        .where('userId', isEqualTo: uid)
        .where('name', isEqualTo: kosuAdi)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        var list = result.data();
        var list2 = list.values.toList();
        //points.add(list2[0]);
        // points.add(list2[4]);
        //position = points[0];
        //position = points[4];
        points.add(list2[0]);
        points2.add(list2[4]);

        // ignore: unnecessary_statements
        for (i; i < points.length; i++) {
          //print(i);
          liste1.add(points[i]);
          liste2.add(points2[i]);
        }
        // print(liste1);
        // print(liste2);
      });
    });
  }

  getDatas() {
    FirebaseFirestore.instance
        .collection('Aktivite Verileri')
        .where('userId', isEqualTo: uid)
        .where('name', isEqualTo: kosuAdi)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        list = result.data();
        dataList = list.values.toList();
        //points.add(list2[0]);
        // points.add(list2[4]);
        //position = points[0];
        //position = points[4];
        // print(dataList);
        mesafe = dataList[1];
        ortalamaHiz = dataList[6];
        saat = dataList[3];
        dk = dataList[5];
        sn = dataList[2];
        cal = dataList[0];
      });
    });
  }

  goMyRun() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PastMapView()),
    );
  }

  function() async {
    await getDatas();
    await getPoints();
    print(liste1);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Geçmiş Aktiviteleriniz'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          )),
          child: ListView.builder(
            itemCount: runList.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white70,
                child: ListTile(
                  onTap: () async {
                    kosuAdi = names[index].toString();
                    print(kosuAdi);
                    await function();
                    i = 0;
                    Future.delayed(const Duration(milliseconds: 500) , () {
                      goMyRun();
                    });
                  },
                  title: Text(names[index].toString()),
                ),
              );
            },
          ),
        ));
  }
}
