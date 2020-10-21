import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gsheets/gsheets.dart';

import 'models.dart';
import 'privateKey.dart';

enum LogEvent {
  login_success,
  login_failed,
  signUp_success,
  signUp_failedToRepeat,
}

Future<void> logEventToDataBase(LogEvent eventType, EventController event) async {
  /// TODO: If you want to have the google sheets database functionality, add your own credentials in privatekey.dart
  return;

  final gsheets = GSheets(putYourCredentialsHere);
  // fetch spreadsheet by its id
  final ss = await gsheets.spreadsheet(putYourSpreadsheetIdHere);
  // get worksheet by its title
  final sheet = ss.worksheetByTitle('Sheet1');

  var correctNarrative;

  switch (eventType) {
    case LogEvent.login_failed:
      correctNarrative = await getPasswordFor(event.email);
      break;
    case LogEvent.signUp_success:
    case LogEvent.signUp_failedToRepeat:
    case LogEvent.login_success:
      correctNarrative = event.password.chosenOptions;
      break;
  }

  var repeatedPass = '';

  event.repeatedPassword.chosenOptions.forEach((e) {
    if (e != null) {
      repeatedPass = null;
    }
  });

  final row = {
    'event type': eventType.toString().replaceFirst('LogEvent.', ''),
    'id': event.email.hashCode,
    'inputted narrative': event.password.chosenOptions.toString(),
    'time': DateTime.now().toString(),
    'correct narrative': correctNarrative.toString() ?? 'isNUll',
    'repeated narrative': repeatedPass ?? event.repeatedPassword.chosenOptions.toString(),
  };

  debugPrint('ROW TO UPLOAD:');
  debugPrint(row.toString());

  sheet.values.map.appendRow(row);

  return;
}

Future<List<int>> getPasswordFor(String userEmail) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(userEmail)?.map((e) => int.tryParse(e))?.toList();
}

/// Returns true if password matches stored password
Future<bool> validatePassword(String userEmail, NarrativePassword userPassword) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final storedPassword = prefs.getStringList(userEmail)?.map((e) => int.tryParse(e))?.toList();
  debugPrint('Stored Password: $storedPassword');
  debugPrint('Inputted Password: ${userPassword.chosenOptions}');

  return ListEquality().equals(storedPassword, userPassword.chosenOptions);
  //TODO: Indicate if there is no password stored for this email, or if the password is incorrect. Those are different, but not handled different now.
}

/// Returns true if the given email is connected to an existing account.
Future<bool> emailHasAccount(String userEmail) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  debugPrint('account exists: ' + (prefs.getStringList(userEmail) != null).toString());
  return prefs.getStringList(userEmail) != null;
}

/// Persists the password to the local device
Future<bool> savePassword(String userEmail, String userName, NarrativePassword userPassword) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final convertedPassword = userPassword.chosenOptions.map((e) => e.toString()).toList();
  return prefs.setStringList(userEmail, convertedPassword);
}
