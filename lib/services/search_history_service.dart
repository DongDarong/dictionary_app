import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _key = 'search_history';

  // Get history list
  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Add new keyword
  static Future<void> addHistory(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_key) ?? [];

    // Remove duplicate
    history.remove(keyword);

    // Add to top
    history.insert(0, keyword);

    // Limit history size (optional)
    if (history.length > 10) {
      history = history.take(10).toList();
    }

    await prefs.setStringList(_key, history);
  }

  // Clear history
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
