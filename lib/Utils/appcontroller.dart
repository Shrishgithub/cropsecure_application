import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// class AppController{

//   // cl
//   AppController controller =

// }
/*TOAST MESSAGE*/
toastMsg(String value) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: value,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 12.0,
  );
}

void logError(String name, String msg) {
  log('\x1B[31m$msg\x1B[0m', name: '\x1B[37m$name\x1B[0m');
}

void logInfo(String name, String msg) {
  log('\x1B[33m$msg\x1B[0m', name: '\x1B[37m$name\x1B[0m');
}

void logSuccess(String name, String msg) {
  log('\x1B[32m$msg\x1B[0m', name: '\x1B[37m$name\x1B[0m');
}
