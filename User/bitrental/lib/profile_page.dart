import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('個人資料'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
                    Text('姓名：${userData!['displayName'] ?? '未提供'}'),
                    SizedBox(height: 8),
                    Text('信箱：${userData!['email'] ?? '未提供'}'),
                  ],
                )
              : Text('找不到使用者資料'),
        ),
      ),
    );
  }
}
