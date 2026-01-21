import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../services/api_service.dart';
import '../models/word.dart';
import 'word_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> favoriteWords = [];
  List<Word> words = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => isLoading = true);

    favoriteWords = await FavoriteService.getFavorites();
    words.clear();

    
    for (String w in favoriteWords) {
      try {
        final result = await ApiService.searchWord(w);
        if (result.isNotEmpty) {
          words.add(result.first);
        }
      } catch (_) {}
    }

    setState(() => isLoading = false);
  }

  Future<void> _removeFavorite(String word) async {
    await FavoriteService.toggleFavorite(word);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Favorite Words'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : words.isEmpty
              ? _emptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: words.length,
                  itemBuilder: (context, i) {
                    final word = words[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.favorite, color: Colors.red),
                        title: Text(
                          word.englishWord,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(word.khmerPhonetic),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () =>
                              _removeFavorite(word.englishWord),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WordDetailScreen(word: word),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border,
              size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No favorite words yet',
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
