import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loginScreen.dart';
import 'widget_components/AudioTalesComponents.dart';

class MyBooksScreen extends StatefulWidget {
  @override
  _MyBooksScreenState createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AudioTalesLogo(),
              FakeBooksCarousel(),
              Row(
                children: [
                  SizedBox(width: 10),
                  CupertinoButton(
                    child: Text('Sign Out'),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FakeBooksCarousel extends StatelessWidget {
  final size = 100.0;
  final padding = 30.0;

  final colors = [
    Colors.purple.shade300,
    Colors.purple.shade100,
    Colors.purple.shade600,
    Colors.purple.shade400,
    Colors.purple.shade800,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: size,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (int i = 0; i < 9; i++)
                Row(
                  children: [
                    Container(
                      height: size,
                      width: size,
                      color: colors[i % 5],
                    ),
                    SizedBox(width: padding),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(height: padding),
        Container(color: Colors.purple, width: screenWidth, height: size),
        SizedBox(height: padding),
        SizedBox(
          height: size,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (int i = 9; i >= 0; i--)
                Row(
                  children: [
                    Container(
                      height: size,
                      width: size,
                      color: colors[i % 5],
                    ),
                    SizedBox(width: padding),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
