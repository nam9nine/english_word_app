import 'dart:math';
import 'package:flutter/material.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';

class QuizPage extends StatefulWidget {
  final WordRepository repository;

  const QuizPage({Key? key, required this.repository}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QuizPageState();
  }
}

class _QuizPageState extends State<QuizPage> {
  late List<Word> allWords;
  late List<Word> selectedWords = [];
  int currentIndex = 0;
  TextEditingController answerController = TextEditingController();
  String? userAnswer;
  String? correctAnswer;
  int correctCount = 0;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() async {
    List<Word> loadedWords = await widget.repository.getWordsByCategory('Restaurant');
    List<Word> shuffledWords = List.from(loadedWords)..shuffle();
    setState(() {
      allWords = loadedWords;
      selectedWords = shuffledWords.take(10).toList(); // Select 10 random words
      currentIndex = 0;
      userAnswer = '';
      correctAnswer = selectedWords[currentIndex].meaning;
      showAnswer = false;
    });
  }

  void _nextQuestion() {
    setState(() {
      currentIndex = (currentIndex + 1) % (selectedWords.length);
      userAnswer = '';
      answerController.clear();
      correctAnswer = selectedWords[currentIndex].meaning;
      showAnswer = false;
    });
  }

  void _checkAnswer() {
    String userAns = answerController.text.trim();
    if (userAns.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Enter your answer!'),
      ));
      return;
    }

    setState(() {
      userAnswer = userAns;
    });

    if (userAnswer!.toLowerCase() == correctAnswer!.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Correct!'),
        backgroundColor: Colors.green,
      ));
      correctCount++;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Incorrect. The correct answer is $correctAnswer.'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      showAnswer = true;
    });

    if (currentIndex == selectedWords.length - 1) {
      // Last question
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Quiz Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Questions: ${selectedWords.length}'),
              Text('Correct Answers: $correctCount'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Page'),
      ),
      body: selectedWords.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedWords[currentIndex].english,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: answerController,
              onChanged: (value) {
                setState(() {
                  userAnswer = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter your answer',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: showAnswer ? null : _checkAnswer,
              child: Text('Check Answer'),
            ),
            ElevatedButton(
              onPressed: _nextQuestion,
              child: Text('Next Question'),
            ),
            SizedBox(height: 20),
            Text(
              'Correct Answer: ${showAnswer ? correctAnswer ?? "" : ""}',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}