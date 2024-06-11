import 'dart:math';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:intl/intl.dart';

String dateFormatTodayDate() {
  DateTime c = DateTime.now();
  DateFormat df = DateFormat("yyyy-MM-dd");
  String formattedDate = df.format(c);
  return formattedDate;
}

String dateFormatFiveDaysBefore() {
  DateTime c = DateTime.now().subtract(Duration(days: 5));
  DateFormat df = DateFormat("yyyy-MM-dd");
  String formattedDate = df.format(c);
  return formattedDate;
}

String dateFormatOneMonthBefore() {
  DateTime now = DateTime.now();
  DateTime oneMonthBefore = DateTime(now.year, now.month - 1, now.day);
  DateFormat df = DateFormat("yyyy-MM-dd");
  String formattedDate = df.format(oneMonthBefore);
  return formattedDate;
}

String dateFormatSixMonthBefore() {
  DateTime now = DateTime.now();
  DateTime oneMonthBefore = DateTime(now.year, now.month - 6, now.day);
  DateFormat df = DateFormat("yyyy-MM-dd");
  String formattedDate = df.format(oneMonthBefore);
  return formattedDate;
}

String dateFormatLog(String date) {
  String formattedDate = '';
  //"2024-01-15T23:59:5";
  try {
    DateTime dateTime = DateTime.parse(date);
    formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
  } catch (ex) {
    logError('dateFormatLog', '$ex');
  }
  return formattedDate;
}

String dateFormateCurrentLog() {
  //"2024-01-15T23:59:5";
  return DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
}

String dateFormatOnTpye(String originalDateStr, String formatType) {
  DateFormat dateFormat = DateFormat(formatType);
  String formattedDate = '';
  try {
    DateTime originalDate = DateTime.parse(originalDateStr);
    formattedDate = dateFormat.format(originalDate);
  } catch (ex) {
    logError('dateFormatOnTpye', '$ex');
  }
  return formattedDate;
}

bool dateFormateIs24Hour(String date) {
  if (date.isNotEmpty) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      DateTime now = DateTime.now();
      Duration difference = now.difference(parsedDate);
      if (difference.inHours > 24) {
        return true;
      }
    } catch (ex) {
      logError('dateFormateIs24Hour', '$ex');
    }
    return false;
  } else {
    return true;
  }
}

bool dateFormateIsAdd(String localDate, String serverDate) {
  try {
    if (localDate.isEmpty) {
      return true;
    }
    if (serverDate.isEmpty) {
      return false;
    }
    DateTime localDateTime = DateTime.parse(localDate);
    DateTime serverDateTime = DateTime.parse(serverDate);
    return localDateTime.isBefore(serverDateTime) ||
        localDateTime.isAtSameMomentAs(serverDateTime);
  } catch (ex) {
    logError('dateFormateIsAdd', '$ex');
  }
  return false;
}

String getCreateImageName(String name) {
  String timeStamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  String imageFileName = '${name}_$timeStamp.jpg';
  // String imageFileName = 'SF_20210105_147502.jpg'; // Uncomment this line if you want to use a specific timestamp
  return imageFileName;
}

String getFileSizeString({required int bytes, int decimals = 0}) {
  const suffixes = ["b", "kb", "mb", "gb", "tb"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}

bool dateFilter(String originalDate, String fromDate, String toDate) {
  try {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    DateTime currentDate = DateTime.parse(originalDate);
    DateTime fromD = dateFormat.parse(fromDate);
    DateTime toD = dateFormat.parse(toDate);
    if (currentDate.isAfter(fromD) && currentDate.isBefore(toD)) {
      return true;
    } else {
      return false;
    }
  } catch (ex) {
    logError('dateFilter', '$ex');
  }
  return false;
}

String dateTimeFormatDayMonth(String inputDate, String passDateFormat) {
  String formattedDate = '';
  try {
    DateTime parsedDate = DateFormat(passDateFormat).parse(inputDate);
    formattedDate = DateFormat('EEEE, MMMM d, y').format(parsedDate);
  } catch (ex) {
    logError('dateTimeFormatDayMonth', '$ex');
  }
  return formattedDate;
}

String dateFormatIsFiveMonthsBack() {
  // DateTime inputDate = DateFormat('yyyy-MM-dd').parse(dateString);
  DateTime currentDate = DateTime.now();
  DateTime twoMonthsBackDate = DateTime(
    currentDate.year,
    currentDate.month - 5,
    currentDate.day,
  );
  return twoMonthsBackDate.toString();
}
