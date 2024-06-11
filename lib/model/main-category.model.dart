
import 'package:flutter/cupertino.dart';

//카테고리 모델
class Category {
  String name;
  String imagePath;
  IconData? iconPath;
  Category({
    required this.name,
    required this.imagePath,
    this.iconPath,
  });
}