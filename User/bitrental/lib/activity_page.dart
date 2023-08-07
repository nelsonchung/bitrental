import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    // Get Driver's id
    _loadUserData();

    // Configure the plugin
    bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        heartbeatInterval: 5,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    )).then((bg.State state) {
        if (!state.enabled) {
          bg.BackgroundGeolocation.start();
        }
    });

    // Listen for location updates
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      // Upload location to Firebase
      String userId = userData!['id'] ?? '未提供';
      String displayName = userData!['displayName'] ?? '未提供';
      double latitude = location.coords.latitude;
      double longitude = location.coords.longitude;

      // Show location information
      final snackBar = SnackBar(content: Text('ID: $userId\n司機名稱: $displayName\n緯度: $latitude\n經度: $longitude'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      
      FirebaseFirestore.instance.collection('locations').doc(userId).set({
        'id': userId,
        'displayName': displayName,
        'latitude': latitude,
        'longitude': longitude,
      }, SetOptions(merge: true)).then((_) {
        _showUploadSuccessSnackBar(userId, displayName, latitude, longitude); // Show successful upload message
      }).catchError((error) {
        print('Error occurred while uploading data: $error');
        final snackBar = SnackBar(content: Text('位置資訊上傳失敗'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
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

  void _showUploadSuccessSnackBar(String id, String displayName, double latitude, double longitude) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('位置資訊上傳成功！\nID: $id\nDisplayName: $displayName\n緯度: $latitude\n經度: $longitude'),
        duration: Duration(seconds: 2),
      ),
    );
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
            Center(
              child: const Text('啟動定位功能，並確認是否有定位資訊顯示。\n每5秒更新一次'),
            ),
          ],
        ),
      ),
    );
  }
}
