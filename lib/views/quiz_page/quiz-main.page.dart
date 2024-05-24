

import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget  {
  const QuizPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _QuizPage();
  }
}

class _QuizPage extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title : const Text('quiz_page')
      ),

    );
  }

}