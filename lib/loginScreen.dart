import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';

import 'createNarrativeScreen.dart';
import 'constants.dart';
import 'models.dart';
import 'widget_components/AudioTalesComponents.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Whether to show a sign in screen (for existing users),
  /// or to show a screen for creating new accounts.
  bool _signIn = true;

  final _emailTextController = TextEditingController();
  final _yourNameTextController = TextEditingController();

  /// When pressing button to initiate password input.
  void _onPressedPasswordButton() {
    String userName = _yourNameTextController.text.trim();
    String email = _emailTextController.text.trim();
    bool validEmail = EmailValidator.validate(email);

    if (!validEmail) {
      //TODO: feedback to user
      debugPrint('Invalid Email');
      return;
    }

    /// If the user is signing in with an existing account, we only need to validate that the email is a valid email address.
    bool pushPasswordScreen = _signIn;

    /// If the user is creating a new account we also need to validate that the given name is not empty.
    if (!_signIn) {
      pushPasswordScreen = userName.isNotEmpty;
    }

    if (pushPasswordScreen) {
      _emailTextController.clear();
      _yourNameTextController.clear();
      FocusScope.of(context).unfocus();

      Get.delete<EventController>(force: true);
      final EventController eventController = Get.put(EventController());

      eventController.newEvent(
        SignInOrUpEvent(
          signIn: _signIn,
          email: email,
          userName: _signIn ? null : userName,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _componentWidth = min(300, MediaQuery.of(context).size.width - 32);

    return Container(
      child: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      AudioTalesLogo(),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              _signIn ? signInWelcomeText : createNewAccountText,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            if (!_signIn)
                              SizedBox(
                                width: _componentWidth,
                                child: CupertinoTextField(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10.5),
                                  controller: _yourNameTextController,
                                  placeholder: 'Your Name',
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            if (!_signIn)
                              SizedBox(
                                height: 20,
                              ),
                            SizedBox(
                              width: _componentWidth,
                              child: CupertinoTextField(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10.5),
                                controller: _emailTextController,
                                placeholder: 'Email',
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 1.5,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: _componentWidth,
                              child: CupertinoButton(
                                child: Text(
                                  _signIn ? startPasswordButtonText : continueToPasswordCreationButtonText,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                color: primaryColor,
                                //borderRadius: BorderRadius.circular(4),
                                minSize: 44,
                                padding: EdgeInsets.all(0),
                                onPressed: () => _onPressedPasswordButton(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  child: SwitchBetweenSignInAndCreate(
                    signIn: _signIn,
                    onPressed: () => setState(() {
                      _signIn = !_signIn;
                    }),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A clickable row of text letting the user switch between creating a new account or signing in with an existing.
class SwitchBetweenSignInAndCreate extends StatelessWidget {
  /// Whether to display prompt to create a new account, or to sign in with existing account.
  final bool signIn;
  final VoidCallback onPressed;

  const SwitchBetweenSignInAndCreate({
    Key key,
    @required this.signIn,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          signIn ? dontHaveAccountText : alreadyHaveAccountText,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 8),
        CupertinoButton(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              Text(
                signIn ? createAnAccountButtonText : signInButtonText,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Icon(
                Icons.arrow_right,
                color: primaryColor,
              ),
            ],
          ),
          onPressed: onPressed,
        )
      ],
    );
  }
}
