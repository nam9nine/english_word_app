import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_world/model/main-category.model.dart';
import 'package:english_world/views/learning_page/learning-travel.page.dart';
import 'package:english_world/widget/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../repository/word-repository.dart';
import '../learning_page/learning-main.page.dart';

class HomePage extends StatefulWidget {
  final List<Category> categories;
  final WordRepository repository;

  HomePage({super.key, required this.categories, required this.repository});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarouselController? carouselController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    carouselController = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.school, color: Colors.white),
            SizedBox(width: 10),
            Text("6조 영어단어 학습앱", style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
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
              MainCarouselSlider(categories: widget.categories, pageIndex: pageIndex,),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      if (pageIndex ==0 ) {
                        return TravelWordPage(repository: widget.repository);
                      }
                      return widget;
                    }),
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