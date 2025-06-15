import 'package:flutter/material.dart';
import 'package:dappr/models/recipe.dart';

class RecipeFilterPage extends StatefulWidget {
  @override
  _RecipeFilterPageState createState() => _RecipeFilterPageState();
}

class _RecipeFilterPageState extends State<RecipeFilterPage> {
  String searchQuery = '';
  List<String> selectedIngredients = [];
  String? selectedCategory;

  // Get all unique ingredients
  List<String> get allIngredients {
    final Set<String> ingredientsSet = {};
    for (var recipe in recipes) {
      ingredientsSet.addAll(recipe.ingredients.map((e) => e.toLowerCase()));
    }
    return ingredientsSet.toList()..sort();
  }

  // Get all unique categories
  List<String> get allCategories {
    final Set<String> categorySet = {};
    for (var recipe in recipes) {
      if (recipe.category.isNotEmpty) {
        categorySet.add(recipe.category);
      }
    }
    return categorySet.toList()..sort();
  }

  // Filtered recipe list
  List<Recipe> get filteredRecipes {
    return recipes.where((recipe) {
      final matchesSearch = searchQuery.isEmpty ||
          recipe.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          recipe.ingredients.any((ingredient) =>
              ingredient.toLowerCase().contains(searchQuery.toLowerCase()));

      final matchesIngredients = selectedIngredients.isEmpty ||
          selectedIngredients.every((selected) =>
              recipe.ingredients.any((ingredient) =>
                  ingredient.toLowerCase().contains(selected)));

      final matchesCategory = selectedCategory == null ||
          recipe.category.toLowerCase() == selectedCategory!.toLowerCase();

      return matchesSearch && matchesIngredients && matchesCategory;
    }).toList();
  }

  // UI Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filter Recipes')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🔍 Text Search
            TextField(
              decoration: InputDecoration(
                labelText: 'Search recipes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 10),

            // ✅ Ingredient Multi-select
            ExpansionTile(
              title: Text('Filter by Ingredients'),
              children: allIngredients.map((ingredient) {
                final isSelected = selectedIngredients.contains(ingredient);
                return CheckboxListTile(
                  title: Text(ingredient),
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedIngredients.add(ingredient);
                      } else {
                        selectedIngredients.remove(ingredient);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            // 🍽 Category Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Filter by Category',
                border: OutlineInputBorder(),
              ),
              value: selectedCategory,
              hint: Text('Choose a category'),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              items: allCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            SizedBox(height: 10),

            // 🧾 Filtered Recipe List
            Expanded(
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(recipe.imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(recipe.title),
                      subtitle: Text(
                          'Category: ${recipe.category}, Prep: ${recipe.prepTime}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
