// lib/pages/about_page.dart
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // <--- ADDED AppBar for back button and title
        title: const Text('About', style: TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
        backgroundColor: Colors.deepOrange, // Consistent theme color
        iconTheme: const IconThemeData(color: Colors.white), // For the back arrow icon
      ),
      body: const Center(
        child: Text(
          "About Page (Under Construction)",
          style: TextStyle(fontSize: 24, fontFamily: 'Montserrat'), // Apply font
        ),
      ),
    );
  }
}