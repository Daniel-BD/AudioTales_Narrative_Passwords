import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants.dart';

class EventController extends GetxController {
  SignInOrUpEvent _event;

  bool get signIn => _event.signIn;
  String get email => _event.email;
  String get userName => _event.userName;
  NarrativePassword get password => _event.password;
  NarrativePassword get repeatedPassword => _event.repeatedPassword;

  /// Whether this event has a completed password, meaning the user has chosen answers for all prompts.
  bool get finishedPasswordInput => !password.chosenOptions.contains(null);

  /// Represents the current password prompt index to display to the user.
  /// Should be limited between 0 and [narrativeOptions.length] - 1.
  RxInt currentPromptIndex = 0.obs;

  /// Whether some 'loading' action is taking place, such as talking to server to validate password.
  RxBool loading = false.obs;

  void stepForwardPrompt() {
    if (currentPromptIndex < narrativeOptions.length - 1) {
      currentPromptIndex.value++;
      update();
    }
  }

  void stepBackPrompt() {
    if (currentPromptIndex > 0) {
      password.chosenOptions[currentPromptIndex.value] = null;
      currentPromptIndex.value--;
      update();
    }
  }

  void newEvent(SignInOrUpEvent event) {
    _event = event;
    update();
  }

  /// Returns true if the options chosen in [password] and [repeatedPassword] at [promptIndex] are the same.
  bool optionIsMatching(int promptIndex) {
    if (repeatedPassword.chosenOptions[promptIndex] == null) {
      return true;
    }
    return password.chosenOptions[promptIndex] == repeatedPassword.chosenOptions[promptIndex];
  }

  /// Adds or replaces a narrative in the narrative password at the given index.
  /// Returns false if [isRepeatingPassword] is true and the incoming [optionIndex] is not the same as in [password] for the given
  /// [promptIndex].
  bool addNarrativeOption(int promptIndex, int optionIndex, {bool isRepeatingPassword = false}) {
    if (isRepeatingPassword) {
      _event.repeatedPassword.chosenOptions[promptIndex] = optionIndex;
      update();
      return optionIndex == password.chosenOptions[promptIndex];
    } else {
      _event.password.chosenOptions[promptIndex] = optionIndex;
      update();
      return true;
    }
  }

  /// Clears the currently made password options. Example usage is when a newly created password is to be confirmed and the user
  /// doesn't want to keep the created password, then this can be used to fully clear it.
  void clearPassword({bool clearRepeatingPassword = false}) {
    currentPromptIndex.value = 0;

    if (clearRepeatingPassword) {
      for (int i = 0; i < _event.repeatedPassword.chosenOptions.length; i++) {
        _event.repeatedPassword.chosenOptions[i] = null;
      }
    } else {
      for (int i = 0; i < _event.password.chosenOptions.length; i++) {
        _event.password.chosenOptions[i] = null;
      }
    }

    update();
  }

  /// Whether the user is currently trying to repeat the created password.
  bool _repeatingCreatedPassword = false;

  bool get repeatingCreatedPassword {
    if (finishedPasswordInput && _repeatingCreatedPassword) {
      return true;
    } else {
      _repeatingCreatedPassword = false;
      return false;
    }
  }

  set repeatingCreatedPassword(bool value) {
    if (finishedPasswordInput) {
      _repeatingCreatedPassword = value;
      if (value) {
        currentPromptIndex.value = 0;
      }
      update();
    } else {
      _repeatingCreatedPassword = false;
      update();
    }
  }
}

class SignInOrUpEvent {
  /// Whether this event is a sign in event (signing in with existing account), or a sign up event (creating a new account).
  final bool signIn;

  /// The users email.
  final String email;

  /// The users name, should only be provided if [signIn] is false.
  final String userName;

  final password = NarrativePassword();

  /// Only used when this is a signUp event and the user needs to repeat their newly created password.
  final repeatedPassword = NarrativePassword();

  SignInOrUpEvent({
    @required this.signIn,
    @required this.email,
    this.userName,
  }) : assert(signIn && userName == null || !signIn && userName != null && userName.isNotEmpty);
}

class NarrativePassword {
  NarrativePassword.fromList(this.chosenOptions);
  NarrativePassword() : chosenOptions = List<int>(prompts.length);

  /// 4 ints with the users choice in the password, the number represents an index in [narrativeOptions]
  final List<int> chosenOptions;

  @override
  String toString() {
    var password = StringBuffer();

    for (int i = 0; i < chosenOptions.length; i++) {
      password.write(prompts[i] + '%%' + narrativeOptions[i][chosenOptions[i]]);
      if (i == chosenOptions.length - 1) {
        break;
      }
      password.write('++');
    }

    debugPrint('password.toString: ${password.toString()}');
    return password.toString();
  }
}
