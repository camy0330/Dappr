// pages/filter_recipe_page.dart

import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/my_search_bar.dart'; // your custom search bar
import '../data/recipes_data.dart'; // your recipe list

class RecipeFilterPage extends StatefulWidget {
  final List<Recipe> recipes;

  const RecipeFilterPage({super.key, required this.recipes});

  @override
  State<RecipeFilterPage> createState() => _RecipeFilterPageState();
}

class _RecipeFilterPageState extends State<RecipeFilterPage> {
  List<Recipe> filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    filteredRecipes = widget.recipes;
  }

  void handleSearch(String input) {
    final keywords = input
        .split(' ')
        .where((word) => word.isNotEmpty && !word.startsWith('#'))
        .toList();

    final hashtags = input
        .split(' ')
        .where((word) => word.startsWith('#'))
        .map((h) => h.toLowerCase())
        .toList();

    setState(() {
      filteredRecipes = widget.recipes.where((recipe) {
        final hasKeywords = keywords.every((kw) =>
            recipe.title.toLowerCase().contains(kw.toLowerCase()) ||
            recipe.description.toLowerCase().contains(kw.toLowerCase()));

        final hasHashtags = hashtags.every((tag) =>
            recipe.hashtags.map((h) => h.toLowerCase()).contains(tag));

        return hasKeywords && hasHashtags;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Recipes')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          MySearchBar(onSearch: handleSearch),
          const SizedBox(height: 16),
          Expanded(
            child: filteredRecipes.isEmpty
                ? const Center(child: Text("No recipes found."))
                : ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return Card(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Image.asset(
                            recipe.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(recipe.title),
                          subtitle: Text(recipe.description),
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
