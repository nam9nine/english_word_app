import 'package:english_world/views/learning_page/learning-travel.page.dart';
import 'package:flutter/material.dart';

class LearnPage extends StatefulWidget  {
  const LearnPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LearnPage();
  }
}
class _LearnPage extends State<LearnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Learn Page')
        ),
        body: Container(
                  child: GridView.count(
                      crossAxisCount: 2,
                      children: <Widget>[
                        GestureDetector(
                          child : Card(
                            child : Column(
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/travel_icon.png',
                                  width : 100,
                                  height : 100,
                                  fit : BoxFit.contain,
                                ),
                                const Text('Travel', style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w500,
                                ),),
                              ],
                            )
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder : (context)=> TravelWordPage()));
                          }
                        )
                      ]
                  ),
                )
    );
  }
}