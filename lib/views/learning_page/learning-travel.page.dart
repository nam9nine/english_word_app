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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Travel Words'),
        ),
        body: FutureBuilder<List<Word>>(
          future: widget.repository.getWordsByCategory('Restaurant'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text("단어 없음"));
              }
              return LearnCarouselSlider(words: snapshot.data!, pageIndex: pageIndex);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }
}
