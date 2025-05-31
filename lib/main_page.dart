import 'package:flutter/material.dart';
import 'pages/recipe_list_page.dart';
import 'pages/shopping_list_page.dart';
import 'pages/meal_planner_page.dart';
import 'pages/favourite_page.dart';
import 'pages/timer_cooking_page.dart';
import 'pages/setting_page.dart';
import 'pages/about_page.dart';
import 'pages/recipe_search_page.dart'; // Pastikan import ini betul

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const RecipeListPage(),
    const ShoppingListPage(),
    const RecipeSearchPage(), // Tambah di sini
    const MealPlannerPage(),
    const FavouritePage(),
    const TimerCookingPage(),
    const SettingPage(),
    const AboutPage(),
  ];

  final Color primaryColor = Colors.deepOrange.shade400;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSelectDrawerItem(int index) {
    Navigator.pop(context);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Recipes'),
              onTap: () => _onSelectDrawerItem(0),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Shopping List'),
              onTap: () => _onSelectDrawerItem(1),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () => _onSelectDrawerItem(2),
            ),
            ListTile(
              leading: const Icon(Icons.food_bank),
              title: const Text('Meal Planner'),
              onTap: () => _onSelectDrawerItem(3),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favourite'),
              onTap: () => _onSelectDrawerItem(4),
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Timer Cooking'),
              onTap: () => _onSelectDrawerItem(5),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () => _onSelectDrawerItem(6),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => _onSelectDrawerItem(7),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 2 ? 0 : _selectedIndex,
        onTap: (index) {
          if (index < 3) _onItemTapped(index);
        },
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shopping',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}
