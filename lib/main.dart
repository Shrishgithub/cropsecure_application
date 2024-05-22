// import 'dart:convert';
// import 'dart:developer';

// import 'package:cropsecure_application/Utils/api_payload.dart';
// import 'package:cropsecure_application/Utils/apiresponse.dart';
// import 'package:cropsecure_application/Utils/constant.dart';
// import 'package:cropsecure_application/Utils/sharedpref.dart';
// import 'package:cropsecure_application/listdata.dart';
import 'package:cropsecure_application/splashscreen.dart';
import 'package:flutter/material.dart';

// import 'package:flutter/widgets.dart';
// import 'package:http/http.dart' as http;
//comment
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ,
      home: SplashScreen(),
    );
  }
}
