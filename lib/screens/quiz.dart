import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  static String id = 'quiz_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Center(child: Text('Quiz'))));
  }
}
