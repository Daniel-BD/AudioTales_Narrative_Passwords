import 'package:flutter/material.dart';

import 'createNarrativeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _inputPassword({@required bool isNewAccount}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateStoryScreen(isNewAccount: isNewAccount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _inputPassword(isNewAccount: false);
                },
                child: Text('Login'),
              ),
              OutlinedButton(
                onPressed: () {
                  _inputPassword(isNewAccount: true);
                },
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
