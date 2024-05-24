import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_world/models/main-category.model.dart';
import 'package:flutter/material.dart';
import '../learning_page/learning-main.page.dart';

class HomePage extends StatefulWidget {
  final List<Category> categories;

  HomePage({super.key, required this.categories});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> categorySliders = widget.categories.map((category) =>
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(category.imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  bottom: 20,
                  child: Text(category.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
        )
    ).toList();

    return Scaffold(
      appBar:AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,  // 최소 크기로 조정
          children: <Widget>[
            Icon(Icons.school, color: Colors.white),  // 앱 주제에 맞는 아이콘으로 변경
            SizedBox(width: 10),  // 아이콘과 텍스트 사이의 공간 추가
            Text("6조 영어단어 학습앱", style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.deepPurple,  // AppBar의 배경색 변경
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              print("Settings tapped!");
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                  items: categorySliders
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LearnPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text('학습 시작하기', style: TextStyle(fontSize: 20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}