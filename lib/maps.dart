import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class googleMapsPage extends StatefulWidget {
  const googleMapsPage(
      {Key? key, required this.addLocation, required this.locations})
      : super(key: key);

  final FutureOr<void> Function(String locationId, GeoPoint geopoint) addLocation;
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

    widget.addLocation(res.toString(), GeoPoint(res.latitude, res.longitude));

  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
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
            title: location.name,
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
