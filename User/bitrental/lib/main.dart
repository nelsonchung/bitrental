import 'package:flutter/material.dart';
import 'register_page.dart';
import 'home_page.dart';
import 'post_case_page.dart';
import 'login.dart';
import 'flightinfo_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      title: 'BIT RENTAL designed by Nelson',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // ignore: prefer_const_constructors
        title: Text('BIT RENTAL'),
      ),
      body: Stack(
        children: [
          Container(
            // ignore: prefer_const_constructors
            decoration: BoxDecoration(
              // ignore: prefer_const_constructors
              image: DecorationImage(
                // ignore: prefer_const_constructors
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon_car.png', // 添加图片的路径
                      height: 100,
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(width: 0),
                    // ignore: prefer_const_constructors
                    Text(
                      'BIT RENTAL',
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                        fontSize: 32,
                        // ignore: prefer_const_constructors
                        color: Color.fromRGBO(187, 162, 125, 1),
                        fontFamily: 'BungeeInline',
                      ),
                    ),
                  ],
                ),
                // ignore: prefer_const_constructors
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      // ignore: prefer_const_constructors
                      child: Text('登入'),
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              // ignore: prefer_const_constructors
                              builder: (context) => RegisterPage()),
                        );
                      },
                      // ignore: prefer_const_constructors
                      child: Text('註冊'),
                    ),
                  ],
                ),
                // ignore: prefer_const_constructors
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text('進入主畫面'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PostCasePage()),
                    );
                  },
                  child: const Text('進入派單系統'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FlightInfoApp()),
                    );
                  },
                  child: const Text('進入航班系統'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
