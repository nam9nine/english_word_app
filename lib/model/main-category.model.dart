
import 'package:flutter/cupertino.dart';

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