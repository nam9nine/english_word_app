import 'package:english_world/widget/util-widget.dart';
import 'package:flutter/material.dart';
// import 'package:glass/glass.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';

class IncorrectMainPage extends StatefulWidget {
  final WordRepository repository;

  const IncorrectMainPage({super.key, required this.repository});

  @override
  State<StatefulWidget> createState() => _IncorrectMainPageState();
}

class _IncorrectMainPageState extends State<IncorrectMainPage> {
  late List<Word> wrongWords = [];

  bool effectEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadWrongWords();
  }

  void _loadWrongWords() async {
    List<Word> loadedWords = await widget.repository.getWrongAnswer();
    setState(() {
      wrongWords = loadedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget('단어 오답'),
      body: Container(
        decoration: BackgroundColor(),
        child: wrongWords.isEmpty
            ? const Center(child: Text('오답 없음', style: TextStyle(fontSize: 20)))
            : ListView.builder(
          itemCount: wrongWords.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white.withOpacity(0.85), // Semi-transparent white
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  wrongWords[index].english,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward, color: Colors.black54), // Optional navigation icon
              ),
            );
          },
        ),
      ),
    );
  }
}
