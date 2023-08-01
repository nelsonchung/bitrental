import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';


class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Timer? _timer;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    // get Driver's id
    _loadUserData();
    _initLocationPrivilege();

    // ignore: prefer_const_constructors
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      String userId = userData!['id'] ?? '未提供';
      double latitude = position.latitude;
      double longitude = position.longitude;
      
      //show location information
      final snackBar = SnackBar(content: Text('ID: $userId\n緯度: $latitude\n經度: $longitude'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      
      FirebaseFirestore.instance.collection('locations').doc(userId).set({
        'id': userId,
        'latitude': latitude,
        'longitude': longitude,
      }, SetOptions(merge: true)).then((_) {
        _showUploadSuccessSnackBar(userId, latitude, longitude); // 顯示上傳成功的提示訊息
      }).catchError((error) {
        print('Error occurred while uploading data: $error');
        final snackBar = SnackBar(content: Text('位置資訊上傳失敗'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  }

Future<void> _initLocationPrivilege() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('請開啟定位服務')));
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('請允許位置權限')));
      return;
    }
  }
}


  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      setState(() {
        userData = jsonDecode(userDataString);
      });
    }
  }

  void _showUploadSuccessSnackBar(String id, double latitude, double longitude) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('位置資訊上傳成功！\nID: $id\n緯度: $latitude\n經度: $longitude'),
        duration: Duration(seconds: 2),
      ),
    );
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
        title: const Text('活動資訊'),
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
            /*
            Positioned.fill(
              child: Image.asset(
                'assets/sample_map.png',
                fit: BoxFit.cover,
              ),
            ),
            */
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
