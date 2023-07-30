import 'package:flutter/material.dart';
import 'package:bitrental/register_page.dart';
import 'package:bitrental/home_page.dart';
import 'package:bitrental/post_case_page.dart';
import 'package:bitrental/login.dart';
import 'package:bitrental/flightinfo_page.dart';
import 'package:bitrental/profile_page.dart';
import 'package:bitrental/login_google.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _clearUserData();
  runApp(MyApp());
}

Future<void> _clearUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('userData');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BIT RENTAL 設計：Nelson',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserCredential? userCredential;

  void _onGoogleLoginSuccess(UserCredential result) {
    setState(() {
      userCredential = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('BIT RENTAL'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
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
                      'assets/icon_car.png',
                      height: 100,
                    ),
                    SizedBox(width: 0),
                    Text(
                      'BIT RENTAL',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color.fromRGBO(187, 162, 125, 1),
                        fontFamily: 'BungeeInline',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginGooglePage()), // 不再傳遞 database 參數
                        );

                        if (result != null) {
                          _onGoogleLoginSuccess(result);
                        }
                      },
                      child: Text('登入'),
                    ),
                    /* 臨時取消此功能
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text('註冊'),
                    ),
                    */
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: const Text('進入主畫面'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostCasePage()),
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
                  child: const Text('查詢航班系統'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

