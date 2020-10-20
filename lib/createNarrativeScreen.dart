import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'constants.dart';
import 'models.dart';
import 'myBooksScreen.dart';
import 'backend.dart';
import 'widget_components/AudioTalesComponents.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(56.0);

  final EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: destructiveColor),
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Text(
            _eventController.signIn ? signInPasswordHeadline : createPasswordHeadline,
            style: GoogleFonts.averiaSerifLibre(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Visibility(
            visible: false,
            maintainAnimation: true,
            maintainState: true,
            maintainSize: true,
            child: CupertinoButton(
              child: Text('Cancel'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

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
    final double _userNarrativeWidth = min(400, MediaQuery.of(context).size.width - 16);

    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: GetBuilder<EventController>(builder: (_) {
          final userFlow = _eventController.currentStage;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (userFlow == UserFlow.signUp_ReviewCreatedPassword ||
                  userFlow == UserFlow.signUp_FailedToRepeatPassword ||
                  userFlow == UserFlow.signUp_RegistrationComplete ||
                  userFlow == UserFlow.signIn_WrongPassword)
                AudioTalesLogo(),
              if (userFlow == UserFlow.signUp_RegistrationComplete)
                Expanded(
                  child: RegistrationComplete(),
                ),
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
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              if (userFlow == UserFlow.signUp_ReviewCreatedPassword)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    reviewCreatedStoryHeadline,
                                    style: GoogleFonts.averiaSerifLibre(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              if (userFlow == UserFlow.signUp_RepeatingPassword)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    repeatPasswordToConfirm,
                                    style: GoogleFonts.averiaSerifLibre(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              SizedBox(height: 10),
                              if (userFlow == UserFlow.signIn_InputtingPassword ||
                                  userFlow == UserFlow.signUp_CreatingPassword ||
                                  userFlow == UserFlow.signUp_ReviewCreatedPassword ||
                                  userFlow == UserFlow.signUp_RepeatingPassword)
                                UserNarrative(),
                              if (userFlow == UserFlow.signUp_FailedToRepeatPassword || userFlow == UserFlow.signIn_WrongPassword)
                                Text(
                                  youForgotPasswordText,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.averiaSerifLibre(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (userFlow == UserFlow.signUp_ReviewCreatedPassword) ReviewCreatedPassword(),
              if (userFlow == UserFlow.signUp_FailedToRepeatPassword || userFlow == UserFlow.signIn_WrongPassword) IncorrectPassword(),
              if (userFlow == UserFlow.signIn_InputtingPassword ||
                  userFlow == UserFlow.signUp_CreatingPassword ||
                  userFlow == UserFlow.signUp_RepeatingPassword)
                Column(
                  children: [
                    SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GetBuilder<EventController>(builder: (_) {
                        final double _pageViewHeight =
                            max(userFlow == UserFlow.signUp_RepeatingPassword ? 380 : 360, MediaQuery.of(context).size.height * 0.4);

                        return SizedBox(
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
                        );
                      }),
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
          );
        }),
      ),
    );
  }
}

/// A sad smiley face and a button to go either 1. back to review the created password again, if event is signUp. 2. go back to login screen.
class IncorrectPassword extends StatelessWidget {
  final EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    final userFlow = _eventController.currentStage;

    return Column(
      children: [
        SvgPicture.asset(
          'assets/sadFace.svg',
          semanticsLabel: 'Image of a sad smiley face',
        ),
        if (userFlow == UserFlow.signUp_FailedToRepeatPassword)
          Column(
            children: [
              SizedBox(height: 60),
              Text(
                letsReviewPasswordAgainText,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        if (userFlow == UserFlow.signIn_WrongPassword) SizedBox(height: 80),
        AudioTalesWideButton(
          onPressed: () {
            switch (userFlow) {
              case UserFlow.signIn_WrongPassword:
                Navigator.of(context).pop();
                break;
              case UserFlow.signUp_FailedToRepeatPassword:
                _eventController.moveToUserFlow(UserFlow.signUp_ReviewCreatedPassword);
                break;
              default:
                break;
            }
          },
          label: userFlow == UserFlow.signIn_WrongPassword ? 'Return' : 'Review',
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 60),
        if (userFlow == UserFlow.signIn_WrongPassword)
          CupertinoButton(
            child: Text(
              'Forgot password?',
              style: TextStyle(
                color: primaryColor,
              ),
            ),
            onPressed: () {
              throw UnimplementedError();
            },
          ),
      ],
    );
  }
}

/// A text section with the users currently inputted narrative password.
class UserNarrative extends StatelessWidget {
  final EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(
      builder: (eventController) {
        var currentPromptIndex = _eventController.currentPromptIndex.value;
        final userFlow = _eventController.currentStage;

        if (userFlow == UserFlow.signUp_ReviewCreatedPassword) {
          /// This means the user is on the last prompt and has chosen an alternative.
          currentPromptIndex++;
        }

        final fontSize = userFlow == UserFlow.signUp_ReviewCreatedPassword ? 18.0 : 16.0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userFlow == UserFlow.signUp_CreatingPassword && currentPromptIndex == 0)
              Text(
                createPasswordInstructionText,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            for (int i = 0; i < currentPromptIndex; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    prompts[i] + ' ',
                    style: GoogleFonts.averiaSerifLibre(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    narrativeOptions[i][_eventController.password.chosenOptions[i]] + '... ',
                    style: GoogleFonts.averiaSerifLibre(
                      fontSize: fontSize,
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

/// A text explaining that registration is complete, a 'done' icon and a button to continue.
class RegistrationComplete extends StatelessWidget {
  final EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          registrationCompleteText,
          style: GoogleFonts.averiaSerifLibre(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        SvgPicture.asset(
          'assets/doneIcon.svg',
          semanticsLabel: 'A large check mark image',
        ),
        AudioTalesWideButton(
          label: continueToAudioTalesButtonText,
          onPressed: () {
            logEventToDataBase(LogEvent.signUp_success, _eventController);
            savePassword(_eventController.email, _eventController.userName, _eventController.password);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyBooksScreen(),
              ),
            );
          },
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}

/// When the user has created a password, this widget will let them confirm or change their chosen narrative.
class ReviewCreatedPassword extends StatelessWidget {
  final EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isPasswordCorrectQuestionText,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 24),
        AudioTalesWideButton(
          label: confirmCreatedPasswordButtonText,
          onPressed: () {
            _eventController.moveToUserFlow(UserFlow.signUp_RepeatingPassword);
          },
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 20),
        CupertinoButton(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            regretCreatedPasswordButtonText,
            style: TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          onPressed: () {
            _eventController.moveToUserFlow(UserFlow.signUp_CreatingPassword);
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

/// Displays the current prompt and the narrative options as buttons.
class NarrativeOptions extends StatefulWidget {
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

  @override
  _NarrativeOptionsState createState() => _NarrativeOptionsState();
}

class _NarrativeOptionsState extends State<NarrativeOptions> {
  final EventController _eventController = Get.find();

  /// If this the user is repeating their newly created password and gets an option wrong, this should set to true.
  var _didNotMatch = false;
  var _triesLeft = 3;
  var _wrongGuesses = List<String>();

  @override
  Widget build(BuildContext context) {
    final double componentWidth = min(340, MediaQuery.of(context).size.width - 64);
    final userFlow = _eventController.currentStage;
    final currentPromptIndex = _eventController.currentPromptIndex.value;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (userFlow == UserFlow.signUp_RepeatingPassword)
            Visibility(
              visible: _didNotMatch,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tryAgainText + ' $_triesLeft ' + triesLeftText,
                    style: TextStyle(
                      color: destructiveColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            width: componentWidth,
            child: Text(
              prompts[widget.promptIndex] + '... ',
              style: GoogleFonts.averiaSerifLibre(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: componentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (String option in narrativeOptions[widget.promptIndex])
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AudioTalesWideButton(
                        label: option,
                        leftAlign: true,
                        errorColorBackground: _wrongGuesses.contains(option) ||
                            !_eventController.optionIsMatching(currentPromptIndex) &&
                                _eventController.repeatedPassword.chosenOptions[currentPromptIndex] ==
                                    narrativeOptions[currentPromptIndex].indexOf(option),
                        onPressed: () async {
                          final result = _eventController.addNarrativeOption(
                            widget.promptIndex,
                            narrativeOptions[widget.promptIndex].indexOf(option),
                            isRepeatingPassword: userFlow == UserFlow.signUp_RepeatingPassword,
                          );

                          if (result) {
                            _eventController.stepForwardPrompt();
                            _didNotMatch = false;
                          } else {
                            setState(() {
                              _didNotMatch = true;
                              _triesLeft--;
                              _wrongGuesses.add(option);
                              logEventToDataBase(LogEvent.signUp_failedToRepeat, _eventController);
                              if (_triesLeft <= 0) {
                                debugPrint('Failed to repeat password');
                                _eventController.moveToUserFlow(UserFlow.signUp_FailedToRepeatPassword);
                              }
                            });
                            return;
                          }

                          /// If the button is pressed on any page that isn't the last page
                          if (widget._pageViewController.page.toInt() < prompts.length - 1) {
                            widget._pageViewController.animateToPage(
                              _eventController.currentPromptIndex.value,
                              duration: widget._pageTransitionDuration,
                              curve: widget._pageTransitionCurve,
                            );
                          }

                          /// else if the button is pressed on the last page (meaning the password input is complete)
                          else if (widget._pageViewController.page.toInt() == prompts.length - 1) {
                            if (_eventController.finishedPasswordInput) {
                              //_eventController.loading.value = true;
                              //TODO: loading stuff

                              /// If this is a sign in event
                              if (_eventController.signIn) {
                                final validPassword = await validatePassword(_eventController.email, _eventController.password);
                                //_eventController.loading.value = false;
                                //TODO: loading stuff

                                debugPrint('Valid password: $validPassword');
                                if (validPassword) {
                                  logEventToDataBase(LogEvent.login_success, _eventController);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyBooksScreen(),
                                    ),
                                  );
                                } else {
                                  await logEventToDataBase(LogEvent.login_failed, _eventController);
                                  _eventController.moveToUserFlow(UserFlow.signIn_WrongPassword);
                                  // TODO: Show the user feedback that the signIn attempt failed.
                                }
                              }

                              /// else this is a 'create new account' event and the user just finished creating their password
                              else if (userFlow == UserFlow.signUp_CreatingPassword) {
                                _eventController.moveToUserFlow(UserFlow.signUp_ReviewCreatedPassword);
                              }

                              /// when a user has completed the last step of registration process
                              else if (userFlow == UserFlow.signUp_RepeatingPassword) {
                                _eventController.moveToUserFlow(UserFlow.signUp_RegistrationComplete);
                              }
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
      final userFlow = _eventController.currentStage;

      return Visibility(
        visible: currentPromptIndex > 0 && userFlow != UserFlow.signUp_RepeatingPassword,
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
                currentPromptIndex > 0 ? prompts[currentPromptIndex - 1] + '...' : '',
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
