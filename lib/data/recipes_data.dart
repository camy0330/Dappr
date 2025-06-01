// lib/data/recipes_data.dart
import 'package:dappr/models/recipe.dart';

const List<Recipe> recipes = [
  Recipe(
    id: 'r1',
    title: 'Spaghetti Carbonara',
    description: 'A classic Italian pasta dish with eggs, hard cheese, cured pork, and black pepper.',
    imageUrl: 'assets/images/carbonara.jpg',
    ingredients: [
      '200g spaghetti',
      '100g pancetta or guanciale',
      '2 large eggs',
      '50g Pecorino Romano cheese',
      'Black pepper',
      'Salt'
    ],
    steps: [
      'Cook spaghetti according to package instructions.',
      'While spaghetti cooks, finely chop pancetta and cook in a pan until crispy.',
      'In a bowl, whisk eggs, grated cheese, and a generous amount of black pepper.',
      'Drain spaghetti, reserving some pasta water. Add hot spaghetti to the pan with pancetta (off heat).',
      'Pour egg mixture over spaghetti, tossing quickly to coat. Add a little pasta water if needed to create a creamy sauce.',
      'Serve immediately, garnished with more cheese and black pepper.'
    ],
    category: 'Dinner',
    durationMinutes: 25,
  ),
  Recipe(
    id: 'r2',
    title: 'Classic Pancakes',
    description: 'Fluffy pancakes perfect for a sweet breakfast or brunch.',
    imageUrl: 'assets/images/pancakes.jpg',
    ingredients: [
      '1.5 cups all-purpose flour',
      '3.5 tsp baking powder',
      '1 tsp salt',
      '1 tbsp white sugar',
      '1.25 cups milk',
      '1 egg',
      '3 tbsp melted butter'
    ],
    steps: [
      'In a large bowl, sift together flour, baking powder, salt, and sugar.',
      'In a separate bowl, whisk together milk, egg, and melted butter.',
      'Pour the wet ingredients into the dry ingredients and mix until just combined (lumps are okay).',
      'Heat a lightly oiled griddle or frying pan over medium-high heat.',
      'Pour 1/4 cup of batter per pancake onto the griddle.',
      'Cook for 2-3 minutes per side, until golden brown and cooked through.',
      'Serve warm with your favorite toppings.'
    ],
    category: 'Breakfast',
    durationMinutes: 20,
  ),
  Recipe(
    id: 'r3',
    title: 'Chicken Stir-fry',
    description: 'Quick and healthy stir-fry with tender chicken and crisp vegetables.',
    imageUrl: 'assets/images/stirfry.jpg',
    ingredients: [
      '2 chicken breasts, sliced',
      '1 tbsp soy sauce',
      '1 tbsp oyster sauce',
      '1 tsp sesame oil',
      '1/2 head broccoli, florets',
      '1 bell pepper, sliced',
      '1 onion, sliced',
      '2 cloves garlic, minced',
      '1 tbsp ginger, grated',
      'Cooking oil'
    ],
    steps: [
      'In a small bowl, mix soy sauce, oyster sauce, and sesame oil. Set aside.',
      'Heat oil in a large skillet or wok over medium-high heat. Add chicken and stir-fry until cooked through.',
      'Remove chicken and set aside. Add onion, bell pepper, and broccoli to the wok and stir-fry for 3-5 minutes until tender-crisp.',
      'Add garlic and ginger and stir-fry for 1 minute more until fragrant.',
      'Return chicken to the wok. Pour in the sauce and toss to coat all ingredients.',
      'Serve hot with rice or noodles.'
    ],
    category: 'Dinner',
    durationMinutes: 30,
  ),
  Recipe(
    id: 'r4',
    title: 'Fruit Smoothie',
    description: 'A refreshing and healthy fruit smoothie, perfect for any time of day.',
    imageUrl: 'assets/images/smoothie.jpg',
    ingredients: [
      '1 banana',
      '1 cup mixed berries (frozen)',
      '1/2 cup Greek yogurt',
      '1/2 cup milk (or almond milk)',
      '1 tbsp honey (optional)'
    ],
    steps: [
      'Combine all ingredients in a blender.',
      'Blend until smooth and creamy.',
      'Pour into a glass and enjoy immediately.'
    ],
    category: 'Beverage',
    durationMinutes: 5,
  ),
];