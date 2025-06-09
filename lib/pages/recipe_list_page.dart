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

  @override
  void initState() {
    super.initState();
    try {
      _filteredRecipes = recipes;

      // Fallback UI jika tiada data resepi
      if (_filteredRecipes.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tiada data resepi tersedia.')),
          );
        });
      }
    } catch (e) {
      // Tunjuk ralat umum jika berlaku masalah semasa load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ralat memuat data resepi.')),
        );
      });
    }
  }

  // Filter resepi berdasarkan input carian
  void _onSearchChanged(String query) {
    try {
      setState(() {
        if (query.isEmpty) {
          _filteredRecipes = recipes;
        } else {
          _filteredRecipes = recipes
              .where((recipe) =>
                  recipe.title.toLowerCase().contains(query.toLowerCase()) ||
                  recipe.description.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      });
    } catch (e) {
      // Jika berlaku ralat semasa cari
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Carian gagal. Sila cuba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      body: Column(
        children: [
          // Header dengan carian
          Container(
            height: 160,
            child: Stack(
              children: [
                // Latar belakang gradient
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepOrange.shade700,
                        Colors.deepOrange.shade400,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Kandungan header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What would you like to cook today?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: textColor,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      // Ruangan carian
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
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

          // Senarai resepi atau mesej tiada
          Expanded(
            child: _filteredRecipes.isEmpty
                ? Center(
                    child: Text(
                      'No recipes found. Try a different search.',
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
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
                              // Cuba navigasi ke halaman detail
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeDetailPage(recipe: recipe),
                                ),
                              );
                            } catch (e) {
                              // Jika navigasi gagal
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Tidak dapat buka resepi.')),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Gambar resepi
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: Image.asset(
                                    recipe.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Tangani ralat gambar rosak
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image,
                                            color: Colors.grey, size: 50),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Tajuk & deskripsi
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                        color: textColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
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
                                  ],
                                ),
                              ),
                              // Butang kegemaran
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
                                                'Gagal kemas kini kegemaran.')),
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
