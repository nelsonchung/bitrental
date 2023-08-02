import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AdminManagementApp());
}

class AdminManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late GoogleMapController _controller;
  Set<Marker> _markers = {};

  // Create a timer that will call _loadMarkers every 5 seconds
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadMarkers();

    // Start the timer when the widget is initialized
    _timer = Timer.periodic(Duration(seconds: 5), (_) => _loadMarkers());
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks
    _timer.cancel();
    super.dispose();
  }

  void _loadMarkers() async {
    final querySnapshot = await _firestore.collection('locations').get();
    Set<Marker> newMarkers = {};
    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final marker = Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(
          data['latitude'],
          data['longitude'],
        ),
      );
      newMarkers.add(marker);
    }

    // Update the markers on the map
    setState(() {
      _markers = newMarkers;
    });

    // Display the first marker's details using ScaffoldMessenger
    if (_markers.isNotEmpty) {
      String id = _markers.first.markerId.value;
      double latitude = _markers.first.position.latitude;
      double longitude = _markers.first.position.longitude;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ID: $id, Latitude: $latitude, Longitude: $longitude'),
          duration: Duration(seconds: 5), // Display for 5 seconds
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Management'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        markers: _markers,
      ),
    );
  }
}
