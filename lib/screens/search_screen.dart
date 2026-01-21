import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/api_service.dart';
import '../services/search_history_service.dart';
import '../services/favorite_service.dart';
import 'word_detail_screen.dart';
import '../utils/token_storage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<Word> words = [];
  List<String> history = [];
  List<String> favorites = [];

  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  //Load search history
  Future<void> _loadHistory() async {
    history = await SearchHistoryService.getHistory();
    if (mounted) setState(() {});
  }

  //Load favorite words
  Future<void> _loadFavorites() async {
    favorites = await FavoriteService.getFavorites();
    if (mounted) setState(() {});
  }

  // Handle search
  Future<void> _handleSearch(String text) async {
    text = text.trim();
    if (text.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    //Save history
    await SearchHistoryService.addHistory(text);
    await _loadHistory();

    try {
      final result = await ApiService.searchWord(text);
      if (!mounted) return;
      setState(() {
        words = result;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  //Clear search
  void _clearSearch() {
    _searchCtrl.clear();
    setState(() {
      words = [];
      _hasSearched = false;
    });
  }

  //Clear history
  Future<void> _clearHistory() async {
    await SearchHistoryService.clearHistory();
    await _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dictionary',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          //Favorite Page
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          //Logout
          IconButton(
  icon: const Icon(Icons.logout),
  onPressed: () async {
    await TokenStorage.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  },
),

        ],
      ),
      body: Column(
        children: [
          
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchCtrl,
              textInputAction: TextInputAction.search,
              onSubmitted: _handleSearch,
              decoration: InputDecoration(
                hintText: 'Search for a word...',
                filled: true,
                fillColor: Colors.grey[100],
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: _clearSearch,
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: Colors.blue, width: 1.5),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          //Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(),
          ),
        ],
      ),
    );
  }

  //Content builder
  Widget _buildContent() {
    
    if (!_hasSearched) {
      if (history.isEmpty) {
        return _emptyState(
          icon: Icons.book_outlined,
          text: 'Type a word to start searching',
        );
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Search History',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _clearHistory,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, i) {
                final item = history[i];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(item),
                  onTap: () {
                    _searchCtrl.text = item;
                    _handleSearch(item);
                  },
                );
              },
            ),
          ),
        ],
      );
    }

    
    if (words.isEmpty) {
      return _emptyState(
        icon: Icons.search_off,
        text: 'No results found',
      );
    }

    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: words.length,
      itemBuilder: (context, i) {
        final word = words[i];
        final isFav = favorites.contains(word.englishWord);

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WordDetailScreen(word: word),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.translate, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.englishWord,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          word.khmerPhonetic,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFav
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () async {
                      await FavoriteService.toggleFavorite(
                          word.englishWord);
                      await _loadFavorites();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

 
  Widget _emptyState({required IconData icon, required String text}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
