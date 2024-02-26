import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      // Implement sign-in logic here
    } catch (error) {
      // Handle sign-in error
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    // Implement sign-in logic with username and password here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signInWithEmailAndPassword,
                child: Text('Sign In'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signInWithGoogle,
                child: Text('Sign In with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
