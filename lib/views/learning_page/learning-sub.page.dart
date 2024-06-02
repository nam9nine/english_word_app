import 'package:english_world/widget/util-widget.dart';
import 'package:flutter/material.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';
import '../../widget/learning-carousel.dart';

class LearnSubPage extends StatefulWidget {
  final WordRepository repository;
  final String category;
  const LearnSubPage({super.key, required this.category, required this.repository});

  @override
  _LearnSubPageState createState() => _LearnSubPageState();
}

class _LearnSubPageState extends State<LearnSubPage> {
  bool isFinished = false;
  int pageIndex = 0;
  late List<Word> showList = [];

  @override
  @override
  void initState() {
    super.initState();
   _init();
  }
  _init () async {
    List<Word> loadList = await widget.repository.getWordsByCategory(widget.category);
    setState(() {
      showList = loadList;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.category} 단어 학습",
            style : const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold),),
        backgroundColor: Colors.teal[400],
      ),
      body: Container(
        decoration: BackgroundColor(),
        child : Center(
          child: Column(
            children: <Widget>[
                 Padding(
                    padding: const EdgeInsets.only(top : 45.0, bottom: 5.0),
                    child: Text(
                      '${pageIndex + 1}/${showList.length}',
                      style : const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35
                      ),
                  ),
                 ),
              showList.isEmpty ? const CircularProgressIndicator()
              : LearnCarouselSlider(
                words: showList,
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                  if (pageIndex + 1 == showList.length) {
                    setState(() {
                      isFinished = true;
                    });
                  }
                }
              ),

              Visibility(
                visible: isFinished,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 3.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.teal[400],
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        ),
                    child: const Text(
                      "학습 완료!",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

