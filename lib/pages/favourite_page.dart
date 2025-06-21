// lib/pages/favourite_page.dart

import 'package:dappr/providers/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'recipe_detail_page.dart';

/// Defines the category of action for a menu item: either a sorting action
/// or a filtering action. This helps in distinguishing selection logic.
enum FavoriteMenuActionType { sort, filter }

/// A custom data structure to represent a single item in the combined
/// sort/filter dropdown menu. Each item carries its type (sort/filter),
/// the actual enum value (e.g., RecipeSortType.titleAsc), and the
/// display label for the menu item.
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

        // --- Responsive Grid Size Calculation ---
        // Define a target aspect ratio for your cards (width / height).
        // A value of 0.65 means height is ~1.54 times the width, making it portrait.
        // If you want more square-like cards, increase this value closer to 1.0.
        // If you want even taller cards, decrease it.
        const double targetAspectRatio = 0.65; // Your desired aspect ratio (width / height)

        // Define the maximum width a card should take.
        // This helps in preventing items from becoming too wide on large screens.
        const double maxCardWidth = 250.0; // Keep your original max width


        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Favorite Recipes',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
            ),
            iconTheme:
                const IconThemeData(color: Colors.white), // Ensures icons are white
            leading: IconButton(
              icon: const Icon(Icons.arrow_back), // Back button for navigation
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepOrange,
                    Colors.orangeAccent
                  ], // Your desired gradient colors
                  begin: Alignment.topLeft, // Start of the gradient (adjust as needed)
                  end: Alignment.bottomRight, // End of the gradient (adjust as needed)
                ),
              ),
            ),
            actions: [
              PopupMenuButton<FavoriteMenuItem>(
                icon: const Icon(Icons.filter_list,
                    color:
                        Colors.white), // A single filter icon representing both functions.
                onSelected: (FavoriteMenuItem selectedItem) {
                  if (selectedItem.type == FavoriteMenuActionType.sort) {
                    favoriteProvider
                        .setSortType(selectedItem.value as RecipeSortType);
                  } else if (selectedItem.type ==
                      FavoriteMenuActionType.filter) {
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
                              : "This should not happen: No favorite recipes found with no active filters/sort.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color ??
                                Colors.grey,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: maxCardWidth, // Max width of each grid item
                        crossAxisSpacing: 16.0, // Horizontal spacing
                        mainAxisSpacing: 16.0, // Vertical spacing
                        childAspectRatio:
                            targetAspectRatio, // Use the fixed target aspect ratio
                      ),
                      itemCount: favoriteRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = favoriteRecipes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailPage(recipe: recipe),
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
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(15.0)),
                                    child: Hero(
                                      tag: 'recipe-image-${recipe.id}',
                                      child: recipe.imageUrl.isNotEmpty
                                          ? Image.network(
                                              recipe.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) =>
                                                      Container(
                                                color: Theme.of(context)
                                                    .hoverColor,
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 60,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              color: Theme.of(context)
                                                  .hoverColor,
                                              child: const Icon(Icons.fastfood,
                                                  size: 60,
                                                  color: Colors.deepOrange),
                                            ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
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
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
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
                                              favoriteProvider
                                                      .isFavorite(recipe.id)
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: favoriteProvider
                                                      .isFavorite(recipe.id)
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .hintColor,
                                            ),
                                            onPressed: () {
                                              favoriteProvider
                                                  .toggleFavorite(recipe.id);
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
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "No favorite recipes yet! Tap the heart icon on a recipe to add it here.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Colors.grey,
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