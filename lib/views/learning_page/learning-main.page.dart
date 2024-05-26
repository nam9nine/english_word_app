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
        title: const Text('Learn Page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8), // Adds padding around the grid
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10, // Horizontal space between cards
          mainAxisSpacing: 10, // Vertical space between cards
          children: <Widget>[
            GestureDetector(
              child: Card(
                elevation: 4, // Adds a subtle shadow to each card
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centers the content vertically
                  children: <Widget>[

                    // Makes the image expand to fill the card height
                    Padding(
                        padding: const EdgeInsets.only(top : 2.0, bottom: 2.0),
                        child : Image.asset(
                          'assets/images/travel_icon.png',
                          width: 120,
                          height: 120,// Makes the image expand to fill the card width
                          fit: BoxFit.contain, // Covers the area without stretching the image
                        ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0), // Padding around the text
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
