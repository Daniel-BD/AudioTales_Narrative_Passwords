import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants.dart';

class EventController extends GetxController {
  SignInOrUpEvent _event;

  bool get signIn => _event.signIn;
  String get email => _event.email;
  String get userName => _event.userName;
  NarrativePassword get password => _event.password;

  /// Whether this event has a completed password, meaning the user has chosen answers for all prompts.
  bool get completedPassword => !password.chosenOptions.contains(null);

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

  /// Adds or replaces a narrative in the narrative password at the given index.
  void addNarrativeOption(int promptIndex, int optionIndex) {
    _event.password.chosenOptions[promptIndex] = optionIndex;
    update();

    debugPrint('Narrative Password: ${_event.password.chosenOptions}');
  }
}

class SignInOrUpEvent {
  /// Whether this event is a sign in event (signing in with existing account), or a sign up event (creating a new account).
  final bool signIn;

  /// The users email
  final String email;

  /// The users name, should only be provided if [signIn] is false.
  final String userName;

  final password = NarrativePassword();

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
  final chosenOptions;

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
