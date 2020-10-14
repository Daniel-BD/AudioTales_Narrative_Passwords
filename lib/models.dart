import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants.dart';

class EventController extends GetxController {
  SignInOrUpEvent _event;

  bool get signIn => _event.signIn;
  String get email => _event.email;
  String get userName => _event.userName;
  NarrativePassword get password => _event.password;

  /// Represents the current password prompt index to display to the user.
  /// Should be limited between 0 and [narrativeOptions.length] - 1.
  var currentPromptIndex = 0.obs;

  void stepForwardPrompt() {
    if (currentPromptIndex < narrativeOptions.length - 1) {
      currentPromptIndex.value++;
    }
  }

  void stepBackPrompt() {
    if (currentPromptIndex > 0) {
      currentPromptIndex.value--;
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
  /// 4 ints with the users choice in the password, the number represents an index in [narrativeOptions]
  final chosenOptions = List<int>(prompts.length);

  /*String completeStory() {
    var story = StringBuffer();

    for (int i = 0; i < chosenOptions.length; i++) {
      story.write(prompts[i].replaceAll('...', ''));
      story.write(chosenOptions[i].replaceAll('...', ''));
      story.write('\n');
    }

    return story.toString();
  }*/
}
