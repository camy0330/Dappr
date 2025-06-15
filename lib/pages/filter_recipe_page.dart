import 'package:flutter/material.dart';

// === Simple Recipe Model === //
class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String cookTime;
  final String prepTime;
  final List<String> ingredients;
  final List<String> steps;
  final String submittedBy;
  final String category;
  final List<String> tags;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cookTime,
    required this.prepTime,
    required this.ingredients,
    required this.steps,
    required this.submittedBy,
    required this.category,
    required this.tags,
  });
}

// === Sample Recipe Data === //
final List<Recipe> recipes = [
  Recipe(
    id: 'R1',
    title: 'Village Fried Rice',
    description: 'Spicy and delicious, perfect for lunch or dinner.',
    imageUrl: 'assets/images/nasi_goreng.jpg',
    cookTime: '15 minutes',
    prepTime: '25 minutes',
    ingredients: ['rice', 'egg', 'chicken', 'anchovies', 'soy sauce', 'garlic'],
    steps: ['Step 1', 'Step 2', 'Step 3'],
    submittedBy: 'Admin',
    category: 'Main Dish',
    tags: ['lunch', 'dinner', 'sidedish'],
  ),
  // Add more recipes if needed
];

// === Main App Entry === //
void main() {
  runApp(MaterialApp(
    home: RecipeFilterPage(),
    debugShowCheckedModeBanner: false,
  ));
}

// === Full Filter UI === //
class RecipeFilterPage extends StatefulWidget {
  @override
  _RecipeFilterPageState createState() => _RecipeFilterPageState();
}

class _RecipeFilterPageState extends State<RecipeFilterPage> {
  String searchQuery = '';
  List<String> selectedIngredients = [];
  String? selectedCategory;
  List<String> selectedTags = [];

  final List<String> allTags = [
    'breakfast', 'lunch', 'dinner', 'sidedish',
    'dessert', 'soup', 'supper', 'brunch', 'vegetable'
  ];

  List<String> get allIngredients {
    final Set<String> ingredientsSet = {};
    for (var recipe in recipes) {
      ingredientsSet.addAll(recipe.ingredients.map((e) => e.toLowerCase()));
    }
    return ingredientsSet.toList()..sort();
  }

  List<String> get allCategories {
    final Set<String> categorySet = {};
    for (var recipe in recipes) {
      categorySet.add(recipe.category);
    }
    return categorySet.toList()..sort();
  }

  List<Recipe> get filteredRecipes {
    return recipes.where((recipe) {
      final matchesSearch = searchQuery.isEmpty ||
          recipe.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          recipe.ingredients.any((ingredient) =>
              ingredient.toLowerCase().contains(searchQuery.toLowerCase()));

      final matchesIngredients = selectedIngredients.isEmpty ||
          selectedIngredients.every((selected) =>
              recipe.ingredients.map((e) => e.toLowerCase()).contains(selected));

      final matchesCategory = selectedCategory == null ||
          recipe.category.toLowerCase() == selectedCategory!.toLowerCase();

      final matchesTags = selectedTags.isEmpty ||
          selectedTags.every((tag) => recipe.tags.contains(tag));

      return matchesSearch && matchesIngredients && matchesCategory && matchesTags;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filter Recipes')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🔍 Text Search
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value.toLowerCase());
              },
            ),
            SizedBox(height: 12),

            // ✅ Ingredient Checkboxes
            ExpansionTile(
              title: Text('Filter by Ingredients'),
              children: allIngredients.map((ingredient) {
                return CheckboxListTile(
                  title: Text(ingredient),
                  value: selectedIngredients.contains(ingredient),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedIngredients.add(ingredient);
                      } else {
                        selectedIngredients.remove(ingredient);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 10),

            // 🍽 Category Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              value: selectedCategory,
              items: allCategories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) => setState(() => selectedCategory = value),
            ),
            SizedBox(height: 10),

            // 🏷️ Tags/Meal Types (Chips)
            Wrap(
              spacing: 6,
              children: allTags.map((tag) {
                final isSelected = selectedTags.contains(tag);
                return FilterChip(
                  label: Text('#$tag'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      isSelected
                          ? selectedTags.remove(tag)
                          : selectedTags.add(tag);
                    });
                  },
                  selectedColor: Colors.green.shade300,
                  checkmarkColor: Colors.white,
                );
              }).toList(),
            ),
            SizedBox(height: 10),

            // Filtered List
            Expanded(
              child: filteredRecipes.isEmpty
                  ? Center(child: Text('No recipes match your filters.'))
                  : ListView.builder(
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];
                        return Card(
                          child: ListTile(
                            leading: Image.asset(recipe.imageUrl,
                                width: 50, height: 50, fit: BoxFit.cover),
                            title: Text(recipe.title),
                            subtitle: Text(
                                '${recipe.category} • ${recipe.cookTime}'),
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
