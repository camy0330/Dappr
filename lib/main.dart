// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

// Data & Providers
import 'package:dappr/data/recipes_data.dart';
import 'package:dappr/providers/favorite_provider.dart';
import 'package:dappr/providers/rating_provider.dart';
import 'package:dappr/providers/shopping_list_provider.dart';
import 'package:dappr/theme_notifier.dart';

// Pages
import 'package:dappr/welcome_page/welcome_page.dart';
import 'package:dappr/pages/about_page.dart';
import 'package:dappr/pages/filter_recipe_page.dart';
import 'package:dappr/pages/setting_page.dart';
import 'package:dappr/pages/timer_cooking_page.dart';
import 'package:dappr/pages/recipe_puzzle_game.dart'; // ✅ Puzzle Game

var logger = Logger();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => RatingProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingListProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Dappr Recipe App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Montserrat',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              secondary: Colors.amber,
              onSecondary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black87,
              error: Colors.red,
              onError: Colors.white,
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 96, color: Colors.black87),
              headlineMedium: TextStyle(fontSize: 32, color: Colors.black87),
              titleLarge: TextStyle(fontSize: 18, color: Colors.black87),
              bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
              bodyMedium: TextStyle(color: Colors.black54),
              bodySmall: TextStyle(fontSize: 12, color: Colors.black45),
              labelLarge: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Montserrat',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.grey.shade900,
            colorScheme: ColorScheme.dark(
              primary: Colors.deepOrange.shade700,
              onPrimary: Colors.white,
              secondary: Colors.amberAccent,
              onSecondary: Colors.black,
              surface: Colors.grey.shade800,
              onSurface: Colors.white70,
              error: Colors.red.shade400,
              onError: Colors.black,
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 96, color: Colors.white70),
              headlineMedium: TextStyle(fontSize: 32, color: Colors.white70),
              titleLarge: TextStyle(fontSize: 18, color: Colors.white70),
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
              bodySmall: TextStyle(fontSize: 12, color: Colors.white38),
              labelLarge: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          themeMode: themeNotifier.themeMode,
          home: const WelcomePage(),
          routes: {
            '/about': (context) => const AboutPage(),
            '/timer': (context) => const TimerCookingPage(),
            '/settings': (context) => const SettingPage(),
            '/filter_recipes': (context) => RecipeFilterPage(recipes: recipes),
            '/puzzle_game': (context) => const DummyPuzzleRoute(), // ✅ Game route placeholder
          },
        );
      },
    );
  }
}

// Optional dummy widget for direct navigation (not used if you push manually with recipe)
class DummyPuzzleRoute extends StatelessWidget {
  const DummyPuzzleRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Open the Puzzle Game using Navigator.push."),
      ),
    );
  }
}
