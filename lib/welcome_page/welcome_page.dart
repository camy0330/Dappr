// lib/main.dart
import 'package:flutter/material.dart'; // Place 'dart:' imports before others
import 'package:dappr/welcome_page/welcome_page.dart'; // Correct path to welcome_page.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dappr Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Montserrat',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
      ),
      home: const WelcomePage(), // Start with WelcomePage
      debugShowCheckedModeBanner: false,
    );
  }
}