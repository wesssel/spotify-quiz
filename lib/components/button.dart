import 'package:flutter/material.dart';
import 'package:spotifyquiz/constants/theme.dart';

class Button extends StatelessWidget {
  final Color color;
  final String text;
  final Function onPressed;

  Button({this.color, @required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text,
          style: kTextBase.copyWith(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
      color: color ?? kPrimaryColor,
      padding: EdgeInsets.only(top: 14, bottom: 12, left: 25, right: 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      onPressed: onPressed,
    );
  }
}
