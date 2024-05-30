import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../model/main-category.model.dart';

class MainCarouselSlider extends StatefulWidget {
  final List<Category> categories;
  final void Function(int) onPageChanged;

  const MainCarouselSlider({super.key, required this.categories, required this.onPageChanged});

  @override
  State<StatefulWidget> createState() {
    return _MainCarouselSlider();
  }
}

class _MainCarouselSlider extends State<MainCarouselSlider> {
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
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(category.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    ).toList();

    return CarouselSlider(
      items: categorySliders,
      options: CarouselOptions(
          aspectRatio: 16 / 9,
          enlargeCenterPage: true,
          autoPlay: true,
          onPageChanged : (index, reason) {
            widget.onPageChanged(index);
          }
      ),
    );
  }
}
