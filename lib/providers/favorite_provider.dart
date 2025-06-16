// lib/providers/favorite_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/recipes_data.dart'; // Ensure this path is correct for your recipes data
import '../models/recipe.dart'; // Ensure this path is correct for your Recipe model

// ===================================================================
// IMPORTANT: These enums MUST be defined OUTSIDE the FavoriteProvider class
// (i.e., at the top level of this file)
// ===================================================================

enum RecipeSortType {
  none,
  titleAsc, // Sort by title A-Z
  titleDesc, // Sort by title Z-A
  prepTimeAsc, // Sort by preparation time (shortest to longest)
  prepTimeDesc, // Sort by preparation time (longest to shortest)
  cookTimeAsc, // Sort by cooking time (shortest to longest)
  cookTimeDesc, // Sort by cooking time (longest to shortest)
}

enum RecipeFilterType {
  none,
  lessThan30MinPrep, // Filter for recipes with prep time <= 30 minutes
  lessThan1HourPrep, // Filter for recipes with prep time <= 60 minutes
  // Add more filter types here if you need them in the future
}

// ===================================================================
// End of enum definitions. The class definition follows.
// ===================================================================

class FavoriteProvider with ChangeNotifier {
  // Stores only the IDs of favorite recipes for persistence
  Set<String> _favoriteRecipeIds = {};
  
  // Stores the actual Recipe objects corresponding to the favorite IDs
  // This list is updated whenever _favoriteRecipeIds changes
  List<Recipe> _allFavoriteRecipes = [];
  
  // Current sorting and filtering preferences
  RecipeSortType _currentSortType = RecipeSortType.none;
  RecipeFilterType _currentFilterType = RecipeFilterType.none;

  FavoriteProvider() {
    _loadFavorites(); // Load favorites when the provider is initialized
  }

  // Getter to expose the current sort type to the UI
  RecipeSortType get currentSortType => _currentSortType;
  // Getter to expose the current filter type to the UI
  RecipeFilterType get currentFilterType => _currentFilterType;

  // Getter to check if there are any favorites stored at all (before any filtering/sorting)
  bool get hasRawFavorites => _allFavoriteRecipes.isNotEmpty;

  // This is the main getter that the UI will use to display favorite recipes.
  // It applies the current filter and sort settings.
  List<Recipe> get favoriteRecipes {
    // Start with a mutable copy of all favorite recipe objects
    List<Recipe> processedList = List.from(_allFavoriteRecipes);

    // Apply filtering logic based on _currentFilterType
    if (_currentFilterType == RecipeFilterType.lessThan30MinPrep) {
      processedList = processedList.where((recipe) => recipe.prepTimeInMinutes <= 30).toList();
    } else if (_currentFilterType == RecipeFilterType.lessThan1HourPrep) {
      processedList = processedList.where((recipe) => recipe.prepTimeInMinutes <= 60).toList();
    }
    // Add more `else if` conditions here for any new filter types you define

    // Apply sorting logic based on _currentSortType
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
        // No specific sorting applied, maintains original order from _allFavoriteRecipes
        break;
    }

    return processedList;
  }

  // Checks if a recipe is currently marked as favorite
  bool isFavorite(String recipeId) {
    return _favoriteRecipeIds.contains(recipeId);
  }

  // Toggles the favorite status of a recipe
  void toggleFavorite(String recipeId) {
    if (_favoriteRecipeIds.contains(recipeId)) {
      _favoriteRecipeIds.remove(recipeId);
    } else {
      _favoriteRecipeIds.add(recipeId);
    }
    _updateAllFavoriteRecipesList(); // Update the list of Recipe objects
    _saveFavorites(); // Persist changes to SharedPreferences
    notifyListeners(); // Notify listeners (UI) to rebuild
  }

  // Loads favorite recipe IDs from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('favoriteRecipeIds');
    if (savedIds != null) {
      _favoriteRecipeIds = savedIds.toSet();
      _updateAllFavoriteRecipesList(); // Rebuild the list of Recipe objects after loading IDs
    }
    notifyListeners(); // Notify after initial load is complete
  }

  // Saves current favorite recipe IDs to SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteRecipeIds', _favoriteRecipeIds.toList());
  }

  // Helper method to populate _allFavoriteRecipes list based on current _favoriteRecipeIds
  void _updateAllFavoriteRecipesList() {
    // Assuming 'recipes' is a global list of all available recipes (from recipes_data.dart)
    _allFavoriteRecipes = recipes
        .where((recipe) => _favoriteRecipeIds.contains(recipe.id))
        .toList();
  }

  // Clears all favorite recipes
  Future<void> clearAllFavorites() async {
    _favoriteRecipeIds.clear();
    await _saveFavorites();
    _updateAllFavoriteRecipesList(); // Ensure the list of Recipe objects is also cleared
    notifyListeners();
  }

  // Setter to change the current sorting type
  void setSortType(RecipeSortType sortType) {
    if (_currentSortType != sortType) {
      _currentSortType = sortType;
      notifyListeners(); // Trigger UI rebuild with new sorting
    }
  }

  // Setter to change the current filtering type
  void setFilterType(RecipeFilterType filterType) {
    if (_currentFilterType != filterType) {
      _currentFilterType = filterType;
      notifyListeners(); // Trigger UI rebuild with new filtering
    }
  }
}