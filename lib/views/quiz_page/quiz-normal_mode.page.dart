
import 'package:english_world/widget/util-widget.dart';
import 'package:flutter/material.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';
import '../../widget/quiz-carousel.dart';
import 'package:carousel_slider/carousel_slider.dart';
class QuizNormalPage extends StatefulWidget {
  final WordRepository repository;
  final String? category;
  final bool isIncorrectQuiz;
  const QuizNormalPage({
    super.key, this.category,
    required this.repository,
    this.isIncorrectQuiz = false
  });
  @override
  State<StatefulWidget> createState() {
    return _QuizNormalPageState();
  }
}

class _QuizNormalPageState extends State<QuizNormalPage> {
  late List<Word> allWords;
  late List<Word> showWords = [];
  late TextEditingController answerController = TextEditingController();
  late CarouselController _carouselController;
  // TextField 사용 감지를 알기 위해 변수 선언
  final FocusNode focusNode = FocusNode();
  String feedbackMessage = '';
  bool isCorrect = false;
  int correctCount = 0;
  int cardIndex = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget('${widget.category ?? '오답'} 퀴즈'),
      body: Container(
        decoration: BackgroundColor(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            // TextField 클릭 시 키보드가 올라오는데 그때 ui들이 범위에 벗어나게 됨
            // -> SingleChildScrollView 추가
            child: SingleChildScrollView(
              // 카드 인덱스가 나열된 단어들 갯수와 같으면 _buildResultWidget로 결과 페이지로 이동
              // 다르다면 _buildQuizWidget 학습 페이지 유지
              child: cardIndex == showWords.length ? _buildResultWidget()
                : _buildQuizWidget(),
            ),
          )
        ),
      ),
    );
  }

  void _init() async {
    // 만약 오답 퀴즈 요청이 아니라면 카테고리 별 단어를 가져오고 해당 요청이 맞다면
    // 오답 단어들을 전부 불러온다.
    allWords = widget.isIncorrectQuiz ?
        await widget.repository.getWrongAnswer() :
        await widget.repository.getWordsByCategory(widget.category!);
    setState(() {
      showWords = widget.isIncorrectQuiz ?
          // 오답 퀴즈는 10개의 랜덤한 단어들, 일반 퀴즈는 5개의 랜덤 단어들
      (List.from(allWords)..shuffle()).take(10).toList().cast<Word>() :
      (List.from(allWords)..shuffle()).take(5).toList().cast<Word>();
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

  // 최종 결과 스코어를 보여주는 Widget
  Widget _buildScoreWidget() {
    return Text(
      'Score ${20 * correctCount}',
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
  Widget _buildQuizWidget() {
    return Column(
      children: <Widget>[
        Text('${cardIndex + 1} / ${showWords.length}', style: const TextStyle(
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
                cardIndex = index;
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
                      borderSide: const BorderSide(color: Colors.black, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.teal, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSubmitted: (value) {
                    _handleSubmitted(value, cardIndex);
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // 사용자가 다음 버튼 혹은 엔터 키보드를 누를 시 _handleSubmitted 호출
                    return _handleSubmitted(answerController.text, cardIndex);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal[400],
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
              Navigator.pop(context);
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
  // 사용자가 입력한 값 value 변수와 현재 카드 위치를 알려주는 index 변수
  void _handleSubmitted(String value, int index) {
    // 사용자 입력값
    String inputValue = value.trim();
    // 정답
    String? correctValue = showWords[index].meaning?.trim();
    if (inputValue != correctValue) {
      // 오답 처리
      // 스낵바로 답 여부 체크 표시
      _checkAnswer(correctValue!, false);
      widget.repository.updateWrongAnswer(correctValue);
    } else {
      // 정답 처리
      // 스낵바로 답 여부 체크 표시
      _checkAnswer(correctValue!, true);
      widget.repository.updateCorrectAnswer(correctValue);
      // 스코어 점수 집계를 위해 correctCount 변수 증가
      correctCount++;
    }
    answerController.clear();
    if (cardIndex == showWords.length - 1){
      cardIndex++;
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
