import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Method to handle Google Sign In
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User cancelled the Google Sign In process
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in to Firebase using the Google credential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Google Sign In was successful, you can now use the userCredential
        // to perform further actions, such as registering or logging in the user.

        // Example: Get the user's email address and display it
        print('User Email: ${userCredential.user!.email}');

        // Show a success message using SnackBar
        final snackBar = SnackBar(content: Text('登入成功！'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // Something went wrong during Firebase sign in
        // Show a failure message using SnackBar
        final snackBar = SnackBar(content: Text('登入失敗！'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
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
        title: null,
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon_car.png',
                      height: 100,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'BIT RENTAL',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color.fromRGBO(187, 162, 125, 1),
                        fontFamily: 'BungeeInline',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '用戶名',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '密碼',
                  ),
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // 忘記密碼點擊事件
                      },
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _handleGoogleSignIn(context), // Call the _handleGoogleSignIn method with context
                      child: const Text('登入'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('返回'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
