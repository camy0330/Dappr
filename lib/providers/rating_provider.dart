// lib/providers/rating_provider.dart
import 'dart:convert'; // For encoding/decoding JSON

import 'package:dappr/models/rating.dart'; // Import your Rating model (ensure it has toJson/fromJson)
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingProvider with ChangeNotifier {
  // This list will store all the user's ratings.
  final List<Rating> _userRatings = [];

  // Constructor: When the RatingProvider is created, it attempts to load saved ratings.
  RatingProvider() {
    _loadRatings();
  }

  // Getter: Provides read-only access to the list of user ratings.
  List<Rating> get userRatings => _userRatings;

  // Method to add or update a rating for a specific recipe.
  void addRating(Rating rating) {
    // Check if a rating for this recipeId already exists in the list.
    int existingIndex = _userRatings.indexWhere((r) => r.recipeId == rating.recipeId);

    if (existingIndex != -1) {
      // If a rating exists, update it with the new rating value.
      _userRatings[existingIndex] = rating;
    } else {
      // If no rating exists for this recipe, add the new rating to the list.
      _userRatings.add(rating);
    }
    _saveRatings(); // Save the updated list to persistent storage.
    notifyListeners(); // Notify all widgets listening to this provider that data has changed.
  }

  // Method to retrieve the rating for a specific recipe.
  // Returns the rating value if found, otherwise returns 0.0 (or a default value).
  double getRatingForRecipe(String recipeId) {
    return _userRatings.firstWhere(
      (rating) => rating.recipeId == recipeId,
      // UPDATED: Added placeholder values for 'userName' and 'comment'
      orElse: () => Rating(recipeId: recipeId, ratingValue: 0.0, userName: 'Anonymous', comment: ''), // Default if not found
    ).ratingValue;
  }

  // Asynchronous method to load ratings from SharedPreferences.
  Future<void> _loadRatings() async {
    final prefs = await SharedPreferences.getInstance();
    // Retrieve the JSON string of ratings from SharedPreferences using a specific key.
    final String? ratingsJsonString = prefs.getString('user_ratings_list');

    if (ratingsJsonString != null) {
      try {
        // Decode the JSON string into a dynamic list (List<Map<String, dynamic>>).
        final List<dynamic> decodedList = json.decode(ratingsJsonString);
        _userRatings.clear(); // Clear any existing data before loading.
        // Convert each item in the decoded list (which are Maps) back into Rating objects.
        _userRatings.addAll(decodedList.map((item) => Rating.fromJson(item as Map<String, dynamic>)));
      } catch (e) {
        // Log any errors during loading (e.g., corrupted data) and clear the list.
        debugPrint('Error loading ratings list from SharedPreferences: $e');
        _userRatings.clear();
      }
    }
    notifyListeners(); // Notify listeners after data is loaded (even if empty).
  }

  // Asynchronous method to save the current ratings list to SharedPreferences.
  Future<void> _saveRatings() async {
    final prefs = await SharedPreferences.getInstance();
    // Convert each Rating object in _userRatings to a JSON-compatible Map.
    final List<Map<String, dynamic>> ratingsMapList = _userRatings.map((rating) => rating.toJson()).toList();
    // Encode the list of Maps into a single JSON string.
    final String ratingsJsonString = json.encode(ratingsMapList);
    // Save the JSON string to SharedPreferences.
    await prefs.setString('user_ratings_list', ratingsJsonString);
  }

  // NEW: Method to clear all ratings. This is the method that SettingPage was trying to call.
  void clearAllRatings() {
    _userRatings.clear(); // Remove all elements from the list.
    _saveRatings(); // Persist this empty state to SharedPreferences.
    notifyListeners(); // Notify all listening widgets that the ratings data has been cleared.
    debugPrint('All ratings cleared from RatingProvider.');
  }
}
