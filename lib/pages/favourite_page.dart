// lib/pages/favourite_page.dart
import 'package:dappr/providers/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'recipe_detail_page.dart'; // Import your recipe detail page

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Recipes',
          style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          final favoriteRecipes = favoriteProvider.favoriteRecipes;

          if (favoriteRecipes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "No favorite recipes yet! Tap the heart icon on a recipe to add it here.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color != null
                        ? Color.fromARGB(
                            (Theme.of(context).textTheme.bodyMedium!.color!.a * 255.0).round().clamp(0, 255),
                            (Theme.of(context).textTheme.bodyMedium!.color!.r * 255.0).round().clamp(0, 255),
                            (Theme.of(context).textTheme.bodyMedium!.color!.g * 255.0).round().clamp(0, 255),
                            (Theme.of(context).textTheme.bodyMedium!.color!.b * 255.0).round().clamp(0, 255),
                          )
                        : Colors.grey,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250.0,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.65,
              ),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(recipe: recipe),
                      ),
                    );
                  },
                  child: Card(
                    color: Theme.of(context).cardColor,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                            // Wrap the image with Hero
                            child: Hero(
                              tag: 'recipe-image-${recipe.id}', // Unique tag for each recipe
                              child: recipe.imageUrl.isNotEmpty
                                  ? Image.network(
                                      recipe.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                            color: Theme.of(context).hoverColor,
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 60,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                    )
                                  : Container(
                                      color: Theme.of(context).hoverColor,
                                      child: const Icon(Icons.fastfood, size: 60, color: Colors.deepOrange),
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    fontFamily: 'Montserrat',
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Prep: ${recipe.prepTime} | Cook: ${recipe.cookTime}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontFamily: 'Montserrat',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: Icon(
                                      favoriteProvider.isFavorite(recipe.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: favoriteProvider.isFavorite(recipe.id)
                                          ? Colors.red
                                          : Theme.of(context).hintColor,
                                    ),
                                    onPressed: () {
                                      favoriteProvider.toggleFavorite(recipe.id);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
