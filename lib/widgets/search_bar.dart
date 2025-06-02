// lib/widgets/search_bar.dart
import 'package:flutter/material.dart'; // Place 'dart:' imports before others

class MySearchBar extends StatelessWidget { // Class name updated
  final Function(String) onSearch;

  const MySearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding( // Wrap with Padding
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust this value
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              // Replaced deprecated withOpacity
              color: const Color.fromARGB(38, 255, 87, 34), // Represents Colors.deepOrange.withOpacity(0.15)
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: onSearch,
          decoration: InputDecoration(
            hintText: 'Search recipes...',
            prefixIcon: const Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          style: const TextStyle(fontFamily: 'Montserrat'),
        ),
      ),
    );
  }
}