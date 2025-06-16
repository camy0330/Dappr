import 'package:flutter/material.dart';
import '../data/recipes_data.dart';
import '../models/recipe.dart';

class RecipeFilterPage extends StatefulWidget {
  @override
  _RecipeFilterPageState createState() => _RecipeFilterPageState();
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
    List<Recipe> filteredRecipes = recipes.where((recipe) {
      final matchesSearch = recipe.title.toLowerCase().contains(searchText.toLowerCase());
      final matchesTags = selectedHashtags.every((tag) => recipe.hashtags.contains(tag));
      return matchesSearch && matchesTags;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Filter Recipes')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            // 🔍 Text Search
            TextField(
              decoration: InputDecoration(labelText: 'Search by name...'),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            SizedBox(height: 10),

            // ✅ Filter Chips
            Wrap(
              spacing: 8.0,
              children: allHashtags.map((tag) {
                final isSelected = selectedHashtags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selected
                          ? selectedHashtags.add(tag)
                          : selectedHashtags.remove(tag);
                    });
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 10),

            // 🍽 Filtered List
            Expanded(
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(
                        recipe.imageUrl,
                        width: 50,
                        height: 50,
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
