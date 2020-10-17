import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'models.dart';

bool validatePassword(String userEmail, NarrativePassword userPassword) {
  String password = userPassword.toString();

  return true;
}

/*

/// Persists the created password, meaning it's saved so that we can access it even if the app is shut down and restarted.
/// Returns true if successful.
Future<bool> _savePassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //return await prefs.setStringList('password', _eventController.password.chosenOptions);
}

/// Controls if the inputted password matches the persisted (saved) password.
/// Returns true if password matches.
Future<bool> _controlPassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('password').toString() == _eventController.password.chosenOptions.toString();
}

void _onPasswordEntered() async {
  if (!_eventController.signIn) {
    var success = await _savePassword();

    if (!success) {
      return;
    }

    await Future.delayed(Duration(seconds: 2));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  } else if (_eventController.signIn) {
    var success = await _controlPassword();

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyBooksScreen(),
        ),
      );
    }
  }
}*/
