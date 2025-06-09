import 'package:flutter/material.dart';
import 'package:dappr/data/recipes_data.dart';
import 'package:dappr/data/ratings-data.dart';
import 'package:dappr/models/recipe.dart';
import 'package:dappr/models/rating.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colors that adapt based on theme mode
    final Color reviewBoxColor = isDarkMode
        ? Colors.orange.shade900.withOpacity(0.3)
        : Colors.orange.shade50;

    final Color userNameColor =
        isDarkMode ? Colors.orange.shade300 : Colors.deepOrange;

    final Color commentTextColor =
        isDarkMode ? Colors.orange.shade100 : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Reviews & Ratings"),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final Recipe recipe = recipes[index];

          // Filter reviews for this recipe
          final List<Rating> recipeReviews = allRatings
              .where((rating) => rating.recipeId == recipe.id)
              .toList();

          // Calculate average rating for this recipe
          final double avgRating = recipeReviews.isNotEmpty
              ? recipeReviews
                      .map((r) => r.ratingValue)
                      .reduce((a, b) => a + b) /
                  recipeReviews.length
              : 0.0;

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
                      // Recipe image
                      if (recipe.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            recipe.imageUrl,
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
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
                                color: isDarkMode
                                    ? Colors.orange.shade900.withOpacity(0.4)
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
                                        color: Colors.deepOrange.withOpacity(0.15),
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
                              .take(2) // Show only up to 2 reviews
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