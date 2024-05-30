//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class LearningCard extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _LearningCard();
//   }
// }
//
// class _LearningCard extends State<LearningCard> {
//   @override
//   Widget build(BuildContext context) {
//     return  GestureDetector(
//       child: Card(
//         color: Colors.teal[300],
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Container(
//           child: const Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(top : 2.0, bottom: 2.0),
//                 child: Icon(Icons.flight, size: 110, color: Colors.white),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
//                 child: Text(
//                   TRAVEL_CONST,
//                   style: TextStyle(
//                       fontSize: 26,
//                       fontFamily: "Pretendard",
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => TravelWordPage(repository: widget.repository)),
//         );
//       },
//     ),
//   }
//
// }