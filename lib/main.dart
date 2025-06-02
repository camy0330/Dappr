// lib/main.dart
import 'package:dappr/providers/favorite_provider.dart';
import 'package:dappr/welcome_page/welcome_page.dart'; // Corrected import path for welcome_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dappr Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Montserrat', // Ensure this font is correctly loaded in pubspec.yaml
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
      ),
      home: const WelcomePage(), // Using WelcomePage as the initial route
      debugShowCheckedModeBanner: false,
    );
  }
}