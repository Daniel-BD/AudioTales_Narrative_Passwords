import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'createNarrativeScreen.dart';
import 'constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Whether to show a sign in screen (for existing users),
  /// or to show a screen for creating new accounts.
  bool _signIn = true;

  final _emailTextController = TextEditingController();

  void _inputPassword({@required bool isNewAccount}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateStoryScreen(isNewAccount: isNewAccount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _componentWidth = min(300, MediaQuery.of(context).size.width - 32);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              AudioTalesLogo(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _signIn ? signInWelcomeText : createNewAccountText,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: _componentWidth,
                      child: CupertinoTextField(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10.5),
                        controller: _emailTextController,
                        placeholder: 'Email',
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
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
                          startPasswordButtonText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(4),
                        minSize: 44,
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              CreateAccountWidget(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateAccountWidget extends StatelessWidget {
  const CreateAccountWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          dontHaveAccountText,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 8),
        CupertinoButton(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              Text(
                createAnAccountText,
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
          onPressed: () {},
        )
      ],
    );
  }
}

class AudioTalesLogo extends StatelessWidget {
  final String assetName = 'assets/logo.svg';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(assetName, semanticsLabel: 'AudioTales Logo - an image of a book'),
        Text(
          'AudioTales',
          style: GoogleFonts.averiaSerifLibre(fontSize: 36),
        ),
      ],
    );
  }
}
