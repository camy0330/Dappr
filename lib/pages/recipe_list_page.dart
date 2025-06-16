import 'package:dappr/data/recipes_data.dart'; // Make sure this provides 'recipes' List<Recipe>
import 'package:dappr/models/recipe.dart'; // Make sure Recipe model has an 'id' field
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

  @override
  void initState() {
    super.initState();
    try {
      // Initialize _filteredRecipes with the full list of recipes
      _filteredRecipes = recipes;

      // Fallback UI if no recipe data is loaded
      if (_filteredRecipes.isEmpty) {
        // Using addPostFrameCallback to ensure SnackBar is shown after widget has been built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No recipe data available.')),
          );
        });
      }
    } catch (e) {
      // Show general error if initial loading fails
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading recipe data.')),
        );
      });
    }
  }

  // Filter recipes based on search input query
  void _onSearchChanged(String query) {
    try {
      setState(() {
        if (query.isEmpty) {
          // If query is empty, show all recipes
          _filteredRecipes = recipes;
        } else {
          // Filter recipes by title or description (case-insensitive)
          _filteredRecipes = recipes
              .where((recipe) =>
                  recipe.title.toLowerCase().contains(query.toLowerCase()) ||
                  recipe.description.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      });
    } catch (e) {
      // If search filtering causes an error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Search failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the FavoriteProvider to check favorite status
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    // Determine current brightness (light/dark mode) for adaptive text colors
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
               colors: [Colors.deepOrange, Colors.orangeAccent], // Gradient warna yang diminta
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ), // Solid color background for the header
            child: Stack(
              children: [
                // White line at the top (under the AppBar implicitly)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    color: Colors.white,
                  ),
                ),
                // Header content: title and search field
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What would you like to cook today?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: textColor, // Adaptive text color
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      // Search field container with rounded corners and subtle background
                      Container(
                        decoration: BoxDecoration(
                          // FIX: Replaced withOpacity with withAlpha for direct alpha control
                          color: Colors.white.withAlpha((255 * 0.9).round()),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          onChanged: _onSearchChanged, // Calls the filter method on text change
                          style: const TextStyle(color: Colors.black), // Text input color
                          decoration: InputDecoration(
                            hintText: 'Search recipes...',
                            hintStyle: TextStyle(color: Colors.grey[700]), // Hint text color
                            border: InputBorder.none, // No default border for text field
                            icon: Icon(Icons.search, color: Colors.grey[700]), // Search icon
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Spacing below search field
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Recipe list or "No recipes found" message
          Expanded(
            child: _filteredRecipes.isEmpty
                ? Center(
                    child: Text(
                      'No recipes found. Try a different search.',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        color: textColor, // Adaptive text color
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      // Responsive grid: 2 columns for smaller screens, 3 for larger
                      crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.8, // Aspect ratio of each grid item
                    ),
                    itemCount: _filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _filteredRecipes[index];
                      // Check if the current recipe is a favorite
                      final bool isFavorite = favoriteProvider.isFavorite(recipe.id);

                      return Card(
                        elevation: 4, // Card shadow
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)), // Rounded card corners
                        clipBehavior: Clip.antiAlias, // Ensures content is clipped to card shape
                        child: InkWell(
                          onTap: () {
                            try {
                              // Navigate to the RecipeDetailPage when card is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeDetailPage(recipe: recipe), // Pass the selected recipe
                                ),
                              );
                            } catch (e) {
                              // If navigation fails (e.g., RecipeDetailPage not set up correctly)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Unable to open recipe.')),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Recipe image
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15)), // Rounded top corners for image
                                  child: Image.network( // Using Image.network for external URLs
                                    recipe.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback for image loading errors
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image,
                                            color: Colors.grey, size: 50),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10), // Spacing between image and text content
                              // Submitter info and title
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                child: Row(
                                  children: [
                                    // Avatar placeholder
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
                                              color: textColor, // Adaptive text color
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
                              // Description (optional, can be removed for compactness)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  recipe.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: brightness == Brightness.dark
                                        ? Colors.grey[400]
                                        : Colors.grey, // Adaptive text color
                                    fontFamily: 'Montserrat',
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Favorite button aligned to the bottom right
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
                                          .toggleFavorite(recipe.id); // Toggle favorite status
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
