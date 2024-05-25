import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../repository/word-repository.dart';

class TravelWordPage extends StatefulWidget {
  final WordRepository repository;

  const TravelWordPage({Key? key, required this.repository}) : super(key: key);

  @override
  _TravelWordPageState createState() => _TravelWordPageState();
}

class _TravelWordPageState extends State<TravelWordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Words'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.repository.getAllWords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            final words = snapshot.data ?? [];
            return ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                var word = words[index];
                return ListTile(
                  title: Text(word['english']),
                  subtitle: Text(word['meaning']),
                );
              },
            );
          } else {
            // 데이터 로딩 중이면 로딩 인디케이터를 표시
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}