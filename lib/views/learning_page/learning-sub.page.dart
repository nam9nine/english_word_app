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
            "${widget.category} 학습",
            style : const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold),),
        backgroundColor: Colors.teal[400],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0x91a8e6cf),
              Color(0xFFdcedc1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child : Center(
          child: Column(
            children: <Widget>[
                 Padding(
                    padding: const EdgeInsets.only(top : 20.0, bottom: 5.0),
                    child: Text(
                      '${pageIndex + 1}/${showList.length}',
                      style : const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30
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
                  padding: const EdgeInsets.only(top: 16.0, bottom: 3.0),
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

