import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'constants.dart';
import 'models.dart';
import 'myBooksScreen.dart';
import 'loginScreen.dart';
import 'backend.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final EventController _eventController = Get.find();

  final _pageTransitionDuration = Duration(milliseconds: 600);
  final _pageTransitionCurve = Curves.easeInOut;
  final _pageViewController = PageController(initialPage: 0);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double _pageViewHeight = max(360, MediaQuery.of(context).size.height * 0.4);
    final double _userNarrativeWidth = min(400, MediaQuery.of(context).size.width - 16);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          _eventController.signIn ? signInPasswordHeadline : createPasswordHeadline,
          style: GoogleFonts.averiaSerifLibre(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: CupertinoButton(
          child: Icon(
            CupertinoIcons.clear_thick,
            size: 30,
            color: destructiveColor,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SizedBox(
                width: _userNarrativeWidth,
                child: Obx(() {
                  final currentPromptIndex = _eventController.currentPromptIndex.value;

                  return Scrollbar(
                    isAlwaysShown: (!_eventController.signIn && currentPromptIndex == 0) ? true : false,
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          SizedBox(height: 10),
                          UsersNarrative(),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: _pageViewHeight,
                    child: PageView(
                      controller: _pageViewController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        for (int i = 0; i < prompts.length; i++)
                          NarrativeOptions(
                            promptIndex: i,
                            pageViewController: _pageViewController,
                            pageTransitionDuration: _pageTransitionDuration,
                            pageTransitionCurve: _pageTransitionCurve,
                          ),
                      ],
                    ),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _pageViewController,
                  count: 4,
                  effect: WormEffect(
                    activeDotColor: indicatorColor,
                    dotColor: inactiveColor,
                  ),
                ),
                StepBackButton(
                    pageViewController: _pageViewController,
                    pageTransitionDuration: _pageTransitionDuration,
                    pageTransitionCurve: _pageTransitionCurve),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A text section with the users currently inputted narrative password.
class UsersNarrative extends StatelessWidget {
  final EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    final _signIn = _eventController.signIn;

    return GetBuilder<EventController>(
      builder: (_) {
        var currentPromptIndex = _eventController.currentPromptIndex.value;

        if (currentPromptIndex == prompts.length - 1 && _eventController.password.chosenOptions.last != null) {
          /// This means the user is on the last prompt and has chosen an alternative.
          currentPromptIndex++;
        }

        return Column(
          children: [
            if (!_signIn && currentPromptIndex == 0)
              Text(
                createPasswordInstructionText,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            for (int i = 0; i < currentPromptIndex; i++)
              Row(
                children: [
                  Text(
                    prompts[i] + ' ',
                    style: GoogleFonts.averiaSerifLibre(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    narrativeOptions[i][_eventController.password.chosenOptions[i]] + '... ',
                    style: GoogleFonts.averiaSerifLibre(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

/// Displays the current prompt and the narrative options as buttons.
class NarrativeOptions extends StatelessWidget {
  NarrativeOptions({
    Key key,
    @required this.promptIndex,
    @required PageController pageViewController,
    @required Duration pageTransitionDuration,
    @required Cubic pageTransitionCurve,
  })  : _pageViewController = pageViewController,
        _pageTransitionDuration = pageTransitionDuration,
        _pageTransitionCurve = pageTransitionCurve,
        assert(promptIndex < prompts.length && promptIndex >= 0, 'Invalid promptIndex given: $promptIndex'),
        super(key: key);

  final int promptIndex;
  final PageController _pageViewController;
  final Duration _pageTransitionDuration;
  final Cubic _pageTransitionCurve;
  final EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    final double _componentWidth = min(300, MediaQuery.of(context).size.width - 32);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: _componentWidth,
            child: Text(
              prompts[promptIndex] + '... ',
              style: GoogleFonts.averiaSerifLibre(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: _componentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (String option in narrativeOptions[promptIndex])
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        color: primaryColor,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(option),
                          //TODO: TextStyle för dessa knappar
                        ),
                        onPressed: () {
                          _eventController.stepForwardPrompt();
                          _eventController.addNarrativeOption(promptIndex, narrativeOptions[promptIndex].indexOf(option));

                          /// If the button is pressed on any page that isn't the last page
                          if (_pageViewController.page.toInt() < prompts.length - 1) {
                            _pageViewController.animateToPage(
                              _eventController.currentPromptIndex.value,
                              duration: _pageTransitionDuration,
                              curve: _pageTransitionCurve,
                            );
                          }

                          /// else if the button is pressed on the last page (meaning the password input is complete)
                          else if (_pageViewController.page.toInt() == prompts.length - 1) {
                            if (_eventController.completedPassword) {
                              _eventController.loading.value = true;
                              validatePassword(_eventController.email, _eventController.password);
                            }
                          }
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A button that steps back in the prompt sequence.
/// Displayed in the bottom left corner of the screen when visible.
class StepBackButton extends StatelessWidget {
  StepBackButton({
    Key key,
    @required PageController pageViewController,
    @required Duration pageTransitionDuration,
    @required Cubic pageTransitionCurve,
  })  : _pageViewController = pageViewController,
        _pageTransitionDuration = pageTransitionDuration,
        _pageTransitionCurve = pageTransitionCurve,
        super(key: key);

  final PageController _pageViewController;
  final Duration _pageTransitionDuration;
  final Cubic _pageTransitionCurve;
  final EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentPromptIndex = _eventController.currentPromptIndex.value;

      return Visibility(
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
      );
    });
  }
}

extension NumExtensions on num {
  bool get isInt => (this % 1) == 0;
}
