import 'package:flutter/material.dart';
import 'package:dappr/welcome_page/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dappr',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange).copyWith(secondary: Colors.deepOrange),
      ),
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false, // Removes the red "DEBUG" banner
    );
  }
}