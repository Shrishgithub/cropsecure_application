import 'dart:async';
import 'dart:convert';

import 'package:cropsecure_application/Model/loclist.dart';
import 'package:cropsecure_application/Utils/api_payload.dart';
import 'package:cropsecure_application/Utils/apiresponse.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/Utils/constant.dart';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:cropsecure_application/Utils/spinkit.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final int level1;
  final int level2;
  final String userid;
  const MapScreen(
      {required this.level1, required this.level2, required this.userid});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  List<DatumLocList> locations = [];
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), _fetchlocation);
  }

  Set<Marker> _createMarkers() {
    return locations
        .where((location) => location.lat.isNotEmpty && location.lon.isNotEmpty)
        .map((location) => Marker(
              markerId: MarkerId(location.id.toString()),
              position: LatLng(
                  double.parse(location.lat), double.parse(location.lon)),
              infoWindow: InfoWindow(
                title: location.name,
              ),
            ))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    LatLng initialPosition = LatLng(26.5869121, 80.2162712);

    // logError('locations[0].lat.isNotEmpty', locations[0].lat);
    // logError('locations[0].lon.isNotEmpty', locations[0].lon);

    // // Update the initial position if locations are available
    // if (locations.isNotEmpty &&
    //     locations[0].lat.isNotEmpty &&
    //     locations[0].lon.isNotEmpty) {
    //   initialPosition = LatLng(
    //       double.parse(locations[0].lat), double.parse(locations[0].lon));
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('Location Map'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 12,
        ),
        markers: _createMarkers(),
      ),
    );
  }

  Future<void> _fetchlocation() async {
    dialogLoader(context, 'Loading map...');
    String token = await SharePref.shred.getString('token');
    logInfo('token', token);
    var response = await APIResponse.data.postApiRequest(
        Constant.LocationList,
        ApiPayload.inst
            .locationList(widget.level1, widget.level2, widget.userid),
        {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response != '401' && response != 'No Data') {
      var jsonResponse = jsonDecode(response);
      logSuccess('Location List Data', jsonResponse.toString());

      LocList locl = LocList.fromMap(jsonResponse);
      logSuccess('locl', locl.toString());

      if (locl.status == 'success') {
        setState(() {
          locations = locl.data;
          dialogClose(context);
        });
        logSuccess('locations list', locations.toString());
      } else {
        logError('Location List data', 'Location List Not Found...');
        setState(() {
          dialogClose(context);
        });
      }
    } else {
      setState(() {
        // _isLoading = false;
        dialogClose(context);
      });
    }
  }
}



// import 'dart:async';
// import 'dart:convert';

// import 'package:cropsecure_application/Model/loclist.dart';
// import 'package:cropsecure_application/Utils/api_payload.dart';
// import 'package:cropsecure_application/Utils/apiresponse.dart';
// import 'package:cropsecure_application/Utils/appcontroller.dart';
// import 'package:cropsecure_application/Utils/constant.dart';
// import 'package:cropsecure_application/Utils/sharedpref.dart';
// import 'package:cropsecure_application/Utils/spinkit.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapScreen extends StatefulWidget {
//   // const MapScreen({super.key});
//   final int level1;
//   final int level2;
//   final String userid;
//   const MapScreen(
//       {required this.level1, required this.level2, required this.userid});

//   @override
//   // ignore: library_private_types_in_public_api
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.delayed(Duration(milliseconds: 500), _fetchlocation);
//   }

//   GoogleMapController? _controller;
  

//   final List<Map<String, dynamic>> locations = [
//     {
//       "mongoid": "5f450c4d9e645032a62ebe43",
//       "id": 52876,
//       "name": "Ratan Apartment 1",
//       "level1": 5,
//       "level2": 454,
//       "level3": 6253,
//       "lat": "26.5869121",
//       "lon": "80.2162712"
//     },
//     {
//       "mongoid": "5f450c6a9e645032c9109fa3",
//       "id": 52877,
//       "name": "Ratan Apartment 2",
//       "level1": 5,
//       "level2": 454,
//       "level3": 6253,
//       "lat": "26.5180415",
//       "lon": "80.24494684"
//     },
//     {
//       "mongoid": "661690b39e645007ac090429",
//       "id": 67509,
//       "name": "AWAQE 3",
//       "level1": 5,
//       "level2": 454,
//       "level3": 6253,
//       "lat": "",
//       "lon": ""
//     }
//   ];

//   Set<Marker> _createMarkers() {
//     return locations
//         .where((location) => location['lat'] != "" && location['lon'] != "")
//         .map((location) => Marker(
//               markerId: MarkerId(location['id'].toString()),
//               position: LatLng(
//                   double.parse(location['lat']), double.parse(location['lon'])),
//               infoWindow: InfoWindow(
//                 title: location['name'],
//               ),
//             ))
//         .toSet();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final LatLng initialPosition =
//         LatLng(26.5869121, 80.2162712); // Default center position

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Map'),
//       ),
//       body: GoogleMap(
//         onMapCreated: (controller) {
//           _controller = controller;
//         },
//         initialCameraPosition: CameraPosition(
//           target: initialPosition,
//           zoom: 12,
//         ),
//         markers: _createMarkers(),
//       ),
//     );
//   }

//   Future<void> _fetchlocation() async {
//     // dialogLoader(context, 'Loading map...');
//     String token = await SharePref.shred.getString('token');
//     logInfo('token', token);
//     var response = await APIResponse.data.postApiRequest(
//         Constant.LocationList,
//         ApiPayload.inst
//             .locationList(widget.level1, widget.level2, widget.userid),
//         {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         });

//     if (response != '401' && response != 'No Data') {
//       response = jsonDecode(response);
//       logSuccess('Location List Data', response.toString());

//       LocList locl = LocList.fromMap(response);
//       logSuccess('locl', locl.toString());

//       if (locl.status == 'success') {
//         //       locations = locl.data;
//         //       logSuccess('locations list', locations.toString());
//       } else {
//         logError('Location List data', 'Location List Not Found...');
//       }
//     }
//   }
// }
