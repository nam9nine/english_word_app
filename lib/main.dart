
import 'package:english_world/model/main-category.model.dart';
import 'package:english_world/repository/word-repository.dart';
import 'package:english_world/views/home_page/home-main.page.dart';
import 'package:english_world/views/incorrect_page/incorrect-main.page.dart';
import 'package:english_world/views/learning_page/learning-main.page.dart';
import 'package:english_world/views/quiz_page/quiz-main.page.dart';
import 'package:flutter/material.dart';
import 'db/db.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp( EnglishWordApp());
}

class EnglishWordApp extends StatelessWidget {
  const EnglishWordApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English World App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  TabController? controller;
  List<Category> categories = List.empty(growable: true);
  late WordRepository repository;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    categories.add(Category(name: '여행', imagePath: 'assets/images/travel_banner.jpg'));
    categories.add(Category(name: '식당', imagePath: 'assets/images/restaurant_banner.jpg'));
    categories.add(Category(name: '일상 생활', imagePath: 'assets/images/daily-life_banner.jpg'));
    repository = WordRepository(DatabaseHelper());
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          HomePage(categories: categories, repository : repository),
          LearnPage(repository: repository),
          QuizMainPage(repository: repository),
          IncorrectPage(repository: repository),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: controller,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.book)),
          Tab(icon: Icon(Icons.question_answer)),
          Tab(icon: Icon(Icons.error_outline)),
        ],
      ),
    );
  }
}