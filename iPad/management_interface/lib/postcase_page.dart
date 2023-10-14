/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Nelson Chung
 * Creation Date: Octber 12, 2023
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart'; 


class PostCasePage extends StatefulWidget {
  @override
  _PostCasePageState createState() {
    print("Creating MyFormState");  // Debug print
    return _PostCasePageState();
  }
}

class _PostCasePageState extends State<PostCasePage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  // New variables for dropdowns
  String? pickupLocation;
  String? dropoffLocation;
  int? numberOfPassengers;
  int? numberOfLuggage;

  // 在您的MyFormState類裡面
  String? pickupSelectedCity;
  List<String>? pickupSelectedDistricts;
  String? pickupSelectedDistrict;
  String? pickupDetailedAddress;

  String? dropoffSelectedCity;
  List<String>? dropoffSelectedDistricts;
  String? dropoffSelectedDistrict;
  String? dropoffDetailedAddress;

  String? passengerName;
  String? contactNumber;
  String? remarks;
  String? flightNumber;  // 新增這個變數來存儲航班編號
  String? driverID;
  String? statusCase;

  final List<String> taiwanCities = [
    '基隆市', '台北市', '新北市', '桃園市', '新竹市', '新竹縣', '苗栗縣', 
    '台中市', '南投縣', '彰化縣', '雲林縣', '嘉義市', '嘉義縣', '台南市', 
    '高雄市', '屏東縣', '宜蘭縣', '花蓮縣', '台東縣', '澎湖縣', '金門縣', 
    '連江縣'
  ];
  final Map<String, List<String>> taiwanDistricts = {
    '基隆市': ['仁愛區', '信義區', '中正區', '中山區', '安樂區', '暖暖區', '七堵區'],
    '台北市': ['中正區', '大同區', '中山區', '松山區', '大安區', '萬華區', '信義區', '士林區', '北投區', '內湖區', '南港區', '文山區'],
    '新北市': ['板橋區', '新莊區', '中和區', '永和區', '土城區', '樹林區', '三峽區', '鶯歌區', '三重區', '蘆洲區', '五股區', '泰山區', '林口區', '八里區', '淡水區', '三芝區', '石門區', '金山區', '萬里區', '汐止區', '瑞芳區', '貢寮區', '平溪區', '雙溪區', '新店區', '深坑區', '石碇區', '坪林區', '烏來區'],
    '桃園市': ['桃園區', '中壢區', '平鎮區', '八德區', '楊梅區', '蘆竹區', '大園區', '龍潭區', '龜山區', '大溪區', '新屋區', '觀音區', '復興區'],
    '新竹市': ['東區', '北區', '香山區'],
    '新竹縣': ['竹北市', '湖口鄉', '新豐鄉', '新埔鎮', '關西鎮', '芎林鄉', '寶山鄉', '竹東鎮', '五峰鄉', '橫山鄉', '尖石鄉', '北埔鄉', '峨眉鄉'],
    '苗栗縣': ['苗栗市', '頭份市', '三灣鄉', '南庄鄉', '獅潭鄉', '後龍鎮', '通霄鎮', '苑裡鎮', '苗栗市', '造橋鄉', '頭屋鄉', '公館鄉', '大湖鄉', '泰安鄉', '銅鑼鄉', '三義鄉', '西湖鄉', '卓蘭鎮'],
    '台中市': ['中區', '東區', '南區', '西區', '北區', '北屯區', '西屯區', '南屯區', '太平區', '大里區', '霧峰區', '烏日區', '豐原區', '后里區', '石岡區', '東勢區', '和平區', '新社區', '潭子區', '大雅區', '神岡區', '大肚區', '沙鹿區', '龍井區', '梧棲區', '清水區', '大甲區', '外埔區', '大安區'],
    '南投縣': ['南投市', '中寮鄉', '草屯鎮', '國姓鄉', '埔里鎮', '仁愛鄉', '名間鄉', '集集鎮', '水里鄉', '魚池鄉', '信義鄉', '竹山鎮', '鹿谷鄉'],
    '彰化縣': ['彰化市', '芬園鄉', '花壇鄉', '秀水鄉', '鹿港鎮', '福興鄉', '線西鄉', '和美鎮', '伸港鄉', '員林市', '社頭鄉', '永靖鄉', '埔心鄉', '溪湖鎮', '大村鄉', '埔鹽鄉', '田中鎮', '北斗鎮', '田尾鄉', '埤頭鄉', '溪州鄉', '竹塘鄉', '二林鎮', '大城鄉', '芳苑鄉', '二水鄉'],
    '雲林縣': ['斗南鎮', '大埤鄉', '虎尾鎮', '土庫鎮', '褒忠鄉', '東勢鄉', '台西鄉', '崙背鄉', '麥寮鄉', '斗六市', '林內鄉', '古坑鄉', '莿桐鄉', '西螺鎮', '二崙鄉', '北港鎮', '水林鄉', '口湖鄉', '四湖鄉', '元長鄉'],
    '嘉義市': ['東區', '西區'],
    '嘉義縣': ['番路鄉', '梅山鄉', '竹崎鄉', '阿里山鄉', '中埔鄉', '大埔鄉', '水上鄉', '鹿草鄉', '太保市', '朴子市', '東石鄉', '六腳鄉', '新港鄉', '民雄鄉', '大林鎮', '溪口鄉', '義竹鄉', '布袋鎮'],
    '台南市': ['中西區', '東區', '南區', '北區', '安平區', '安南區', '永康區', '歸仁區', '新化區', '左鎮區', '玉井區', '楠西區', '南化區', '仁德區', '關廟區', '龍崎區', '官田區', '麻豆區', '佳里區', '西港區', '七股區', '將軍區', '學甲區', '北門區', '新營區', '後壁區', '白河區', '東山區', '六甲區', '下營區', '柳營區', '鹽水區', '善化區', '大內區', '山上區', '新市區', '安定區'],
    '高雄市': ['楠梓區', '左營區', '鼓山區', '三民區', '鹽埕區', '前金區', '新興區', '苓雅區', '前鎮區', '旗津區', '小港區', '鳳山區', '大寮區', '鳥松區', '林園區', '仁武區', '大樹區', '大社區', '岡山區', '路竹區', '橋頭區', '梓官區', '彌陀區', '永安區', '燕巢區', '田寮區', '阿蓮區', '茄萣區', '湖內區', '旗山區', '美濃區', '內門區', '杉林區', '甲仙區', '六龜區', '茂林區', '桃源區', '那瑪夏區'],
    '屏東縣': ['屏東市', '三地門鄉', '霧台鄉', '瑪家鄉', '九如鄉', '里港鄉', '高樹鄉', '鹽埔鄉', '長治鄉', '麟洛鄉', '竹田鄉', '內埔鄉', '萬丹鄉', '潮州鎮', '泰武鄉', '來義鄉', '萬巒鄉', '崁頂鄉', '新埤鄉', '南州鄉', '林邊鄉', '東港鎮', '琉球鄉', '佳冬鄉', '新園鄉', '枋寮鄉', '枋山鄉', '春日鄉', '獅子鄉', '車城鄉', '牡丹鄉', '恆春鎮', '滿州鄉'],
    '宜蘭縣': ['宜蘭市', '頭城鎮', '礁溪鄉', '壯圍鄉', '員山鄉', '羅東鎮', '三星鄉', '大同鄉', '五結鄉', '冬山鄉', '蘇澳鎮', '南澳鄉', '釣魚台'],
    '花蓮縣': ['花蓮市', '新城鄉', '秀林鄉', '吉安鄉', '壽豐鄉', '鳳林鎮', '光復鄉', '豐濱鄉', '瑞穗鄉', '萬榮鄉', '玉里鎮', '卓溪鄉', '富里鄉'],
    '台東縣': ['台東市', '綠島鄉', '蘭嶼鄉', '延平鄉', '卑南鄉', '鹿野鄉', '關山鎮', '海端鄉', '池上鄉', '東河鄉', '成功鎮', '長濱鄉', '太麻里鄉', '金峰鄉', '大武鄉', '達仁鄉'],
    '澎湖縣': ['馬公市', '西嶼鄉', '望安鄉', '七美鄉', '白沙鄉', '湖西鄉'],
    '金門縣': ['金沙鎮', '金湖鎮', '金寧鄉', '金城鎮', '烈嶼鄉', '烏坵鄉'],
    '連江縣': ['南竿鄉', '北竿鄉', '莒光鄉', '東引鄉'],
  };

  final List<int> passengerNumbers = List.generate(10, (index) => index + 1);
  final List<int> luggageNumbers = List.generate(5, (index) => index + 1);

  String generateCaseId() {
    // Generate a unique caseId based on the current date and time
    DateTime now = DateTime.now();
    return DateFormat('yyyyMMddHHmmssSSS').format(now);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  Future<void> _sendToFirebase(BuildContext context) async {
    print("Attempting to send data to Firebase");  // Debug print

    String caseId = generateCaseId();  // Generate a unique caseId
    String pickupLocationFull = "$pickupSelectedCity, $pickupSelectedDistrict, $pickupDetailedAddress";
    String dropoffLocationFull = "$dropoffSelectedCity, $dropoffSelectedDistrict, $dropoffDetailedAddress";
    
    CollectionReference travelData = FirebaseFirestore.instance.collection('travelData');
    //return travelData.add({
    return travelData
        .doc(caseId)  // Use the generated caseId as the document ID
        .set({      
      'flightNumber': flightNumber,  // 新增這個字段
      'travelDate': formatter.format(selectedDate),
      'travelTime': selectedTime.format(context),
      //'pickupLocation': pickupLocationFull,
      //'dropoffLocation': dropoffLocationFull,
      'pickupSelectedCity': pickupSelectedCity,
      'pickupSelectedDistrict': pickupSelectedDistrict,
      'pickupDetailedAddress': pickupDetailedAddress,
      'dropoffSelectedCity': dropoffSelectedCity,
      'dropoffSelectedDistrict': dropoffSelectedDistrict,
      'dropoffDetailedAddress': dropoffDetailedAddress,
      'numberOfPassengers': numberOfPassengers,
      'numberOfLuggage': numberOfLuggage,
      'passengerName': passengerName,
      'contactNumber': contactNumber,
      'remarks': remarks,
      'driverID': driverID,
      'statusCase': statusCase,
    })
    .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("案件新增完成並同步到雲系統"),
        ),
      );
    })
    .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("新增案件失敗: $error"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/background.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[

          Text("航班日期:", style: TextStyle(fontFamily: 'NotoSansTC')),
          TextButton(
            onPressed: () => _selectDate(context),
            child: Text(formatter.format(selectedDate)),
          ),
          Text("航班時間:", style: TextStyle(fontFamily: 'NotoSansTC')),
          TextButton(
            onPressed: () => _selectTime(context),
            child: Text(selectedTime.format(context)),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "航班編號:"),
            onChanged: (value) {
              flightNumber = value;  // 更新變數
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "乘客稱呼:"),
            onChanged: (value) {
              passengerName = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "聯絡電話:"),
            onChanged: (value) {
              contactNumber = value;
            },
          ),
          // New Dropdown for Pickup Location
          DropdownButtonFormField<String>(
            value: pickupSelectedCity,
            onChanged: (String? newValue) {
              setState(() {
                pickupSelectedCity = newValue;
                pickupSelectedDistricts = taiwanDistricts[newValue];
              });
            },
            items: taiwanCities.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(labelText: '上車地點 (縣市):'),
          ),
          if (pickupSelectedDistricts != null)
            DropdownButtonFormField<String>(
              value: pickupSelectedDistrict,
              onChanged: (String? newValue) {
                setState(() {
                  pickupSelectedDistrict = newValue;
                });
              },
              items: pickupSelectedDistricts!.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: '上車地點 (區域):'),
            ),
          TextFormField(
            decoration: InputDecoration(labelText: '上車詳細地址:'),
            onChanged: (value) {
              pickupDetailedAddress = value;
            },
          ),
          // New Dropdown for Dropoff Location (City)
          DropdownButtonFormField<String>(
            value: dropoffSelectedCity,
            onChanged: (String? newValue) {
              setState(() {
                dropoffSelectedCity = newValue;
                dropoffSelectedDistricts = taiwanDistricts[newValue];
              });
            },
            items: taiwanCities.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(labelText: '下車地點 (縣市):'),
          ),
          if (dropoffSelectedDistricts != null)
            DropdownButtonFormField<String>(
              value: dropoffSelectedDistrict,
              onChanged: (String? newValue) {
                setState(() {
                  dropoffSelectedDistrict = newValue;
                });
              },
              items: dropoffSelectedDistricts!.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: '下車地點 (區域):'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '下車詳細地址:'),
              onChanged: (value) {
                dropoffDetailedAddress = value;
              },
            ),
          // New Dropdown for Number of Passengers
          DropdownButtonFormField<int>(
            value: numberOfPassengers,
            onChanged: (int? newValue) {
              setState(() {
                numberOfPassengers = newValue;
              });
            },
            items: passengerNumbers.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
            decoration: InputDecoration(labelText: '乘車人數:'),
          ),

          // New Dropdown for Number of Luggage
          DropdownButtonFormField<int>(
            value: numberOfLuggage,
            onChanged: (int? newValue) {
              setState(() {
                numberOfLuggage = newValue;
              });
            },
            items: luggageNumbers.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
            decoration: InputDecoration(labelText: '行李數量:'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "備註:"),
            onChanged: (value) {
              remarks = value;
            },
          ),
          SizedBox(height: 30.0),  // Add space here
          Container(
            height: 50.0,  // Customize height here
            width: 200.0,  // Customize width here
            child: ElevatedButton(
              onPressed: () => _sendToFirebase(context),
              child: Text("新增案件"),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
