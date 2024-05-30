import 'package:english_world/const/category.const.dart';
import 'package:english_world/views/learning_page/learning-travel.page.dart';
import 'package:flutter/material.dart';
import '../../repository/word-repository.dart';

class LearnPage extends StatefulWidget {
  final WordRepository repository;
  const LearnPage({super.key, required this.repository});

  @override
  State<StatefulWidget> createState() {
    return _LearnPage();
  }
}

class _LearnPage extends State<LearnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("학습 카테고리", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
        )),
        backgroundColor: Colors.teal[400],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
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
            GestureDetector(
              child: Card(
                color: Colors.teal[300],
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top : 2.0, bottom: 2.0),
                        child: Icon(Icons.flight, size: 110, color: Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                        child: Text(
                          TRAVEL_CONST,
                          style: TextStyle(
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
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TravelWordPage(repository: widget.repository)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
