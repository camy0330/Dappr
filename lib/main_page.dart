import 'package:flutter/material.dart';
import 'pages/recipe_list_page.dart';

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
              leading: const Icon(Icons.food_bank),
              title: const Text('Meal Planner'),
              onTap: () => _onSelectDrawerItem(2),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favourite'),
              onTap: () => _onSelectDrawerItem(3),
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Timer Cooking'),
              onTap: () => _onSelectDrawerItem(4),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () => _onSelectDrawerItem(5),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => _onSelectDrawerItem(6),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 1 ? 0 : _selectedIndex,
        onTap: (index) {
          if (index < 2) _onItemTapped(index);
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
            label: 'Shopping List',
          ),
        ],
      ),
    );
  }
}

// Placeholder Pages
class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("This is Shopping List Page"));
}

class MealPlannerPage extends StatelessWidget {
  const MealPlannerPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("This is Meal Planner Page"));
}

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("This is Favourite Page"));
}

class TimerCookingPage extends StatelessWidget {
  const TimerCookingPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("This is Timer Cooking Page"));
}

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("This is Setting Page"));
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("This is About Page"));
}
