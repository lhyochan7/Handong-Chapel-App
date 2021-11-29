import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
//import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';


class googleMapsPage extends StatefulWidget {
  const googleMapsPage({Key? key}) : super(key: key);

  @override
  _googleMapsPageState createState() => _googleMapsPageState();
}

class _googleMapsPageState extends State<googleMapsPage> {
//   late GoogleMapController mapController;
//   LatLng _center = LatLng(37.532600, 127.024612);
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
//
//   late String _currentAddress = "0.0";
//
//   Future<Position> getLocation() async {
//     Position position = await Geolocator.getCurrentPosition();
//     setState(() {
//       _center = LatLng(position.latitude, position.longitude);
//     });
//
//     return position;
//   }
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
//           //zoomControlsEnabled: false,
//           //markers: _markers,l
//         ),
//       ),
//     );
//   }
// }

  late GoogleMapController mapController;
  LatLng _center = LatLng(37.532600, 127.024612);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  late String _currentAddress = "0.0";

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });

    return position;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps Sample App'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 18,
          ),
          onMapCreated: (GoogleMapController controller) async {},
          myLocationEnabled: true,

          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          //markers: _markers,l
        ),
      ),
    );
  }
}
