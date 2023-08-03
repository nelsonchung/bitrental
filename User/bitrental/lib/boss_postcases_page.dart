import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BossPostCasesPage extends StatefulWidget {
  const BossPostCasesPage({Key? key}) : super(key: key);

  @override
  _BossPostCasesPageState createState() => _BossPostCasesPageState();
}

class _BossPostCasesPageState extends State<BossPostCasesPage> {
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
        title: Text('新增派單'),
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
