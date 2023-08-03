import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class BossShowDriversPositionPage extends StatefulWidget {
  const BossShowDriversPositionPage({Key? key}) : super(key: key);

  @override
  _BossShowDriversPositionPageState createState() => _BossShowDriversPositionPageState();
}

class _BossShowDriversPositionPageState extends State<BossShowDriversPositionPage> {
  late GoogleMapController mapController;
  static const LatLng taiwanLatLng = LatLng(25.0330, 121.5654);
  Map<String, Marker> markers = {}; // 使用 Map 來保存司機標記，以司機 ID 為鍵

  @override
  void initState() {
    super.initState();
    getDriversLocations();
  }

  Future<void> getDriversLocations() async {
    try {
      // 從 Firebase 的 "locations" 集合中取得所有文件
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('locations').get();

      // 更新有變化的司機標記
      querySnapshot.docs.forEach((doc) {
        double latitude = doc['latitude'];
        double longitude = doc['longitude'];
        String driverId = doc['id'];

        // 如果司機 ID 在 markers 中已存在，且座標有變化，則更新該司機的標記
        if (markers.containsKey(driverId) && markers[driverId]!.position.latitude != latitude && markers[driverId]!.position.longitude != longitude) {
          setState(() {
            markers[driverId] = Marker(
              markerId: MarkerId(driverId),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: '司機 $driverId',
                snippet: '緯度: $latitude, 經度: $longitude',
              ),
            );
          });

            // 顯示司機的資訊
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('司機 $driverId 的位置資訊已更新：緯度 $latitude, 經度 $longitude'),
                    duration: Duration(seconds: 2),
                ),
            );
        } else {
          // 否則建立新的司機標記
          markers[driverId] = Marker(
            markerId: MarkerId(driverId),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: '司機 $driverId',
              snippet: '緯度: $latitude, 經度: $longitude',
            ),
          );
        }
      });
    } catch (error) {
      print('Error occurred while getting drivers locations: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('顯示司機位置'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: taiwanLatLng,
          zoom: 15,
        ),
        markers: Set<Marker>.from(markers.values), // 將 markers 中的標記轉換成 Set<Marker>
        compassEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
      ),
    );
  }
}
