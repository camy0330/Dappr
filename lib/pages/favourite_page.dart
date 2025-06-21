// lib/pages/favourite_page.dart

// Imports the FavoriteProvider for state management of favorite recipes.
import 'package:dappr/providers/favorite_provider.dart';
// Imports the Flutter material design library for UI components.
import 'package:flutter/material.dart';
// Imports the provider package for simplified state management.
import 'package:provider/provider.dart';

// Imports the RecipeDetailPage, which is navigated to when a recipe card is tapped.
import 'recipe_detail_page.dart'; // Ensure this path is correct for your project

// You might need to import your recipe_data.dart if you are using static
// asset paths that are defined there. However, the Image.network/asset
// fallback should cover most cases.

/// ===========================================================================
/// HELPER DEFINITIONS FOR COMBINED SORT/FILTER MENU (from previous response)
/// ===========================================================================

/// Defines the types of actions available in the favorite recipes menu: sort or filter.
enum FavoriteMenuActionType { sort, filter }

/// A model class representing an item in the favorite recipes menu.
/// It combines the action type, its associated value, and the display label.
class FavoriteMenuItem {
  final FavoriteMenuActionType type;
  final dynamic value;
  final String label;

  /// Constructs a [FavoriteMenuItem] with a specified type, value, and label.
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
/// A stateless widget that displays the user's favorite recipes.
class FavouritePage extends StatelessWidget {
  /// Constructs a [FavouritePage].
  const FavouritePage({super.key});

  @override
  /// Builds the UI for the favorite recipes page.
  Widget build(BuildContext context) {
    // Consumes the FavoriteProvider to react to changes in favorite recipes.
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        // Retrieves the list of favorite recipes from the provider.
        final favoriteRecipes = favoriteProvider.favoriteRecipes;
        // Checks if there are any recipes marked as favorites (raw, before filtering).
        final bool hasAnyFavorites = favoriteProvider.hasRawFavorites;
        // Checks if any sorting or filtering is currently applied.
        final bool isFilteredOrSorted = favoriteProvider.currentSortType !=
                RecipeSortType.none ||
            favoriteProvider.currentFilterType != RecipeFilterType.none;

        // Determine text color based on theme brightness, exactly like your list page
        // Gets the current brightness mode of the theme (light/dark).
        final brightness = Theme.of(context).brightness;
        // Sets text color to white70 for dark theme and black87 for light theme.
        final Color textColor = brightness == Brightness.dark
            ? Colors.white70
            : Colors.black87;

        // Returns a Scaffold, providing the basic visual structure.
        return Scaffold(
          // Defines the app bar for the page.
          appBar: AppBar(
            // Sets the title of the app bar with a custom font and color.
            title: const Text(
              'Favorite Recipes',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
            ),
            // Sets the color for all icons in the app bar to white.
            iconTheme: const IconThemeData(color: Colors.white),
            // Defines the leading widget (back button) in the app bar.
            leading: IconButton(
              // Specifies the back arrow icon.
              icon: const Icon(Icons.arrow_back),
              // Defines the action when the back button is pressed: pop the current route.
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // Creates a flexible space for the app bar with a gradient background.
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  // Defines the colors for the gradient.
                  colors: [Colors.deepOrange, Colors.orangeAccent],
                  // Sets the gradient's starting point.
                  begin: Alignment.topLeft,
                  // Sets the gradient's ending point.
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Defines actions (buttons/menus) for the app bar.
            actions: [
              // Creates a PopupMenuButton for sort and filter options.
              PopupMenuButton<FavoriteMenuItem>(
                // Sets the icon for the popup menu button.
                icon: const Icon(Icons.filter_list, color: Colors.white),
                // Callback function when a menu item is selected.
                onSelected: (FavoriteMenuItem selectedItem) {
                  // Checks if the selected item is a sort action.
                  if (selectedItem.type == FavoriteMenuActionType.sort) {
                    // Sets the sort type in the FavoriteProvider.
                    favoriteProvider
                        .setSortType(selectedItem.value as RecipeSortType);
                  } else if (selectedItem.type == FavoriteMenuActionType.filter) {
                    // Sets the filter type in the FavoriteProvider.
                    favoriteProvider
                        .setFilterType(selectedItem.value as RecipeFilterType);
                  }
                },
                // Builds the list of menu items for the popup.
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<FavoriteMenuItem>>[
                  // Menu item for "Default Order" sorting.
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.none,
                      label: 'Default Order',
                    ),
                    child: const Text('Default Order'),
                  ),
                  // Menu item for "Title (A-Z)" sorting.
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.titleAsc,
                      label: 'Title (A-Z)',
                    ),
                    child: const Text('Title (A-Z)'),
                  ),
                  // Menu item for "Title (Z-A)" sorting.
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.titleDesc,
                      label: 'Title (Z-A)',
                    ),
                    child: const Text('Title (Z-A)'),
                  ),
                  // Menu item for "Prep Time (Shortest)" sorting.
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.prepTimeAsc,
                      label: 'Prep Time (Shortest)',
                    ),
                    child: const Text('Prep Time (Shortest)'),
                  ),
                  // Menu item for "Prep Time (Longest)" sorting.
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.prepTimeDesc,
                      label: 'Prep Time (Longest)',
                    ),
                    child: const Text('Prep Time (Longest)'),
                  ),
                  // Menu item for "Cook Time (Shortest)" sorting.
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.cookTimeAsc,
                      label: 'Cook Time (Shortest)',
                    ),
                    child: const Text('Cook Time (Shortest)'),
                  ),
                  // Menu item for "Cook Time (Longest)" sorting.
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.sort,
                      value: RecipeSortType.cookTimeDesc,
                      label: 'Cook Time (Longest)',
                    ),
                    child: const Text('Cook Time (Longest)'),
                  ),
                  // A visual divider in the popup menu.
                  const PopupMenuDivider(),
                  // Menu item for "Show All" filtering.
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.filter,
                      value: RecipeFilterType.none,
                      label: 'Show All',
                    ),
                    child: const Text('Show All'),
                  ),
                  // Menu item for "Prep Time < 30 Mins" filtering.
                  PopupMenuItem<FavoriteMenuItem>(
                    value: FavoriteMenuItem(
                      type: FavoriteMenuActionType.filter,
                      value: RecipeFilterType.lessThan30MinPrep,
                      label: 'Prep Time < 30 Mins',
                    ),
                    child: const Text('Prep Time < 30 Mins'),
                  ),
                  // Menu item for "Prep Time < 1 Hour" filtering.
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
          // Defines the body of the Scaffold.
          body: hasAnyFavorites // Checks if any recipes have ever been favorited.
              ? (favoriteRecipes.isEmpty // If there are raw favorites, check if the *filtered* list is empty.
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              // Displays a message if no recipes match current filter/sort criteria.
                              isFilteredOrSorted
                                  ? "No recipes match your current filter and sort criteria. Try adjusting them!"
                                  // Displays a message if no recipes are favorited (and no filters/sorts applied).
                                  : "You haven't added any recipes to your favorites yet. Tap the heart icon on a recipe to add it here!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                // Dynamically sets text color based on theme.
                                color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        )
                      : GridView.builder( // Displays favorite recipes in a grid.
                          // Adds padding around the grid.
                          padding: const EdgeInsets.all(8.0), // Match list page
                          // Defines the grid's layout properties.
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            // Sets the number of columns based on screen width.
                            crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3, // Match list page
                            // Sets horizontal spacing between grid items.
                            crossAxisSpacing: 10.0, // Match list page
                            // Sets vertical spacing between grid items.
                            mainAxisSpacing: 10.0, // Match list page
                            // Sets the aspect ratio of each grid item.
                            childAspectRatio: 0.8, // Match list page
                          ),
                          // Specifies the total number of items in the grid.
                          itemCount: favoriteRecipes.length,
                          // Builds each individual grid item.
                          itemBuilder: (context, index) {
                            // Retrieves the current recipe based on the index.
                            final recipe = favoriteRecipes[index];
                            // Checks if the current recipe is marked as a favorite.
                            final bool isFavorite = favoriteProvider.isFavorite(recipe.id);

                            // Returns a Card widget to display each recipe.
                            return Card(
                              // Sets the shadow elevation for the card.
                              elevation: 4, // Match list page
                              // Defines the shape of the card with rounded corners.
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)), // Match list page
                              // Clips the content to the card's rounded borders.
                              clipBehavior: Clip.antiAlias, // Match list page
                              // Allows the card to be tappable.
                              child: InkWell( // Match list page
                                // Defines the action when the card is tapped.
                                onTap: () {
                                  try {
                                    // Navigates to the RecipeDetailPage for the tapped recipe.
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RecipeDetailPage(recipe: recipe),
                                      ),
                                    );
                                  } catch (e) {
                                    // Displays a SnackBar if navigation fails.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Unable to open recipe.')),
                                    );
                                  }
                                },
                                // Arranges the card content in a vertical column.
                                child: Column(
                                  // Stretches children horizontally.
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Makes the image expandable within the column.
                                    Expanded( // Match list page
                                      child: ClipRRect(
                                        // Applies a top border radius to the image.
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(15)), // Match list page
                                        // Displays the recipe image from a network URL.
                                        child: Image.network( // Match list page
                                          recipe.imageUrl,
                                          // Fills the available space while maintaining aspect ratio.
                                          fit: BoxFit.cover,
                                          // Builder for error handling when loading image.
                                          errorBuilder: (context, error, stackTrace) {
                                            // Fallback to asset image if network image fails.
                                            return Image.asset(
                                              recipe.imageUrl,
                                              fit: BoxFit.cover,
                                              // Fallback to a grey container with a broken image icon if asset also fails.
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
                                    // Adds vertical spacing below the image.
                                    const SizedBox(height: 10), // Match list page
                                    // Padding for the recipe details.
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6), // Match list page
                                      // Row to display author avatar and text details.
                                      child: Row(
                                        children: [
                                          // Circular avatar for the recipe submitter.
                                          CircleAvatar( // Match list page
                                            radius: 16,
                                            backgroundColor: Colors.grey.shade300,
                                            child: Icon(Icons.person,
                                                color: Colors.grey.shade700, size: 20), // Match list page
                                          ),
                                          // Adds horizontal spacing between avatar and text.
                                          const SizedBox(width: 8), // Match list page
                                          // Expands the text content to fill remaining space.
                                          Expanded(
                                            child: Column(
                                              // Aligns text to the start.
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Displays the recipe submitter's name.
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
                                                // Displays the recipe title.
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
                                    // Padding for the recipe description.
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8), // Match list page
                                      // Displays the recipe description.
                                      child: Text(
                                        recipe.description,
                                        style: TextStyle(
                                          fontSize: 12, // Match list page
                                          // Dynamically sets description color based on theme.
                                          color: brightness == Brightness.dark
                                              ? Colors.grey[400]
                                              : Colors.grey, // Match list page
                                          fontFamily: 'Montserrat', // Match list page
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Aligns the favorite icon to the bottom right.
                                    Align( // Match list page
                                      alignment: Alignment.bottomRight,
                                      // IconButton for toggling favorite status.
                                      child: IconButton(
                                        // Changes icon based on favorite status.
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          // Sets icon color based on favorite status.
                                          color:
                                              isFavorite ? Colors.red : Colors.grey, // Match list page
                                          size: 28, // Match list page
                                        ),
                                        // Defines the action when the favorite icon is pressed.
                                        onPressed: () {
                                          try {
                                            // Toggles the favorite status of the recipe.
                                            favoriteProvider
                                                .toggleFavorite(recipe.id);
                                          } catch (e) {
                                            // Displays a SnackBar if updating favorite fails.
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
              : Center( // Displays this message if there are absolutely no favorite recipes saved.
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