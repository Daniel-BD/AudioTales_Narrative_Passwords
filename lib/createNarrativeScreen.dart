import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'narratives.dart';
import 'myBooksScreen.dart';
import 'loginScreen.dart';

class CreateStoryScreen extends StatefulWidget {
  final bool isNewAccount;

  CreateStoryScreen({
    Key key,
    @required this.isNewAccount,
  }) : super(key: key);

  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  var _pageTransitionDuration = Duration(milliseconds: 600);
  final _pageTransitionCurve = Curves.easeInOut;
  final _controller = PageController(
    initialPage: 0,
  );
  var _createdStory = Story();

  /// Persists the created password, meaning it's saved so that we can access it even if the app is shut down and restarted.
  /// Returns true if successful.
  Future<bool> _savePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList('password', _createdStory.chosenOptions);
  }

  /// Controls if the inputted password matches the persisted (saved) password.
  /// Returns true if password matches.
  Future<bool> _controlPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('password').toString() == _createdStory.chosenOptions.toString();
  }

  void _onPasswordEntered() async {
    if (widget.isNewAccount) {
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
    } else if (!widget.isNewAccount) {
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

  Widget _prompt(String prompt) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Text(
        prompt,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _options(List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (String option in options)
            OutlinedButton(
              child: Text(option),
              onPressed: () async {
                _createdStory.chosenOptions.add(option);
                if (_controller.page.toInt() < prompts.length - 1) {
                  _controller.nextPage(duration: _pageTransitionDuration, curve: _pageTransitionCurve);
                  Future.delayed(_pageTransitionDuration).then((_) => setState(() {}));
                } else {
                  setState(() {});
                  _onPasswordEntered();
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _page(int pageNumber) {
    assert(pageNumber < prompts.length || pageNumber < 0, 'Invalid pageNumber given: $pageNumber');

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _prompt(prompts[pageNumber]),
            _options(options[pageNumber]),
          ],
        ),
      ),
    );
  }

  Widget _storyText() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Text(
          _createdStory.completeStory(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _storyText(),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _page(0),
                  _page(1),
                  _page(2),
                  _page(3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
