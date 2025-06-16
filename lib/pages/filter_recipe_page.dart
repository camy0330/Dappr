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
  List<String> selectedHashtags = [];

  final List<String> allHashtags = [
    '#breakfast',
    '#lunch',
    '#dinner',
    '#drink',
    '#rice',
    '#spicy',
  ];

  @override
  Widget build(BuildContext context) {
    List<Recipe> filteredRecipes = widget.recipes.where((recipe) {
      final matchesSearch = recipe.title.toLowerCase().contains(searchText.toLowerCase());
      final matchesTags = selectedHashtags.every((tag) => recipe.hashtags.contains(tag));
      return matchesSearch && matchesTags;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🔍 Text Search
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search recipe...',
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

            // ✅ Hashtag Filters
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: allHashtags.map((tag) {
                final isSelected = selectedHashtags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedHashtags.add(tag);
                      } else {
                        selectedHashtags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 🍽 Filtered Recipes List
            Expanded(
              child: filteredRecipes.isEmpty
                  ? const Center(child: Text("No recipes match your filters."))
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
                            onTap: () {
                              // TODO: Navigate to detail page if needed
                            },
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
