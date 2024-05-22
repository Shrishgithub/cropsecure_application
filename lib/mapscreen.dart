import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final LatLng location;

  MapScreen(this.location);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location on Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('selected-location'),
            position: location,
          ),
        },
      ),
    );
  }
}
