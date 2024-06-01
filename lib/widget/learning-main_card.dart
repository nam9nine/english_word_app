
import 'package:english_world/model/main-category.model.dart';
import 'package:english_world/views/learning_page/learning-sub.page.dart';
import 'package:flutter/material.dart';
import '../repository/word-repository.dart';

class LearnMainCard extends StatefulWidget {
  final Category category;
  final WordRepository repository;
  const LearnMainCard({super.key, required this.category, required this.repository});

  @override
  State<StatefulWidget> createState() {
    return _LearnMainCard();
  }
}

class _LearnMainCard extends State<LearnMainCard> {

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      child: Card(
        color: Colors.teal[300],
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top : 2.0, bottom: 2.0),
              child: Icon(widget.category.iconPath, size: 110, color: Colors.white)
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
              child: Text(
                widget.category.name,
                style: const TextStyle(
                    fontSize: 26,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LearnSubPage(category : widget.category.name, repository: widget.repository)),
        );
      },
    );
  }

}