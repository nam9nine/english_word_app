import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../model/category-word.model.dart';

class QuizCarouselSlider extends StatefulWidget {
  final List<Word>? words;
  final void Function(int) onPageChanged;
  final CarouselController controller;
  final TextEditingController answerController;
  const QuizCarouselSlider({
    super.key,
    required this.words,
    required this.onPageChanged,
    required this.controller,
    required this.answerController,
  });

  @override
  State<StatefulWidget> createState() => _QuizCarouselSliderState();
}

class _QuizCarouselSliderState extends State<QuizCarouselSlider> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.words!.map((word) => Container(
            width: MediaQuery.of(context).size.width, // 화면의 가로 폭에 맞춤
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    word.english,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent
                    ),
                  ),
                ],
              ),
            ),
          )).toList(),
          carouselController: widget.controller,
          options: CarouselOptions(
            height: 250,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            autoPlay: false,
            onPageChanged: (index, reason) {
              if (index > currentPage) {
                setState(() {
                  currentPage = index;
                });
                widget.onPageChanged(index);
              } else {

                if (currentPage != 0) {
                  widget.controller.jumpToPage(currentPage);
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
