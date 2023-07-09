import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    final Color lightGoldenrodYellow = Color.fromRGBO(250, 250, 210, 1);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            // ignore: prefer_const_constructors
            Center(
              // ignore: prefer_const_constructors
              child: CircleAvatar(
                radius: 50,
                // ignore: prefer_const_constructors
                backgroundImage: AssetImage(
                    'assets/profile_picture.png'), // Replace with your image
              ),
            ),
            const SizedBox(height: 10),
            // ignore: prefer_const_constructors
            Center(
              child: const Text(
                'Username',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: lightGoldenrodYellow.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Account',
                    style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.edit, color: Colors.white),
                onTap: () {
                  // Navigate to account edit page
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: lightGoldenrodYellow.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListTile(
                leading: const Icon(Icons.lock, color: Colors.white),
                title: const Text('Password',
                    style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.edit, color: Colors.white),
                onTap: () {
                  // Navigate to password edit page
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: lightGoldenrodYellow.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListTile(
                leading: const Icon(Icons.mail, color: Colors.white),
                title:
                    const Text('Email', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.edit, color: Colors.white),
                onTap: () {
                  // Navigate to email edit page
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: lightGoldenrodYellow.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.white),
                title:
                    const Text('Phone', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.edit, color: Colors.white),
                onTap: () {
                  // Navigate to phone edit page
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: lightGoldenrodYellow.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title:
                    const Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navigate to phone edit page
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
