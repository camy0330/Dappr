import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CARD IMAGE & TITLE
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE & BACK BUTTON
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                          child: Image.network(
                            recipe.imageUrl,
                            width: double.infinity,
                            height: 240,
                            fit: BoxFit.contain,  // <-- changed here
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: CircleAvatar(
                            backgroundColor: Colors.white70,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // TITLE & ID
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'ID: ${recipe.id}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // INGREDIENTS TITLE
              Text(
                'Ingredients',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepOrange[400],
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 12),

              // INGREDIENTS LIST
              ...recipe.ingredients.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ',
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.4,
                          )),
                      Expanded(
                        child: Text(
                          item,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              const Divider(thickness: 1.2),
              const SizedBox(height: 24),

              // COOKING STEPS TITLE
              Text(
                'Cooking Steps',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepOrange[400],
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 12),

              // COOKING STEPS LIST
              ...recipe.steps.asMap().entries.map(
                (entry) {
                  int idx = entry.key + 1;
                  String step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      '$idx. $step',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
