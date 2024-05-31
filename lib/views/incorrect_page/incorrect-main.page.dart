import 'package:english_world/widget/util.widget.dart';
import 'package:flutter/material.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';

class IncorrectPage extends StatefulWidget {
  final WordRepository repository;

  const IncorrectPage({Key? key, required this.repository}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IncorrectPageState();
}

class _IncorrectPageState extends State<IncorrectPage> {
  late List<Word> wrongWords = [];
  bool showMeaning = false; // 단어 뜻 표시 여부를 나타내는 변수

  @override
  void initState() {
    super.initState();
    _loadWrongWords();
  }

  void _loadWrongWords() async {
    List<Word> loadedWords = await widget.repository.getWrongAnswer('여행');
    setState(() {
      wrongWords = loadedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget('단어 오답'),
      body: Column(
        children: [
          Expanded(
            child: wrongWords.isNotEmpty
                ? ListView.builder(
              itemCount: wrongWords.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    // 단어 뜻 표시 여부 토글
                    setState(() {
                      showMeaning = !showMeaning;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: showMeaning
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wrongWords[index].english,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (showMeaning)
                          Text(
                            wrongWords[index].meaning ??
                                "No meaning available",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            )
                : const Center(child: Text('틀린 오답이 없습니다.')),
          ),
          ElevatedButton(
            onPressed: _startRetest,
            child: Text('재시험'),
          ),
        ],
      ),
    );
  }

  void _startRetest() async {
    // 오답노트가 비어있는 경우 아무 작업도 수행하지 않음
    if (wrongWords.isEmpty) {
      return;
    }

    // 오답노트를 5개씩 묶어서 재시험 페이지로 이동
    List<List<Word>> groups = [];
    for (int i = 0; i < wrongWords.length; i += 5) {
      int end = (i + 5 < wrongWords.length) ? i + 5 : wrongWords.length;
      groups.add(wrongWords.sublist(i, end));
    }

    // 각 그룹별로 재시험을 보여주고 수정된 단어 리스트를 받아옴
    List<Word> updatedWords = [];
    for (int i = 0; i < groups.length; i++) {
      List<Word>? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RetestPage(
            words: groups[i],
            repository: widget.repository,
          ),
        ),
      );

      if (result != null) {
        updatedWords.addAll(result);
      }
    }

    // 수정된 단어 리스트로 오답 노트를 갱신
    setState(() {
      wrongWords = updatedWords;
    });
  }
}

class RetestPage extends StatefulWidget {
  final List<Word> words;
  final WordRepository repository;

  const RetestPage({Key? key, required this.words, required this.repository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RetestPageState();
}

class _RetestPageState extends State<RetestPage> {
  late List<TextEditingController> answerControllers;

  @override
  void initState() {
    super.initState();
    // 각 단어에 대한 컨트롤러를 초기화합니다.
    answerControllers = List.generate(widget.words.length, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('재시험'),
      ),
      body: Column(
        children: [
          for (int i = 0; i < widget.words.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.words[i].english,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: answerControllers[i], // 해당 단어의 컨트롤러를 지정합니다.
                    decoration: InputDecoration(
                      hintText: '답을 입력하세요',
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ElevatedButton(
            onPressed: _handleFinish,
            child: Text('완료'),
          ),
        ],
      ),
    );
  }

  void _handleFinish() {
    List<Word> updatedWords = [];

    // 입력된 답과 정답을 비교하여 맞는지 여부를 확인하고,
    // 결과에 따라 사용자에게 알려줍니다.
    for (int i = 0; i < widget.words.length; i++) {
      String inputValue = answerControllers[i].text.trim();
      String? correctValue = widget.words[i].meaning?.trim();

      bool isCorrect = inputValue == correctValue;

      // 답이 맞으면 green, 틀리면 red 색상의 SnackBar를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCorrect ? '정답입니다!' : '틀렸습니다. 답은 $correctValue 입니다.',
          ),
          backgroundColor: isCorrect ? Colors.green : Colors.red,
        ),
      );

      // 답이 틀린 경우 오답 리스트에 추가합니다.
      if (!isCorrect) {
        updatedWords.add(widget.words[i]);
      }
    }

    // 수정된 단어 리스트로 이전 페이지로 돌아갑니다.
    Navigator.pop(context, updatedWords);
  }

  @override
  void dispose() {
    // 페이지가 dispose될 때 컨트롤러를 모두 해제합니다.
    for (var controller in answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}