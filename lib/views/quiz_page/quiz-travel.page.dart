import 'package:flutter/material.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';
import '../../widget/quiz-carousel.dart';
import 'package:carousel_slider/carousel_slider.dart';

class QuizTravelPage extends StatefulWidget {
  final WordRepository repository;
  const QuizTravelPage({super.key, required this.repository});

  @override
  State<StatefulWidget> createState() {
    return _QuizTravelPageState();
  }
}

class _QuizTravelPageState extends State<QuizTravelPage> {
  late List<Word> allWords;
  late TextEditingController answerController = TextEditingController();
  late CarouselController _carouselController;
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<int> pageIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> isFinished = ValueNotifier<bool>(false);
  late List<Word> showWords = [];
  String feedbackMessage = '';
  bool isCorrect = false;
  int correctCount = 0;
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    allWords = await widget.repository.getWordsByCategory('Travel');
    setState(() {
      showWords = (List.from(allWords)..shuffle()).take(5).toList().cast<Word>();
    });
    _carouselController = CarouselController();
  }

  void _checkAnswer(String showWord, bool isCorrect) {
    FocusScope.of(context).requestFocus(focusNode);
    setState(() {
      feedbackMessage = isCorrect ? '정답!' : '오답 -> 정답 : $showWord';
      this.isCorrect = isCorrect;
      if (isCorrect) {
        correctCount++;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(feedbackMessage),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
      duration: const Duration(milliseconds: 500),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Quiz', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: ValueListenableBuilder<bool>(
                valueListenable: isFinished,
                builder: (context, finished, child) {
                  if(currentIndex == 6){
                    return _buildResultWidget();
                  } else {
                    return _buildQuizWidget();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreWidget() {
    return Text(
      'Score ${20 * correctCount}',
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildQuizWidget() {
    return Column(
      children: <Widget>[
        Text('$currentIndex / ${showWords.length}'),
        if (showWords.isEmpty)
          const CircularProgressIndicator()
        else
          QuizCarouselSlider(
            answerController: answerController,
            controller: _carouselController,
            words: showWords,
            onPageChanged: (index) {
              pageIndex.value = index;
              if (pageIndex.value == showWords.length - 1) {
                isFinished.value = true;
              }
            },
          ),
        const SizedBox(height: 20),
        ValueListenableBuilder<int>(
          valueListenable: pageIndex,
          builder: (_, index, __) {
            return Column(
              children: [
                TextField(
                  controller: answerController,
                  focusNode: focusNode,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSubmitted: (value) {
                    _handleSubmitted(value, index);
                    currentIndex++;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    currentIndex++;
                    return _handleSubmitted(answerController.text, index);
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
                  child: const Text('다음'),
                ),
              ],
            );
          },
        ),
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
    String inputValue = value.trim();
    String? correctValue = showWords[index].meaning?.trim();
    if (inputValue != correctValue) {
      _checkAnswer(correctValue!, false);
      widget.repository.updateWrongAnswer(correctValue, 'Travel');
    } else {
      _checkAnswer(correctValue!, true);
      widget.repository.updateCorrectAnswer(correctValue, 'Travel');
    }
    if (!isFinished.value) {
      _carouselController.nextPage();
    }
    answerController.clear();
  }

  @override
  void dispose() {
    answerController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
