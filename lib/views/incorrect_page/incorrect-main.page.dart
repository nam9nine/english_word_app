


import 'package:flutter/material.dart';

import '../../repository/word-repository.dart';

class IncorrectPage extends StatefulWidget  {
  final WordRepository repository;
  const IncorrectPage({super.key, required this.repository});

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