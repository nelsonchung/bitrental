import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class ManageCasePage extends StatefulWidget {
  final String caseId; // 新增這一行
  ManageCasePage({required this.caseId}); // 修改這一行
  @override
  _ManageCasePageState createState() => _ManageCasePageState();
}

class _ManageCasePageState extends State<ManageCasePage> {
  List<String> caseIds = []; // 在這裡保存所有獲取的 caseId
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime pickupDate = DateTime.now();
  TimeOfDay pickupTime = TimeOfDay.now();

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

  Future<Map<String, dynamic>?>? caseDataFuture = Future.value({}); // 初始化
  List<String> selectedDateCaseIds = []; // 用來儲存選定日期的案件ID

  //加入日曆設計，讓使用者可以選擇日期去看當天訂單
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

/* old design
  @override
  void initState() {
    print("Enter initState");
    super.initState();
    _fetchAllCaseIds().then((_) {
      if (caseIds.isNotEmpty) {
        //caseDataFuture = _fetchCaseData(caseIds.first);
        _fetchSelectedDateCaseIds(selectedDate);
        print("caseDataFuture: $caseDataFuture");
      }
    });
  }
*/
  @override
  void initState() {
    super.initState();

    // 確保傳入的 caseId 有效
    if (widget.caseId != null) {
      // 更新 caseDataFuture
      caseDataFuture = _fetchCaseData(widget.caseId!);
    } else {
      print("No valid caseId provided.");
    }
  }

  // 獲取所有 caseId 的函數
  Future<void> _fetchAllCaseIds() async {
    print("Enter _fetchAllCaseIds");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('travelData').get();
    setState(() {
      caseIds = querySnapshot.docs.map((doc) => doc.id).toList();
      print("Fetched caseIds: $caseIds");
    });
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedDateCaseIds(
      DateTime date) async {
    print("Enter _fetchSelectedDateCaseIds");
    List<Map<String, dynamic>> cases = [];
    String formattedDate = formatter.format(date);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('travelData')
        .where('travelDate', isEqualTo: formattedDate)
        .get();
    for (var doc in querySnapshot.docs) {
      cases.add(doc.data() as Map<String, dynamic>);
    }
    return cases;
  }

  Future<Map<String, dynamic>> _fetchCaseData(String caseId) async {
    print("Enter _fetchCaseData");
    print("Fetching case data for caseId: $caseId");

    final DocumentReference caseRef =
        FirebaseFirestore.instance.collection('travelData').doc(caseId);
    final DocumentSnapshot caseSnapshot = await caseRef.get();

    if (caseSnapshot.exists) {
      print("Successfully fetched case data");
      final caseData = caseSnapshot.data() as Map<String, dynamic>;

      // 更新狀態以反映獲取到的案件詳情
      setState(() {
        flightNumber = caseData['flightNumber'];
        selectedDate = DateFormat('yyyy-MM-dd').parse(caseData['travelDate']);
        DateFormat dateFormat = DateFormat("yyyy-MM-dd h:mm a");
        DateTime dateTime =
            dateFormat.parse("2023-01-01 ${caseData['travelTime']}");
        selectedTime = TimeOfDay.fromDateTime(dateTime);

        pickupDate = DateFormat('yyyy-MM-dd').parse(caseData['pickupDate']);
        DateTime pickupDateTime = DateFormat("yyyy-MM-dd h:mm a")
            .parse("2023-01-01 ${caseData['pickupTime']}");
        pickupTime = TimeOfDay.fromDateTime(pickupDateTime);

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
      return caseData;
    } else {
      print("Failed to fetch case data or case does not exist");
      return {}; // 返回一個空的 Map
    }
  }

  Future<void> _updateCaseData(BuildContext context) async {
    print("Enter _updateCaseData");
    if (widget.caseId != null) {
      final DocumentReference caseRef = FirebaseFirestore.instance
          .collection('travelData')
          .doc(widget.caseId);
      return caseRef.update({
        'flightNumber': flightNumber,
        'travelDate': formatter.format(selectedDate),
        'travelTime': selectedTime.format(context),
        'pickupDate': formatter.format(pickupDate),
        'pickupTime': pickupTime.format(context),
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
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("案件更新完成"),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("更新案件失敗: $error"),
          ),
        );
      });
    }
  }

// 添加一個新的函數來刪除案件
  Future<void> _deleteCaseData(BuildContext context) async {
    if (widget.caseId != null) {
      final DocumentReference caseRef = FirebaseFirestore.instance
          .collection('travelData')
          .doc(widget.caseId);
      return caseRef.delete().then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("案件已成功刪除"),
          ),
        );
        Navigator.pop(context, 'refresh'); //使用 'refresh' 標記來返回
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("刪除案件失敗: $error"),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  // 添加 AppBar
        title: Text('管理派單'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
//////
        body: Stack(
      children: [
        // 背景圖片
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        //////
        FutureBuilder<Map<String, dynamic>?>(
          future: caseDataFuture, //使用 caseDataFuture
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("No data"));
            } else {
              Map<String, dynamic> caseData = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    /*
                                            // 添加 TableCalendar 組件
                                            TableCalendar(
                                                firstDay: DateTime.utc(2022, 1, 1),
                                                lastDay: DateTime.utc(2030, 12, 31),
                                                focusedDay: _focusedDay,
                                                calendarFormat: _calendarFormat,
                                                selectedDayPredicate: (DateTime day) {
                                                    return isSameDay(_selectedDay, day);
                                                },
                                                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                                                setState(() {
                                                    _selectedDay = selectedDay;
                                                    _focusedDay = focusedDay;
                                                    // 更新當前選擇的日期，並重新獲取相關的案件
                                                    _fetchSelectedDateCaseIds(_selectedDay!).then((_) {
                                                    if (selectedDateCaseIds.isNotEmpty) {
                                                        caseDataFuture = _fetchCaseData(selectedDateCaseIds.first);  // 或者是您想展示的某個特定案件
                                                    }
                                                    });
                                                });
                                                },
                                                onPageChanged: (focusedDay) {
                                                _focusedDay = focusedDay;
                                                },
                                            ),
                                            */
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
                      child: Text("航班日期: ${formatter.format(selectedDate)}"),
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
                      child: Text("航班時間: ${selectedTime.format(context)}"),
                    ),
                    // 上車日期
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: pickupDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != pickupDate)
                          setState(() {
                            pickupDate = picked;
                          });
                      },
                      child: Text("上車日期: ${formatter.format(pickupDate)}"),
                    ),
                    // 上車時間
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: pickupTime,
                        );
                        if (picked != null && picked != pickupTime)
                          setState(() {
                            pickupTime = picked;
                          });
                      },
                      child: Text("上車時間: ${pickupTime.format(context)}"),
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
                    DropdownButtonFormField<String>(
                      value: driverID,
                      decoration: InputDecoration(labelText: "司機ID:"),
                      onChanged: (String? newValue) {
                        setState(() {
                          driverID = newValue;
                        });
                      },
                      items: <String>['', 'driver1', 'driver2']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // Status Case
                    DropdownButtonFormField<String>(
                      value: statusCase,
                      decoration: InputDecoration(labelText: "案件狀態:"),
                      onChanged: (String? newValue) {
                        setState(() {
                          statusCase = newValue;
                        });
                      },
                      items: <String>['正在安排司機', '已安排好司機', '載送中', '已結案']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // 在 ListView 的底部添加這些按鈕
                    ElevatedButton(
                      onPressed: () {
                        _updateCaseData(context);
                      },
                      child: Text('更新案件'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _deleteCaseData(context);
                      },
                      child: Text('刪除案件'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // 設定按鈕顏色為紅色
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
    ));
  }
}
