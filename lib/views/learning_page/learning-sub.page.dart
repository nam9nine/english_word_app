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

  final ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> isFinished = ValueNotifier<bool>(false);

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
              ValueListenableBuilder<int>(
                valueListenable: pageIndexNotifier,
                builder: (_, value, __) {
                  return Padding(
                    padding: const EdgeInsets.only(top : 20.0, bottom: 5.0),
                    child: Text(
                      '${value + 1}/10',
                      style : const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),
                  ),
                );
              },
            ),

            FutureBuilder<List<Word>>(
              future: widget.repository.getWordsByCategory(widget.category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Center(child: Text("단어 없음"));
                  }
                  return LearnCarouselSlider(
                    words: snapshot.data!,
                    onPageChanged: (index) {
                      pageIndexNotifier.value = index;
                      if (pageIndexNotifier.value == 9) {
                        isFinished.value = true;
                      }
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            ValueListenableBuilder<bool>(
                valueListenable: isFinished,
                builder: (_, value, __){
                  return Visibility(
                    visible: value,
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
                  );
                }),
          ],
        ),
      ),
      )
    );
  }

  @override
  void dispose() {
    pageIndexNotifier.dispose();
    super.dispose();
  }
}

