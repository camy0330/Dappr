// lib/providers/favorite_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/recipes_data.dart'; // Import to access the global list of all recipes.
import '../models/recipe.dart';     // Import the Recipe model definition.

/// ===========================================================================
/// ENUMERATIONS FOR SORTING AND FILTERING
/// These enums define the available options for ordering and filtering recipes.
/// They are declared at the top-level of this file to be easily accessible
/// by other parts of the application, such as the UI.
/// ===========================================================================

/// Defines the possible sorting criteria for a list of recipes.
enum RecipeSortType {
  none,        // No specific sorting applied, maintains original insertion order.
  titleAsc,    // Sorts recipes by title in ascending (A-Z) order.
  titleDesc,   // Sorts recipes by title in descending (Z-A) order.
  prepTimeAsc, // Sorts recipes by preparation time from shortest to longest.
  prepTimeDesc, // Sorts recipes by preparation time from longest to shortest.
  cookTimeAsc, // Sorts recipes by cooking time from shortest to longest.
  cookTimeDesc, // Sorts recipes by cooking time from longest to shortest.
}

/// Defines the possible filtering criteria for a list of recipes.
enum RecipeFilterType {
  none,             // No filtering applied, all recipes are included.
  lessThan30MinPrep, // Filters for recipes with a preparation time of 30 minutes or less.
  lessThan1HourPrep, // Filters for recipes with a preparation time of 1 hour (60 minutes) or less.
  // Additional filter types can be added here as the application expands.
}

/// ===========================================================================
/// FavoriteProvider Class
/// This class manages the state of favorite recipes, including adding, removing,
/// persisting, loading, sorting, and filtering them. It extends [ChangeNotifier]
/// from the Flutter [provider] package, allowing it to notify its listeners
/// (typically UI widgets) when its internal state changes, triggering UI updates.
/// ===========================================================================
class FavoriteProvider with ChangeNotifier {
  /// Internal set to store the unique IDs of favorite recipes.
  /// Using a [Set] ensures that each recipe is marked as favorite only once
  /// and provides efficient O(1) lookup, addition, and removal.
  Set<String> _favoriteRecipeIds = {};

  /// Internal list to hold the actual [Recipe] objects that are favorited.
  /// This list is populated from `_favoriteRecipeIds` and the global `recipes` data.
  List<Recipe> _allFavoriteRecipes = [];

  /// Stores the currently selected sorting type.
  RecipeSortType _currentSortType = RecipeSortType.none;

  /// Stores the currently selected filtering type.
  RecipeFilterType _currentFilterType = RecipeFilterType.none;

  /// Constructor for [FavoriteProvider].
  /// Initializes the provider and immediately attempts to load previously
  /// saved favorite recipe IDs from persistent storage.
  FavoriteProvider() {
    _loadFavorites();
  }

  /// Getter to retrieve the currently active sorting type.
  /// Used by the UI to reflect the user's current sorting preference.
  RecipeSortType get currentSortType => _currentSortType;

  /// Getter to retrieve the currently active filtering type.
  /// Used by the UI to reflect the user's current filtering preference.
  RecipeFilterType get currentFilterType => _currentFilterType;

  /// Getter to check if there are any favorite recipes stored at all,
  /// regardless of current filters or sorts. This is useful for displaying
  /// an "empty state" message if no recipes have ever been favorited.
  bool get hasRawFavorites => _allFavoriteRecipes.isNotEmpty;

  /// Public getter that returns the list of favorite recipes after
  /// applying the current filter and sorting preferences.
  /// This is the primary list used by the UI to display recipes.
  List<Recipe> get favoriteRecipes {
    // Create a mutable copy of the current favorite recipes to apply operations.
    List<Recipe> processedList = List.from(_allFavoriteRecipes);

    // --- Apply Filtering Logic ---
    // Filters the list based on the `_currentFilterType`.
    if (_currentFilterType == RecipeFilterType.lessThan30MinPrep) {
      processedList = processedList.where((recipe) => recipe.prepTimeInMinutes <= 30).toList();
    } else if (_currentFilterType == RecipeFilterType.lessThan1HourPrep) {
      processedList = processedList.where((recipe) => recipe.prepTimeInMinutes <= 60).toList();
    }
    // Extend this section with more `else if` conditions for additional filters.

    // --- Apply Sorting Logic ---
    // Sorts the filtered list based on the `_currentSortType`.
    switch (_currentSortType) {
      case RecipeSortType.titleAsc:
        processedList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case RecipeSortType.titleDesc:
        processedList.sort((a, b) => b.title.compareTo(a.title));
        break;
      case RecipeSortType.prepTimeAsc:
        processedList.sort((a, b) => a.prepTimeInMinutes.compareTo(b.prepTimeInMinutes));
        break;
      case RecipeSortType.prepTimeDesc:
        processedList.sort((a, b) => b.prepTimeInMinutes.compareTo(a.prepTimeInMinutes));
        break;
      case RecipeSortType.cookTimeAsc:
        processedList.sort((a, b) => a.cookTimeInMinutes.compareTo(b.cookTimeInMinutes));
        break;
      case RecipeSortType.cookTimeDesc:
        processedList.sort((a, b) => b.cookTimeInMinutes.compareTo(a.cookTimeInMinutes));
        break;
      case RecipeSortType.none:
        // No specific sorting applied; the list remains in its filtered order.
        break;
    }

    return processedList;
  }

  /// Checks if a specific recipe is currently marked as favorite.
  ///
  /// [recipeId]: The unique identifier of the recipe to check.
  /// Returns `true` if the recipe is favorite, `false` otherwise.
  bool isFavorite(String recipeId) {
    return _favoriteRecipeIds.contains(recipeId);
  }

  /// Toggles the favorite status of a given recipe.
  /// If the recipe is currently favorite, it will be unfavorited, and vice-versa.
  ///
  /// [recipeId]: The unique identifier of the recipe to toggle.
  void toggleFavorite(String recipeId) {
    if (_favoriteRecipeIds.contains(recipeId)) {
      _favoriteRecipeIds.remove(recipeId);
    } else {
      _favoriteRecipeIds.add(recipeId);
    }
    _updateAllFavoriteRecipesList(); // Synchronize the list of Recipe objects.
    _saveFavorites(); // Persist the updated favorite IDs.
    notifyListeners(); // Notify all listening widgets to rebuild.
  }

  /// Asynchronously loads favorite recipe IDs from device's [SharedPreferences].
  /// This method is called upon initialization of the [FavoriteProvider].
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('favoriteRecipeIds');
    if (savedIds != null) {
      _favoriteRecipeIds = savedIds.toSet();
      _updateAllFavoriteRecipesList(); // Populate the list of Recipe objects from loaded IDs.
    }
    notifyListeners(); // Notify listeners that initial data loading is complete.
  }

  /// Asynchronously saves the current set of favorite recipe IDs to [SharedPreferences].
  /// This ensures that favorite selections persist across app sessions.
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteRecipeIds', _favoriteRecipeIds.toList());
  }

  /// Internal helper method to update the `_allFavoriteRecipes` list.
  /// It reconstructs this list by filtering the global `recipes` list
  /// (assumed to be defined in `recipes_data.dart`) based on the IDs
  /// currently present in `_favoriteRecipeIds`.
  void _updateAllFavoriteRecipesList() {
    // `recipes` is expected to be a globally accessible list of all Recipe objects.
    _allFavoriteRecipes = recipes
        .where((recipe) => _favoriteRecipeIds.contains(recipe.id))
        .toList();
  }

  /// Clears all favorite recipes from the list and persistent storage.
  Future<void> clearAllFavorites() async {
    _favoriteRecipeIds.clear();
    await _saveFavorites();
    _updateAllFavoriteRecipesList(); // Ensure the `_allFavoriteRecipes` list is also empty.
    notifyListeners(); // Notify UI to reflect the empty favorites state.
  }

  /// Sets the active sorting type and notifies listeners if the type has changed.
  ///
  /// [sortType]: The new [RecipeSortType] to apply.
  void setSortType(RecipeSortType sortType) {
    if (_currentSortType != sortType) {
      _currentSortType = sortType;
      notifyListeners(); // Trigger a rebuild of widgets that depend on `favoriteRecipes`.
    }
  }

  /// Sets the active filtering type and notifies listeners if the type has changed.
  ///
  /// [filterType]: The new [RecipeFilterType] to apply.
  void setFilterType(RecipeFilterType filterType) {
    if (_currentFilterType != filterType) {
      _currentFilterType = filterType;
      notifyListeners(); // Trigger a rebuild of widgets that depend on `favoriteRecipes`.
    }
  }
}