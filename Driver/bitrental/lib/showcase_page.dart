import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'login_page.dart';

class ShowCasePage extends StatefulWidget {
  final String driverID;  // 新增 driverID
  ShowCasePage({required this.driverID});  // 更新 constructor
  
  @override
  _ShowCasePageState createState() => _ShowCasePageState();
}

class _ShowCasePageState extends State<ShowCasePage> {
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

  String? currentCaseId; // 添加這一行來保存當前選擇的 caseId

  Future<Map<String, dynamic>?> caseDataFuture = Future.value({}); // 初始化
  List<String> selectedDateCaseIds = []; // 用來儲存選定日期的案件ID

  List<Map<String, dynamic>> selectedDateCases = []; // 用來儲存選定日期的所有案件

  //加入日曆設計，讓使用者可以選擇日期去看當天訂單
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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

Future<void> _fetchSelectedDateCaseIds(DateTime date) async {
  print("Enter _fetchSelectedDateCaseIds");
  String formattedDate = formatter.format(date);
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('travelData')
      .where('travelDate', isEqualTo: formattedDate)
      .where('driverID', isEqualTo: widget.driverID)
      .get();
  setState(() {
    selectedDateCases = querySnapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;  // 保存文檔的 ID
          return data;
        })
        .toList();
  });
}


  Future<Map<String, dynamic>?> _fetchCaseData(String? caseId) async {
    print("Enter _fetchCaseData");

    if (caseId == null) {
      return null;
    }
    currentCaseId = caseId;

    final DocumentReference caseRef =
        FirebaseFirestore.instance.collection('travelData').doc(currentCaseId);
    final DocumentSnapshot caseSnapshot = await caseRef.get();

    if (caseSnapshot.exists) {
      final caseData = caseSnapshot.data() as Map<String, dynamic>;
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
    }
    return null;
  }

  Future<void> _updateCaseData(BuildContext context) async {
    print("Enter _updateCaseData");
    if (currentCaseId != null) {
      final DocumentReference caseRef = FirebaseFirestore.instance
          .collection('travelData')
          .doc(currentCaseId);
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
  //}

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('案例資訊'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
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

          SingleChildScrollView(
            // 使用 SingleChildScrollView 而非 ListView
            padding: const EdgeInsets.all(45.0),
            child: Column(
              // 使用 Column 來垂直排列子控件
              children: <Widget>[
                // 重新加入 TableCalendar
                TableCalendar(
                  // ... 其他設定
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
                      _fetchSelectedDateCaseIds(_selectedDay!);
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),

                // 顯示今天的日期
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '今天是 ${DateFormat('y年M月d日').format(DateTime.now())}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),  // 添加一些間距
                      Text(
                        '以下是客戶的資訊。辛苦了！！',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                
                // 生成卡片列表
                ListView.builder(
                  shrinkWrap: true, // 這樣它就不會無限制地擴展
                  physics: NeverScrollableScrollPhysics(), // 禁用內部的滾動
                  itemCount: selectedDateCases.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> caseData = selectedDateCases[index];
                    return Card(
                      child: ListTile(
                        /*
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
											 */
                        title: Text(caseData['flightNumber'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // 使文本靠左對齊
                          children: [
                            Text(
                                "班機資訊: ${caseData['travelDate'] ?? ''}, ${caseData['travelTime'] ?? ''}"),
                            Text(
                                "上車日期: ${caseData['pickupDate'] ?? ''}, ${caseData['pickupTime'] ?? ''}"),
                            Text(
                                "乘客資訊: ${caseData['passengerName'] ?? ''}, ${caseData['contactNumber'] ?? ''}"),
                            Text("司機資訊: ${caseData['driverID'] ?? ''}"),
                            //Text("上車時間: ${caseData['pickupTime'] ?? ''}"),
                          ],
                        ),
                        onTap: () {
                          /*
                          // 這裡您可以導航到編輯頁面，並將選中的 caseData 傳遞過去
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageCasePage(caseId: caseData['id']), // 假設您的案件 ID 存儲在 caseData['id']
                            ),
                          ).then((result) {
                            if (result == 'refresh') {
                              _fetchAllCaseIds();
                              _fetchSelectedDateCaseIds(_selectedDay!);
                            }
                          });
                          */
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
