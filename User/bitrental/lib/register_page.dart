import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
                      'assets/icon_car.png', // 添加图片的路径
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
                // ignore: prefer_const_constructors
                TextField(
                  decoration: const InputDecoration(
                    labelText: '用戶名',
                  ),
                ),
                const SizedBox(height: 10),
                // ignore: prefer_const_constructors
                TextField(
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
                      onPressed: () {
                        // 註冊按鈕點擊事件
                      },
                      child: const Text('送出'),
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
