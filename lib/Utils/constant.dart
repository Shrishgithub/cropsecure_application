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
  static const LOG_IN = "${Base_URL}login";
  static const Level1Data = "${Base_URL}getLevel1List";
  static const Level2Data = "${Base_URL}getLevel2List";
  static const Level3Data = "${Base_URL}getLevel3List";
  static const LocationCount = "${Base_URL}getLocationCount";
  static const WheatherParam = "${Base_URL}getParameters";
}
