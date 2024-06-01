import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_world/model/main-category.model.dart';
import 'package:english_world/views/learning_page/learning-sub.page.dart';
import 'package:english_world/widget/util-widget.dart';
import 'package:english_world/widget/home-carousel.dart';
import 'package:flutter/material.dart';
import '../../repository/word-repository.dart';

class HomePage extends StatefulWidget {
  final List<Category> categories;
  final WordRepository repository;

  const HomePage({super.key, required this.categories, required this.repository});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarouselController? carouselController;
  String category = "여행";

  @override
  void initState() {
    super.initState();
    carouselController = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget('6조 영어단어 학습'),
      body: Container(
        decoration: BackgroundColor(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MainCarouselSlider(
                categories: widget.categories,
                onPageChanged: (value){
                  setState(() {
                    category = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return LearnSubPage(category: category, repository: widget.repository);
                        }),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.teal[400],
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: const Text('학습 시작하기', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    )),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
