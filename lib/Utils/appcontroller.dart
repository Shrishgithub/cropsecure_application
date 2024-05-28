import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// class AppController{

//   // cl
//   AppController controller =

// }
/*Check Internet Connectivity*/
Future<bool> muIsNetworkAvailable([bool isToast = true]) async {
  try {
    final result = await InternetAddress.lookup('google.com');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      toastMsg('Check Newtork Connection');
      return false;
    }
  } on SocketException catch (ex) {
    logError('muIsNetworkAvailable', 'Internet Not Connected $ex');
    toastMsg('Check Newtork Connection');
    return false;
  }
}

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
