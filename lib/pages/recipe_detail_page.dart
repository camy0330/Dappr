// lib/pages/recipe_detail_page.dart
import 'package:dappr/models/recipe.dart';
import 'package:dappr/providers/favorite_provider.dart'; // Import your FavoriteProvider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:dappr/pages/recipe_puzzle_game.dart'; // 👈 import your puzzle game page


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
        // Add favorite button to the AppBar actions
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              return IconButton(
                icon: Icon(
                  favoriteProvider.isFavorite(recipe.id)
                      ? Icons.favorite // Filled heart if favorite
                      : Icons.favorite_border, // Bordered heart if not
                  color: favoriteProvider.isFavorite(recipe.id)
                      ? Colors.red // Red for favorite
                      : Colors.white, // White otherwise
                ),
                onPressed: () {
                  favoriteProvider.toggleFavorite(recipe.id);
                  // Provide user feedback using a SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        favoriteProvider.isFavorite(recipe.id)
                            ? '${recipe.title} added to favorites!'
                            : '${recipe.title} removed from favorites!',
                      ),
                      duration: const Duration(seconds: 1), // SnackBar visible for 1 second
                      behavior: SnackBarBehavior.floating, // Makes it float above content
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrap the image with Hero for the animation
            Hero(
              tag: 'recipe-image-${recipe.id}', // Must match the tag from FavouritePage
              child: AspectRatio(
                aspectRatio: 16 / 9, // Konsisten untuk semua gambar
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16.0)),
                  // Changed from Image.asset to Image.network
                  // This assumes recipe.imageUrl is a network URL
                  child: recipe.imageUrl.isNotEmpty
                      ? Image.network(
                          recipe.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover, // Gambar selalu penuh dan seragam
                          // Enhanced errorBuilder for network images
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Theme.of(context).hoverColor, // Use theme color for consistency
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image, // More descriptive icon
                                    size: 80,
                                    color: Theme.of(context).hintColor, // Use theme color
                                  ),
                                ),
                              ),
                        )
                      : Container( // Fallback if imageUrl is empty
                          color: Theme.of(context).hoverColor,
                          child: const Center(
                            child: Icon(Icons.fastfood, size: 80, color: Colors.deepOrange),
                          ),
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
                    'Instructions:',
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
                    children: recipe.steps
                        .asMap()
                        .entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text('${entry.key + 1}. ${entry.value}', style: const TextStyle(fontSize: 16, fontFamily: 'Montserrat')),
                            ))
                        .toList(),
                  ),
                  // The new puzzle game button
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.extension),
                    label: const Text('🧩 Play Puzzle Game'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipePuzzleGame(
                            recipe: recipe, // This uses your current recipe
                            useSteps: true, // Change to false if you want ingredient puzzle
                          ),
                        ),
                      );
                    },
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