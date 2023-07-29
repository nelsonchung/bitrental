import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginGooglePage extends StatefulWidget {
  const LoginGooglePage({Key? key}) : super(key: key);

  @override
  _LoginGooglePageState createState() => _LoginGooglePageState();
}

class _LoginGooglePageState extends State<LoginGooglePage> {
  // Method to handle Google Sign In
  Future<UserCredential?> _handleGoogleSignIn(BuildContext context) async {
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

      // Show a success message using SnackBar
      final snackBar = SnackBar(content: Text('登入成功！'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
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
      appBar: AppBar(
        title: Text('Google 登入'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleGoogleSignIn(context), // Call the _handleGoogleSignIn method with context
          child: Text('使用 Google 登入'),
        ),
      ),
    );
  }
}
