import 'package:flutter/material.dart';
import 'package:bitrental/register_page.dart';
import 'package:bitrental/home_page.dart';
import 'package:bitrental/post_case_page.dart';
import 'package:bitrental/flightinfo_page.dart';
import 'package:bitrental/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bitrental/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _clearUserData();
  runApp(MyApp());
}

Future<void> _clearUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('user_data');
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
  Map<String, dynamic>? userData;

  void _onGoogleLoginSuccess(Map<String, dynamic> data) {
    setState(() {
      userData = data;
      _saveUserDataToStorage(userData!);
    });
  }

  void _saveUserDataToStorage(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_data', json.encode(data));
  }

  void _onEmployeeLogin() async {
    Map<String, dynamic> result = await _simulateGoogleLogin();
    if (result.isNotEmpty) {
      _onGoogleLoginSuccess(result);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
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
                ElevatedButton(
                  onPressed: _onEmployeeLogin,
                  child: Text('員工登入'),
                ),
                
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text('管理者登入'),
                ),
                
                /* 臨時取消此功能
                SizedBox(height: 20),
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
                /*
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: const Text('進入主畫面'),
                ),*/
                /*暫時不開放此功能
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
                */
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

  // 模擬 Google 登入的函式，返回使用者資訊
  Future<Map<String, dynamic>> _simulateGoogleLogin() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Show a success message using SnackBar
      final snackBar = SnackBar(content: Text('登入成功！'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Save user data to shared preferences using JSON serialization
      final userData = {
        'id': userCredential.user?.uid,
        'displayName': userCredential.user?.displayName,
        'email': userCredential.user?.email,
        'photoUrl': userCredential.user?.photoURL,
      };
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_data', jsonEncode(userData));

      // Navigate back to the main page (MyHomePage) and pass the userCredential
      //Navigator.pop(context, userCredential);

      return userData;
    } catch (error) {
      // Handle any errors that occurred during the Google Sign In process
      print('Error occurred during Google Sign In: $error');

      // Show a failure message using SnackBar
      final snackBar = SnackBar(content: Text('登入失敗！'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return {};
    }
  }
}
