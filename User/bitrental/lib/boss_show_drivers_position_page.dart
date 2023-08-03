import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BossShowDriversPositionPage extends StatefulWidget {
  const BossShowDriversPositionPage({Key? key}) : super(key: key);

  @override
  _BossShowDriversPositionPageState createState() => _BossShowDriversPositionPageState();
}

class _BossShowDriversPositionPageState extends State<BossShowDriversPositionPage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('確認司機位置'),
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
      ),
    );
  }
}
