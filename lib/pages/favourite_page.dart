// lib/pages/favourite_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// IMPORTANT: Ensure this import is present and correct to access FavoriteProvider and its enums
import 'package:dappr/providers/favorite_provider.dart'; 

import 'recipe_detail_page.dart'; // Import your recipe detail page

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Consumer to react to changes in FavoriteProvider and rebuild the UI
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        // The list of favorite recipes, already filtered and sorted by the provider
        final favoriteRecipes = favoriteProvider.favoriteRecipes; 
        
        // Check if there are ANY favorite recipes stored at all (raw count)
        final bool hasAnyFavorites = favoriteProvider.hasRawFavorites; 
        
        // Check if any filter or sort is currently active
        final bool isFilteredOrSorted = favoriteProvider.currentSortType != RecipeSortType.none || favoriteProvider.currentFilterType != RecipeFilterType.none;

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
            // Actions for Sorting and Filtering in the AppBar
            actions: [
              // Sort Button
              PopupMenuButton<RecipeSortType>(
                icon: const Icon(Icons.sort, color: Colors.white),
                onSelected: (RecipeSortType selectedType) {
                  favoriteProvider.setSortType(selectedType); // Update sort type
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<RecipeSortType>>[
                  const PopupMenuItem<RecipeSortType>(
                    value: RecipeSortType.none,
                    child: Text('Default Order'),
                  ),
                  const PopupMenuItem<RecipeSortType>(
                    value: RecipeSortType.titleAsc,
                    child: Text('Title (A-Z)'),
                  ),
                  const PopupMenuItem<RecipeSortType>(
                    value: RecipeSortType.titleDesc,
                    child: Text('Title (Z-A)'),
                  ),
                  const PopupMenuItem<RecipeSortType>(
                    value: RecipeSortType.prepTimeAsc,
                    child: Text('Prep Time (Shortest)'),
                  ),
                  const PopupMenuItem<RecipeSortType>(
                    value: RecipeSortType.prepTimeDesc,
                    child: Text('Prep Time (Longest)'),
                  ),
                  const PopupMenuItem<RecipeSortType>(
                    value: RecipeSortType.cookTimeAsc,
                    child: Text('Cook Time (Shortest)'),
                  ),
                  const PopupMenuItem<RecipeSortType>(
                    value: RecipeSortType.cookTimeDesc,
                    child: Text('Cook Time (Longest)'),
                  ),
                ],
              ),
              // Filter Button
              PopupMenuButton<RecipeFilterType>(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onSelected: (RecipeFilterType selectedType) {
                  favoriteProvider.setFilterType(selectedType); // Update filter type
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<RecipeFilterType>>[
                  const PopupMenuItem<RecipeFilterType>(
                    value: RecipeFilterType.none,
                    child: Text('Show All'),
                  ),
                  const PopupMenuItem<RecipeFilterType>(
                    value: RecipeFilterType.lessThan30MinPrep,
                    child: Text('Prep Time < 30 Mins'),
                  ),
                  const PopupMenuItem<RecipeFilterType>(
                    value: RecipeFilterType.lessThan1HourPrep,
                    child: Text('Prep Time < 1 Hour'),
                  ),
                  // Add more filter menu items here if you define more filter types
                ],
              ),
            ],
          ),
          body: hasAnyFavorites // If there are ANY favorites stored in the app
              ? (favoriteRecipes.isEmpty // But the currently filtered/sorted list is empty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          isFilteredOrSorted // Message changes if filters/sort are active
                              ? "No recipes match your current filter and sort criteria. Try adjusting them!"
                              : "This should not happen: No favorite recipes found with no active filters/sort.", // Fallback, ideally not seen
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    )
                  : GridView.builder( // Display the grid of filtered/sorted favorites
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
                            // Navigate to Recipe Detail Page when a card is tapped
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
                                    child: Hero(
                                      tag: 'recipe-image-${recipe.id}', // Hero animation tag
                                      child: recipe.imageUrl.isNotEmpty
                                          ? Image.network(
                                              recipe.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Container( // Fallback for image loading errors
                                                    color: Theme.of(context).hoverColor,
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 60,
                                                      color: Theme.of(context).hintColor,
                                                    ),
                                                  ),
                                            )
                                          : Container( // Fallback if no image URL
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
                                              favoriteProvider.isFavorite(recipe.id) // Check favorite status
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: favoriteProvider.isFavorite(recipe.id)
                                                  ? Colors.red
                                                  : Theme.of(context).hintColor,
                                            ),
                                            onPressed: () {
                                              favoriteProvider.toggleFavorite(recipe.id); // Toggle favorite on tap
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
                    ))
              : Center( // If no favorites are stored at all
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "No favorite recipes yet! Tap the heart icon on a recipe to add it here.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}