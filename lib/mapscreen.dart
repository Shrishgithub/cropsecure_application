import 'dart:async';
import 'dart:convert';

import 'package:cropsecure_application/Model/loclist.dart';
import 'package:cropsecure_application/Utils/api_payload.dart';
import 'package:cropsecure_application/Utils/apiresponse.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/Utils/constant.dart';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:cropsecure_application/Utils/spinkit.dart';
import 'package:cropsecure_application/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final int level1;
  final int level2;
  final int level3;
  final String userid;
  const MapScreen(
      {required this.level1,
      required this.level2,
      required this.level3,
      required this.userid});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  List<DatumLocList> locations = [];

  LatLng initialPosition = LatLng(20.5937, 78.9629); // Default initial position

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

  LatLngBounds _calculateBounds() {
    double southWestLat = double.infinity;
    double southWestLng = double.infinity;
    double northEastLat = -double.infinity;
    double northEastLng = -double.infinity;

    for (var location in locations) {
      double lat = double.parse(location.lat);
      double lng = double.parse(location.lon);

      if (lat < southWestLat) southWestLat = lat;
      if (lng < southWestLng) southWestLng = lng;
      if (lat > northEastLat) northEastLat = lat;
      if (lng > northEastLng) northEastLng = lng;
    }

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Location Map',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
          _updateCameraBounds(); // Update camera bounds when the map is created
        },
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 10.0,
        ),
        markers: _createMarkers(),
        minMaxZoomPreference: MinMaxZoomPreference(5, 10),
      ),
    );
  }

  Future<void> _fetchlocation() async {
    dialogLoader(context, 'Loading map...');
    String token = await SharePref.shred.getString('token');
    logInfo('token', token);
    var response = await APIResponse.data.postApiRequest(
        Constant.LocationList,
        ApiPayload.inst.locationList(
            widget.level1, widget.level2, widget.level3, widget.userid),
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
          if (locations.isNotEmpty &&
              locations[0].lat.isNotEmpty &&
              locations[0].lon.isNotEmpty) {
            initialPosition = LatLng(
                double.parse(locations[0].lat), double.parse(locations[0].lon));
            _updateCameraBounds(); // Update camera bounds after fetching locations
          }
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
      toastMsg('Token Expire, Please Login Again !!');
      SharePref.shred.setBool('islogin', false);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyHomePage()),
          (Route route) => false);
      // setState(() {
      //   dialogClose(context);
      // });
    }
  }

  void _updateCameraBounds() {
    if (_controller != null && locations.isNotEmpty) {
      LatLngBounds bounds = _calculateBounds();
      _controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }
}
