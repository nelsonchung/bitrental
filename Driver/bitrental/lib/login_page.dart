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
 * Creation Date: Octber 12, 2023
 */
 
import 'package:flutter/material.dart';
import 'main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'main.dart';
import 'showcase_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;

  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Hardcoded users for demonstration
  final Map<String, String> users = {'driver1': '1234', 'driver2': '5678'};

  // This function performs basic account and password authentication
  void _handleAccountPasswordSignIn(BuildContext context) async{
    String account = _accountController.text;
    String password = _passwordController.text;

    bool isValid = await validateUser(account, password);

    // Check from FirebaseFireStore
    if (isValid) {
      // Successful login
      final snackBar = SnackBar(content: Text('登入成功！'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Save user data to shared preferences using JSON serialization
      final userData = {
        'id': '', // Since you are not using FirebaseAuth, this could be empty or a custom ID
        'displayName': account, // Display name if you have any, otherwise could be empty
        'account': account, // Store the account
        'photoUrl': '', // Photo URL if you have any, otherwise could be empty
      };
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_data', jsonEncode(userData));

      // Navigate to MainPage with the current driverID
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MainPage(driverID: account), // 傳遞當前 driverID
      ));
    } else {
      // Failed login
      final snackBar = SnackBar(content: Text('登入失敗！'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  /* Local check
    if (users.containsKey(account) && users[account] == password) {
      // Successful login
      final snackBar = SnackBar(content: Text('登入成功！'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPage())); //original design and go to main_page.dart
      // Navigate to ShowcasePage with the driverID
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MainPage(driverID: account), // 傳遞當前 driverID
      ));      
    } else {
      // Failed login
      final snackBar = SnackBar(content: Text('登入失敗！'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  */
  }
  
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Show a success message using SnackBar
      final snackBar = SnackBar(content: Text('登入成功！'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Save user data to shared preferences using JSON serialization
      final userData = {
        'id': userCredential.user?.uid,
        'displayName': userCredential.user?.displayName,
        'account': userCredential.user?.email,
        'photoUrl': userCredential.user?.photoURL,
      };
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_data', jsonEncode(userData));

      // Navigate to the main page (MainPage)
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MainPage(
            driverID: userCredential.user?.email ?? 'driver1'), // 使用默認值
      ));
    } catch (error) {
      // Handle any errors that occurred during the Google Sign In process
      print('Error occurred during Google Sign In: $error');

      if (error is FirebaseAuthException) {
        // Handle FirebaseAuthException
        final snackBar = SnackBar(content: Text('登入失敗：${error.message}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // Handle other types of errors
        final snackBar = SnackBar(content: Text('登入失敗！'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      // Navigate to the first page (MyApp)
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
    }
  }

  InputDecoration _inputDecoration(IconData icon, String labelText) {
    return InputDecoration(
      fillColor: Color(0xFFF1F6FB),
      filled: true,
      prefixIcon: Icon(icon, color: Color(0xFF8189B0)),
      labelText: labelText,
      labelStyle: TextStyle(color: Color(0xFF8189B0)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('BIT RENTAL'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
////start
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(  // <-- 添加此行
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 75.0),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hotel, size: 30.0),
                          SizedBox(width: 10.0),
                          Text('帳號登入', style: TextStyle(fontSize: 24.0)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 80.0),
                  Text(
                    'Welcome Back!', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 24.0, 
                      color: Color.fromRGBO(187, 162, 125, 1), // 更新顏色
                      fontFamily: 'BungeeInline', // 更新字體
                    )
                  ),
                  SizedBox(height: 10.0),
                  Text('Please enter your account here.', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 40.0),
                  TextField(
                    controller: _accountController,
                    decoration: _inputDecoration(Icons.account_circle, 'Account'),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isObscured,
                    decoration: _inputDecoration(Icons.lock, 'Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, color: Color(0xFF8189B0)),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 60.0),
                  /*
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: Text('Forgot password?', style: TextStyle(color: Colors.blue[900])),
                        onPressed: () {
                          // TODO: Handle forgot password
                        },
                      ),
                    ],
                  ),   
                  */       
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () => _handleAccountPasswordSignIn(context),
                      /* test code
                      onPressed: () {
                        // 啟動 main_page.dart
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
                      },
                      */
                      child: Text(
                        'Login in',
                        style: TextStyle(
                          color: Color.fromRGBO(187, 162, 125, 1), // 更新顏色
                          fontFamily: 'BungeeInline', // 更新字體
                          fontSize: 24.0, // 增加文字大小，可以根據需要調整
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0), // 加入這行，為按鈕提供間距
                  /*
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () => _handleGoogleSignIn(context),
                      child: Text(
                        'Google Login',
                        style: TextStyle(
                          color: Color.fromRGBO(187, 162, 125, 1), // 更新顏色
                          fontFamily: 'BungeeInline', // 更新字體
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
                  ),                
                  SizedBox(height: 20.0),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Don't have any account? "),
                        TextButton(
                          child: Text('Sign Up', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                          onPressed: () {
                            // TODO: Handle sign up
                          },
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
///////end          
    );
  }
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<bool> validateUser(String account, String password) async {
  bool isValid = false;
  
  // Fetch driver data from Firestore
  QuerySnapshot snapshot = await _firestore.collection('driverData').get();
  final List<QueryDocumentSnapshot> documents = snapshot.docs;
  
  // Validate user input against fetched data
  for (var document in documents) {
    var docData = document.data() as Map<String, dynamic>?;  // Explicit casting
    if (docData != null) {
      var fetchedAccount = docData['driveraccount'];
      var fetchedPassword = docData['driverpassword'];
      
      if (fetchedAccount is String && fetchedPassword is String) {
        print('fetchedAccount is $fetchedAccount, fetchedPassword is $fetchedPassword');
        if (fetchedAccount == account && fetchedPassword == password) {
          isValid = true;
          break;
        }
      }
    }
  }

  return isValid;
}
