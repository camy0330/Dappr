// lib/pages/favourite_page.dart

import 'package:dappr/providers/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'recipe_detail_page.dart'; // Import for navigating to recipe details.

/// ===========================================================================
/// HELPER DEFINITIONS FOR COMBINED SORT/FILTER MENU
/// These classes and enums are specifically designed to enable a single
/// dropdown menu button to handle both sorting and filtering options.
/// Their usage is confined to this file.
/// ===========================================================================

/// Defines the category of action for a menu item: either a sorting action
/// or a filtering action. This helps in distinguishing selection logic.
enum FavoriteMenuActionType { sort, filter }

/// A custom data structure to represent a single item in the combined
/// sort/filter dropdown menu. Each item carries its type (sort/filter),
/// the actual enum value (e.g., RecipeSortType.titleAsc), and the
/// display label for the menu item.
class FavoriteMenuItem {
  final FavoriteMenuActionType type; // Specifies if it's a sort or filter option.
  final dynamic value; // Holds the specific RecipeSortType or RecipeFilterType enum value.
  final String label; // The text string displayed in the menu.

  /// Constructor for [FavoriteMenuItem].
  FavoriteMenuItem({
    required this.type,
    required this.value,
    required this.label,
  });
}

/// ===========================================================================
/// FavouritePage Class
/// This widget displays a grid of favorite recipes. It interacts with the
/// [FavoriteProvider] to fetch the list of recipes and to allow users to
/// sort, filter, and toggle favorite status. It uses the [Consumer] widget
/// from the `provider` package to efficiently rebuild only when the
/// [FavoriteProvider]'s state changes.
/// ===========================================================================
class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    // [Consumer<FavoriteProvider>] listens for changes in [FavoriteProvider].
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final favoriteRecipes = favoriteProvider.favoriteRecipes;
        final bool hasAnyFavorites = favoriteProvider.hasRawFavorites;
        final bool isFilteredOrSorted = favoriteProvider.currentSortType !=
                RecipeSortType.none ||
            favoriteProvider.currentFilterType != RecipeFilterType.none;

        // --- Responsive Grid Size Calculation Parameters ---
        // Define the maximum width an individual card should take.
        const double maxCardWidth = 250.0;
        // Define the ideal height for the content area (below the image)
        // This is an estimated height for the text content and favorite button.
        // Increased this value to provide more vertical space for text and icon,
        // resolving the "Bottom overflowed" error.
        const double contentHeightEstimate = 160.0;

        // Calculate a dynamic childAspectRatio to make cards fit better
        // This takes into account the image's 3/4 ratio and the text content's 1/4 ratio
        // Let's assume the image width will be maxCardWidth for this calculation.
        // Image height for a square image with maxCardWidth = maxCardWidth.
        // So, total estimated height = maxCardWidth (image) + contentHeightEstimate.
        // childAspectRatio = Card Width / Total Card Height = maxCardWidth / (maxCardWidth + contentHeightEstimate)
        final double calculatedChildAspectRatio =
            maxCardWidth / (maxCardWidth + contentHeightEstimate);


        return Scaffold(
          // Corrected the typo here: appAppar -> appBar
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
                  colors: [
                    Colors.deepOrange,
                    Colors.orangeAccent
                  ],
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
                              : "This should not happen: No favorite recipes found with no active filters/sort.",
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
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: maxCardWidth,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: calculatedChildAspectRatio,
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
                            color: Theme.of(context).colorScheme.surface,
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
                                              child: const Icon(Icons.fastfood,
                                                  size: 60,
                                                  color: Colors.deepOrange),
                                            ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              size: 16,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                recipe.submittedBy,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                  fontFamily: 'Montserrat',
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),

                                        Text(
                                          recipe.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Theme.of(context).colorScheme.onSurface,
                                            fontFamily: 'Montserrat',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),

                                        Text(
                                          recipe.description,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                                            fontFamily: 'Montserrat',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),

                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(
                                              favoriteProvider.isFavorite(recipe.id)
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: favoriteProvider.isFavorite(recipe.id)
                                                  ? Colors.red
                                                  : Theme.of(context).colorScheme.onSurface,
                                              size: 24,
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