import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationPermission? permission;
  getPermission() async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    }
  }

  getLocation() async {
    if (permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition();
      marker.add(Marker(
          markerId: const MarkerId('1'),
          position: LatLng(position.latitude, position.longitude)));
      gmc!.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude)));
      setState(() {});
    }
  }

  List<Marker> marker = [];
  GoogleMapController? gmc;
  CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(33.504307, 36.304141), zoom: 12.1);

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              getLocation();
            },
            child: const Icon(Icons.location_pin,
                color: Color.fromARGB(255, 81, 62, 255), size: 30)),
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 81, 62, 255),
            title: const Text('GeoLocator',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold))),
        body: SizedBox(
            child: Column(children: [
          Expanded(
              child: GoogleMap(
                  markers: marker.toSet(),
                  onMapCreated: (controller) {
                    gmc = controller;
                  },
                  initialCameraPosition: cameraPosition,
                  myLocationButtonEnabled: true))
        ])));
  }
}
