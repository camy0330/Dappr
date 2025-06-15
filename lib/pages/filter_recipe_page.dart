import 'package:flutter/material.dart';
import 'package:dappr/models/recipe.dart';

class RecipeFilterPage extends StatefulWidget {
  @override
  _RecipeFilterPageState createState() => _RecipeFilterPageState();
}

class _RecipeFilterPageState extends State<RecipeFilterPage> {
  String query = "";

  List<Recipe> get filteredRecipes {
    return recipes.where((recipe) {
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
      appBar: AppBar(title: Text('Recipe Filter')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
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
                  child: ListTile(
                    leading: Image.asset(recipe.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(recipe.title),
                    subtitle: Text('Prep: ${recipe.prepTime}, Cook: ${recipe.cookTime}'),
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
