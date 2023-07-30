import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlightInfoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FlightInfoScreen(),
    );
  }
}

class FlightInfoScreen extends StatefulWidget {
  @override
  _FlightInfoScreenState createState() => _FlightInfoScreenState();
}

class _FlightInfoScreenState extends State<FlightInfoScreen> {
  String flightCode = 'BR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('航班資訊查詢'),
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 48.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Flight Code',
              ),
              onChanged: (value) {
                flightCode = value;
              },
            ),
            const SizedBox(height: 28.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlightInfoWebView(flightCode: flightCode),
                  ),
                );
              },
              child: const Text('獲取航班資訊'),
            ),
          ],
        ),
      ),
    );
  }
}

class FlightInfoWebView extends StatelessWidget {
  final String flightCode;

  FlightInfoWebView({Key? key, required this.flightCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('航班資訊'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: WebView(
        initialUrl: 'https://www.taoyuan-airport.com/flight_arrival?k=$flightCode&time=22%3A00-23%3A59',
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 返回主畫面
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
