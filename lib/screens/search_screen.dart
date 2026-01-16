import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/api_service.dart';
import 'word_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Word> words = [];
  bool loading = false;

  void search(String text) async {
    setState(() => loading = true);
    try {
      words = await ApiService.searchWord(text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dictionary')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search word',
                border: OutlineInputBorder(),
              ),
              onSubmitted: search,
            ),
          ),
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: words.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(words[i].englishWord),
                        subtitle: Text(words[i].khmerPhonetic),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WordDetailScreen(word: words[i]),
                            ),
                          );
                        },
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
