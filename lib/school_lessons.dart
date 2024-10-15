import 'package:flutter/material.dart';

class SchoolLessonPage extends StatefulWidget {
  const SchoolLessonPage({super.key});

  @override
  State<SchoolLessonPage> createState() => _SchoolLessonPageState();
}

class _SchoolLessonPageState extends State<SchoolLessonPage> {
  int link_id = 0;

  List links = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQV1H4eltMC-QOhCRa1iNsS-CWkvtuFob8XPw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDMV37cbh5FuT51wbkURQfcg0GCPZ9cGdCtA&s"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: InkWell(
      onTap: () {
        setState(() {
          link_id = (link_id + 1) % links.length;
        });
      },
      child: Image.network(
        links[link_id],
        fit: BoxFit.fitWidth,
        width: 200,
      ),
    )));
  }
}
