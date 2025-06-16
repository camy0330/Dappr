// lib/main_page.dart
import 'package:dappr/homepage/auth_page.dart'; // Assuming AuthPage is the logout target
import 'package:dappr/pages/about_page.dart';
import 'package:dappr/pages/favourite_page.dart';
import 'package:dappr/pages/meal_planner_page.dart';
import 'package:dappr/pages/rating_page.dart';
// Pages for Bottom Navigation Bar
import 'package:dappr/pages/recipe_list_page.dart';
import 'package:dappr/pages/setting_page.dart';
// Pages for Drawer (Sidebar Navigation)
import 'package:dappr/pages/shopping_list_page.dart';
import 'package:dappr/pages/timer_cooking_page.dart'; // Standardized to timer_cooking_page.dart
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Start on the first bottom nav page (Recipes List)

  final List<Widget> _bottomNavPages = [
    const RecipeListPage(), // Index 0
    const MealPlannerPage(), // Index 1
    const TimerCookingPage(), // Index 2 (Using TimerCookingPage name)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dappr', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat')),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _bottomNavPages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('John Doe', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat')),
              accountEmail: Text('john.doe@example.com', style: TextStyle(color: Colors.white70, fontFamily: 'Montserrat')),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.deepOrange),
              ),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.deepOrange),
              title: const Text('Shopping List', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShoppingListPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.deepOrange),
              title: const Text('Favorite Recipes', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavouritePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_rate, color: Colors.deepOrange),
              title: const Text('Rating and Review', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RatingPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.deepOrange),
              title: const Text('Settings', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.deepOrange),
              title: const Text('About', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: const Text('Logout', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () {
                // Navigate to AuthPage and clear navigation stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()), // Using AuthPage
                  (Route<dynamic> route) => false, // Clear all previous routes
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon for Recipes List (acting as "Home")
            label: 'Recipes', // Label changed to 'Recipes'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensure all items are visible
      ),
    );
  }
}
