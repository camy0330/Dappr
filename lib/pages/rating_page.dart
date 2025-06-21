// Import necessary data, models, and providers for the RatingPage.
import 'package:dappr/data/ratings-data.dart'; // Imports predefined rating data.
import 'package:dappr/data/recipes_data.dart'; // Imports predefined recipe data.
import 'package:dappr/models/rating.dart'; // Imports the 'Rating' data model definition.
import 'package:dappr/models/recipe.dart'; // Imports the 'Recipe' data model definition.
import 'package:dappr/providers/rating_provider.dart'; // Imports the 'RatingProvider' for state management of ratings.
import 'package:flutter/material.dart'; // Imports the core Flutter Material Design library.
import 'package:provider/provider.dart'; // Imports the 'provider' package for state management.

/// A StatefulWidget that displays a list of recipes along with their ratings and allows users to add or edit reviews.
class RatingPage extends StatefulWidget {
  /// Constructor for RatingPage, taking an optional Key.
  const RatingPage({super.key});

  /// Creates the mutable state for this widget.
  @override
  State<RatingPage> createState() => _RatingPageState();
}

/// The private State class for RatingPage, managing its mutable properties.
class _RatingPageState extends State<RatingPage> {
  /// Generates a consistent random color for an avatar based on the username.
  ///
  /// The color is determined by the first character's ASCII value modulo the number of available colors.
  Color randomAvatarColor(String username) {
    /// A predefined list of colors for avatars.
    final colors = [
      Colors.deepOrange, // First color option.
      Colors.orange, // Second color option.
      Colors.orangeAccent, // Third color option.
      Colors.deepOrangeAccent, // Fourth color option.
      Colors.amber, // Fifth color option.
    ];
    // Returns a color from the list based on the username's first character.
    return colors[username.codeUnitAt(0) % colors.length];
  }

  /// Displays a dialog to allow users to add or edit a rating for a specific recipe.
  ///
  /// [context] is the BuildContext of the widget.
  /// [recipeId] is the unique identifier of the recipe being rated.
  /// [existingReview] is an optional Rating object for editing an existing review.
  void _showAddRatingDialog(BuildContext context, String recipeId,
      {Rating? existingReview}) {
    // Controller for the user name input field, pre-filled if editing.
    final userController =
        TextEditingController(text: existingReview?.userName ?? '');
    // Controller for the comment input field, pre-filled if editing.
    final commentController =
        TextEditingController(text: existingReview?.comment ?? '');
    // Initial rating value for the slider, defaulting to 3.0 if no existing review.
    double ratingValue = existingReview?.ratingValue ?? 3.0;

    /// Shows a Material Design dialog.
    showDialog(
      context: context, // The context for showing the dialog.
      builder: (context) {
        // StatefulBuilder allows rebuilding parts of the dialog.
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            // Sets the title of the dialog based on whether a review is being edited or added.
            title: Text(existingReview != null
                ? 'Edit Your Review'
                : 'Add Your Rating'),
            // Defines the content of the dialog as a vertical column.
            content: Column(
              mainAxisSize: MainAxisSize.min, // Constrains the column to its minimum size.
              children: [
                // Text field for user's name.
                TextField(
                  controller: userController, // Binds the controller to the text field.
                  readOnly: existingReview != null, // Makes the field read-only if editing an existing review.
                  decoration: const InputDecoration(labelText: 'Your Name'), // Label for the input field.
                ),
                // Text field for user's comment/review.
                TextField(
                  controller: commentController, // Binds the controller to the text field.
                  decoration: const InputDecoration(labelText: 'Your Review'), // Label for the input field.
                ),
                const SizedBox(height: 10), // Adds vertical spacing.
                // Row to display the rating slider and current rating value.
                Row(
                  children: [
                    const Text('Rating:'), // Static text label for rating.
                    // Expanded widget to allow the slider to fill available horizontal space.
                    Expanded(
                      child: Slider(
                        value: ratingValue, // Current value of the slider.
                        min: 1, // Minimum value of the slider.
                        max: 5, // Maximum value of the slider.
                        divisions: 4, // Number of discrete divisions for the slider (1, 2, 3, 4, 5).
                        label: ratingValue.toString(), // Label displayed on the thumb when sliding.
                        onChanged: (value) {
                          // Callback when the slider value changes.
                          setState(() {
                            ratingValue = value; // Updates the rating value, triggering a rebuild.
                          });
                        },
                      ),
                    ),
                    Text(ratingValue.toStringAsFixed(1)), // Displays the current rating value, formatted to one decimal place.
                  ],
                ),
              ],
            ),
            // Actions (buttons) at the bottom of the dialog.
            actions: [
              // Cancel button for the dialog.
              TextButton(
                onPressed: () => Navigator.pop(context), // Closes the dialog when pressed.
                child: const Text('Cancel'), // Text for the cancel button.
              ),
              // Submit/Update button for the dialog.
              ElevatedButton(
                onPressed: () {
                  // Checks if both user name and comment fields are not empty.
                  if (userController.text.isNotEmpty &&
                      commentController.text.isNotEmpty) {
                    // Retrieves the RatingProvider instance without listening for changes.
                    final provider =
                        Provider.of<RatingProvider>(context, listen: false);

                    // If editing an existing review.
                    if (existingReview != null) {
                      // Calls the provider to edit the existing rating.
                      provider.editRating(
                        recipeId: recipeId, // ID of the recipe.
                        userName: existingReview.userName, // Original user name.
                        newComment: commentController.text, // New comment from the text field.
                        newRating: ratingValue, // New rating value from the slider.
                      );
                    } else {
                      // If adding a new review.
                      provider.addRating(Rating(
                        userName: userController.text, // User name from the text field.
                        comment: commentController.text, // Comment from the text field.
                        ratingValue: ratingValue, // Rating value from the slider.
                        recipeId: recipeId, // ID of the recipe.
                      ));
                    }

                    Navigator.pop(context); // Closes the dialog after submission.
                    setState(() {}); // Triggers a rebuild of the StatefulBuilder to refresh UI (though not strictly necessary here, as provider handles rebuilds).
                  }
                },
                // Text for the button, either 'Update' or 'Submit'.
                child: Text(existingReview != null ? 'Update' : 'Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    // Determines if the current theme is dark mode.
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Defines the background color for review boxes based on theme.
    final Color reviewBoxColor = isDarkMode
        // ignore: deprecated_member_use // Ignore for using deprecated member (if applicable).
        ? Colors.orange.shade900.withOpacity(0.3) // Dark mode color.
        : Colors.orange.shade50; // Light mode color.
    // Defines the color for usernames based on theme.
    final Color userNameColor =
        isDarkMode ? Colors.orange.shade300 : Colors.deepOrange;
    // Defines the color for comment text based on theme.
    final Color commentTextColor =
        isDarkMode ? Colors.orange.shade100 : Colors.black87;

    // Retrieves user-added ratings from the RatingProvider.
    final userRatings = Provider.of<RatingProvider>(context).userRatings;
    // Combines all predefined ratings with user-added ratings.
    final List<Rating> allCombinedRatings = [...allRatings, ...userRatings];

    /// Returns a Scaffold, providing the basic visual structure for the page.
    return Scaffold(
      /// Defines the AppBar (header) of the page.
      appBar: AppBar(
        title: const Text("Recipe Reviews & Ratings"), // Sets the title text of the AppBar.
        /// Provides a flexible space behind the AppBar's title and actions.
        flexibleSpace: Container(
          /// Applies a decoration to the flexible space, in this case, a linear gradient.
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent], // Specifies the gradient colors.
              begin: Alignment.topLeft, // Sets the starting point of the gradient.
              end: Alignment.bottomRight, // Sets the ending point of the gradient.
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Sets the color of icons in the AppBar to white.
      ),
      /// The main content of the page, displayed as a scrollable list of recipes.
      body: ListView.builder(
        padding: const EdgeInsets.all(12), // Adds padding around the entire list.
        itemCount: recipes.length, // Sets the number of items in the list to the total number of recipes.
        itemBuilder: (context, index) {
          // Retrieves the current recipe based on the list index.
          final Recipe recipe = recipes[index];

          // Filters all combined ratings to get only reviews for the current recipe.
          final List<Rating> recipeReviews = allCombinedRatings
              .where((rating) => rating.recipeId == recipe.id)
              .toList();

          // Calculates the average rating for the current recipe.
          final double avgRating = recipeReviews.isNotEmpty
              ? recipeReviews
                      .map((r) => r.ratingValue) // Extracts rating values.
                      .reduce((a, b) => a + b) / // Sums up all rating values.
                  recipeReviews.length // Divides by the number of reviews to get average.
              : 0.0; // Defaults to 0.0 if no reviews exist.

          /// Returns a Card widget for each recipe, displaying its details and reviews.
          return Card(
            elevation: 6, // Adds a shadow effect to the card.
            margin: const EdgeInsets.symmetric(vertical: 10), // Sets vertical margin between cards.
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Defines rounded corners for the card.
            child: Padding(
              padding: const EdgeInsets.all(16), // Adds internal padding within the card.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left) of the column.
                children: [
                  // Row containing the recipe image and title/average rating.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the top of the row.
                    children: [
                      // Conditionally displays the recipe image if the URL is not empty.
                      if (recipe.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12), // Applies rounded corners to the image.
                          child: Image.asset(
                            recipe.imageUrl, // Loads the image from assets.
                            height: 90, // Sets the height of the image.
                            width: 90, // Sets the width of the image.
                            fit: BoxFit.cover, // Ensures the image covers its box.
                          ),
                        ),
                      const SizedBox(width: 14), // Adds horizontal spacing.
                      // Expanded column for recipe title and rating display.
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left).
                          children: [
                            // Displays the recipe title.
                            Text(
                              recipe.title, // The title of the recipe.
                              maxLines: 2, // Limits the title to two lines.
                              overflow: TextOverflow.ellipsis, // Truncates with ellipsis if it overflows.
                              style: const TextStyle(
                                fontSize: 18, // Sets font size.
                                fontWeight: FontWeight.bold, // Makes text bold.
                                color: Colors.deepOrange, // Sets text color.
                              ),
                            ),
                            const SizedBox(height: 8), // Adds vertical spacing.
                            // Container for displaying the average rating and star icons.
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 2), // Adds vertical margin.
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10), // Adds internal padding.
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    // ignore: deprecated_member_use // Ignore for deprecated member.
                                    ? Colors.orange.shade900.withOpacity(0.4) // Dark mode background.
                                    : Colors.orange.shade100, // Light mode background.
                                borderRadius: BorderRadius.circular(10), // Applies rounded corners.
                              ),
                              child: Row(
                                children: [
                                  // Displays the average rating text.
                                  Text(
                                    avgRating > 0
                                        ? avgRating.toStringAsFixed(1) // Formats average rating to one decimal place.
                                        : "No ratings", // Text if no ratings.
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, // Makes text bold.
                                      fontSize: 18, // Sets font size.
                                      color: isDarkMode
                                          ? Colors.orange.shade200 // Dark mode text color.
                                          : Colors.deepOrange, // Light mode text color.
                                    ),
                                  ),
                                  const SizedBox(width: 8), // Adds horizontal spacing.
                                  // Row to display star icons based on the average rating.
                                  Row(
                                    children: List.generate(5, (i) {
                                      // Generates 5 star icons.
                                      return Icon(
                                        i < avgRating.round() // Checks if the star should be filled or bordered.
                                            ? Icons.star // Filled star.
                                            : Icons.star_border, // Bordered star.
                                        color: Colors.orange, // Star color.
                                        size: 20, // Star size.
                                      );
                                    }),
                                  ),
                                  // Conditionally displays review count if reviews exist.
                                  if (recipeReviews.isNotEmpty) ...[
                                    const SizedBox(width: 8), // Adds horizontal spacing.
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 2), // Adds internal padding.
                                      decoration: BoxDecoration(
                                        color: Colors.deepOrange
                                            // ignore: deprecated_member_use // Ignore for deprecated member.
                                            .withOpacity(0.15), // Background color with opacity.
                                        borderRadius: BorderRadius.circular(8), // Applies rounded corners.
                                      ),
                                      // Displays the number of reviews.
                                      child: Text(
                                        "${recipeReviews.length} review${recipeReviews.length > 1 ? 's' : ''}", // Displays "review" or "reviews".
                                        style: TextStyle(
                                          fontSize: 12, // Sets font size.
                                          color: isDarkMode
                                              ? Colors.orange.shade200 // Dark mode text color.
                                              : Colors.deepOrange, // Light mode text color.
                                          fontWeight: FontWeight.w600, // Sets font weight.
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Adds vertical spacing.
                  // Aligns the "Add Review" button to the right.
                  Align(
                    alignment: Alignment.centerRight, // Aligns to the center right.
                    child: TextButton.icon(
                      icon: const Icon(Icons.rate_review,
                          color: Colors.deepOrange), // Icon for the button.
                      label: const Text(
                        "Add Review", // Text for the button.
                        style: TextStyle(color: Colors.deepOrange), // Text style.
                      ),
                      onPressed: () =>
                          _showAddRatingDialog(context, recipe.id), // Calls dialog on press.
                    ),
                  ),
                  const Text(
                    "Reviews:", // Heading for the reviews section.
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15), // Text style.
                  ),
                  const SizedBox(height: 4), // Adds vertical spacing.
                  // Conditionally displays "No reviews." or the list of reviews.
                  recipeReviews.isEmpty
                      ? const Text(
                          "No reviews.", // Message if no reviews.
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 13), // Text style.
                        )
                      : Column(
                          children: recipeReviews
                              .reversed // Displays most recent reviews first.
                              .map((review) => Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 3), // Adds vertical margin.
                                    decoration: BoxDecoration(
                                      color: reviewBoxColor, // Background color for the review box.
                                      borderRadius: BorderRadius.circular(8), // Applies rounded corners.
                                    ),
                                    child: ListTile(
                                      dense: true, // Makes the list tile smaller.
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2), // Adds padding to content.
                                      leading: CircleAvatar(
                                        radius: 14, // Radius of the circular avatar.
                                        backgroundColor:
                                            randomAvatarColor(review.userName), // Background color based on username.
                                        child: Text(
                                          review.userName[0].toUpperCase(), // Displays the first letter of the username.
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13), // Text style for the avatar letter.
                                        ),
                                      ),
                                      title: Text(
                                        review.userName, // Displays the username.
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, // Makes text bold.
                                          fontSize: 13, // Sets font size.
                                          color: userNameColor, // Text color based on theme.
                                        ),
                                      ),
                                      subtitle: Text(
                                        review.comment, // Displays the review comment.
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: commentTextColor), // Text style for the comment.
                                        maxLines: 2, // Limits comment to two lines.
                                        overflow: TextOverflow.ellipsis, // Truncates with ellipsis if overflows.
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min, // Shrinks row to minimum size.
                                        children: [
                                          // Conditionally displays an edit button if the review was user-added.
                                          if (userRatings.contains(review))
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  size: 16,
                                                  color: Colors.deepOrange), // Edit icon.
                                              tooltip: 'Edit Review', // Tooltip text.
                                              onPressed: () =>
                                                  _showAddRatingDialog(
                                                      context, recipe.id,
                                                      existingReview:
                                                          review), // Calls dialog to edit.
                                            ),
                                          // Row to display star rating for the individual review.
                                          Row(
                                            children:
                                                List.generate(5, (i) {
                                              // Generates 5 star icons.
                                              return Icon(
                                                i < review.ratingValue // Checks if star should be filled.
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                size: 13, // Star size.
                                                color: Colors.orange, // Star color.
                                              );
                                            }),
                                          ),
                                          const SizedBox(width: 3), // Adds horizontal spacing.
                                          // Displays the numerical rating for the individual review.
                                          Text(
                                            "${review.ratingValue}/5", // Rating value out of 5.
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold, // Makes text bold.
                                              fontSize: 12, // Sets font size.
                                              color: Colors.orange, // Text color.
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(), // Converts iterable to list of widgets.
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}