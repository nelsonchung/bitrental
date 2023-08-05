import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class BossShowDriversPositionPage extends StatefulWidget {
  const BossShowDriversPositionPage({Key? key}) : super(key: key);

  @override
  _BossShowDriversPositionPageState createState() =>
      _BossShowDriversPositionPageState();
}

class _BossShowDriversPositionPageState
    extends State<BossShowDriversPositionPage> {
  late GoogleMapController mapController;
  static const LatLng taiwanLatLng = LatLng(25.0330, 121.5654);
  Map<String, Marker> markers = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getDriversLocations();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // 定位成功後，在地圖上移動到當前位置
    _getLocation().then((position) {
      if (position != null) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ));
      }
    });
  }

  Future<Position?> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getDriversLocations() async {
    try {
      // 從 Firebase 的 "locations" 集合中取得所有文件
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('locations').get();

      // 更新有變化的司機標記
      querySnapshot.docs.forEach((doc) {
        double latitude = doc['latitude'];
        double longitude = doc['longitude'];
        String driverId = doc['id'];
        String displayName = doc['displayName'];

        /* Debug use
        // 顯示司機的資訊: 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '司機 $displayName 的位置資訊：\n緯度 $latitude \n經度 $longitude'),
            duration: Duration(seconds: 2),
          ),
        );
        */

        // 先設定永遠更新
        if (true) {
        // 如果司機 ID 在 markers 中已存在，且座標有變化，則更新該司機的標記
        /*
        if (markers.containsKey(driverId) &&
            markers[driverId]!.position.latitude != latitude &&
            markers[driverId]!.position.longitude != longitude) {
                */
            setState(() {
            
            /*
            //Debug use
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Enter if'),
                    duration: Duration(seconds: 2),
                ),
            );
            */

            markers[driverId] = Marker(
              markerId: MarkerId(driverId),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: '司機 $driverId',
                snippet: '稱呼: $displayName, 緯度: $latitude, 經度: $longitude',
              ),
              icon: BitmapDescriptor.defaultMarker, // 將標記顏色設為預設的紅色
            );
          });
        } else {

            //Debug use
            /*
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Enter else'),
                    duration: Duration(seconds: 2),
                ),
            );
            */

          // 否則建立新的司機標記
          markers[driverId] = Marker(
            markerId: MarkerId(driverId),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: '司機 $driverId',
              snippet: '稱呼: $displayName, 緯度: $latitude, 經度: $longitude',
            ),
            icon: BitmapDescriptor.defaultMarker, // 將標記顏色設為預設的紅色
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
        //backgroundColor: Colors.transparent,
        //elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            target: taiwanLatLng,
            zoom: 15,
          ),
          markers: Set<Marker>.from(markers.values),
          compassEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
        ),
      ),
    );
  }
}
