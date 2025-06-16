import 'dart:async'; // Required for debouncing the search input
import 'package:flutter/material.dart';
import '../models/recipe.dart'; // Make sure this path is correct for your Recipe model

class RecipeFilterPage extends StatefulWidget {
  final List<Recipe> recipes;

  const RecipeFilterPage({Key? key, required this.recipes}) : super(key: key);

  @override
  State<RecipeFilterPage> createState() => _RecipeFilterPageState();
}

class _RecipeFilterPageState extends State<RecipeFilterPage> {
  String searchText = ''; // Stores the current text from the search input
  Timer? _debounce; // Timer for debouncing search input to reduce rebuilds

  // Getter to extract keywords (words not starting with '#') from searchText
  List<String> get keywords =>
      searchText.split(' ').where((w) => w.isNotEmpty && !w.startsWith('#')).toList();

  // Getter to extract hashtags (words starting with '#') from searchText, converted to lowercase
  List<String> get hashtags =>
      searchText.split(' ').where((w) => w.startsWith('#')).map((h) => h.toLowerCase()).toList();

  @override
  void dispose() {
    // Cancel the debounce timer when the widget is removed from the widget tree
    // This prevents memory leaks and ensures the timer doesn't try to call setState on a disposed widget
    _debounce?.cancel();
    super.dispose();
  }

  /// Handles changes in the search input field with a debouncing mechanism.
  /// This prevents the filter from being applied on every keystroke,
  /// leading to better performance and a smoother user experience.
  void _onSearchChanged(String query) {
    // If there's an active debounce timer, cancel it (user typed again)
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    // Start a new timer. The `setState` will only be called after 300ms
    // of inactivity (no new characters typed).
    _debounce = Timer(const Duration(milliseconds: 300), () {
      // Update the searchText state variable, which triggers a rebuild
      setState(() {
        searchText = query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter the list of recipes based on the current searchText
    // This list is re-calculated every time setState is called (i.e., after debounced search input)
    List<Recipe> filteredRecipes = widget.recipes.where((recipe) {
      // Check if all keywords are present in the recipe's title or description (case-insensitive)
      final textMatch = keywords.every((kw) =>
          recipe.title.toLowerCase().contains(kw.toLowerCase()) ||
          recipe.description.toLowerCase().contains(kw.toLowerCase()));

      // Check if all hashtags are present in the recipe's hashtags (case-insensitive)
      final tagMatch = hashtags.every((tag) =>
          recipe.hashtags.map((h) => h.toLowerCase()).contains(tag));

      // A recipe matches if both text keywords AND hashtags criteria are met
      return textMatch && tagMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Filter Recipes')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🔍 Combined Search + Hashtag input field (directly in this page)
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search with keywords or #hashtags',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              // Assign the debounced handler to onChanged
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 12), // Spacing below the search bar

            // 🍽 Filtered Recipes List
            Expanded(
              child: filteredRecipes.isEmpty
                  // Display a message if no recipes are found after filtering
                  ? const Center(child: Text("No matching recipes found."))
                  // Otherwise, build the list of filtered recipes
                  : ListView.builder(
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.asset( // Displays the recipe image
                              recipe.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(recipe.title), // Displays the recipe title
                            subtitle: Text(recipe.description), // Displays the recipe description
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
