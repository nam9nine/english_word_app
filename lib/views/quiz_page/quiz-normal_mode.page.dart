import 'package:flutter/material.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';
import '../../widget/quiz-carousel.dart';
import 'package:carousel_slider/carousel_slider.dart';

class QuizSubPage extends StatefulWidget {
  final WordRepository repository;
  const QuizSubPage({super.key, required this.repository});

  @override
  State<StatefulWidget> createState() {
    return _QuizSubPageState();
  }
}

class _QuizSubPageState extends State<QuizSubPage> {
  late List<Word> allWords;
  late List<Word> showWords = [];
  late TextEditingController answerController = TextEditingController();
  late CarouselController _carouselController;

  final FocusNode focusNode = FocusNode();

  String feedbackMessage = '';
  bool isCorrect = false;
  int correctCount = 0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    allWords = await widget.repository.getWordsByCategory('여행');
    setState(() {
      showWords = (List.from(allWords)..shuffle()).take(5).toList().cast<Word>();
    });
    _carouselController = CarouselController();
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
      'Score ${20 * correctCount}',
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildQuizWidget() {
    return Column(
      children: <Widget>[
        Text('${currentIndex + 1} / ${showWords.length}', style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color : Colors.white,
        ),),
        if (showWords.isEmpty)
          const CircularProgressIndicator()
        else
          QuizCarouselSlider(
            answerController: answerController,
            controller: _carouselController,
            words: showWords,
            onPageChanged: (index) {
              setState((){
                currentIndex = index;
              });
            },
          ),
        const SizedBox(height: 20),

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
    String inputValue = value.trim();
    String? correctValue = showWords[index].meaning?.trim();

    if (inputValue != correctValue) {
      _checkAnswer(correctValue!, false);
      widget.repository.updateWrongAnswer(correctValue, '여행');
    } else {
      _checkAnswer(correctValue!, true);
      widget.repository.updateCorrectAnswer(correctValue, '여행');
        correctCount++;

    }

    answerController.clear();
    if (currentIndex == showWords.length - 1){
      currentIndex++;
    }
    _carouselController.nextPage();

  }

  @override
  void dispose() {
    answerController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
