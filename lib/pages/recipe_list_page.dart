// lib/pages/recipe_list_page.dart
import 'package:flutter/material.dart';
import 'package:dappr/models/recipe.dart';
import 'package:dappr/data/recipes_data.dart';
// import 'package:dappr/widgets/search_bar.dart'; // Commented out MySearchBar import

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  String _searchQuery = '';
  List<Recipe> _filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _filteredRecipes = recipes;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Recipes', style: TextStyle(fontFamily: 'Montserrat')),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            // MySearchBar is disabled, so nothing shown here
            // You can add a simple placeholder if you want, e.g.:
            // child: Text('Search bar disabled'),
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
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tapped on ${recipe.title}',
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat')),
                                duration: const Duration(seconds: 1),
                              ),
                            );
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
                                        child: const Icon(Icons.broken_image,
                                            color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'Montserrat'),
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
    );
  }
}
