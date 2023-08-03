import 'package:flutter/material.dart';
import 'boss_postcases_page.dart';
import 'boss_show_drivers_position_page.dart';

class BossHomePage extends StatefulWidget {
  const BossHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BossHomePageState createState() => _BossHomePageState();
}

class _BossHomePageState extends State<BossHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    BossShowDriversPositionPage(),
    BossPostCasesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text('Home'),
      //),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icon_home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icon_fleet.png')),
            label: 'Fleet',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(169, 122, 54, 1),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
