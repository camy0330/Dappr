import 'package:dappr/data/ratings-data.dart'; // Make sure this file exists and is correctly structured
import 'package:dappr/data/recipes_data.dart'; // Make sure this file exists and is correctly structured
import 'package:dappr/models/rating.dart';
import 'package:dappr/models/recipe.dart'; // Make sure Recipe model has an 'id' field
import 'package:dappr/providers/rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Main page for viewing and adding ratings/reviews for all recipes
class RatingPage extends StatefulWidget {
  const RatingPage({super.key});
  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  // Generate a consistent avatar color based on username
  Color randomAvatarColor(String username) {
    final colors = [
      Colors.deepOrange,
      Colors.orange,
      Colors.orangeAccent,
      Colors.deepOrangeAccent,
      Colors.amber,
    ];
    return colors[username.codeUnitAt(0) % colors.length];
  }

  // Show dialog for user to add a rating for a recipe
  void _showAddRatingDialog(BuildContext context, String recipeId) {
    final userController = TextEditingController();
    final commentController = TextEditingController();
    double ratingValue = 3.0; // Initial rating value

    showDialog(
      context: context,
      builder: (context) {
        // Use StatefulBuilder to allow dialog to update its own state (e.g., slider value)
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Add Your Rating'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // User name input
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(labelText: 'Your Name'),
                ),
                // Review comment input
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(labelText: 'Your Review'),
                  maxLines: 3, // Allow multiple lines for comments
                ),
                const SizedBox(height: 10),
                // Star rating slider
                Row(
                  children: [
                    const Text('Rating:'),
                    Expanded(
                      child: Slider(
                        value: ratingValue,
                        min: 1, // Minimum rating
                        max: 5, // Maximum rating
                        divisions: 4, // Allows values 1.0, 2.0, 3.0, 4.0, 5.0
                        label: ratingValue.toString(), // Shows current value above thumb
                        onChanged: (value) {
                          setState(() { // Update dialog's local state
                            ratingValue = value;
                          });
                        },
                      ),
                    ),
                    Text(ratingValue.toStringAsFixed(1)), // Display rating with one decimal place
                  ],
                ),
              ],
            ),
            actions: [
              // Cancel button
              TextButton(
                onPressed: () => Navigator.pop(context), // Close dialog without saving
                child: const Text('Cancel'),
              ),
              // Submit button
              ElevatedButton(
                onPressed: () {
                  // Only submit if both user name and comment fields are filled
                  if (userController.text.isNotEmpty &&
                      commentController.text.isNotEmpty) {
                    Provider.of<RatingProvider>(context, listen: false).addRating(
                      Rating(
                        userName: userController.text,
                        comment: commentController.text,
                        ratingValue: ratingValue,
                        recipeId: recipeId, // Pass the recipeId to the Rating object
                      ),
                    );
                    Navigator.pop(context); // Close the dialog
                    // No need for setState(() {}); here as Provider will notify listeners
                    // and rebuild the parent widget automatically.
                  } else {
                    // Optionally, show a snackbar or message if fields are empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your name and review.')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Detect dark mode for adaptive colors
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colors that adapt based on theme mode - FIX: Replaced withOpacity
    final Color reviewBoxColor = isDarkMode
        ? Colors.orange.shade900.withAlpha((255 * 0.3).round()) // Fix deprecated withOpacity
        : Colors.orange.shade50;
    final Color userNameColor =
        isDarkMode ? Colors.orange.shade300 : Colors.deepOrange;
    final Color commentTextColor =
        isDarkMode ? Colors.orange.shade100 : Colors.black87;

    // Combine static ratings (from ratings-data.dart) and user ratings from provider
    final userRatings = Provider.of<RatingProvider>(context).userRatings;
    // Assuming 'allRatings' is defined in ratings-data.dart.
    // Ensure `recipe.id` exists and is consistent for filtering.
    final List<Rating> allCombinedRatings = [...allRatings, ...userRatings];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Reviews & Ratings"),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: recipes.length, // Assuming 'recipes' is available (e.g., from recipes_data.dart)
        itemBuilder: (context, index) {
          final Recipe recipe = recipes[index];
          
          // Filter reviews for this specific recipe from combined ratings
          final List<Rating> recipeReviews = allCombinedRatings
              .where((rating) => rating.recipeId == recipe.id) // IMPORTANT: Recipe model needs an 'id' field
              .toList();
          
          // Calculate average rating for this recipe
          final double avgRating = recipeReviews.isNotEmpty
              ? recipeReviews
                  .map((r) => r.ratingValue)
                  .reduce((a, b) => a + b) /
                  recipeReviews.length
              : 0.0; // Default to 0.0 if no reviews

          return Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row for image and recipe info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe image (assuming it's a local asset for Image.asset)
                      // If it's a network image, use Image.network and provide a fallback.
                      if (recipe.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          // Consider using Image.network if paths are URLs,
                          // or ensure 'assets/images/' is correctly configured in pubspec.yaml
                          child: Image.network( // Changed from Image.asset to Image.network
                            recipe.imageUrl,
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 90,
                                height: 90,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      const SizedBox(width: 14),
                      // Recipe title and rating info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Recipe title
                            Text(
                              recipe.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Overall rating box
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                // Fix deprecated withOpacity
                                color: isDarkMode
                                    ? Colors.orange.shade900.withAlpha((255 * 0.4).round())
                                    : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Average rating number or "No ratings"
                                  Text(
                                    avgRating > 0
                                        ? "${avgRating.toStringAsFixed(1)}"
                                        : "No ratings",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: isDarkMode
                                          ? Colors.orange.shade200
                                          : Colors.deepOrange,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Star icons for average rating
                                  Row(
                                    children: List.generate(5, (i) {
                                      return Icon(
                                        i < avgRating.round()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.orange,
                                        size: 20,
                                      );
                                    }),
                                  ),
                                  // Show review count if there are reviews
                                  if (recipeReviews.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        // Fix deprecated withOpacity
                                        color: Colors.deepOrange.withAlpha((255 * 0.15).round()),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${recipeReviews.length} review${recipeReviews.length > 1 ? 's' : ''}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkMode
                                              ? Colors.orange.shade200
                                              : Colors.deepOrange,
                                          fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 10),
                  // Add Review Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: const Icon(Icons.rate_review, color: Colors.deepOrange),
                      label: const Text(
                        "Add Review",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                      onPressed: () => _showAddRatingDialog(context, recipe.id), // Pass recipe.id
                    ),
                  ),
                  // Reviews section title
                  const Text(
                    "Reviews:",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  // Show reviews or "No reviews" text
                  recipeReviews.isEmpty
                      ? const Text(
                          "No reviews.",
                          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                        )
                      : Column(
                          children: recipeReviews
                              .reversed // Show latest reviews first
                              .map((review) => Container(
                                    margin: const EdgeInsets.symmetric(vertical: 3),
                                    decoration: BoxDecoration(
                                      color: reviewBoxColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      // User avatar
                                      leading: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: randomAvatarColor(review.userName),
                                        child: Text(
                                          review.userName[0].toUpperCase(),
                                          style: const TextStyle(color: Colors.white, fontSize: 13),
                                        ),
                                      ),
                                      // User name
                                      title: Text(
                                        review.userName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: userNameColor,
                                        ),
                                      ),
                                      // Review comment
                                      subtitle: Text(
                                        review.comment,
                                        style: TextStyle(
                                            fontSize: 12, color: commentTextColor),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // Star rating and value
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: List.generate(5, (i) {
                                              return Icon(
                                                i < review.ratingValue
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                size: 13,
                                                color: Colors.orange,
                                              );
                                            }),
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            "${review.ratingValue}/5",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
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
