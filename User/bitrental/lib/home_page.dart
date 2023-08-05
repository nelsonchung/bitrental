import 'package:flutter/material.dart';
import 'fleet_page.dart';
import 'schedule_page.dart';
import 'activity_page.dart';
import 'profile_page.dart';
import 'main_page.dart'; // 新增的頁面

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ActivityPage(), //ActivityPage()與MainPage()對調，為了使用者登入後，進入HomePage能夠自動啟動gps定位
    FleetPage(),
    SchedulePage(),
    MainPage(),
    ProfilePage(),
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
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icon_calendar.png')),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icon_activity.png')),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icon_profile.png')),
            label: 'Profile',
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
