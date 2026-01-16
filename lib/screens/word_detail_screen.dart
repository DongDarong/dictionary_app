import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/word.dart';

class WordDetailScreen extends StatelessWidget {
  final Word word;

  WordDetailScreen({required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(word.englishWord)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Html(data: word.khmerDef),
      ),
    );
  }
}
