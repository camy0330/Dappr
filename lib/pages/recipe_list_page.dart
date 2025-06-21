// lib/pages/recipe_list_page.dart

// Importing necessary data for recipes. This file is expected to contain the list of available recipes.
import 'package:dappr/data/recipes_data.dart';
// Importing the Recipe model. This defines the structure of a recipe object.
import 'package:dappr/models/recipe.dart';
// Importing the RecipeDetailPage. This page is navigated to when a user taps on a recipe.
import 'package:dappr/pages/recipe_detail_page.dart';
// Importing the FavoriteProvider. This provider manages the state of favorite recipes across the application.
import 'package:dappr/providers/favorite_provider.dart';
// Importing the Flutter material package. This provides core Flutter UI widgets and theming.
import 'package:flutter/material.dart';
// Importing the Provider package. This package is used for state management, specifically for FavoriteProvider.
import 'package:provider/provider.dart';

/// RecipeListPage is a StatefulWidget that displays a list of recipes.
/// It allows users to search, filter, and view details of recipes.
class RecipeListPage extends StatefulWidget {
  /// Constructor for RecipeListPage.
  /// The [key] parameter is used to control how a widget replaces another widget in the widget tree.
  const RecipeListPage({super.key});

  /// Creates the mutable state for this widget.
  /// The framework calls this method when it builds this widget into the widget tree.
  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

/// The private State class for RecipeListPage.
/// It holds the mutable state that can change over the lifetime of the widget.
class _RecipeListPageState extends State<RecipeListPage> {
  /// A list of recipes that are currently displayed, updated based on search and filter criteria.
  List<Recipe> _filteredRecipes = [];
  /// A controller for the search text field, used to manage and retrieve the user's search query.
  final TextEditingController _searchController = TextEditingController();

  // --- Filter State Variables ---
  /// A set to store the currently selected hashtags for filtering recipes.
  /// Recipes must contain at least one of these selected hashtags to be displayed.
  Set<String> _selectedHashtags = {};
  /// A RangeValues object representing the selected minimum and maximum preparation time in minutes.
  RangeValues _prepTimeRange = const RangeValues(0, 120); // Default max 120 mins (2 hours)
  /// A RangeValues object representing the selected minimum and maximum cooking time in minutes.
  RangeValues _cookTimeRange = const RangeValues(0, 120); // Default max 120 mins (2 hours)

  /// A predefined list of all possible hashtag categories available for filtering.
  /// In a production application, this might be loaded dynamically from a backend.
  final List<String> _allPossibleTags = [
    "Breakfast", "Lunch", "Dinner", "Snack", "Dessert", "Appetizer", "MainCourse", "SideDish", "Drink",
    "Italian", "Mexican", "Asian", "Indian", "American", "Mediterranean", "French", "Thai", "Japanese", "Chinese", "Malay", "Malaysian",
    "Vegetarian", "Vegan", "GlutenFree", "Dairy-Free", "Nut-Free", "Keto", "Paleo", "Healthy", "Quick", "Spicy", "Sweet", "Pasta",
    "Rice", "Noodles", "Chicken", "Seafood", "Soup" // Added based on assumed recipe data
  ];
  // --- End Filter State Variables ---

  /// Called once when the widget is inserted into the widget tree.
  /// Initializes the [_filteredRecipes] list by applying initial filters (which are defaults at this stage).
  @override
  void initState() {
    super.initState();
    _applyFilters(); // Populates the list with all recipes initially.
  }

  /// Called when this State object is removed from the widget tree.
  /// Disposes of the [_searchController] to free up resources.
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Filtering Logic ---
  /// Applies all active filters (search query, hashtags, prep time, cook time)
  /// to the list of [recipes] and updates [_filteredRecipes].
  void _applyFilters() {
    // setState is called to trigger a rebuild of the widget with the new filtered data.
    setState(() {
      // Filters the global 'recipes' list.
      _filteredRecipes = recipes.where((recipe) {
        // 1. Apply Search Query Filter: Checks if the recipe title or description contains the search query.
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            recipe.title.toLowerCase().contains(searchQuery) ||
            recipe.description.toLowerCase().contains(searchQuery);

        // If the recipe does not match the search query, it's excluded immediately.
        if (!matchesSearch) return false;

        // 2. Apply Hashtag (Categorical) Filter: Checks if the recipe's hashtags
        // contain any of the selected filter hashtags.
        final matchesHashtags = _selectedHashtags.isEmpty ||
            _selectedHashtags.any((filterTag) => recipe.hashtags.contains(filterTag));

        // If the recipe does not match the selected hashtags, it's excluded immediately.
        if (!matchesHashtags) return false;

        // 3. Apply Prep Time Filter: Checks if the recipe's preparation time
        // falls within the selected range.
        final matchesPrepTime = recipe.prepTimeInMinutes >= _prepTimeRange.start &&
                                recipe.prepTimeInMinutes <= _prepTimeRange.end;
        // If the recipe does not match the prep time range, it's excluded immediately.
        if (!matchesPrepTime) return false;

        // 4. Apply Cook Time Filter: Checks if the recipe's cooking time
        // falls within the selected range.
        final matchesCookTime = recipe.cookTimeInMinutes >= _cookTimeRange.start &&
                                recipe.cookTimeInMinutes <= _cookTimeRange.end;
        // If the recipe does not match the cook time range, it's excluded immediately.
        if (!matchesCookTime) return false;

        // If all filters pass, the recipe is included in the filtered list.
        return true;
      }).toList(); // Converts the filtered iterable back to a list.
    });

    // Provide user feedback (SnackBar) if no recipes are found after filtering.
    // addPostFrameCallback ensures the SnackBar is shown after the current build frame.
    if (_filteredRecipes.isEmpty && (_searchController.text.isNotEmpty || _selectedHashtags.isNotEmpty || _prepTimeRange.start > 0 || _cookTimeRange.start > 0 || _prepTimeRange.end < 120 || _cookTimeRange.end < 120 )) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No recipes found with the selected filters.')),
        );
      });
    } else if (recipes.isEmpty) { // Handle case where there's no initial recipe data.
        WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No recipe data available.')),
        );
      });
    }
  }

  /// Callback function triggered when the search text field's content changes.
  /// Calls [_applyFilters] to re-filter the recipe list based on the new query.
  void _onSearchChanged(String query) {
    _applyFilters(); // Re-apply all filters including the search query.
  }

  /// Displays a modal bottom sheet containing filter options for categories,
  /// preparation time, and cooking time.
  void _showFilterBottomSheet() {
    // Create temporary copies of current filter selections.
    // This allows users to make changes in the modal without affecting the main list
    // until "Apply Filters" is pressed.
    Set<String> tempSelectedHashtags = Set.from(_selectedHashtags);
    RangeValues tempPrepTimeRange = _prepTimeRange;
    RangeValues tempCookTimeRange = _cookTimeRange;

    // Shows a modal bottom sheet that slides up from the bottom of the screen.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take full height if needed (e.g., for keyboard).
      builder: (context) {
        // StatefulBuilder is used to manage the state within the bottom sheet itself,
        // allowing it to rebuild independently when filter options are changed in the modal.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            // Determine text color based on the current theme's brightness.
            final brightness = Theme.of(context).brightness;
            final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

            // Container holds the content of the bottom sheet.
            return Container(
              // Padding ensures content is not obscured by system UI (e.g., keyboard).
              padding: EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Accounts for keyboard.
              ),
              // SingleChildScrollView allows the content within the bottom sheet to scroll if it overflows.
              child: SingleChildScrollView(
                // Column arranges filter options vertically.
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Makes the column only as tall as its children.
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left).
                  children: [
                    // Header row for the filter sheet.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes space between title and close button.
                      children: [
                        // Title of the filter sheet.
                        Text(
                          'Filter Recipes',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold, // Bold font for emphasis.
                            fontFamily: 'Montserrat', // Custom font.
                            color: Colors.deepOrange, // Accent color.
                          ),
                        ),
                        // Close button for the bottom sheet.
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.deepOrange), // Close icon with accent color.
                          onPressed: () => Navigator.pop(context), // Closes the bottom sheet when pressed.
                        ),
                      ],
                    ),
                    const SizedBox(height: 16), // Vertical spacing.

                    // Categorical Filters section (using hashtags).
                    Text(
                      'Categories (e.g., Meal Type, Cuisine, Dietary)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8), // Vertical spacing.
                    // Wrap widget allows chips to flow to the next line if space is insufficient.
                    Wrap(
                      spacing: 8.0, // Horizontal spacing between chips.
                      runSpacing: 8.0, // Vertical spacing between rows of chips.
                      children: _allPossibleTags.map((tag) {
                        // Determine if the current tag is selected.
                        final isSelected = tempSelectedHashtags.contains(tag);
                        // FilterChip allows users to select/deselect categories.
                        return FilterChip(
                          label: Text(tag), // Text label for the chip.
                          selected: isSelected, // Visual state of the chip (selected/unselected).
                          selectedColor: Colors.deepOrange.withAlpha((255 * 0.7).round()), // Color when selected.
                          checkmarkColor: Colors.white, // Checkmark color when selected.
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : textColor, // Label text color based on selection.
                            fontFamily: 'Montserrat',
                          ),
                          // Callback when the chip is tapped.
                          onSelected: (bool selected) {
                            // modalSetState rebuilds only the content of the bottom sheet.
                            modalSetState(() {
                              if (selected) {
                                tempSelectedHashtags.add(tag); // Add tag if selected.
                              } else {
                                tempSelectedHashtags.remove(tag); // Remove tag if deselected.
                              }
                            });
                          },
                        );
                      }).toList(), // Convert the iterable of chips to a list of widgets.
                    ),
                    const SizedBox(height: 16), // Vertical spacing.

                    // Prep Time Filter section.
                    Text(
                      'Preparation Time (mins)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: textColor,
                      ),
                    ),
                    // RangeSlider allows users to select a range for preparation time.
                    RangeSlider(
                      values: tempPrepTimeRange, // Current selected range values.
                      min: 0, // Minimum prep time.
                      max: 120, // Maximum prep time (2 hours).
                      divisions: 24, // Divides the range into 24 segments (5-minute increments).
                      labels: RangeLabels(
                        '${tempPrepTimeRange.start.round()} min', // Label for the start thumb.
                        '${tempPrepTimeRange.end.round()} min', // Label for the end thumb.
                      ),
                      activeColor: Colors.deepOrange, // Color of the active portion of the slider.
                      onChanged: (RangeValues newValues) {
                        // modalSetState rebuilds only the content of the bottom sheet.
                        modalSetState(() {
                          tempPrepTimeRange = newValues; // Update the temporary prep time range.
                        });
                      },
                    ),
                    const SizedBox(height: 16), // Vertical spacing.

                    // Cook Time Filter section.
                    Text(
                      'Cook Time (mins)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: textColor,
                      ),
                    ),
                    // RangeSlider allows users to select a range for cooking time.
                    RangeSlider(
                      values: tempCookTimeRange, // Current selected range values.
                      min: 0, // Minimum cook time.
                      max: 120, // Maximum cook time (2 hours).
                      divisions: 24, // Divides the range into 24 segments (5-minute increments).
                      labels: RangeLabels(
                        '${tempCookTimeRange.start.round()} min', // Label for the start thumb.
                        '${tempCookTimeRange.end.round()} min', // Label for the end thumb.
                      ),
                      activeColor: Colors.deepOrange, // Color of the active portion of the slider.
                      onChanged: (RangeValues newValues) {
                        // modalSetState rebuilds only the content of the bottom sheet.
                        modalSetState(() {
                          tempCookTimeRange = newValues; // Update the temporary cook time range.
                        });
                      },
                    ),
                    const SizedBox(height: 24), // Vertical spacing.

                    // Action Buttons (Clear Filters and Apply Filters).
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distributes space evenly between buttons.
                      children: [
                        // "Clear Filters" button.
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // modalSetState clears the temporary filter selections.
                              modalSetState(() {
                                tempSelectedHashtags.clear();
                                tempPrepTimeRange = const RangeValues(0, 120);
                                tempCookTimeRange = const RangeValues(0, 120);
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.deepOrange, // Text color of the button.
                              side: const BorderSide(color: Colors.deepOrange), // Border color.
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // Rounded corners.
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12), // Vertical padding.
                            ),
                            child: const Text('Clear Filters', style: TextStyle(fontSize: 16, fontFamily: 'Montserrat')),
                          ),
                        ),
                        const SizedBox(width: 16), // Horizontal spacing between buttons.
                        // "Apply Filters" button.
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // setState updates the main page's state with the selected filter values.
                              setState(() {
                                _selectedHashtags = tempSelectedHashtags;
                                _prepTimeRange = tempPrepTimeRange;
                                _cookTimeRange = tempCookTimeRange;
                              });
                              _applyFilters(); // Applies the new filters to the main recipe list.
                              Navigator.pop(context); // Closes the bottom sheet.
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange, // Background color of the button.
                              foregroundColor: Colors.white, // Text color of the button.
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // Rounded corners.
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12), // Vertical padding.
                            ),
                            child: const Text(
                              'Apply Filters',
                              style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  // --- End Filtering Logic ---

  /// Describes the part of the user interface represented by this widget.
  /// This method is called every time the widget's configuration changes or when the state changes.
  @override
  Widget build(BuildContext context) {
    // Access the FavoriteProvider instance to check and toggle favorite status.
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    // Determine the current theme brightness for adaptive UI colors.
    final brightness = Theme.of(context).brightness;
    // Set text color based on theme brightness.
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    // Scaffold provides the basic visual structure for a Material Design app.
    return Scaffold(
      // Column arranges the header, filter summary, and recipe list vertically.
      body: Column(
        children: [
          // Header section containing the title, filter icon, and search bar.
          Container(
            height: 160, // Fixed height for the header.
            decoration: const BoxDecoration(
              // Gradient background for a visually appealing header.
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Decorative white line at the top of the header.
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    color: Colors.white,
                  ),
                ),
                // Padding for the content within the header.
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left.
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spaces out title and filter icon.
                        children: [
                          // Main title of the recipe list page.
                          Text(
                            'What would you like to cook today?',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: textColor, // Text color adapts to theme.
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Filter Icon Button: Tapping this opens the filter bottom sheet.
                          IconButton(
                            icon: const Icon(Icons.filter_list, color: Colors.white, size: 30),
                            onPressed: _showFilterBottomSheet, // Calls the method to show the filter sheet.
                          ),
                        ],
                      ),
                      const SizedBox(height: 12), // Vertical spacing.
                      // Search bar container.
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((255 * 0.9).round()), // Semi-transparent white background.
                          borderRadius: BorderRadius.circular(10), // Rounded corners for the search bar.
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12), // Horizontal padding for text field.
                        child: TextField(
                          controller: _searchController, // Links the text field to the search controller.
                          onChanged: _onSearchChanged, // Calls the filter function when text changes.
                          style: const TextStyle(color: Colors.black), // Text input color.
                          decoration: InputDecoration(
                            hintText: 'Search recipes...', // Placeholder text.
                            hintStyle: TextStyle(color: Colors.grey[700]), // Hint text style.
                            border: InputBorder.none, // Removes the default text field border.
                            icon: Icon(Icons.search, color: Colors.grey[700]), // Search icon.
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Vertical spacing.
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Display current filter summary (optional but good for user experience).
          // This section is only shown if any filters are active.
          if (_selectedHashtags.isNotEmpty ||
              _prepTimeRange.start > 0 || _prepTimeRange.end < 120 ||
              _cookTimeRange.start > 0 || _cookTimeRange.end < 120)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SingleChildScrollView( // Allows the filter chips to scroll horizontally.
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text('Active Filters: ', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                    // Map selected hashtags to Chip widgets.
                    ..._selectedHashtags.map((tag) => Chip(
                      label: Text(tag), // Display the hashtag name.
                      onDeleted: () {
                        // Deleting a chip removes the filter and reapplies.
                        setState(() {
                          _selectedHashtags.remove(tag);
                          _applyFilters();
                        });
                      },
                      backgroundColor: Colors.deepOrange.shade100, // Light background for chips.
                      labelStyle: const TextStyle(color: Colors.deepOrange), // Dark text for chips.
                      deleteIconColor: Colors.deepOrange, // Color of the delete icon.
                    )),
                    // Display chip for Prep Time Range if not default.
                    if (_prepTimeRange.start > 0 || _prepTimeRange.end < 120)
                      Chip(
                        label: Text('Prep: ${_prepTimeRange.start.round()}-${_prepTimeRange.end.round()} mins'),
                        onDeleted: () {
                          // Deleting this chip resets the prep time filter.
                          setState(() {
                            _prepTimeRange = const RangeValues(0, 120);
                            _applyFilters();
                          });
                        },
                          backgroundColor: Colors.deepOrange.shade100,
                          labelStyle: const TextStyle(color: Colors.deepOrange),
                          deleteIconColor: Colors.deepOrange,
                      ),
                    // Display chip for Cook Time Range if not default.
                    if (_cookTimeRange.start > 0 || _cookTimeRange.end < 120)
                      Chip(
                        label: Text('Cook: ${_cookTimeRange.start.round()}-${_cookTimeRange.end.round()} mins'),
                        onDeleted: () {
                          // Deleting this chip resets the cook time filter.
                          setState(() {
                            _cookTimeRange = const RangeValues(0, 120);
                            _applyFilters();
                          });
                        },
                          backgroundColor: Colors.deepOrange.shade100,
                          labelStyle: const TextStyle(color: Colors.deepOrange),
                          deleteIconColor: Colors.deepOrange,
                      ),
                  ].expand((widget) => [widget, const SizedBox(width: 4)]).toList(), // Adds spacing between chips.
                ),
              ),
            ),

          // Results Count Display: Shows how many recipes are currently displayed.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerRight, // Aligns the text to the right.
              child: Text(
                '${_filteredRecipes.length} results', // Displays the count of filtered recipes.
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  // ignore: deprecated_member_use
                  color: textColor.withOpacity(0.7), // Slightly transparent text color.
                ),
              ),
            ),
          ),

          // Recipe list or "No recipes found" message.
          Expanded( // Takes up the remaining available vertical space.
            child: _filteredRecipes.isEmpty
                ? Center( // Displayed when no recipes match the current filters.
                    child: Text(
                      'No recipes found with these criteria.',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : GridView.builder( // Displays recipes in a grid layout.
                    padding: const EdgeInsets.all(8.0), // Padding around the grid.
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3, // 2 columns on small screens, 3 on larger.
                      crossAxisSpacing: 10.0, // Horizontal spacing between grid items.
                      mainAxisSpacing: 10.0, // Vertical spacing between grid items.
                      childAspectRatio: 0.8, // Aspect ratio of each grid item.
                    ),
                    itemCount: _filteredRecipes.length, // Number of items in the grid.
                    itemBuilder: (context, index) {
                      final recipe = _filteredRecipes[index]; // Get the current recipe.
                      final bool isFavorite = favoriteProvider.isFavorite(recipe.id); // Check if the recipe is a favorite.

                      // Card widget for each recipe, providing elevation and rounded corners.
                      return Card(
                        elevation: 4, // Shadow effect.
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)), // Rounded corners for the card.
                        clipBehavior: Clip.antiAlias, // Ensures content is clipped to the rounded corners.
                        child: InkWell( // Makes the card tappable.
                          onTap: () {
                            try {
                              // Navigates to the RecipeDetailPage when the card is tapped.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeDetailPage(recipe: recipe), // Pass the selected recipe to the detail page.
                                ),
                              );
                            } catch (e) {
                              // Displays a SnackBar if navigation fails.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Unable to open recipe.')),
                              );
                            }
                          },
                          // Column to arrange image, details, and favorite icon.
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretches children horizontally.
                            children: [
                              Expanded( // Makes the image take available vertical space.
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15)), // Rounded top corners for the image.
                                  child: Image.network( // Displays the recipe image from a network URL.
                                    recipe.imageUrl,
                                    fit: BoxFit.cover, // Covers the available space without distortion.
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback for asset images or if network image fails to load.
                                      // This assumes imageUrl can also be a local asset path.
                                      return Image.asset(
                                        recipe.imageUrl, // Tries to load as an asset if network fails.
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          // Displays a broken image icon if both network and asset loading fail.
                                          return Container(
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.broken_image,
                                                color: Colors.grey, size: 50),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10), // Vertical spacing.
                              // Padding for recipe submitted by and title.
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                child: Row(
                                  children: [
                                    // Circular avatar for the submitter.
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.grey.shade300,
                                      child: Icon(Icons.person,
                                          color: Colors.grey.shade700, size: 20),
                                    ),
                                    const SizedBox(width: 8), // Horizontal spacing.
                                    Expanded( // Allows text to take available space.
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start, // Aligns text to the left.
                                        children: [
                                          // Text for who submitted the recipe.
                                          Text(
                                            recipe.submittedBy,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat',
                                            ),
                                            maxLines: 1, // Restricts to one line.
                                            overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows.
                                          ),
                                          // Text for the recipe title.
                                          Text(
                                            recipe.title,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat',
                                              color: textColor,
                                            ),
                                            maxLines: 1, // Restricts to one line.
                                            overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows.
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding for recipe description.
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  recipe.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: brightness == Brightness.dark
                                        ? Colors.grey[400]
                                        : Colors.grey, // Description text color adapts to theme.
                                    fontFamily: 'Montserrat',
                                  ),
                                  maxLines: 2, // Restricts to two lines.
                                  overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows.
                                ),
                              ),
                              // Align widget for the favorite button to the bottom right.
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite // Displays filled heart if favorite, outlined if not.
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        isFavorite ? Colors.red : Colors.grey, // Red if favorite, grey otherwise.
                                    size: 28, // Icon size.
                                  ),
                                  onPressed: () {
                                    try {
                                      // Toggles the favorite status of the recipe using the provider.
                                      favoriteProvider
                                          .toggleFavorite(recipe.id);
                                    } catch (e) {
                                      // Displays a SnackBar if updating favorite fails.
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Failed to update favorite.')),
                                          );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}