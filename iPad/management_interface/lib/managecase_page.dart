import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageCasePage extends StatefulWidget {
  //final String caseId;
  //ManageCasePage({required this.caseId});

  @override
  _ManageCasePageState createState() => _ManageCasePageState();
}

class _ManageCasePageState extends State<ManageCasePage> {
  List<String> caseIds = []; // 在這裡保存所有獲取的 caseId

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  // Initialize your variables here, similar to PostCasePage
  String? flightNumber;
  //String? pickupLocationFull;
  //String? dropoffLocationFull;
  int? numberOfPassengers;
  int? numberOfLuggage;
  String? passengerName;
  String? contactNumber;
  String? remarks;
  String? driverID;
  String? statusCase;
  String? pickupSelectedCity;
  String? pickupSelectedDistrict;
  String? pickupDetailedAddress;
  String? dropoffSelectedCity;
  String? dropoffSelectedDistrict;
  String? dropoffDetailedAddress;

  String? currentCaseId;  // 添加這一行來保存當前選擇的 caseId


  @override
  void initState() {
    super.initState();
    _fetchAllCaseIds();
  }

  // 獲取所有 caseId 的函數
  Future<void> _fetchAllCaseIds() async {
    print("Enter _fetchAllCaseIds");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('travelData').get();
    setState(() {
      caseIds = querySnapshot.docs.map((doc) => doc.id).toList();
    });
    // 如果您想要用第一個 caseId 進行其他操作，您可以這樣做
    if (caseIds.isNotEmpty) {
      _fetchCaseData(caseIds.first);  // 使用第一個 caseId 作為例子
    }
  }  

  Future<void> _fetchCaseData(String caseId) async {
    print("Enter _fetchCaseData");
    currentCaseId = caseId;

    final DocumentReference caseRef = FirebaseFirestore.instance.collection('travelData').doc(currentCaseId);
    final DocumentSnapshot caseSnapshot = await caseRef.get();

    if (caseSnapshot.exists) {
      final caseData = caseSnapshot.data() as Map<String, dynamic>;
      setState(() {
        flightNumber = caseData['flightNumber'];
        selectedDate = DateFormat('yyyy-MM-dd').parse(caseData['travelDate']);
        DateFormat dateFormat = DateFormat("yyyy-MM-dd h:mm a");
        DateTime dateTime = dateFormat.parse("2023-01-01 ${caseData['travelTime']}");
        selectedTime = TimeOfDay.fromDateTime(dateTime);
        //selectedTime = TimeOfDay.fromDateTime(DateTime.parse('2023-01-01 ${caseData['travelTime']}'));
        //pickupLocationFull = caseData['pickupLocation'];
        //dropoffLocationFull = caseData['dropoffLocation'];
        numberOfPassengers = caseData['numberOfPassengers'];
        numberOfLuggage = caseData['numberOfLuggage'];
        passengerName = caseData['passengerName'];
        contactNumber = caseData['contactNumber'];
        remarks = caseData['remarks'];
        driverID = caseData['driverID'];
        statusCase = caseData['statusCase'];
        pickupSelectedCity = caseData['pickupSelectedCity'];
        pickupSelectedDistrict = caseData['pickupSelectedDistrict'];
        pickupDetailedAddress = caseData['pickupDetailedAddress'];
        dropoffSelectedCity = caseData['dropoffSelectedCity'];
        dropoffSelectedDistrict = caseData['dropoffSelectedDistrict'];
        dropoffDetailedAddress = caseData['dropoffDetailedAddress'];        
      });
    }
  }

  Future<void> _updateCaseData(BuildContext context) async {
    print("Enter _updateCaseData");
    if (currentCaseId != null) {
        final DocumentReference caseRef = FirebaseFirestore.instance.collection('travelData').doc(currentCaseId);
        return caseRef.update({
        'flightNumber': flightNumber,
        'travelDate': formatter.format(selectedDate),
        'travelTime': selectedTime.format(context),
        //'pickupLocation': pickupLocationFull,
        //'dropoffLocation': dropoffLocationFull,
        'numberOfPassengers': numberOfPassengers,
        'numberOfLuggage': numberOfLuggage,
        'passengerName': passengerName,
        'contactNumber': contactNumber,
        'remarks': remarks,
        'driverID': driverID,
        'statusCase': statusCase,
        'pickupSelectedCity': pickupSelectedCity,
        'pickupSelectedDistrict': pickupSelectedDistrict,
        'pickupDetailedAddress': pickupDetailedAddress,
        'dropoffSelectedCity': dropoffSelectedCity,
        'dropoffSelectedDistrict': dropoffSelectedDistrict,
        'dropoffDetailedAddress': dropoffDetailedAddress,      
        })
        .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
            content: Text("案件更新完成"),
            ),
        );
        })
        .catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
            content: Text("更新案件失敗: $error"),
            ),
        );
        });
    }
  }
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('管理案件'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Flight Number
            TextFormField(
              initialValue: flightNumber,
              decoration: InputDecoration(labelText: "航班編號:"),
              onChanged: (value) {
                flightNumber = value;
              },
            ),
            // Travel Date
            ElevatedButton(
              onPressed: () async {
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
              },
              child: Text("選擇日期: ${formatter.format(selectedDate)}"),
            ),
            // Travel Time
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null && picked != selectedTime)
                  setState(() {
                    selectedTime = picked;
                  });
              },
              child: Text("選擇時間: ${selectedTime.format(context)}"),
            ),
            // 上車地點
            TextFormField(
            initialValue: pickupSelectedCity,
            decoration: InputDecoration(labelText: "上車城市:"),
            onChanged: (value) {
                pickupSelectedCity = value;
            },
            ),
            TextFormField(
            initialValue: pickupSelectedDistrict,
            decoration: InputDecoration(labelText: "上車地區:"),
            onChanged: (value) {
                pickupSelectedDistrict = value;
            },
            ),
            TextFormField(
            initialValue: pickupDetailedAddress,
            decoration: InputDecoration(labelText: "上車詳細地址:"),
            onChanged: (value) {
                pickupDetailedAddress = value;
            },
            ),
            // 目的地
            TextFormField(
            initialValue: dropoffSelectedCity,
            decoration: InputDecoration(labelText: "目的城市:"),
            onChanged: (value) {
                dropoffSelectedCity = value;
            },
            ),
            TextFormField(
            initialValue: dropoffSelectedDistrict,
            decoration: InputDecoration(labelText: "目的地區:"),
            onChanged: (value) {
                dropoffSelectedDistrict = value;
            },
            ),
            TextFormField(
            initialValue: dropoffDetailedAddress,
            decoration: InputDecoration(labelText: "目的詳細地址:"),
            onChanged: (value) {
                dropoffDetailedAddress = value;
            },
            ),

            // Number of Passengers
            TextFormField(
              initialValue: numberOfPassengers?.toString(),
              decoration: InputDecoration(labelText: "乘客人數:"),
              onChanged: (value) {
                numberOfPassengers = int.parse(value);
              },
              keyboardType: TextInputType.number,
            ),
            // Number of Luggage
            TextFormField(
              initialValue: numberOfLuggage?.toString(),
              decoration: InputDecoration(labelText: "行李數量:"),
              onChanged: (value) {
                numberOfLuggage = int.parse(value);
              },
              keyboardType: TextInputType.number,
            ),
            // Passenger Name
            TextFormField(
              initialValue: passengerName,
              decoration: InputDecoration(labelText: "乘客名稱:"),
              onChanged: (value) {
                passengerName = value;
              },
            ),
            // Contact Number
            TextFormField(
              initialValue: contactNumber,
              decoration: InputDecoration(labelText: "聯絡號碼:"),
              onChanged: (value) {
                contactNumber = value;
              },
              keyboardType: TextInputType.phone,
            ),
            // Remarks
            TextFormField(
              initialValue: remarks,
              decoration: InputDecoration(labelText: "備註:"),
              onChanged: (value) {
                remarks = value;
              },
            ),
            // Driver ID
            TextFormField(
              initialValue: driverID,
              decoration: InputDecoration(labelText: "司機ID:"),
              onChanged: (value) {
                driverID = value;
              },
            ),
            // Status Case
            TextFormField(
              initialValue: statusCase,
              decoration: InputDecoration(labelText: "案件狀態:"),
              onChanged: (value) {
                statusCase = value;
              },
            ),
            ElevatedButton(
              onPressed: () => _updateCaseData(context),
              child: Text('更新案件'),
            ),
          ],
        ),
      ),
    );
  }

}
