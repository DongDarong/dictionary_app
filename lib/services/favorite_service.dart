import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = 'favorite_words';

  // Get favorites
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Check if favorite
  static Future<bool> isFavorite(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.contains(word);
  }

  // Toggle favorite
  static Future<void> toggleFavorite(String word) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(_key) ?? [];

    if (list.contains(word)) {
      list.remove(word);
    } else {
      list.add(word);
    }

    await prefs.setStringList(_key, list);
  }
}
