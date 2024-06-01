
import 'package:flutter/material.dart';

AppBar AppBarWidget (String title, {MaterialAccentColor? color}) {
  return AppBar(
    title:  Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.school, color: Colors.white),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
        )),
      ],
    ),
    backgroundColor: color ?? Colors.teal[500],
  );
}

