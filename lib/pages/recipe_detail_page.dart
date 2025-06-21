// lib/pages/recipe_detail_page.dart
import 'package:dappr/models/recipe.dart'; // Imports the Recipe model definition.
import 'package:dappr/pages/recipe_puzzle_game.dart'; // Imports the RecipePuzzleGame page for navigation.
import 'package:dappr/providers/favorite_provider.dart'; // Imports the FavoriteProvider for state management of favorite recipes.
import 'package:flutter/material.dart'; // Imports the Flutter material design library.
import 'package:provider/provider.dart'; // Imports the Provider package for state management.

/// A StatelessWidget that displays the detailed information of a given recipe.
class RecipeDetailPage extends StatelessWidget {
  /// The recipe object containing all the details to be displayed.
  final Recipe recipe;

  /// Constructor for RecipeDetailPage.
  ///
  /// Requires a [recipe] object to display its details.
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Returns a Scaffold, which provides the basic visual structure for the page.
    return Scaffold(
      // Defines the app bar for the page.
      appBar: AppBar(
        // Sets the title of the app bar to the recipe's title.
        title: Text(recipe.title,
            style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white)), // Applies a custom font and color to the title.
        // Sets the theme for icons in the app bar.
        iconTheme:
            const IconThemeData(color: Colors.white), // Makes app bar icons white.
        // Provides a flexible space behind the app bar title and actions.
        flexibleSpace: Container(
          // Applies a decoration to the flexible space.
          decoration: const BoxDecoration(
            // Creates a linear gradient for the app bar background.
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent], // Specifies the gradient colors.
              begin: Alignment.topLeft, // Sets the start point of the gradient.
              end: Alignment.bottomRight, // Sets the end point of the gradient.
            ),
          ),
        ),

        // Defines a list of widgets to display in the app bar's actions section (typically on the right).
        actions: [
          // Uses Consumer to listen for changes in FavoriteProvider.
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              // Returns an IconButton for toggling the favorite status.
              return IconButton(
                // Sets the icon based on whether the recipe is a favorite.
                icon: Icon(
                  favoriteProvider.isFavorite(recipe.id)
                      ? Icons.favorite // Displays a filled heart if favorite.
                      : Icons.favorite_border, // Displays an outlined heart if not.
                  // Sets the color of the icon based on whether the recipe is a favorite.
                  color: favoriteProvider.isFavorite(recipe.id)
                      ? Colors.red // Red color for favorite.
                      : Colors.white, // White color otherwise.
                ),
                // Defines the action to perform when the button is pressed.
                onPressed: () {
                  // Toggles the favorite status of the current recipe.
                  favoriteProvider.toggleFavorite(recipe.id);
                  // Displays a SnackBar to provide feedback to the user.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      // Sets the content text of the SnackBar based on the favorite status.
                      content: Text(
                        favoriteProvider.isFavorite(recipe.id)
                            ? '${recipe.title} added to favorites!' // Message when added to favorites.
                            : '${recipe.title} removed from favorites!', // Message when removed from favorites.
                      ),
                      duration: const Duration(
                          seconds: 1), // SnackBar is visible for 1 second.
                      behavior: SnackBarBehavior
                          .floating, // Makes the SnackBar float above content.
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      // The main content of the page, allowing scrolling if content overflows.
      body: SingleChildScrollView(
        // Arranges children in a vertical column.
        child: Column(
          // Aligns children to the start (left) of the column.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wraps the image with Hero for a smooth animation transition.
            Hero(
              tag: 'recipe-image-${recipe.id}', // Unique tag for the hero animation, must match elsewhere.
              // Defines an aspect ratio for the image to maintain consistency.
              child: AspectRatio(
                aspectRatio: 16 / 9, // Sets the aspect ratio to 16:9.
                // Clips the image with rounded corners at the bottom.
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16.0)), // Applies bottom rounded corners.
                  // Conditionally displays an Image.network or a fallback container.
                  child: recipe.imageUrl.isNotEmpty
                      ? Image.network(
                          recipe.imageUrl, // Loads image from the network URL.
                          width: double.infinity, // Makes the image take full width.
                          fit: BoxFit.cover, // Covers the entire box, cropping if necessary.
                          // Provides an error builder for network image loading failures.
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Theme.of(context)
                                .hoverColor, // Uses theme color for consistency.
                            child: Center(
                              child: Icon(
                                Icons.broken_image, // Displays a broken image icon.
                                size: 80, // Sets the icon size.
                                color: Theme.of(context)
                                    .hintColor, // Uses theme hint color for the icon.
                              ),
                            ),
                          ),
                        )
                      : Container(
                          // Fallback container if imageUrl is empty.
                          color: Theme.of(context)
                              .hoverColor, // Uses theme hover color for background.
                          child: const Center(
                            child: Icon(Icons.fastfood,
                                size: 80,
                                color:
                                    Colors.deepOrange), // Displays a food icon.
                          ),
                        ),
                ),
              ),
            ),
            // Adds padding around the textual content.
            Padding(
              padding: const EdgeInsets.all(16.0), // Applies 16.0 padding on all sides.
              // Arranges textual content in a vertical column.
              child: Column(
                // Aligns children to the start (left) of the column.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Displays the recipe title.
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 24, // Sets font size.
                      fontWeight: FontWeight.bold, // Sets font weight to bold.
                      fontFamily: 'Montserrat', // Applies custom font.
                      color: Colors.deepOrange, // Sets text color.
                    ),
                  ),
                  const SizedBox(height: 8), // Adds vertical space.
                  // Displays the recipe description.
                  Text(
                    recipe.description,
                    style: TextStyle(
                      fontSize: 16, // Sets font size.
                      color: Colors.grey[700], // Sets text color.
                      fontFamily: 'Montserrat', // Applies custom font.
                    ),
                  ),
                  const SizedBox(height: 16), // Adds vertical space.
                  // Row for displaying prep and cook times.
                  Row(
                    children: [
                      const Icon(Icons.timer,
                          color: Colors.deepOrange, size: 20), // Timer icon.
                      const SizedBox(width: 4), // Adds horizontal space.
                      Text('Prep: ${recipe.prepTime}',
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16)), // Displays prep time.
                      const SizedBox(width: 16), // Adds horizontal space.
                      const Icon(Icons.watch_later,
                          color: Colors.deepOrange, size: 20), // Watch later icon.
                      const SizedBox(width: 4), // Adds horizontal space.
                      Text('Cook: ${recipe.cookTime}',
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16)), // Displays cook time.
                    ],
                  ),
                  const SizedBox(height: 16), // Adds vertical space.
                  // Title for the ingredients section.
                  const Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 18, // Sets font size.
                      fontWeight: FontWeight.bold, // Sets font weight to bold.
                      fontFamily: 'Montserrat', // Applies custom font.
                      color: Colors.deepOrange, // Sets text color.
                    ),
                  ),
                  const SizedBox(height: 8), // Adds vertical space.
                  // Column to display each ingredient.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start.
                    children: recipe.ingredients
                        .map((ingredient) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4.0), // Adds bottom padding to each ingredient.
                              child: Text('• $ingredient',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily:
                                          'Montserrat')), // Displays each ingredient with a bullet.
                            ))
                        .toList(), // Converts the mapped iterable to a list of widgets.
                  ),
                  const SizedBox(height: 16), // Adds vertical space.
                  // Title for the instructions section.
                  const Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 18, // Sets font size.
                      fontWeight: FontWeight.bold, // Sets font weight to bold.
                      fontFamily: 'Montserrat', // Applies custom font.
                      color: Colors.deepOrange, // Sets text color.
                    ),
                  ),
                  const SizedBox(height: 8), // Adds vertical space.
                  // Column to display each instruction step.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start.
                    children: recipe.steps
                        .asMap() // Converts the list of steps to a map with indices.
                        .entries // Gets a list of map entries (index and value).
                        .map((entry) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0), // Adds vertical padding to each step.
                              child: Text('${entry.key + 1}. ${entry.value}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily:
                                          'Montserrat')), // Displays each step with its number.
                            ))
                        .toList(), // Converts the mapped iterable to a list of widgets.
                  ),
                  const SizedBox(height: 24), // Adds vertical space before the button.
                  // Centers the puzzle game button horizontally.
                  Align(
                    alignment: Alignment.center, // Centers the child widget.
                    // An elevated button for navigating to the puzzle game.
                    child: ElevatedButton.icon(
                      icon: const Icon(
                          Icons.extension), // Icon for the puzzle game.
                      label: const Text('🧩 Play Puzzle Game'), // Text label for the button.
                      // Styles for the elevated button.
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.deepOrange, // Background color of the button.
                        foregroundColor:
                            Colors.white, // Text and icon color of the button.
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12), // Padding around the button's content.
                        textStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16), // Text style for the button's label.
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Rounded corners for the button.
                        ),
                      ),
                      // Action to perform when the button is pressed.
                      onPressed: () {
                        // Navigates to the RecipePuzzleGame page.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipePuzzleGame(
                              recipe:
                                  recipe, // Passes the current recipe to the puzzle game.
                              useSteps:
                                  true, // Specifies to use steps for the puzzle (can be false for ingredients).
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}