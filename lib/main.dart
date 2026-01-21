import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/search_screen.dart';
import 'screens/favorite_screen.dart';

void main() {
  runApp(const DictionaryApp());
}

class DictionaryApp extends StatelessWidget {
  const DictionaryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      
      initialRoute: '/login',

      routes: {
        '/login': (_) => LoginScreen(),     
        '/register': (_) => RegisterScreen(),
        '/search': (_) => const SearchScreen(),
        '/favorites': (_) => const FavoriteScreen(),
      },
    );
  }
}
