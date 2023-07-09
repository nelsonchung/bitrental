import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(AdminManagementApp());
}

// ignore: use_key_in_widget_constructors
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

// ignore: use_key_in_widget_constructors
class MapPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // ignore: unused_field
  late GoogleMapController _controller;
  // ignore: prefer_final_fields
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() async {
    final querySnapshot = await _firestore.collection('locations').get();
    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final marker = Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(
          data['latitude'],
          data['longitude'],
        ),
      );
      _markers.add(marker);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text('Admin Management'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        // ignore: prefer_const_constructors
        initialCameraPosition: CameraPosition(
          // ignore: prefer_const_constructors
          target: LatLng(0, 0),
          zoom: 2,
        ),
        markers: _markers,
      ),
    );
  }
}
