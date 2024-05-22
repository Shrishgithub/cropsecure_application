import 'dart:async';
import 'package:cropsecure_application/Database/db.dart';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:cropsecure_application/homepage.dart';
import 'package:cropsecure_application/listdata.dart';
import 'package:cropsecure_application/main.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    DB.inst.openDB();
    super.initState();
    // Start a timer to navigate after a certain duration+
    Timer(const Duration(seconds: 2), () async {
      if (!await SharePref.shred.getBool('islogin')) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ListData()),
        );
        // SharePref.shred.setBool('islogin', false);
      }
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const MyHomePage()),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Adjust this to your splash screen color
      body: Center(
        // You can display your logo or animation here
        child: Image.asset(
          'assets/wrms_logo.png',
          height: 40,
        ),
      ),
    );
  }
}
