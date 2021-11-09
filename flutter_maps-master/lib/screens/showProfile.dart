import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/activity.dart';
import 'package:flutter_maps/screens/homePage.dart';
import 'package:flutter_maps/screens/loginpage.dart';


class ProfileUI2 extends StatelessWidget {
  @override

    Future <void> _signOut()  async{
    uid == null;
    await FirebaseAuth.instance.signOut();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/background.png"
                ),
                fit: BoxFit.cover,
              )
          ),
          child: Column(
            children: [
              SizedBox(
                height: 90,
              ),
              Center(
                child: Text(
                  FirebaseAuth.instance.currentUser.email,
                  style: TextStyle(
                    fontSize: 15.0,
                    color:Colors.white70,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400
                ),
                ),
              ),
              SizedBox(
                height: 90,
              ),
             SafeArea(
               child: Padding(
                 padding: const EdgeInsets.only(bottom: 5.0, left: 0),
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: <Widget>[
                     RaisedButton(
                       onPressed: () {
                         _signOut();
                         Navigator.pushReplacement(
                             context,
                             MaterialPageRoute(builder: (context) => Loginpage()));
                       },
                       color: Colors.deepPurple,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20.0),
                       ),
                       child: Padding(
                         padding: const EdgeInsets.all(5.0),
                         child: Text(
                           "Çıkış Yap",
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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 200.0, right: 0),
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
                          padding: const EdgeInsets.all(1.0),
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
          ),
        )
    );
  }
}