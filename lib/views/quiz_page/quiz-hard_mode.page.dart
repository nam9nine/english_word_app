import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';
import '../../widget/quiz-carousel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../widget/util-widget.dart';

class QuizHardPage extends StatefulWidget {
  final WordRepository repository;
  final String category;
  const QuizHardPage({super.key, required this.category, required this.repository});

  @override
  State<StatefulWidget> createState() {
    return _QuizHardPageState();
  }
}

class _QuizHardPageState extends State<QuizHardPage> {
  late List<Word> allWords;
  late List<Word> showWords = [];
  late TextEditingController answerController = TextEditingController();
  late CarouselController _carouselController;
  Timer? _timer;
  int _remainingTime = 5;
  int baseScore = 40;
  int timeBonus = 2;

  final FocusNode focusNode = FocusNode();

  String feedbackMessage = '';
  bool isCorrect = false;
  int correctCount = 0;
  int currentIndex = 0;
  int totalScore = 0;

  @override
  void initState() {
    super.initState();
    _init();
    focusNode.addListener(_handleFocusChange);
  }

  void _init() async {
    allWords = await widget.repository.getWordsByCategory(widget.category);
    setState(() {
      showWords = (List.from(allWords)..shuffle()).take(5).toList().cast<Word>();
    });
    _carouselController = CarouselController();
  }

  void _handleFocusChange() {
    if (focusNode.hasFocus) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = 5;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    _handleSubmitted('', currentIndex);
  }

  void _checkAnswer(String showWord, bool isCorrect) {
    FocusScope.of(context).requestFocus(focusNode);

    setState(() {
      feedbackMessage = isCorrect ? '정답!' : '오답';
      this.isCorrect = isCorrect;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(feedbackMessage),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
      duration: const Duration(milliseconds: 500),
    ));
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget('${widget.category} 퀴즈', color: Colors.redAccent),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffe15757), // Soft red
              Color(0xffa8d1aa), // Muted green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, top: 5),
            child: Center(
              child: SingleChildScrollView(
                child: currentIndex == showWords.length ? _buildResultWidget()
                    : _buildQuizWidget(),
              ),
            )
        ),
      ),
    );
  }

  Widget _buildScoreWidget() {
    return Text(
      'Score $totalScore',
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildTimerWidget() {
    return Text('남은 시간: $_remainingTime 초', style: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color : Colors.white,
    ),);
  }

  Widget _buildQuizWidget() {
    return Column(
      children: <Widget>[
        Text('${currentIndex + 1} / ${showWords.length}', style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color : Colors.white,
        ),),
        const SizedBox(height: 10),
        _buildTimerWidget(),
        const SizedBox(height: 10),
        showWords.isEmpty ? const CircularProgressIndicator()
            : QuizCarouselSlider(
          answerController: answerController,
          controller: _carouselController,
          words: showWords,
          onPageChanged: (index) {
            setState((){
              currentIndex = index;
            });
          },
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            TextField(
              controller: answerController,
              focusNode: focusNode,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) {
                _handleSubmitted(value, currentIndex);
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                return _handleSubmitted(answerController.text, currentIndex);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                textStyle: const TextStyle(fontSize: 16.0),
              ),
              child: const Text('다음'),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildResultWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildScoreWidget(),
        const SizedBox(height : 60),
        const Text(
          '퀴즈 완료!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          '총 ${showWords.length}문제 중 $correctCount문제 맞춤!',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            textStyle: const TextStyle(fontSize: 16.0),
          ),
          child: const Text('메인으로 돌아가기'),
        ),
      ],
    );
  }

  void _handleSubmitted(String value, int index) {
    _timer?.cancel();
    String inputValue = value.trim();
    String? correctValue = showWords[index].meaning?.trim();

    if (inputValue != correctValue) {
      _checkAnswer(correctValue!, false);
      widget.repository.updateWrongAnswer(correctValue);
    } else {
      int bonus = _remainingTime * timeBonus;
      totalScore += baseScore + bonus;
      _checkAnswer(correctValue!, true);
      widget.repository.updateCorrectAnswer(correctValue);
      correctCount++;
    }

    answerController.clear();
    if (currentIndex == showWords.length - 1) {
      currentIndex++;
    }
    _carouselController.nextPage();
  }

  @override
  void dispose() {
    answerController.dispose();
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
