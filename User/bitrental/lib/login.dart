import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'main.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const SizedBox.shrink(),
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
                // ignore: prefer_const_constructors
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage('assets/icon_car.png'),
                      height: 100,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'BIT RENTAL',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color(0xFFBBA27D),
                        fontFamily: 'Bungee Inline',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '用戶名',
                  ),
                  controller: _usernameController,
                  onChanged: (value) {
                    // 將用戶名存儲在狀態中，以供後續使用
                    // 例如：setState(() { username = value; });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '密碼',
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  onChanged: (value) {
                    // 將密碼存儲在狀態中，以供後續使用
                    // 例如：setState(() { password = value; });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // 忘記密碼點擊事件
                      },
                      child: const Text('忘記密碼？'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _checkCredentials(context);
                      },
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

  Future<void> _checkCredentials(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // 模擬延遲等待一秒
    await Future.delayed(const Duration(milliseconds: 500));

    final jsonString = await rootBundle.loadString('assets/account.json');
    final accounts = json.decode(jsonString);

    for (var account in accounts) {
      if (account['account'] == username && account['password'] == password) {
        // 跳轉到主頁面
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          // ignore: prefer_const_constructors
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return;
      }
    }

    // 顯示錯誤消息
    // ignore: use_build_context_synchronously
    _showSnackBar(context, '用戶名或密碼錯誤');

    await Future.delayed(const Duration(milliseconds: 500));

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
