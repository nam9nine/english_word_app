import 'package:english_world/views/quiz_page/quiz-travel.page.dart';
import 'package:flutter/material.dart';
import '../../repository/word-repository.dart';


class QuizMainPage extends StatefulWidget {
  final WordRepository repository;

  const QuizMainPage({super.key, required this.repository});

  @override
  State<StatefulWidget> createState() {
    return _QuizMainPageState();
  }
}

class _QuizMainPageState extends State<QuizMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            GestureDetector(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top : 2.0, bottom: 2.0),
                      child : Image.asset(
                        'assets/images/travel_icon.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: Text(
                        'Travel',
                        style: TextStyle(
                          fontSize: 26,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizTravelPage(repository: widget.repository)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
}
 
