/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Nelson Chung
 * Creation Date: Octber 6, 2023
 */
 
import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'showcase_page.dart';
import 'activity_page.dart';


class MainPage extends StatefulWidget {
  final String driverID;
  MainPage({required this.driverID});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;  // 預設為 Home 頁面
  late List<Widget> _pages; // late to do the initialization

/*
  List<Widget> _pages = [
    ShowCasePage(driverID: widget.driverID),      // showcase_page
    //ManageCasePage(),    // managecase_page
    //SearchCasePage(),     // searchcase_page
    ProfilePage(),       // profile_page
  ];
*/
  @override
  void initState() {
    super.initState();
    _pages = [
      ShowCasePage(driverID: widget.driverID),  // 在這裡使用 widget.driverID
      // 其他頁面...
      ActivityPage(), 
      ProfilePage(),  // profile_page
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景圖像
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 實際內容
          _pages[_currentIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue[900],  // 選擇的項目顏色
        unselectedItemColor: Colors.grey,     // 未選擇的項目顏色
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Post Case',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share_location),
            label: 'GPS',
          ),
          /*
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search),
            label: 'Manage Case',
          ),
          */
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

