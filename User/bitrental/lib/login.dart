import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'boss_home_page.dart';
import 'package:flutter/services.dart' show rootBundle;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  List<dynamic>? _accountsData;

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    String jsonString = await rootBundle.loadString('assets/account.json');
    setState(() {
      _accountsData = json.decode(jsonString);
    });
  }

  // Method to handle Local Login
  Future<void> _handleLocalLogin(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;
    //彭小哥 2023/8/22 跟我說密碼太複雜，要我改成簡單一點。願意用綠寶石來換。我馬上答應要改。
    String nelson_username = "bitrental";
    String nelson_password = "peng";

    if (_accountsData == null) {
      return;
    }

    bool loginSuccessful = false;
    for (var account in _accountsData!) {
      //if (account['account'] == username && account['password'] == password) {
      if (nelson_username == username && nelson_password == password) {
        loginSuccessful = true;
        break;
      }
    }

    if (loginSuccessful) {
      // If login successful, navigate to BossHomePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BossHomePage()),
      );
    } else {
      // If login failed, show SnackBar with login failed message
      final snackBar = SnackBar(content: Text('登入失敗！'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: null,
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon_car.png',
                      height: 100,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'BIT RENTAL',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color.fromRGBO(187, 162, 125, 1),
                        fontFamily: 'BungeeInline',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: '用戶名',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: '密碼',
                  ),
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // 忘記密碼點擊事件
                      },
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _handleLocalLogin(context),
                      child: const Text('登入'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('返回'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
