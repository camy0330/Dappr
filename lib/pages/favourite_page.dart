// lib/pages/favourite_page.dart

// Important: This import makes the FavoriteProvider class and its associated
// enums (RecipeSortType, RecipeFilterType) accessible within this file.
import 'package:dappr/providers/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'recipe_detail_page.dart'; // Import for navigating to recipe details.

/// ===========================================================================
/// HELPER DEFINITIONS FOR COMBINED SORT/FILTER MENU
/// These classes and enums are specifically designed to enable a single
/// dropdown menu button to handle both sorting and filtering options.
/// They are defined locally within this file as their usage is confined here.
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
    // When `notifyListeners()` is called in `FavoriteProvider`, this builder
    // function will re-execute, updating the UI with the latest data.
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        // Retrieve the list of favorite recipes, which is already
        // filtered and sorted according to the provider's current state.
        final favoriteRecipes = favoriteProvider.favoriteRecipes; 
        
        // Checks if there are any recipes marked as favorite at all,
        // regardless of current filters. Used to determine initial empty state.
        final bool hasAnyFavorites = favoriteProvider.hasRawFavorites; 
        
        // Checks if any sorting or filtering is currently active.
        // Used to provide a specific message when the filtered list is empty.
        final bool isFilteredOrSorted = favoriteProvider.currentSortType != RecipeSortType.none || favoriteProvider.currentFilterType != RecipeFilterType.none;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Favorite Recipes',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
            ),
            backgroundColor: Colors.deepOrange,
            iconTheme: const IconThemeData(color: Colors.white), // Ensures icons are white
            leading: IconButton(
              icon: const Icon(Icons.arrow_back), // Back button for navigation
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // Actions list for the AppBar. Contains only one button for combined functionality.
            actions: [
              // [PopupMenuButton] provides a dropdown menu for sorting and filtering options.
              PopupMenuButton<FavoriteMenuItem>(
                icon: const Icon(Icons.filter_list, color: Colors.white), // A single filter icon representing both functions.
                onSelected: (FavoriteMenuItem selectedItem) {
                  // This callback is triggered when a menu item is selected.
                  // It determines whether the selected item is a sort or filter action
                  // and calls the appropriate method on the FavoriteProvider.
                  if (selectedItem.type == FavoriteMenuActionType.sort) {
                    // Cast `selectedItem.value` to `RecipeSortType` as it's a sort action.
                    favoriteProvider.setSortType(selectedItem.value as RecipeSortType);
                  } else if (selectedItem.type == FavoriteMenuActionType.filter) {
                    // Cast `selectedItem.value` to `RecipeFilterType` as it's a filter action.
                    favoriteProvider.setFilterType(selectedItem.value as RecipeFilterType);
                  }
                },
                // [itemBuilder] constructs the list of menu items displayed in the dropdown.
                itemBuilder: (BuildContext context) => <PopupMenuEntry<FavoriteMenuItem>>[
                  // --- SORTING OPTIONS ---
                  // Each PopupMenuItem is an instance of [FavoriteMenuItem]
                  // categorizing it as a sort action and providing its specific sort type.
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

                  const PopupMenuDivider(), // A visual separator to distinguish sorting from filtering options.

                  // --- FILTERING OPTIONS ---
                  // Each PopupMenuItem here is an instance of [FavoriteMenuItem]
                  // categorizing it as a filter action and providing its specific filter type.
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
                  // Add more filter menu items here if new filter types are defined in `RecipeFilterType`.
                ],
              ),
            ],
          ),
          // Conditional body content based on the availability of favorite recipes.
          body: hasAnyFavorites 
              ? (favoriteRecipes.isEmpty // If there are favorites, but the filtered/sorted list is empty.
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          isFilteredOrSorted // Message tailored if filters/sorts are active.
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
                  : GridView.builder( // Displays the favorite recipes in a grid layout.
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250.0, // Maximum width of each grid item.
                        crossAxisSpacing: 16.0,     // Horizontal spacing between items.
                        mainAxisSpacing: 16.0,      // Vertical spacing between items.
                        childAspectRatio: 0.65,     // Aspect ratio of each item (width / height).
                      ),
                      itemCount: favoriteRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = favoriteRecipes[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigates to the [RecipeDetailPage] when a recipe card is tapped.
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
                                      tag: 'recipe-image-${recipe.id}', // Unique tag for Hero animation.
                                      child: recipe.imageUrl.isNotEmpty
                                          ? Image.network(
                                              recipe.imageUrl,
                                              fit: BoxFit.cover,
                                              // Error builder for network images.
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
                                          : Container( // Placeholder if image URL is empty.
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
                                        const Spacer(), // Pushes the IconButton to the bottom-right.
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: IconButton(
                                            icon: Icon(
                                              favoriteProvider.isFavorite(recipe.id) // Checks current favorite status.
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: favoriteProvider.isFavorite(recipe.id)
                                                  ? Colors.red
                                                  : Theme.of(context).hintColor,
                                            ),
                                            onPressed: () {
                                              favoriteProvider.toggleFavorite(recipe.id); // Toggles favorite status on tap.
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
              : Center( // Displays this message if no recipes have ever been favorited.
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