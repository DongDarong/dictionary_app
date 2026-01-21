import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/word.dart';
import '../utils/token_storage.dart';

class ApiService {

  static Future<String?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      await TokenStorage.saveToken(data['token']);
      return null;
    }
    return 'Invalid email or password';
  }


  static Future<String?> register(
      String name, String email, String password) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      await TokenStorage.saveToken(data['token']);
      return null;
    }

    final data = jsonDecode(res.body);
    return data['error'] ?? 'Register failed';
  }


  static Future<List<Word>> searchWord(String query) async {
    final token = await TokenStorage.getToken();

    final res = await http.get(
      Uri.parse(
          '${ApiConfig.baseUrl}/api/dictionary/search?query=$query&limit=20'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['words'] as List)
          .map((e) => Word.fromJson(e))
          .toList();
    }

    if (res.statusCode == 429) {
      throw Exception('Rate limit exceeded');
    }

    throw Exception('Failed to load words');
  }
}
