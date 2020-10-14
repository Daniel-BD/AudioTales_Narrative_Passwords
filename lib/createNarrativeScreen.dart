import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'constants.dart';
import 'models.dart';
import 'myBooksScreen.dart';
import 'loginScreen.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final EventController _eventController = Get.find();

  final _pageTransitionDuration = Duration(milliseconds: 600);
  final _pageTransitionCurve = Curves.easeInOut;
  final _pageViewController = PageController(initialPage: 0);

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
  }

  Widget _options(List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (String option in options)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: primaryColor,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(option),
                ),
                onPressed: () async {
                  _eventController.stepForwardPrompt();

                  if (_pageViewController.page.toInt() < prompts.length - 1) {
                    _pageViewController.animateToPage(
                      _eventController.currentPromptIndex.value,
                      duration: _pageTransitionDuration,
                      curve: _pageTransitionCurve,
                    );
                    //Future.delayed(_pageTransitionDuration).then((_) => setState(() {}));
                  }

                  /*_eventController.addNarrativeOption(_pageViewController.page.toInt(), options.indexOf(option));
                  //_createdStory.chosenOptions.add(option);
                  if (_pageViewController.page.toInt() < prompts.length - 1) {
                    _pageViewController.nextPage(duration: _pageTransitionDuration, curve: _pageTransitionCurve);
                    Future.delayed(_pageTransitionDuration).then((_) => setState(() {}));
                  } else {
                    setState(() {});
                    _onPasswordEntered();
                  }*/
                },
              ),
              SizedBox(height: 10),
            ],
          ),
      ],
    );
  }

  Widget _page(int pageNumber) {
    assert(pageNumber < prompts.length && pageNumber >= 0, 'Invalid pageNumber given: $pageNumber');
    final double _componentWidth = min(300, MediaQuery.of(context).size.width - 32);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: _componentWidth,
            child: Text(
              prompts[pageNumber],
              style: GoogleFonts.averiaSerifLibre(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: _componentWidth,
            child: _options(options[pageNumber]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _pageViewHeight = max(360, MediaQuery.of(context).size.height * 0.4);

    return Obx(() {
      final currentPromptIndex = _eventController.currentPromptIndex.value;

      return Scaffold(
        appBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Text(
              'Cancel',
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
          middle: Text(
            _eventController.signIn ? signInPasswordScreenTitle : createPasswordScreenTitle,
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextSection(),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: _pageViewHeight,
                  child: PageView(
                    controller: _pageViewController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _page(0),
                      _page(1),
                      _page(2),
                      _page(3),
                    ],
                  ),
                ),
              ),
              SmoothPageIndicator(
                controller: _pageViewController,
                count: 4,
                effect: WormEffect(activeDotColor: primaryColor),
              ),
              Visibility(
                visible: currentPromptIndex > 0,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: CupertinoButton(
                  onPressed: () {
                    if (!_pageViewController.page.isInt) {
                      return;
                    }
                    _eventController.stepBackPrompt();
                    if (_pageViewController.page.toInt() > 0) {
                      _pageViewController.animateToPage(
                        _eventController.currentPromptIndex.value,
                        duration: _pageTransitionDuration,
                        curve: _pageTransitionCurve,
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.back,
                        size: 24,
                        color: primaryColor,
                      ),
                      Text(
                        currentPromptIndex > 0 ? prompts[currentPromptIndex - 1] : '',
                        style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(left: 0, right: 0, top: 4),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }
}

class TextSection extends StatelessWidget {
  final EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          _eventController.signIn ? signInPasswordHeadline : createPasswordHeadline,
          style: GoogleFonts.averiaSerifLibre(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        Text(
          'here goes user story', //_eventController.password.completeStory(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.orange,
          ),
        )
      ],
    );
  }
}

extension NumExtensions on num {
  bool get isInt => (this % 1) == 0;
}
