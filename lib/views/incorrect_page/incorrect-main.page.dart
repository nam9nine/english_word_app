


import 'package:flutter/material.dart';

class IncorrectPage extends StatefulWidget  {
  const IncorrectPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IncorrectPage();
  }

}

class _IncorrectPage extends State<IncorrectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title : const Text('incorrect_page')
      ),
    );
  }

}