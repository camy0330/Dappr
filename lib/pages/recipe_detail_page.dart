// lib/pages/recipe_detail_page.dart
<<<<<<< Updated upstream
import 'package:dappr/models/recipe.dart';
import 'package:flutter/material.dart';
=======
import 'package:flutter/material.dart';
import '../models/recipe.dart'; // Correct import path
>>>>>>> Stashed changes

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< Updated upstream
        title: Text(recipe.title, style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              recipe.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: TextStyle( 
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.deepOrange, size: 20),
                      const SizedBox(width: 4),
                      Text('Prep: ${recipe.prepTime}', style: const TextStyle(fontFamily: 'Montserrat')),
                      const SizedBox(width: 16),
                      const Icon(Icons.watch_later, color: Colors.deepOrange, size: 20),
                      const SizedBox(width: 4),
                      Text('Cook: ${recipe.cookTime}', style: const TextStyle(fontFamily: 'Montserrat')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recipe.ingredients
                        .map((ingredient) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text('• $ingredient', style: const TextStyle(fontSize: 16, fontFamily: 'Montserrat')),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.instructions, // This is the corrected line
                    style: const TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                  ),
                ],
              ),
            ),
=======
        title: Text(recipe.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white), // For the back button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset( // Use Image.asset
                recipe.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported,
                          size: 60, color: Colors.grey),
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              recipe.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recipe.description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ingredients:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients
                  .map((ingredient) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('• $ingredient', style: const TextStyle(fontSize: 16)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Steps:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.steps
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('${entry.key + 1}. ${entry.value}', style: const TextStyle(fontSize: 16)),
                      ))
                  .toList(),
            ),
>>>>>>> Stashed changes
          ],
        ),
      ),
    );
  }
}