// lib/widgets/search_bar.dart
<<<<<<< Updated upstream
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
=======
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget { // <--- Class name is now MySearchBar
  final Function(String) onSearch; // Add this line back for the onSearch callback

  const MySearchBar({super.key, required this.onSearch}); // Add required onSearch

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            // Before: color: Colors.deepOrange.withOpacity(0.15),
            color: const Color.fromARGB(38, 255, 87, 34), // (255 * 0.15).round() = 38
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // IMPORTANT: You need to add a TextField inside this Container
      // to actually have a search bar functionality.
      child: TextField(
        onChanged: onSearch, // Pass the callback
        decoration: InputDecoration(
          hintText: 'Search recipes...',
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none, // No border needed since Container has one
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
>>>>>>> Stashed changes
        ),
        style: const TextStyle(fontFamily: 'Montserrat'),
      ),
    );
  }
}