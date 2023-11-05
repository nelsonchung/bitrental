import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      setState(() {
        userData = jsonDecode(userDataString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('個人資訊'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      /*
      //backgroundColor: Color(0xFF4CAD73),
      appBar: AppBar(
        title: Text('個人資料', style: TextStyle(color: Colors.white)),
        //backgroundColor: Color(0xFF4CAD73),
        elevation: 0,
      ),
      */
      body: Stack(
        children: [
          // 背景圖片
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 實際內容
          Center(
            child: userData != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (userData!['photoUrl'] != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData!['photoUrl']),
                      ),
                      SizedBox(height: 16),
                      if ((userData!['displayName'] ?? '').isNotEmpty)
                      Text('姓名：${userData!['displayName'] ?? '未提供'}',
                      style: TextStyle(color: Colors.white)),
                      SizedBox(height: 8),
                      if ((userData!['email'] ?? '').isNotEmpty)
                        Text('信箱：${userData!['email'] ?? '未提供'}',
                        style: TextStyle(color: Colors.white)),
                  ],
                )
              : Text('找不到使用者資料', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  } //end of build
}
