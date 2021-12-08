// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
//
// //import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
//
//
// class googleMapsPage extends StatefulWidget {
//   const googleMapsPage({Key? key}) : super(key: key);
//
//   @override
//   _googleMapsPageState createState() => _googleMapsPageState();
// }
//
// class _googleMapsPageState extends State<googleMapsPage> {
//   late GoogleMapController mapController;
//   LatLng _center = const LatLng(37.532600, 127.024612);
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
//
//   final Set<Marker> markers = new Set(); //markers for google map
//
//   Future<Position> getLocation() async {
//     Position position = await Geolocator.getCurrentPosition();
//     setState(() {
//       _center = LatLng(position.latitude, position.longitude);
//     });
//     return position;
//   }
//
//   final Set<Marker> _markers = {};
//   LatLng _lastMapPosition = _center;
//
//
//   void _onCameraMove(CameraPosition position) {
//     _lastMapPosition = position.target;
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Maps Sample App'),
//         backgroundColor: Colors.green[700],
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: _center,
//             zoom: 18,
//           ),
//           onMapCreated: (GoogleMapController controller) async {},
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//           zoomControlsEnabled: false,
//           markers: _markers,
//         ),
//       ),
//     );
//   }
//
// }

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class googleMapsPage extends StatefulWidget {
  const googleMapsPage(
      {Key? key, required this.addLocation, required this.locations})
      : super(key: key);

  final FutureOr<void> Function(String locationId, double latitude,
      double longitude, GeoPoint geopoint) addLocation;
  final List<locationInfo> locations;

  @override
  _googleMapsPageState createState() =>
      _googleMapsPageState(locations: this.locations);
}

class _googleMapsPageState extends State<googleMapsPage> {
  List<locationInfo> locations;
  _googleMapsPageState({required this.locations});

  Completer<GoogleMapController> _controller = Completer();

  final Stream<QuerySnapshot> _locationStream =
  FirebaseFirestore.instance.collection('locations').snapshots();

  static const LatLng _center = const LatLng(37.532600, 129.024612);

  late Marker _markers;
  late Set<Marker> markers = {};
  var currentLocation;
  LatLng _lastMapPosition = _center;

  var count = 0;
  MapType _currentMapType = MapType.normal;

  void _onAddMarkerButtonPressed() async {
    Position res = await Geolocator.getCurrentPosition();

    widget.addLocation(res.toString(), res.latitude, res.longitude, GeoPoint(res.latitude, res.longitude));

  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);

    setState(() {
      for (var location in widget.locations) {
        count++;
        _markers = Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(count.toString()),
          position:
          LatLng(location.geopoint.latitude, location.geopoint.longitude),
          infoWindow: InfoWindow(
            title: FirebaseAuth.instance.currentUser!.displayName,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );
        markers.add( _markers);
      }

    });
  }
  void _onCreated() async {

    setState(() {
      for (var location in widget.locations) {
        count++;
        _markers = Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(count.toString()),
          position:
          LatLng(location.geopoint.latitude, location.geopoint.longitude),
          infoWindow: InfoWindow(
            title: FirebaseAuth.instance.currentUser!.displayName,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );
        markers.add( _markers);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    _onCreated();
    return StreamBuilder<QuerySnapshot>(
      stream: _locationStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        return Scaffold(
          appBar: AppBar(
            title: Text('Maps'),
          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 16.0,
                ),
                mapType: _currentMapType,
                markers: markers,
                onCameraMove: _onCameraMove,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: _onAddMarkerButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        child: const Icon(Icons.add_location, size: 36.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
