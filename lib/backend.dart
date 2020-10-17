import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Returns true if password matches stored password
Future<bool> validatePassword(String userEmail, NarrativePassword userPassword) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final storedPassword = prefs.getStringList(userEmail).map((e) => int.tryParse(e)).toList();

  return storedPassword == userPassword.chosenOptions;
}

Future<bool> savePassword(String userEmail, String userName, NarrativePassword userPassword) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final convertedPassword = userPassword.chosenOptions.map((e) => e.toString()).toList();
  return prefs.setStringList(userEmail, convertedPassword);
}
