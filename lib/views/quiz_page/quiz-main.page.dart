import 'package:english_world/widget/util.widget.dart';
import 'package:flutter/material.dart';
import '../../repository/word-repository.dart';
import 'quiz-normal_mode.page.dart';

class QuizMainPage extends StatefulWidget {
  final WordRepository repository;

  const QuizMainPage({super.key, required this.repository});

  @override
  State<StatefulWidget> createState() {
    return _QuizMainPageState();
  }
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
                child: _normalMode(widget.repository),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: _hardMode(widget.repository),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _normalMode(WordRepository repository) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizSubPage(repository: repository))),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.teal, Color(0xc8a5d6a7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.help_outline, size: 80, color: Colors.white),
            SizedBox(height: 17),
            Text(
              '일반 모드',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              '기본적인 퀴즈를 즐겨보세요',
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hardMode(WordRepository repository) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizSubPage(repository: repository))),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xffef9a9a),Colors.redAccent,],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer, size: 80, color: Colors.white),
            SizedBox(height: 17),
            Text(
              '하드 모드',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              '시간 제한과 더 어려운 문제에 도전하세요',
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}


