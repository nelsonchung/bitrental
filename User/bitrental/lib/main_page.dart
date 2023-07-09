import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Main'),
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
        child: Center(
          child: FutureBuilder<List<List<String>>>(
            future: _generateRandomData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<List<String>>> snapshot) {
              if (snapshot.hasData) {
                List<List<String>> data = snapshot.data!;
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 1.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 15.0, // 調整列之間的間距
                      columns: const [
                        DataColumn(
                          label: Text(
                            '時間',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '上車點',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '下車點',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                      rows: data.map<DataRow>((row) {
                        return DataRow(cells: [
                          DataCell(
                            // ignore: sized_box_for_whitespace
                            Container(
                              width: 130, // 設定時間欄位的寬度
                              child: Text(
                                row[0],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            // ignore: sized_box_for_whitespace
                            Container(
                              width: 130, // 設定上車點欄位的寬度
                              child: Text(
                                row[1],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              row[2],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text('Error loading data');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<List<String>>> _generateRandomData() async {
    List<List<String>> randomData = [];

    // Load office data
    String officeJson = await rootBundle.loadString('assets/office.json');
    List<dynamic> officeData = json.decode(officeJson);
    List<String> officeLocations = officeData
        .map((office) => '${office['city']} ${office['address']}')
        .toList();

    // Load airport data
    String airportJson = await rootBundle.loadString('assets/airport.json');
    List<dynamic> airportData = json.decode(airportJson);
    List airportNames =
        airportData.map((airport) => airport['airport']).toList();

    // Generate random data
    final random = Random();
    for (int i = 0; i < 5; i++) {
      String time = _generateRandomTime();
      String startPoint =
          officeLocations[random.nextInt(officeLocations.length)];
      String endPoint = airportNames[random.nextInt(airportNames.length)];

      List<String> rowData = [time, startPoint, endPoint];
      randomData.add(rowData);
    }

    // Sort the random data by time in ascending order
    randomData.sort((a, b) => a[0].compareTo(b[0]));

    return randomData;
  }

  String _generateRandomTime() {
    final random = Random();
    DateTime now = DateTime.now();
    DateTime randomTime = now.add(Duration(days: random.nextInt(7)));
    String formattedTime =
        '${randomTime.year}/${randomTime.month.toString().padLeft(2, '0')}/'
        '${randomTime.day.toString().padLeft(2, '0')} '
        '${randomTime.hour.toString().padLeft(2, '0')}:'
        '${randomTime.minute.toString().padLeft(2, '0')}';
    return formattedTime;
  }
}
