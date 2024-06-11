import 'package:english_world/model/main-category.model.dart';
import 'package:english_world/widget/quiz-main_widget.dart';
import 'package:flutter/material.dart';
import '../../repository/word-repository.dart';
import 'package:english_world/widget/util-widget.dart';

class QuizMainPage extends StatefulWidget {
  final WordRepository repository;
  final List<Category> categories;
  const QuizMainPage({super.key, required this.categories, required this.repository});

  @override
  State<StatefulWidget> createState() => _QuizMainPageState();
}

class _QuizMainPageState extends State<QuizMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget('단어 퀴즈'),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xdaa8e6cf), Color(0xffc86b67)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                // 일반 모드 페이지
                child: NormalMode(
                    widget.repository, context, widget.categories),
              ),
              const SizedBox(height: 25),
              Expanded(
                //하드 모드 페이지
                child: HardMode(widget.repository, context, widget.categories),
              ),
            ],
          ),
        ),
      ),
    );
  }
}