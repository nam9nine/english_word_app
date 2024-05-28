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
  late List<Word> showWords = [];
  final TextEditingController answerController = TextEditingController();
  final ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> isFinished = ValueNotifier<bool>(false);
  bool isWrongAnswer = false;
  int correctCount = 0;
  late CarouselController _carouselController;
  bool isEnter = false;
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    List<Word> loadedWords = await widget.repository.getWordsByCategory('Travel');
    List<Word> shuffledWords = List.from(loadedWords)..shuffle();

    _carouselController = CarouselController();
    setState(() {
      allWords = loadedWords;
      showWords = shuffledWords.take(5).toList();
    });
  }

  void _checkAnswer(String showWord) {
    String userAns = answerController.text.trim();
    if (userAns.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter your answer!'),
      ));
      return;
    }
    if (userAns == showWord) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('정답!'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('오답입니다 정답 :  $showWord'),
        backgroundColor: Colors.red,
      ));
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Page'),
      ),
      body: Container(
        child: Center(
          child : SingleChildScrollView(
            child : Column(

              children: <Widget>[
                if (showWords.isEmpty)
                  const CircularProgressIndicator()
                else
                  QuizCarouselSlider(
                    answerController: answerController,
                    controller: _carouselController,
                    words: showWords,
                    onPageChanged: (index) {
                      pageIndexNotifier.value = index;
                      if (pageIndexNotifier.value == showWords.length - 1) {
                        isFinished.value = true;
                      }
                    },
                  ),
                ValueListenableBuilder<int>(
                  valueListenable: pageIndexNotifier,
                  builder: (_, index, __) {
                    return TextField(
                      controller: answerController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      onSubmitted: (value) {
                        String trimmedValue = value.trim();
                        String? correctValue = showWords[index].meaning?.trim();

                        if (trimmedValue != correctValue) {
                          _checkAnswer(correctValue!);
                          print(correctValue);
                          widget.repository.updateWrongAnswer(correctValue, 'Travel');
                        } else {
                          _checkAnswer(correctValue!);
                        }
                        if (!isFinished.value) {
                          _carouselController.nextPage();
                        }
                        answerController.clear();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }
}
