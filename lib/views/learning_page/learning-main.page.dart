
import 'package:english_world/widget/learning-main_card.dart';
import 'package:flutter/material.dart';
import '../../model/main-category.model.dart';
import '../../repository/word-repository.dart';
import '../../widget/util-widget.dart';

class LearnMainPage extends StatefulWidget {
  final WordRepository repository;
  final List<Category> categories;
  const LearnMainPage({super.key, required this.categories, required this.repository});

  @override
  State<StatefulWidget> createState() {
    return _LearnPage();
  }
}
class _LearnPage extends State<LearnMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget('단어 학습'),
      body: Container(
        padding: const EdgeInsets.only(left : 20, right : 20, top : 60),
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
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            // 메인에서 초기화한 카테고리 리스트 요소마다  카드형식으로 만들어줌
            ...widget.categories.map((category){
              return LearnMainCard(category: category, repository: widget.repository,);
            })
        ],
        ),
      ),
    );
  }
}
