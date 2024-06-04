
import 'package:english_world/views/quiz_page/quiz-hard_mode.page.dart';
import 'package:flutter/material.dart';
import '../model/main-category.model.dart';
import '../repository/word-repository.dart';
import '../views/quiz_page/quiz-normal_mode.page.dart';

Widget NormalMode(WordRepository repository, BuildContext context, List<Category> categories ) {
  return GestureDetector(
    onTap: () => _showCategoryDialog("일반 모드", repository, context, categories),
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.teal, Color(0xc8a5d6a7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.help_outline, size: 80, color: Colors.white),
          SizedBox(height: 17),
          Text(
            '일반 모드',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            '기본적인 퀴즈를 즐겨보세요',
            style: TextStyle(fontSize: 20, color: Colors.white70),
          ),
        ],
      ),
    ),
  );
}

Widget HardMode(WordRepository repository, BuildContext context, List<Category> categories) {
  return GestureDetector(
    onTap: () => _showCategoryDialog('하드 모드', repository, context, categories),
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffef9a9a),Colors.redAccent,],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer, size: 80, color: Colors.white),
          SizedBox(height: 17),
          Text(
            '하드 모드',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            '시간 제한과 더 어려운 문제에 도전하세요',
            style: TextStyle(fontSize: 20, color: Colors.white70),
          ),
        ],
      ),
    ),
  );
}

void _showCategoryDialog(
    String mode,
    WordRepository repository,
    BuildContext context,
    List<Category> categories
    ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xdaa8e6cf), Color(0xffc86b67)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mode,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: mode == "일반 모드" ? Colors.teal : Colors.redAccent
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...categories.map((category) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        mode == "일반 모드" ?
                        QuizNormalPage(category: category.name, repository: repository) :
                        QuizHardPage(category: category.name, repository: repository)
                        ));
                      },
                      splashColor: Colors.white24,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding : const EdgeInsets.all(1.0),
                                child : Icon(
                                    category.iconPath,
                                    size : 25,
                                    color : mode == "일반 모드" ? Colors.teal : Colors.redAccent
                                )
                            ),
                            const SizedBox(width: 10),
                            Text(
                              category.name,
                              style: const TextStyle(fontSize: 18, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xffc86b67),
                    ),
                    child: const Text('취소', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
