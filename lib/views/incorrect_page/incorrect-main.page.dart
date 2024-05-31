import 'package:flutter/material.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';


class IncorrectPage extends StatefulWidget {
  final WordRepository repository;
  const IncorrectPage({super.key, required this.repository});

  @override
  State<StatefulWidget> createState() => _IncorrectPageState();
}

class _IncorrectPageState extends State<IncorrectPage> {
  late List<Word> wrongWords = []; // 초기 값으로 빈 리스트 할당
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
      appBar: AppBar(
        title: const Text('Incorrect Words'),
      ),
      body: wrongWords.isNotEmpty
          ? ListView.builder(
        itemCount: wrongWords.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(wrongWords[index].english),
            subtitle: Text(wrongWords[index].meaning ?? "No meaning available"),
          );
        },
      ) : const Text('오답이 없습니다'),

    );
  }
}
