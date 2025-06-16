// lib/models/recipe.dart
class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final String prepTime; // e.g., "30 mins", "1 hour"
  final String cookTime; // e.g., "20 mins", "45 mins"
  final List<String> steps;
  final List<String> hashtags;
  final String submittedBy; // New field for recipe origin/user

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.prepTime,
    required this.cookTime,
    required this.steps,
    this.hashtags = const [],
    required this.submittedBy, // Add to constructor
  });

  // --- NEW: Helper getters for numerical time values ---
  int get prepTimeInMinutes {
    return _parseTime(prepTime);
  }

  int get cookTimeInMinutes {
    return _parseTime(cookTime);
  }

  // Helper method to parse time strings like "30 mins" or "1 hour" into minutes
  int _parseTime(String timeString) {
    final parts = timeString.split(' ');
    if (parts.isNotEmpty) {
      try {
        int value = int.parse(parts[0]);
        // Check if the time unit is "hour" (case-insensitive)
        if (timeString.toLowerCase().contains('hour')) {
          return value * 60; // Convert hours to minutes
        }
        return value; // Assume minutes if "hour" is not present
      } catch (e) {
        // Handle parsing errors (e.g., if the string isn't a number)
        // You might want to log this error for debugging
        print('Error parsing time string "$timeString": $e');
        return 0; // Return 0 or a sensible default in case of error
      }
    }
    return 0; // Default if the string is empty or invalid format
  }
  // --- END NEW HELPERS ---

  // You'll also need a toJson() method if you plan to save Recipe objects directly
  // to SharedPreferences as JSON strings (not just IDs).
  // If you only save IDs and reconstruct the Recipe objects from `recipes_data.dart`,
  // then toJson() might not be strictly necessary for the FavoriteProvider itself.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'steps': steps,
      'submittedBy': submittedBy,
    };
  }

  // And a fromJson() factory constructor if you load Recipe objects directly
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      ingredients: List<String>.from(json['ingredients'] as List),
      prepTime: json['prepTime'] as String,
      cookTime: json['cookTime'] as String,
      steps: List<String>.from(json['steps'] as List),
      submittedBy: json['submittedBy'] as String,
    );
  }
}
