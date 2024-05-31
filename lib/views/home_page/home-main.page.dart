  import 'package:carousel_slider/carousel_slider.dart';
  import 'package:english_world/model/main-category.model.dart';
  import 'package:english_world/views/learning_page/learning-sub.page.dart';
  import 'package:english_world/widget/home-main-carousel.dart';
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
    late ValueNotifier<String> category = ValueNotifier<String>('여행');

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
              Text("6조 영어단어 학습앱", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: Colors.deepPurple[500],
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
                MainCarouselSlider(
                  categories: widget.categories,
                  onPageChanged: (value){
                      category.value = value;
                  },
                ),
                const SizedBox(height: 30),
                ValueListenableBuilder<String>(
                  valueListenable: category,
                  builder: (_, category, __) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                              return LearnSubPage(category : category, repository: widget.repository);
                          }),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      ),
                      child: const Text('학습 시작하기', style: TextStyle(fontSize: 20)),
                    );
                  },),

              ],
            ),
          ),
        ),
      );
    }
  }