import 'package:dappr/data/ratings-data.dart';
import 'package:dappr/data/recipes_data.dart';
import 'package:dappr/models/rating.dart';
import 'package:dappr/models/recipe.dart';
import 'package:dappr/providers/rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
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

  void _showAddRatingDialog(BuildContext context, String recipeId,
      {Rating? existingReview}) {
    final userController =
        TextEditingController(text: existingReview?.userName ?? '');
    final commentController =
        TextEditingController(text: existingReview?.comment ?? '');
    double ratingValue = existingReview?.ratingValue ?? 3.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(existingReview != null
                ? 'Edit Your Review'
                : 'Add Your Rating'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: userController,
                  readOnly: existingReview != null,
                  decoration: const InputDecoration(labelText: 'Your Name'),
                ),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(labelText: 'Your Review'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Rating:'),
                    Expanded(
                      child: Slider(
                        value: ratingValue,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: ratingValue.toString(),
                        onChanged: (value) {
                          setState(() {
                            ratingValue = value;
                          });
                        },
                      ),
                    ),
                    Text(ratingValue.toStringAsFixed(1)),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (userController.text.isNotEmpty &&
                      commentController.text.isNotEmpty) {
                    final provider =
                        Provider.of<RatingProvider>(context, listen: false);

                    if (existingReview != null) {
                      provider.editRating(
                        recipeId: recipeId,
                        userName: existingReview.userName,
                        newComment: commentController.text,
                        newRating: ratingValue,
                      );
                    } else {
                      provider.addRating(Rating(
                        userName: userController.text,
                        comment: commentController.text,
                        ratingValue: ratingValue,
                        recipeId: recipeId,
                      ));
                    }

                    Navigator.pop(context);
                    setState(() {});
                  }
                },
                child: Text(existingReview != null ? 'Update' : 'Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color reviewBoxColor = isDarkMode
        // ignore: deprecated_member_use
        ? Colors.orange.shade900.withOpacity(0.3)
        : Colors.orange.shade50;
    final Color userNameColor =
        isDarkMode ? Colors.orange.shade300 : Colors.deepOrange;
    final Color commentTextColor =
        isDarkMode ? Colors.orange.shade100 : Colors.black87;

    final userRatings = Provider.of<RatingProvider>(context).userRatings;
    final List<Rating> allCombinedRatings = [...allRatings, ...userRatings];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Reviews & Ratings"),
         flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange, Colors.orangeAccent], // Gradient applied
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final Recipe recipe = recipes[index];

          final List<Rating> recipeReviews = allCombinedRatings
              .where((rating) => rating.recipeId == recipe.id)
              .toList();

          final double avgRating = recipeReviews.isNotEmpty
              ? recipeReviews
                      .map((r) => r.ratingValue)
                      .reduce((a, b) => a + b) /
                  recipeReviews.length
              : 0.0;

          return Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 2),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    // ignore: deprecated_member_use
                                    ? Colors.orange.shade900.withOpacity(0.4)
                                    : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    avgRating > 0
                                        ? avgRating.toStringAsFixed(1)
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
                                  if (recipeReviews.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.deepOrange
                                            // ignore: deprecated_member_use
                                            .withOpacity(0.15),
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: const Icon(Icons.rate_review,
                          color: Colors.deepOrange),
                      label: const Text(
                        "Add Review",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                      onPressed: () =>
                          _showAddRatingDialog(context, recipe.id),
                    ),
                  ),
                  const Text(
                    "Reviews:",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  recipeReviews.isEmpty
                      ? const Text(
                          "No reviews.",
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 13),
                        )
                      : Column(
                          children: recipeReviews
                              .reversed
                              .map((review) => Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    decoration: BoxDecoration(
                                      color: reviewBoxColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      dense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                      leading: CircleAvatar(
                                        radius: 14,
                                        backgroundColor:
                                            randomAvatarColor(review.userName),
                                        child: Text(
                                          review.userName[0].toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                      title: Text(
                                        review.userName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: userNameColor,
                                        ),
                                      ),
                                      subtitle: Text(
                                        review.comment,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: commentTextColor),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (userRatings.contains(review))
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  size: 16,
                                                  color: Colors.deepOrange),
                                              tooltip: 'Edit Review',
                                              onPressed: () =>
                                                  _showAddRatingDialog(
                                                      context, recipe.id,
                                                      existingReview: review),
                                            ),
                                          Row(
                                            children:
                                                List.generate(5, (i) {
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
