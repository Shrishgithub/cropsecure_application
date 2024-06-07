import 'package:flutter/cupertino.dart';

// class Constant extends StatelessWidget {
//   const Constant({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
class Constant {
  static const Base_URL = "https://aiapi.cropsecure.in/AwsSecusence/";
  static const LOG_IN = "${Base_URL}login"; // Used
  static const Level1Data =
      "${Base_URL}getLevel1List"; // Used // Set to Database and show name from DB // But shorting remain
  static const Level2Data =
      "${Base_URL}getLevel2List"; // Used // Set to Database and show name from DB // But shorting remain
  static const Level3Data =
      "${Base_URL}getLevel3List"; // Used // Set to Database and show name from DB // But shorting remain
  static const LocationCount = "${Base_URL}getLocationCount"; // Used
  static const WheatherParam = "${Base_URL}getParameters"; // Not used yet//
  static const LocationList =
      "${Base_URL}getLocationList"; // Used for locationList and LocationMap
  static const LocationData = "${Base_URL}getLocationData"; // Not used yet//
}
