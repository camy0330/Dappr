// lib/pages/recipe_list_page.dart
import 'package:dappr/data/recipes_data.dart';
import 'package:dappr/models/recipe.dart';
import 'package:dappr/pages/recipe_detail_page.dart';
import 'package:dappr/providers/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  List<Recipe> _filteredRecipes = [];
  final TextEditingController _searchController = TextEditingController();

  // --- Filter State Variables ---
  Set<String> _selectedHashtags = {}; // Now a single set for all tag types
  RangeValues _prepTimeRange = const RangeValues(0, 120); // Max 120 mins (2 hours)
  RangeValues _cookTimeRange = const RangeValues(0, 120); // Max 120 mins (2 hours)

  // Define all possible filter options (collect from your recipes_data or define explicitly)
  // For production, you might generate these dynamically from your data
  final List<String> _allPossibleTags = [
    "Breakfast", "Lunch", "Dinner", "Snack", "Dessert", "Appetizer", "MainCourse", "SideDish", "Drink",
    "Italian", "Mexican", "Asian", "Indian", "American", "Mediterranean", "French", "Thai", "Japanese", "Chinese", "Malay", "Malaysian",
    "Vegetarian", "Vegan", "GlutenFree", "Dairy-Free", "Nut-Free", "Keto", "Paleo", "Healthy", "Quick", "Spicy", "Sweet", "Pasta",
    "Rice", "Noodles", "Chicken", "Seafood", "Soup" // Added based on your data
  ];
  // --- End Filter State Variables ---

  @override
  void initState() {
    super.initState();
    // Initialize _filteredRecipes with the full list of recipes
    _applyFilters(); // Call apply filters initially to populate the list
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Filtering Logic ---
  void _applyFilters() {
    setState(() {
      _filteredRecipes = recipes.where((recipe) {
        // 1. Apply Search Query Filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            recipe.title.toLowerCase().contains(searchQuery) ||
            recipe.description.toLowerCase().contains(searchQuery);

        if (!matchesSearch) return false;

        // 2. Apply Hashtag (Categorical) Filter
        final matchesHashtags = _selectedHashtags.isEmpty ||
            _selectedHashtags.any((filterTag) => recipe.hashtags.contains(filterTag));

        if (!matchesHashtags) return false;

        // 3. Apply Prep Time Filter
        final matchesPrepTime = recipe.prepTimeInMinutes >= _prepTimeRange.start &&
                                recipe.prepTimeInMinutes <= _prepTimeRange.end;
        if (!matchesPrepTime) return false;

        // 4. Apply Cook Time Filter
        final matchesCookTime = recipe.cookTimeInMinutes >= _cookTimeRange.start &&
                                recipe.cookTimeInMinutes <= _cookTimeRange.end;
        if (!matchesCookTime) return false;

        // If all filters pass, include the recipe
        return true;
      }).toList();
    });

    // Provide user feedback if no recipes found after filtering
    if (_filteredRecipes.isEmpty && (_searchController.text.isNotEmpty || _selectedHashtags.isNotEmpty || _prepTimeRange.start > 0 || _cookTimeRange.start > 0 || _prepTimeRange.end < 120 || _cookTimeRange.end < 120 )) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No recipes found with the selected filters.')),
        );
      });
    } else if (recipes.isEmpty) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No recipe data available.')),
        );
      });
    }
  }

  // Called when search text changes
  void _onSearchChanged(String query) {
    _applyFilters(); // Re-apply all filters including the search query
  }

  // Function to show the filter bottom sheet
  void _showFilterBottomSheet() {
    // Make copies of current selections to work with in the modal
    Set<String> tempSelectedHashtags = Set.from(_selectedHashtags);
    RangeValues tempPrepTimeRange = _prepTimeRange;
    RangeValues tempCookTimeRange = _cookTimeRange;


    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows content to take full height
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            final brightness = Theme.of(context).brightness;
            final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

            return Container(
              // Using a safe area to avoid content being cut off by system UI
              padding: EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                // Adjust padding based on keyboard visibility
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              ),
              child: SingleChildScrollView( // Allow scrolling if content overflows
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Make column only as tall as its children
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Recipes',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.deepOrange,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.deepOrange),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Categorical Filters (using hashtags)
                    Text(
                      'Categories (e.g., Meal Type, Cuisine, Dietary)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _allPossibleTags.map((tag) {
                        final isSelected = tempSelectedHashtags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          // FIX: Replaced withOpacity with withAlpha
                          selectedColor: Colors.deepOrange.withAlpha((255 * 0.7).round()),
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : textColor,
                            fontFamily: 'Montserrat',
                          ),
                          onSelected: (bool selected) {
                            modalSetState(() {
                              if (selected) {
                                tempSelectedHashtags.add(tag);
                              } else {
                                tempSelectedHashtags.remove(tag);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Prep Time Filter
                    Text(
                      'Preparation Time (mins)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: textColor,
                      ),
                    ),
                    RangeSlider(
                      values: tempPrepTimeRange,
                      min: 0,
                      max: 120, // Max 2 hours
                      divisions: 24, // 5-minute increments
                      labels: RangeLabels(
                        '${tempPrepTimeRange.start.round()} min',
                        '${tempPrepTimeRange.end.round()} min',
                      ),
                      activeColor: Colors.deepOrange,
                      onChanged: (RangeValues newValues) {
                        modalSetState(() {
                          tempPrepTimeRange = newValues;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Cook Time Filter
                    Text(
                      'Cook Time (mins)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: textColor,
                      ),
                    ),
                    RangeSlider(
                      values: tempCookTimeRange,
                      min: 0,
                      max: 120, // Max 2 hours
                      divisions: 24, // 5-minute increments
                      labels: RangeLabels(
                        '${tempCookTimeRange.start.round()} min',
                        '${tempCookTimeRange.end.round()} min',
                      ),
                      activeColor: Colors.deepOrange,
                      onChanged: (RangeValues newValues) {
                        modalSetState(() {
                          tempCookTimeRange = newValues;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              modalSetState(() {
                                tempSelectedHashtags.clear();
                                tempPrepTimeRange = const RangeValues(0, 120);
                                tempCookTimeRange = const RangeValues(0, 120);
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.deepOrange,
                              side: const BorderSide(color: Colors.deepOrange),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Clear Filters', style: TextStyle(fontSize: 16, fontFamily: 'Montserrat')),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() { // Update the main page's state
                                _selectedHashtags = tempSelectedHashtags;
                                _prepTimeRange = tempPrepTimeRange;
                                _cookTimeRange = tempCookTimeRange;
                              });
                              _applyFilters(); // Apply filters to the main list
                              Navigator.pop(context); // Close the bottom sheet
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
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

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      body: Column(
        children: [
          // Header section with title and search bar
          Container(
            height: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'What would you like to cook today?',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: textColor,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                           // Filter Icon Button
                          IconButton(
                            icon: const Icon(Icons.filter_list, color: Colors.white, size: 30),
                            onPressed: _showFilterBottomSheet,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          // This line was already using withAlpha, so the warning was likely a general deprecation hint
                          color: Colors.white.withAlpha((255 * 0.9).round()),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: _searchController, // Link controller
                          onChanged: _onSearchChanged,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Search recipes...',
                            hintStyle: TextStyle(color: Colors.grey[700]),
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Display current filter summary (optional but good for UX)
          if (_selectedHashtags.isNotEmpty ||
              _prepTimeRange.start > 0 || _prepTimeRange.end < 120 ||
              _cookTimeRange.start > 0 || _cookTimeRange.end < 120)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text('Active Filters: ', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                    ..._selectedHashtags.map((tag) => Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          _selectedHashtags.remove(tag);
                          _applyFilters();
                        });
                      },
                      backgroundColor: Colors.deepOrange.shade100, // Light background for chips
                      labelStyle: const TextStyle(color: Colors.deepOrange), // Dark text for chips
                      deleteIconColor: Colors.deepOrange, // Delete icon color
                    )),
                    // Display for Prep Time Range if not default
                    if (_prepTimeRange.start > 0 || _prepTimeRange.end < 120)
                      Chip(
                        label: Text('Prep: ${_prepTimeRange.start.round()}-${_prepTimeRange.end.round()} mins'),
                        onDeleted: () {
                          setState(() {
                            _prepTimeRange = const RangeValues(0, 120);
                            _applyFilters();
                          });
                        },
                         backgroundColor: Colors.deepOrange.shade100,
                         labelStyle: const TextStyle(color: Colors.deepOrange),
                         deleteIconColor: Colors.deepOrange,
                      ),
                    // Display for Cook Time Range if not default
                    if (_cookTimeRange.start > 0 || _cookTimeRange.end < 120)
                      Chip(
                        label: Text('Cook: ${_cookTimeRange.start.round()}-${_cookTimeRange.end.round()} mins'),
                        onDeleted: () {
                          setState(() {
                            _cookTimeRange = const RangeValues(0, 120);
                            _applyFilters();
                          });
                        },
                         backgroundColor: Colors.deepOrange.shade100,
                         labelStyle: const TextStyle(color: Colors.deepOrange),
                         deleteIconColor: Colors.deepOrange,
                      ),
                  ].expand((widget) => [widget, const SizedBox(width: 4)]).toList(), // Add spacing between chips
                ),
              ),
            ),

          // Results Count Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_filteredRecipes.length} results',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ),
          ),


          // Recipe list or "No recipes found" message
          Expanded(
            child: _filteredRecipes.isEmpty
                ? Center(
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
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _filteredRecipes[index];
                      final bool isFavorite = favoriteProvider.isFavorite(recipe.id);

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            try {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeDetailPage(recipe: recipe),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Unable to open recipe.')),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: Image.network(
                                    recipe.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback for asset images. If you're using network images primarily,
                                      // you might need to adjust your ImageProvider or handle asset images differently.
                                      // For local assets, you would typically use Image.asset('assets/images/your_image.jpg')
                                      // directly without Image.network.
                                      // Assuming your 'assets/images' are correctly configured in pubspec.yaml
                                      // and the paths in recipes_data.dart are correct relative to your project root.
                                      return Image.asset(
                                        recipe.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
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
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.grey.shade300,
                                      child: Icon(Icons.person,
                                          color: Colors.grey.shade700, size: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recipe.submittedBy,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat',
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            recipe.title,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat',
                                              color: textColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  recipe.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: brightness == Brightness.dark
                                        ? Colors.grey[400]
                                        : Colors.grey,
                                    fontFamily: 'Montserrat',
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        isFavorite ? Colors.red : Colors.grey,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    try {
                                      favoriteProvider
                                          .toggleFavorite(recipe.id);
                                    } catch (e) {
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