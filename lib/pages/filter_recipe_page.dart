import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeFilterPage extends StatefulWidget {
  final List<Recipe> recipes;

  const RecipeFilterPage({Key? key, required this.recipes}) : super(key: key);

  @override
  State<RecipeFilterPage> createState() => _RecipeFilterPageState();
}

class _RecipeFilterPageState extends State<RecipeFilterPage> {
  String searchText = '';

  List<String> get keywords =>
      searchText.split(' ').where((w) => w.isNotEmpty && !w.startsWith('#')).toList();

  List<String> get hashtags =>
      searchText.split(' ').where((w) => w.startsWith('#')).toList();

  @override
  Widget build(BuildContext context) {
    List<Recipe> filteredRecipes = widget.recipes.where((recipe) {
      final textMatch = keywords.every((kw) =>
          recipe.title.toLowerCase().contains(kw.toLowerCase()) ||
          recipe.description.toLowerCase().contains(kw.toLowerCase()));

      final tagMatch = hashtags.every((tag) =>
          recipe.hashtags.map((h) => h.toLowerCase()).contains(tag.toLowerCase()));

      return textMatch && tagMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Filter Recipes')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🔍 Combined Search + Hashtag input
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search with keywords or #hashtags',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            const SizedBox(height: 12),

            // 🍽 Filtered Recipes List
            Expanded(
              child: filteredRecipes.isEmpty
                  ? const Center(child: Text("No matching recipes."))
                  : ListView.builder(
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
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
      ),
    );
  }
}
