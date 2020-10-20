import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'loginScreen.dart';
import 'constants.dart';
import 'backend.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    fetchSpreadsheet();

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(color: appBarColor),
      ),
      home: LoginScreen(),
    );
  }
}
