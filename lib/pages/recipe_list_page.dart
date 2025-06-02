// lib/pages/recipe_list_page.dart
<<<<<<< Updated upstream
import 'package:dappr/data/recipes_data.dart';
import 'package:dappr/models/recipe.dart';
import 'package:dappr/pages/recipe_detail_page.dart'; 
import 'package:dappr/providers/favorite_provider.dart';
import 'package:dappr/widgets/search_bar.dart'; // Corrected import for search_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
=======
import 'package:flutter/material.dart';
import 'package:dappr/models/recipe.dart';
import 'package:dappr/data/recipes_data.dart'; // Ensure this path is correct
import 'package:dappr/widgets/search_bar.dart'; // IMPORTANT: Import MySearchBar here
>>>>>>> Stashed changes

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
<<<<<<< Updated upstream
  // ignore: unused_field
  String _searchQuery = ''; // This line is causing the warning
=======
  String _searchQuery = ''; // This field is used now, so the warning should disappear
>>>>>>> Stashed changes
  List<Recipe> _filteredRecipes = [];

  @override
  void initState() {
    super.initState();
<<<<<<< Updated upstream
    _filteredRecipes = recipes;
=======
    _filteredRecipes = recipes; // Initialize with all recipes
>>>>>>> Stashed changes
  }

  void _onSearchChanged(String query) {
    setState(() {
<<<<<<< Updated upstream
      _searchQuery = query; // Retaining _searchQuery as it impacts _filteredRecipes
=======
      _searchQuery = query; // Now used here, so the unused_field warning is resolved
>>>>>>> Stashed changes
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

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: MySearchBar(onSearch: _onSearchChanged), // Ensure MySearchBar is used, not CustomSearchBar
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
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _filteredRecipes[index];
                    final bool isFavorite = favoriteProvider.isFavorite(recipe.id);

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
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
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.title,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    recipe.description,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Montserrat'),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                  size: 28,
                                ),
                                onPressed: () {
                                  favoriteProvider.toggleFavorite(recipe.id);
                                },
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
=======
    return Scaffold(
      appBar: AppBar( // Add an AppBar if you want a title and potentially a back button
        title: const Text('Recipes', style: TextStyle(fontFamily: 'Montserrat')),
        backgroundColor: Colors.deepOrange, // Example color, match your theme
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            // FIX: Use 'MySearchBar' here to match the class name in search_bar.dart
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
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8.0),
                    itemCount: _filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _filteredRecipes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () {
                            // TODO: Navigate to Recipe Detail Page
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tapped on ${recipe.title}',
                                    style: const TextStyle(fontFamily: 'Montserrat')),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                            // Example navigation to RecipeDetailPage
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => RecipeDetailPage(recipe: recipe),
                            //   ),
                            // );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    recipe.imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image, color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.title,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        recipe.description,
                                        style: const TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Montserrat'),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
>>>>>>> Stashed changes
    );
  }
}