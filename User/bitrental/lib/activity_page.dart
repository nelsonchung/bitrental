import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // ignore: prefer_const_constructors
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      FirebaseFirestore.instance.collection('locations').add({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': DateTime.now()
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Activity'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/sample_map.png',
                fit: BoxFit.cover,
              ),
            ),
            // ignore: prefer_const_constructors
            Center(
              child: const Text('Activity Page'),
            ),
          ],
        ),
      ),
    );
  }
}
