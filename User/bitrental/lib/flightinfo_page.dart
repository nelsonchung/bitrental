import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: use_key_in_widget_constructors
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

// ignore: use_key_in_widget_constructors
class FlightInfoScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _FlightInfoScreenState createState() => _FlightInfoScreenState();
}

class _FlightInfoScreenState extends State<FlightInfoScreen> {
  String flightCode = 'BR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('航班資訊查詢'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Flight Code',
              ),
              onChanged: (value) {
                flightCode = value;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FlightInfoWebView(flightCode: flightCode),
                  ),
                );
              },
              child: const Text('Get Arrival Info'),
            ),
          ],
        ),
      ),
    );
  }
}

class FlightInfoWebView extends StatelessWidget {
  final String flightCode;

  const FlightInfoWebView({super.key, required this.flightCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('航班資訊'),
      ),
      body: WebView(
        initialUrl:
            'https://www.taoyuan-airport.com/flight_arrival?k=$flightCode&time=22%3A00-23%3A59',
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
      ),
    );
  }
}
