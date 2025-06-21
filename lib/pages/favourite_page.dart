// lib/pages/favourite_page.dart

import 'package:dappr/providers/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'recipe_detail_page.dart'; // Ensure this path is correct for your project

// You might need to import your recipe_data.dart if you are using static
// asset paths that are defined there. However, the Image.network/asset
// fallback should cover most cases.

/// ===========================================================================
/// HELPER DEFINITIONS FOR COMBINED SORT/FILTER MENU (from previous response)
/// ===========================================================================

enum FavoriteMenuActionType { sort, filter }

class FavoriteMenuItem {
  final FavoriteMenuActionType type;
  final dynamic value;
  final String label;

  FavoriteMenuItem({
    required this.type,
    required this.value,
    required this.label,
  });
}

/// ===========================================================================
/// FavouritePage Class
/// This widget displays a grid of favorite recipes, mirroring the list page's
/// visual structure and behavior.
/// ===========================================================================
class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final favoriteRecipes = favoriteProvider.favoriteRecipes;
        final bool hasAnyFavorites = favoriteProvider.hasRawFavorites;
        final bool isFilteredOrSorted = favoriteProvider.currentSortType !=
                RecipeSortType.none ||
            favoriteProvider.currentFilterType != RecipeFilterType.none;

        // Determine text color based on theme brightness, exactly like your list page
        final brightness = Theme.of(context).brightness;
        final Color textColor = brightness == Brightness.dark
            ? Colors.white70
            : Colors.black87;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Favorite Recipes',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepOrange, Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            actions: [
              PopupMenuButton<FavoriteMenuItem>(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onSelected: (FavoriteMenuItem selectedItem) {
                  if (selectedItem.type == FavoriteMenuActionType.sort) {
                    favoriteProvider
                        .setSortType(selectedItem.value as RecipeSortType);
                  } else if (selectedItem.type == FavoriteMenuActionType.filter) {
                    favoriteProvider
                        .setFilterType(selectedItem.value as RecipeFilterType);
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<FavoriteMenuItem>>[
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.none,
                      label: 'Default Order',
                    ),
                    child: const Text('Default Order'),
                  ),
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.titleAsc,
                      label: 'Title (A-Z)',
                    ),
                    child: const Text('Title (A-Z)'),
                  ),
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.titleDesc,
                      label: 'Title (Z-A)',
                    ),
                    child: const Text('Title (Z-A)'),
                  ),
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.prepTimeAsc,
                      label: 'Prep Time (Shortest)',
                    ),
                    child: const Text('Prep Time (Shortest)'),
                  ),
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.prepTimeDesc,
                      label: 'Prep Time (Longest)',
                    ),
                    child: const Text('Prep Time (Longest)'),
                  ),
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.cookTimeAsc,
                      label: 'Cook Time (Shortest)',
                    ),
                    child: const Text('Cook Time (Shortest)'),
                  ),
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.cookTimeDesc,
                      label: 'Cook Time (Longest)',
                    ),
                    child: const Text('Cook Time (Longest)'),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.filter,
                      value: RecipeFilterType.none,
                      label: 'Show All',
                    ),
                    child: const Text('Show All'),
                  ),
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.filter,
                      value: RecipeFilterType.lessThan30MinPrep,
                      label: 'Prep Time < 30 Mins',
                    ),
                    child: const Text('Prep Time < 30 Mins'),
                  ),
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.filter,
                      value: RecipeFilterType.lessThan1HourPrep,
                      label: 'Prep Time < 1 Hour',
                    ),
                    child: const Text('Prep Time < 1 Hour'),
                  ),
                ],
              ),
            ],
          ),
          body: hasAnyFavorites
              ? (favoriteRecipes.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              isFilteredOrSorted
                                  ? "No recipes match your current filter and sort criteria. Try adjusting them!"
                                  : "You haven't added any recipes to your favorites yet. Tap the heart icon on a recipe to add it here!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(8.0), // Match list page
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3, // Match list page
                            crossAxisSpacing: 10.0, // Match list page
                            mainAxisSpacing: 10.0, // Match list page
                            childAspectRatio: 0.8, // Match list page
                          ),
                          itemCount: favoriteRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = favoriteRecipes[index];
                            final bool isFavorite = favoriteProvider.isFavorite(recipe.id);

                            return Card(
                              elevation: 4, // Match list page
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)), // Match list page
                              clipBehavior: Clip.antiAlias, // Match list page
                              child: InkWell( // Match list page
                                onTap: () {
                                  try {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RecipeDetailPage(recipe: recipe),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Unable to open recipe.')),
                                    );
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded( // Match list page
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(15)), // Match list page
                                        child: Image.network( // Match list page
                                          recipe.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            // Fallback for asset images, exactly like your list page
                                            return Image.asset(
                                              recipe.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[300],
                                                  child: const Icon(Icons.broken_image,
                                                      color: Colors.grey, size: 50),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10), // Match list page
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6), // Match list page
                                      child: Row(
                                        children: [
                                          CircleAvatar( // Match list page
                                            radius: 16,
                                            backgroundColor: Colors.grey.shade300,
                                            child: Icon(Icons.person,
                                                color: Colors.grey.shade700, size: 20), // Match list page
                                          ),
                                          const SizedBox(width: 8), // Match list page
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  recipe.submittedBy,
                                                  style: const TextStyle(
                                                    fontSize: 13, // Match list page
                                                    fontWeight: FontWeight.w600, // Match list page
                                                    fontFamily: 'Montserrat', // Match list page
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  recipe.title,
                                                  style: TextStyle(
                                                    fontSize: 15, // Match list page
                                                    fontWeight: FontWeight.bold, // Match list page
                                                    fontFamily: 'Montserrat', // Match list page
                                                    color: textColor, // Use theme-aware color
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8), // Match list page
                                      child: Text(
                                        recipe.description,
                                        style: TextStyle(
                                          fontSize: 12, // Match list page
                                          color: brightness == Brightness.dark
                                              ? Colors.grey[400]
                                              : Colors.grey, // Match list page
                                          fontFamily: 'Montserrat', // Match list page
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Align( // Match list page
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color:
                                              isFavorite ? Colors.red : Colors.grey, // Match list page
                                          size: 28, // Match list page
                                        ),
                                        onPressed: () {
                                          try {
                                            favoriteProvider
                                                .toggleFavorite(recipe.id);
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Failed to update favorite.')),
                                                );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ))
              : Center(
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