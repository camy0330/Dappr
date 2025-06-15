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
    description: 'Spicy and delicious menu, suitable for dinner or lunch.',
    imageUrl: 'assets/images/nasi_goreng.jpg',
    cookTime: '15 minutes',
    prepTime: '25 minutes',
    ingredients: ['rice', 'egg', 'chicken', 'anchovies'],
    steps: ['Cook rice', 'Fry egg', 'Add anchovies'],
    submittedBy: 'Admin',
    category: 'Main Dish',
    tags: ['lunch', 'dinner', 'supper', 'rice'],
  ),
   Recipe(
    id: 'R2',
    title: 'Mamak Fried Noodles',
    description: 'Rich in spices and flavor.',
    imageUrl: 'assets/images/Mee_goreng_mamak.jpg',
    cookTime: '15 minutes',
    prepTime: '25 minutes',
    ingredients: ['noodles', 'egg', 'garlic', 'soy sauce'],
    steps: ['Blend ingredients', 'Stir fry', 'Serve'],
    submittedBy: 'Chef Mamak',
    category: 'Main Dish',
    tags: ['lunch', 'dinner', 'spicy', 'noodles'],
  ),
   Recipe(
    id: 'R3',
    title: 'Lace Pancakes',
    description: 'Traditional Malay dish, popular during Ramadan.',
    imageUrl: 'assets/images/roti_jala.jpg',
    cookTime: '10 minutes',
    prepTime: '20 minutes',
    ingredients: ['flour', 'egg', 'milk'],
    steps: ['Mix batter', 'Pour on pan', 'Fold'],
    submittedBy: 'Ayu',
    category: 'Main Dish',
    tags: ['dessert', 'supper', 'sidedish' , 'breakfast'],
 Recipe(
      id: 'R4',
      title: 'Spaghetti Aglio Olio Seafood',
      description: 'Italian-style spaghetti with a seafood touch.',
      imageUrl: 'assets/images/spaghetti_aglio_olio.jpg',
      cookTime: '10 minutes',
      prepTime: '20 minutes',
      ingredients: ['spaghetti', 'olive oil', 'garlic', 'shrimp', 'squid'],
      steps: ['Boil', 'Cook'],
      submittedBy: 'Chef Italia',
      category: 'Seafood',
      tags: ['lunch', 'dinner', 'seafood', 'noodles'],
    ),
    Recipe(
      id: 'R5',
      title: 'Thai Tomyam',
      description: 'Authentic Thai Tomyam, spicy and sour.',
      imageUrl: 'assets/images/tomyam_thai.jpg',
      cookTime: '25 minutes',
      prepTime: '40 minutes',
      ingredients: ['shrimp', 'squid', 'lemongrass', 'chilies', 'lime'],
      steps: ['Blend', 'Cook'],
      submittedBy: 'Thai Homecook',
      category: 'Seafood',
      tags: ['lunch', 'dinner', 'sidedish' 'seafood' 'spicy', 'soup'],
    ),
      Recipe(
      id: 'R6',
      title: 'Spiced Red Chicken',
      description: 'Chicken in spicy sambal sauce.',
      imageUrl: 'assets/images/ayam_masak_merah.jpg',
      cookTime: '20 minutes',
      prepTime: '20 minutes',
      ingredients: ['chicken', 'chili paste', 'garlic', 'onion'],
      steps: ['Fry', 'Sauté '],
      submittedBy: 'Mak Cik Siti',
      category: 'Chicken',
      tags: ['lunch', 'dinner', 'sidedish' 'chicken' 'spicy'],
     ),     
    Recipe(
    id: 'R7',
    title: 'Petai Prawn Sambal',
    description: 'Fresh prawns cooked with spicy sambal and fragrant petai beans.',
    imageUrl: 'assets/images/sambal_udang_simple.jpg',
    cookTime: '20 minutes',
    prepTime: '15 minutes',
    ingredients: ['prawns', 'petai', 'chili paste', 'onion', 'garlic', 'shrimp paste', 'tamarind'],
    steps: ['cook','cook'],
    submittedBy: 'Pak Ali',
    category: 'Seafood',
    tags: ['lunch', 'dinner', 'sidedish' 'prawn' 'spicy'],
  ),
  Recipe(
    id: 'R8',
    title: 'Simple Chicken Soup',
    description: 'Light chicken soup suitable for a healthy meal.',
    imageUrl: 'assets/images/sup_ayam_simple.jpg',
    cookTime: '15 minutes',
    prepTime: '20 minutes',
    ingredients: ['chicken', 'potato', 'carrot', 'garlic', 'shallot', 'ginger', 'celery'],
    steps: ['cook','stir'],
    submittedBy: 'Dr. Lim',
    category: 'Soup',
    tags: ['lunch', 'dinner', 'sidedish' 'chicken' 'spicy', 'soup','vegetable'],
  ),
    Recipe(
      id: 'R9',
      title: 'Grilled Fish with Sambal',
      description: 'Grilled fish with spicy sambal...',
      imageUrl: 'assets/images/ikan_bakar.jpg',
      cookTime: '15 minutes',
      prepTime: '20 minutes',
      ingredients: ['fish', 'tamarind juice', 'chili', 'ginger'],
      steps: ['Blend sambal', 'Grill fish', 'Serve'],
      submittedBy: 'IkanMan',
      category: 'Seafood',
      tags: ['lunch', 'dinner', 'sidedish' 'fish' 'spicy'],
  ),
Recipe(
      id: 'R10',
      title: 'Nasi Lemak',
      description: 'Fragrant coconut milk rice',
      imageUrl: 'assets/images/nasi_lemak.jpg',
      cookTime: '25 minutes',
      prepTime: '30 minutes',
      ingredients: ['rice', 'coconut milk', 'anchovies', 'peanuts'],
      steps: ['Cook rice', 'Prepare sambal', 'Serve'],
      submittedBy: 'Mak Long',
      category: 'Malaysian',
      tags: ['breakfast','lunch', 'dinner', 'spicy', 'brunch', 'coconut', 'rice'],

  Recipe(
      id: 'R11',
      title: 'Laksa',
      description: 'A spicy noodle soup with rich coconut milk and tangy tamarind flavor.',
      imageUrl: 'assets/images/laksa.jpg',
      cookTime: '20 minutes',
      prepTime: '25 minutes',
      ingredients: ['200g rice noodles', '200ml coconut milk', '2 tbsp laksa paste', '100g cooked chicken, shredded', '100g prawns, peeled', 'Bean sprouts', 'Boiled eggs, halved', 'Fresh coriander', 'Lime wedges',],
      steps: [],
      submittedBy: 'Penangite',
      category: 'Soup',
      tags: ['breakfast','lunch', 'dinner', 'spicy', 'brunch', 'cocunut', 'noodles'],
    ),
    Recipe(
      id: 'R12',
      title: 'Fried Chicken',
      description: 'Crispy fried chicken with fragrant spices.',
      imageUrl: 'assets/images/ayam_goreng.jpg',
      cookTime: '12 minutes',
      prepTime: '15 minutes',
      ingredients: ['1 whole chicken, cut into pieces', '2 tbsp turmeric powder', '1 tbsp garlic paste', '1 tsp salt', 'Oil for frying',],
      steps: ['deep fry'],
      submittedBy: 'Chef Ayam',
      category: 'Main',
      tags: ['breakfast','lunch', 'dinner', 'brunch', 'fried', 'chicken', 'fried'],
    )
      Recipe(
      id: 'R13',
      title: 'Layered Cake',
      description: 'Colorful layered steamed cake made from rice flour and coconut milk.',
      imageUrl: 'assets/images/kuih_lapis.jpg',
      cookTime: '30 minutes',
      prepTime: '20 minutes',
      ingredients: ['rice flour', 'sugar', 'coconut milk', 'food coloring', 'pandan'],
      steps: ['steam'],
      submittedBy: 'Kak Lapis',
      category: 'Dessert',
      tags: ['breakfast', 'brunch', 'desset', 'sidedish', 'steam', 'cake'],
    ),
    Recipe(
      id: 'R14',
      title: 'Teh Tarik',
      description: 'Traditional Malaysian pulled tea with creamy froth.',
      imageUrl: 'assets/images/teh_tarik.jpg',
      cookTime: '5 minutes',
      prepTime: '5 minutes',
      ingredients: ['tea', 'condensed milk', 'evaporated milk'],
      steps: [],
      submittedBy: 'Pak Teh',
      category: 'Drink',
      tags: ['breakfast','lunch', 'dinner', 'brunch', 'drink', 'sugar' 'tea', 'condensed milk', 'evaporated milk'],
    ),
    Recipe(
      id: 'R15',
      title: 'Carrot Susu',
      description: 'Sweet and refreshing carrot milk drink.',
      imageUrl: 'assets/images/carrot_susu.jpg',
      cookTime: '5 minutes',
      prepTime: '5 minutes',
      ingredients: ['carrot', 'milk', 'sugar', 'ice'],
      steps: [],
      submittedBy: 'JuiceQueen',
      category: 'Drink',
      tags: ['breakfast','lunch', 'dinner', 'brunch', 'supper', 'drink', 'sugar' 'carrot', 'milk', 'ice'], 
    ),
  Recipe(
  id: 'R16',
  title: 'Fish Soup',
  description: 'Light and flavorful fish soup with vegetables and herbs.',
  imageUrl: 'assets/images/sup_ikan.jpg',
  cookTime: '15 minutes',
  prepTime: '20 minutes',
  ingredients: [ 'fish fillets', 'water','garlic', 'ginger', 'carrot', 'celery', 'salt', 'pepper', 'coriander'],
  steps: ['Boil water with garlic and ginger to make broth.', 'Add carrot and celery, cook until tender.', 'Add fish fillets and cook until done.', 'Season with salt and pepper.', 'Garnish with fresh coriander before serving.'],
  submittedBy: 'Chef Ikan',
  category: 'Soup',
  tags: ['breakfast','lunch', 'dinner', 'brunch', 'soup', 'fish', 'spicy' 'vegetable',], 
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
    'breakfast', 'lunch', 'dinner', 'sidedish', 'fish', 'drink', 'sugar' 'carrot', 'milk', 'ice', 'tea', 'condensed milk', 'evaporated milk', 'chicken', 'fish', 'prawn', 'steam', 'cake',
    'dessert', 'soup', 'supper', 'brunch', 'vegetable', 'spicy', 'fried', 'cocunut', 'noodles', 'rice' 
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
