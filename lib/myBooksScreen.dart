import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginScreen.dart';

class MyBooksScreen extends StatefulWidget {
  @override
  _MyBooksScreenState createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome!'),
            OutlinedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
