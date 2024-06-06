import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

class placePathPage extends StatefulWidget {
  final List<Map<String, dynamic>> paths;

  placePathPage({required this.paths});

  @override
  _placePathPageState createState() => _placePathPageState();
}

class _placePathPageState extends State<placePathPage> {
  late GoogleMapController _controller;

  List<LatLng> _getLatLngPoints() {
    List<LatLng> points = [];
    for (var path in widget.paths) {
      for (var schedule in path['schedules']) {
        double? lat = double.tryParse(schedule['latitude']);
        double? lng = double.tryParse(schedule['longitude']);
        if (lat != null && lng != null) {
          points.add(LatLng(lat, lng));
        }
      }
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> points = _getLatLngPoints();

    Set<Polyline> _createPolylines() {
      return {
        Polyline(
          polylineId: PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
        ),
      };
    }

    return Scaffold(
      appBar: AppBar(title: Text('Your path map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: points.isNotEmpty ? points.first : LatLng(37.77483, -122.41942),
          zoom: 12,
        ),
        polylines: _createPolylines(),
        markers: points
            .map((point) => Marker(
          markerId: MarkerId(point.toString()),
          position: point,
        ))
            .toSet(),
        onMapCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}
