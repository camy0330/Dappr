import 'package:dappr/data/recipes_data.dart';
import 'package:dappr/models/recipe.dart';
import 'package:dappr/pages/recipe_detail_page.dart';
import 'package:dappr/providers/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  List<Recipe> _filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _filteredRecipes = recipes;
  }

  // Filter recipes based on search query
  void _onSearchChanged(String query) {
    setState(() {
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
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final brightness = Theme.of(context).brightness;

    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            // Header with gradient background and search bar
            Container(
              height: 160,
              child: Stack(
                children: [
                  // Gradient background for header
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrange.shade700,
                          Colors.deepOrange.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Header content: title and search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What would you like to cook today?',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: textColor,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        // Search bar with white translucent background
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            onChanged: _onSearchChanged,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Search recipes...',
                              hintStyle: TextStyle(color: Colors.grey[700]),
                              border: InputBorder.none,
                              icon: Icon(Icons.search, color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Recipe grid or empty state
            Expanded(
              child: _filteredRecipes.isEmpty
                  // Show message if no recipes found
                  ? Center(
                      child: Text(
                        'No recipes found. Try a different search.',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  // Show recipes in a grid
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
                              // Navigate to recipe detail page
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
                                // Recipe image
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius:
                                        const BorderRadius.vertical(top: Radius.circular(15)),
                                    child: Image.asset(
                                      recipe.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image,
                                              color: Colors.grey, size: 50),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // Recipe title and description
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat',
                                          color: brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        recipe.description,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: brightness == Brightness.dark
                                              ? Colors.grey[400]
                                              : Colors.grey,
                                          fontFamily: 'Montserrat',
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                // Favorite button at the bottom right
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : Colors.grey,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      // Toggle favorite status
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
        ),
      ),
    );
  }
}
