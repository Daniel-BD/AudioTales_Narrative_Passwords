import 'package:flutter/material.dart';

import 'narratives.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _pageTransitionDuration = Duration(milliseconds: 600);
  final _pageTransitionCurve = Curves.easeInOut;

  final _controller = PageController(
    initialPage: 0,
  );

  var _createdStory = Story();

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
              onPressed: () {
                _createdStory.chosenOptions.add(option);
                if (_controller.page.toInt() < prompts.length - 1) {
                  _controller.nextPage(duration: _pageTransitionDuration, curve: _pageTransitionCurve);
                } else {
                  print('Finished story:');
                  print(_createdStory.completeStory());
                  //TODO: När storyn är klar ska något hända
                }
                Future.delayed(_pageTransitionDuration).then((_) => setState(() {}));
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
        padding: const EdgeInsets.all(32.0),
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
            SizedBox(
              height: 400, // TODO: Ska inte ha hårdkodade värden här. Kanske behöver byta ut PageView eftersom den inte kan "shrinkwrappa".
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
