import 'package:flutter/material.dart';
import 'package:english_world/widget/carousel_slider.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';
import 'learning-main.page.dart';

class TravelWordPage extends StatefulWidget {
  final WordRepository repository;
  const TravelWordPage({super.key, required this.repository});

  @override
  _TravelWordPageState createState() => _TravelWordPageState();
}

class _TravelWordPageState extends State<TravelWordPage> {
  final ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> isFinished = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Words'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              ValueListenableBuilder<int>(
                valueListenable: pageIndexNotifier,
                builder: (_, value, __) {
                  return Padding(
                    padding: const EdgeInsets.only(top : 10.0, bottom: 5.0),
                    child: Text('${value + 1}/10'),
                  );
                },
              ),
              FutureBuilder<List<Word>>(
                future: widget.repository.getWordsByCategory('Travel'),
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
                        padding: const EdgeInsets.only(top: 10.0, bottom: 3.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => LearnPage(repository: widget.repository),
                            ));
                          },
                          child: const Text(
                            "학습 완료!",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageIndexNotifier.dispose();
    super.dispose();
  }
}

