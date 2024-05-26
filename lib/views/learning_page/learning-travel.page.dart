import 'package:english_world/views/learning_page/learning-main.page.dart';
import 'package:english_world/widget/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/category-word.model.dart';
import '../../repository/word-repository.dart';

class TravelWordPage extends StatefulWidget {
  final WordRepository repository;

  const TravelWordPage({super.key, required this.repository});

  @override
  _TravelWordPageState createState() => _TravelWordPageState();
}

class _TravelWordPageState extends State<TravelWordPage> {
  int pageIndex = 0;
  bool is_finished = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Travel Words'),
        ),
        body: Container(
          child : Center(
            child : Column(
              children: <Widget>[
                FutureBuilder<List<Word>>(
                  future: widget.repository.getWordsByCategory('Restaurant'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text("단어 없음"));
                      }
                      return LearnCarouselSlider(words: snapshot.data!, pageIndex: pageIndex, is_finished: is_finished,);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                is_finished ? Padding(
                  padding: const EdgeInsets.only(top : 10.0, bottom: 3.0),
                  child : ElevatedButton(onPressed: (){
                    MaterialPageRoute(builder: (context) {
                        return LearnPage(repository: widget.repository);
                    });
                  },
                    child : const Text(
                        "학습 완료!",
                      style : TextStyle(color: Colors.black),
                    )
                  )
                ) :  Text(pageIndex.toString(), style : const TextStyle(color: Colors.black)),
              ],
            )
          )
        )
    );
  }
}
