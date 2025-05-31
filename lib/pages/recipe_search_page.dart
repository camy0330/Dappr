import 'package:flutter/material.dart';
import '../Data/recipes_data.dart';
// ignore: unused_import
import '../models/recipe.dart';
import 'recipe_detail_page.dart';

// ...existing code...
class RecipeSearchPage extends StatefulWidget {
  const RecipeSearchPage({super.key});

  @override
  State<RecipeSearchPage> createState() => _RecipeSearchPageState();
}



class _RecipeSearchPageState extends State<RecipeSearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = recipes.where((recipe) {
      return recipe.title.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Resipi'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari resipi...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredRecipes.isEmpty
                ? const Center(child: Text('Tiada resipi dijumpai.'))
                : ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(recipe.imageUrl),
                        ),
                        title: Text(recipe.title),
                        subtitle: Text(recipe.description, maxLines: 1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
