// lib/pages/recipe_detail_page.dart
import 'package:dappr/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title, style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with ClipRRect and error handling
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16.0)),
              child: Image.asset(
                recipe.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported,
                            size: 60, color: Colors.grey),
                      ),
                    ),
              ),
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
                      color: Colors.deepOrange,
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
                      Text('Prep: ${recipe.prepTime}', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16)),
                      const SizedBox(width: 16),
                      const Icon(Icons.watch_later, color: Colors.deepOrange, size: 20),
                      const SizedBox(width: 4),
                      Text('Cook: ${recipe.cookTime}', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.deepOrange,
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
                    'Instructions:', // Display header for instructions
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Use recipe.steps and format them as numbered steps
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recipe.steps // <--- CHANGED FROM recipe.instructions TO recipe.steps
                        .asMap() // Use asMap to get index for numbering
                        .entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text('${entry.key + 1}. ${entry.value}', style: const TextStyle(fontSize: 16, fontFamily: 'Montserrat')),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
