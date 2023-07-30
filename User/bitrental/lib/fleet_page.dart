// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Car {
  final int id;
  final String carName;
  final String status;

  Car({
    required this.id,
    required this.carName,
    required this.status,
  });
}

class FleetPage extends StatefulWidget {
  const FleetPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FleetPageState createState() => _FleetPageState();
}

class _FleetPageState extends State<FleetPage> {
  late Future<List<Car>> _loadCarData;
  late Future<List<Driver>> _loadDriverData;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCarData = _fetchCarData();
    _loadDriverData = _fetchDriverData();
  }

  Future<List<Car>> _fetchCarData() async {
    String carJson = await rootBundle.loadString('assets/car.json');
    List<dynamic> carData = json.decode(carJson);
    List<Car> cars = carData
        .map((car) => Car(
              id: carData.indexOf(car) + 1,
              carName: car['car_name'],
              status: car['status'],
            ))
        .toList();
    return cars;
  }

  Future<List<Driver>> _fetchDriverData() async {
    String driverJson = await rootBundle.loadString('assets/account.json');
    List<dynamic> driverData = json.decode(driverJson);
    List<Driver> drivers = driverData
        .map((driver) => Driver(
              account: driver['account'],
              password: driver['password'],
              privilege: driver['privilege'],
            ))
        .toList();
    return drivers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('車輛管理'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _currentPageIndex == 0
                    ? DriversPage(loadDriverData: _loadDriverData)
                    : VehiclesPage(loadCarData: _loadCarData),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // 处理按钮点击事件
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Drivers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Vehicles',
          ),
        ],
      ),
    );
  }
}

class DriversPage extends StatelessWidget {
  final Future<List<Driver>> loadDriverData;

  const DriversPage({Key? key, required this.loadDriverData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Driver>>(
      future: loadDriverData,
      builder: (BuildContext context, AsyncSnapshot<List<Driver>> snapshot) {
        if (snapshot.hasData) {
          List<Driver> drivers = snapshot.data!;
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: DataTable(
                columnSpacing: 20.0,
                columns: const [
                  DataColumn(
                    label: Text(
                      '姓名',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '密碼',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '權限',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: drivers
                    .map(
                      (driver) => DataRow(cells: [
                        DataCell(
                          Center(
                            child: Text(
                              driver.account,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              driver.password,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              driver.privilege,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                    )
                    .toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading driver data'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class VehiclesPage extends StatelessWidget {
  final Future<List<Car>> loadCarData;

  const VehiclesPage({Key? key, required this.loadCarData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Car>>(
      future: loadCarData,
      builder: (BuildContext context, AsyncSnapshot<List<Car>> snapshot) {
        if (snapshot.hasData) {
          List<Car> cars = snapshot.data!;
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('編號')),
                  DataColumn(label: Text('車號')),
                  DataColumn(label: Text('狀態')),
                ],
                rows: cars
                    .map(
                      (car) => DataRow(cells: [
                        DataCell(Text(
                          car.id.toString().padLeft(2, '0'),
                          style: TextStyle(color: Colors.white),
                        )),
                        DataCell(Text(
                          car.carName,
                          style: TextStyle(color: Colors.white),
                        )),
                        DataCell(Text(
                          car.status,
                          style: TextStyle(color: Colors.white),
                        )),
                      ]),
                    )
                    .toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading car data'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class Driver {
  final String account;
  final String password;
  final String privilege;

  Driver({
    required this.account,
    required this.password,
    required this.privilege,
  });
}
