import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String? displayName;
  final String? email;
  final String? photoUrl;

  const ProfilePage({Key? key, this.displayName, this.email, this.photoUrl}) : super(key: key);

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
            image: AssetImage('assets/background.png'), // 背景圖片的路徑
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (photoUrl != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(photoUrl!),
                ),
              SizedBox(height: 16),
              Text('姓名：${displayName ?? '未提供'}'),
              SizedBox(height: 8),
              Text('信箱：${email ?? '未提供'}'),
            ],
          ),
        ),
      ),
    );
  }
}
