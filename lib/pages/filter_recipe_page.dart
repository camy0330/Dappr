// lib/pages/filter_recipe_page.dart
// Import your Recipe model
import 'package:dappr/models/recipe.dart';
// You likely don't need recipe_list_page.dart here unless you're navigating to it directly from this file.
// If it contains the 'recipes' list, that list should be moved to data/recipe_data.dart instead.
// import 'package:dappr/pages/recipe_list_page.dart'; // Consider removing this if not used for navigation
import 'package:flutter/material.dart';

// This is the main StatefulWidget for your Recipe Filter Page.
class RecipeFilterPage extends StatefulWidget {
  // 1. Declare a final variable to hold the list of recipes
  final List<Recipe> recipes;

  // 2. Add a constructor to require the recipes list
  const RecipeFilterPage({Key? key, required this.recipes}) : super(key: key);

  @override
  _RecipeFilterPageState createState() => _RecipeFilterPageState();
}

// PART 2: RECIPE FILTER PAGE WIDGET (UI and Filtering Logic)
class _RecipeFilterPageState extends State<RecipeFilterPage> {
  String query = ""; // Stores the current search query from the TextField

  // THIS IS THE CORE FILTERING LOGIC
  List<Recipe> get filteredRecipes {
    // 3. Access the recipes list using 'widget.recipes'
    return widget.recipes.where((recipe) {
      final titleMatch = recipe.title.toLowerCase().contains(query.toLowerCase());
      final ingredientMatch = recipe.ingredients.any(
        (ingredient) => ingredient.toLowerCase().contains(query.toLowerCase()),
      );
      return titleMatch || ingredientMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Filter')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by title or ingredient',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        recipe.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      recipe.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Prep: ${recipe.prepTime}, Cook: ${recipe.cookTime}\nSubmitted by: ${recipe.submittedBy}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on ${recipe.title}')),
                      );
                    },
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