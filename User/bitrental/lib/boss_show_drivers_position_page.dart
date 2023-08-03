import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class BossShowDriversPositionPage extends StatefulWidget {
  const BossShowDriversPositionPage({Key? key}) : super(key: key);

  @override
  _BossShowDriversPositionPageState createState() => _BossShowDriversPositionPageState();
}

class _BossShowDriversPositionPageState extends State<BossShowDriversPositionPage> with WidgetsBindingObserver{
  late GoogleMapController mapController;
  Location location = Location();
  LatLng? currentLocation;
  double? bearing;
  static const LatLng taiwanLatLng = LatLng(25.0330, 121.5654);
  StreamSubscription<LocationData>? locationSubscription;

  @override
  void initState() {
    super.initState();
    initLocation();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData locationData = await location.getLocation();
    LatLng initialLocation = LatLng(
      locationData.latitude ?? taiwanLatLng.latitude,
      locationData.longitude ?? taiwanLatLng.longitude,
    );

    mapController.moveCamera(CameraUpdate.newLatLngZoom(initialLocation, 15));

    setState(() {
      currentLocation = initialLocation;
    });

    startListening();
  }

  void startListening() {
    locationSubscription?.cancel();
    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        this.currentLocation = LatLng(
          currentLocation.latitude ?? taiwanLatLng.latitude,
          currentLocation.longitude ?? taiwanLatLng.longitude,
        );
        bearing = currentLocation.heading;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startListening();
    } else if (state == AppLifecycleState.paused) {
      locationSubscription?.cancel();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('顯示司機位置'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      /*
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      */
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: currentLocation ?? taiwanLatLng,
              zoom: 15,
            ),
            markers: <Marker>{
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: currentLocation ?? const LatLng(0, 0),
                infoWindow: const InfoWindow(
                  title: 'Current Location',
                ),
              ),
            },
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            onCameraMove: (CameraPosition position) {
              setState(() {
                bearing = position.bearing;
              });
            },
          ),
          if (bearing != null)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Bearing: ${bearing!.toStringAsFixed(2)}°',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
