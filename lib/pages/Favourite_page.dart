// lib/pages/favourite_page.dart
import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes', style: TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text(
          "Favorite Recipes Page (Under Construction)",
          style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}