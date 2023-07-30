import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bitrental/profile_page.dart'; // 引入 profile_page.dart

class LoginGooglePage extends StatefulWidget {
  const LoginGooglePage({Key? key}) : super(key: key);

  @override
  _LoginGooglePageState createState() => _LoginGooglePageState();
}

class _LoginGooglePageState extends State<LoginGooglePage> {
  // Method to handle Google Sign In
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
      UserCredential? userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Show a success message using SnackBar
      final snackBar = SnackBar(content: Text('登入成功！'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Pass the user data to ProfilePage and navigate to it
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            displayName: userCredential?.user?.displayName,
            email: userCredential?.user?.email,
            photoUrl: userCredential?.user?.photoURL,
          ),
        ),
      );
    } catch (error) {
      // Handle any errors that occurred during the Google Sign In process
      print('Error occurred during Google Sign In: $error');

      // Show a failure message using SnackBar
      final snackBar = SnackBar(content: Text('登入失敗！'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      // Clean up any resources if needed
      // For example, you might want to clear user inputs or loading indicators.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Google 登入'),
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
          child: ElevatedButton(
            onPressed: () => _handleGoogleSignIn(context),
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(187, 162, 125, 1),
              onPrimary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              '使用 Google 登入',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
