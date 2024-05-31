
import 'package:flutter/material.dart';

AppBar AppBarWidget (String title) {
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
    backgroundColor: Colors.teal[500],
  );
}

