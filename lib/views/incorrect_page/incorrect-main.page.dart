import 'package:english_world/views/quiz_page/quiz-normal_mode.page.dart';
import 'package:flutter/material.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';
import 'package:english_world/widget/util-widget.dart';

class IncorrectMainPage extends StatefulWidget {
  final WordRepository repository;

  const IncorrectMainPage({super.key, required this.repository});

  @override
  State<IncorrectMainPage> createState() => _IncorrectMainPageState();
}

class _IncorrectMainPageState extends State<IncorrectMainPage> {
  late List<Word> wrongWords = [];
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    List<Word> loadedWords = await widget.repository.getWrongAnswer();
    setState(() {
      wrongWords = loadedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget('단어 오답'),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _floatingRefreshButtonWidget(),
          const SizedBox(height: 16),
          _floatingQuizButtonWidget(),
        ],
      ),

      body: Container(
        decoration: BackgroundColor(),
        child: wrongWords.isEmpty
            ? const Center(child: Text("오답 목록이 비어 있습니다.", style: TextStyle(
            fontSize: 20,
            color: Colors.white)))
            : NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            return true;
          },
          child: ListView.builder(
            itemCount: wrongWords.length,
            itemBuilder: (context, index) {
              if (index == wrongWords.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return Card(
                  color: Colors.white.withOpacity(0.85),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      wrongWords[index].english,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // trailing: const Icon(Icons.arrow_forward, color: Colors.black),
                  )
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _floatingRefreshButtonWidget() {
    return  FloatingActionButton(
      heroTag: 'refresh_button',
      onPressed: () {
          _init();
      },
      tooltip: '새로고침',
      backgroundColor: Colors.teal[400],
      child: const Icon(Icons.refresh_rounded, color: Colors.white,),
    );
  }

  Widget _floatingQuizButtonWidget() {
    return  FloatingActionButton(
      heroTag: 'quiz_button',
      onPressed: () {
        if (wrongWords.isEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('오답 없음'),
                content: const Text('더 많은 퀴즈를 풀어보세요.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 다이어로그 닫기
                    },
                    child: const Text('확인'),
                  ),
                ],
              );
            },
          );
        } else {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return QuizNormalPage(repository: widget.repository, isIncorrectQuiz: true);
              }
          ));
        }
      },
      tooltip: '오답 시험 시작',
      backgroundColor: Colors.teal[400],
      child: const Icon(Icons.quiz_rounded, color: Colors.white,),
    );
  }
}
