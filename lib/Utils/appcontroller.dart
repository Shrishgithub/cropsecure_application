import 'dart:developer';

// class AppController{

//   // cl
//   AppController controller =

// }
void logError(String name, String msg) {
  log('\x1B[31m$msg\x1B[0m', name: '\x1B[37m$name\x1B[0m');
}

void logInfo(String name, String msg) {
  log('\x1B[33m$msg\x1B[0m', name: '\x1B[37m$name\x1B[0m');
}

void logSuccess(String name, String msg) {
  log('\x1B[32m$msg\x1B[0m', name: '\x1B[37m$name\x1B[0m');
}
