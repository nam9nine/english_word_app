

import 'package:flutter/material.dart';

import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';
import '../../widget/carousel_slider.dart';

class QuizPage extends StatefulWidget  {
  final WordRepository repository;
  const QuizPage({super.key, required this.repository});


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
      body: FutureBuilder<List<Word>>(
        future: widget.repository.getWordsByCategory('Restaurant'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("단어 없음"));
            }
            // 영어단어 데이터 쓰는 예시
            return Container(
              child : Text(snapshot.data![0].english)
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),

    );
  }

}