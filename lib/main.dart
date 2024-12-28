import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:course_project/login_screen.dart';
import 'package:course_project/signup_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'mainScreen.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final FirebaseAuth _auth =FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GrowthTrack",
      theme:
      ThemeData(primarySwatch: Colors.indigo,primaryColor: Colors.indigo),
      home: _auth.currentUser !=null ? MainScreen() : LoginScreen(),

    );
  }
}
