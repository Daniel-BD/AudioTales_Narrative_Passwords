import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class AudioTalesWideButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  final bool leftAlign;

  const AudioTalesWideButton({
    Key key,
    @required this.onPressed,
    @required this.label,
    this.fontSize = 17,
    this.fontWeight = FontWeight.w500,
    this.leftAlign = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = min(340, MediaQuery.of(context).size.width - 64);

    return SizedBox(
      width: buttonWidth,
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 16),
        color: primaryColor,
        onPressed: onPressed,
        child: Align(
          alignment: leftAlign ? Alignment.centerLeft : Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
