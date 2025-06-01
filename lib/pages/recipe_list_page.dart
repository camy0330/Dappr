// lib/pages/recipe_list_page.dart
import 'package:flutter/material.dart'; // Place 'dart:' imports before others
import 'package:dappr/data/recipes_data.dart';
import 'package:dappr/models/recipe.dart';
import 'package:dappr/widgets/search_bar.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  String _searchQuery = '';
  List<Recipe> _filteredRecipes = [];
  Set<String> _favoriteRecipeIds = {}; // Set to store IDs of favorite recipes

  @override
  void initState() {
    super.initState();
    _filteredRecipes = recipes; // Initialize with all recipes
    // In a real app, load _favoriteRecipeIds from persistent storage here
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredRecipes = recipes;
      } else {
        _filteredRecipes = recipes
            .where((recipe) =>
                recipe.title.toLowerCase().contains(query.toLowerCase()) ||
                recipe.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleFavorite(String recipeId) {
    setState(() {
      if (_favoriteRecipeIds.contains(recipeId)) {
        _favoriteRecipeIds.remove(recipeId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Removed from favorites', style: TextStyle(fontFamily: 'Montserrat')),
              duration: Duration(seconds: 1)),
        );
      } else {
        _favoriteRecipeIds.add(recipeId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Added to favorites', style: TextStyle(fontFamily: 'Montserrat')),
              duration: Duration(seconds: 1)),
        );
      }
    });
    // In a real app, save _favoriteRecipeIds to persistent storage here
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          // Cursor at edge: Adjusted padding for the search bar
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: MySearchBar(onSearch: _onSearchChanged),
        ),
        Expanded(
          child: _filteredRecipes.isEmpty
              ? const Center(
                  child: Text(
                    'No recipes found. Try a different search.',
                    style: TextStyle(fontSize: 18, fontFamily: 'Montserrat'),
                    textAlign: TextAlign.center,
                  ),
                )
              : GridView.builder( // Changed to GridView.builder for square layout
                  padding: const EdgeInsets.all(8.0), // Padding around the grid
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 10.0, // Spacing between rows
                    childAspectRatio: 0.8, // Aspect ratio to make cards more square/taller
                  ),
                  itemCount: _filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _filteredRecipes[index];
                    final bool isFavorite = _favoriteRecipeIds.contains(recipe.id);

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      clipBehavior: Clip.antiAlias, // Clip children to the card's shape
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tapped on ${recipe.title}',
                                  style: const TextStyle(fontFamily: 'Montserrat')),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                          // TODO: Implement navigation to RecipeDetailPage
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => RecipeDetailPage(recipe: recipe),
                          //   ),
                          // );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
                          children: [
                            // Image at the top, occupying available width
                            Expanded( // Use Expanded to give image remaining vertical space
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                child: Image.asset(
                                  recipe.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image, color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0), // Padding for text content
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.title,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                    maxLines: 1, // Limit title to one line
                                    overflow: TextOverflow.ellipsis, // Add ellipsis if too long
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    recipe.description,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Montserrat'),
                                    maxLines: 2, // Limit description to two lines
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // Favorite Button at the bottom right
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                  size: 28,
                                ),
                                onPressed: () => _toggleFavorite(recipe.id),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}