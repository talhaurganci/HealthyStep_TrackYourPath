import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/screens/homePage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser;
var uid = user.uid;

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

  String email;
  String password;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _createUser() async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("Firebase Hatası $e" );
    } catch(e) {
      print("Hata $e" );
    }
  }

   Future<void> _login() async {
    final User user = auth.currentUser;
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      inputData();
      print("Giriş Yapıldı");
    } on FirebaseAuthException catch (e) {
      print("Firebase Hatası $e" );
    } catch(e) {
      print("Hata $e" );
    }
  }

    afterLogin() {
      final User user = auth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    }
  deneme() async {
    await _login();
    afterLogin();
  }

  void inputData() {
    final User user = auth.currentUser;
    final uid = user.uid;
    print(uid);
    // here you write the codes to input the data into firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Healty Step-Track Your Path"
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/background.png"
              ),
              fit: BoxFit.cover,
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  hintText: "E-mailinizi Girin"
                ),
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                    hintText: "Şifrenizi Girin"
                ),
              ),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 MaterialButton(
                   onPressed: deneme,
                   child: Text("Giriş Yap"),
                 ),
                 MaterialButton(
                   onPressed: () {
                     _createUser();
                   },
                   child: Text("Yeni Hesap Oluştur"),
                 ),
               ],
             )
            ],
          ),
        ),
      ),
    );
  }
}
