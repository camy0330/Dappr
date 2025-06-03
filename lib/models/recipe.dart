// lib/models/recipe.dart
class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final String prepTime;
  final String cookTime;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.prepTime,
    required this.cookTime,
    required this.steps,
  });
}
