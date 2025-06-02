// lib/main_page.dart
<<<<<<< Updated upstream
import 'package:dappr/homepage/auth_page.dart'; // Correct path for AuthPage
import 'package:dappr/pages/about_page.dart'; // Correct path
import 'package:dappr/pages/favourite_page.dart'; // Correct path
import 'package:dappr/pages/home_page.dart'; // Corrected import for home_page.dart
import 'package:dappr/pages/meal_planner_page.dart'; // Correct path
import 'package:dappr/pages/recipe_list_page.dart'; // Correct path
import 'package:dappr/pages/setting_page.dart'; // Correct path
import 'package:dappr/pages/shopping_list_page.dart'; // Correct path
import 'package:dappr/pages/timer_cooking_page.dart'; // Corrected import for timer_cooking_page.dart
import 'package:flutter/material.dart';
=======
import 'package:flutter/material.dart';
// Pages for Bottom Navigation Bar
import 'package:dappr/pages/recipe_list_page.dart';
import 'package:dappr/pages/meal_planner_page.dart';
import 'package:dappr/pages/cooking_timer_page.dart';

// Pages for Drawer (Sidebar Navigation)
import 'package:dappr/pages/shopping_list_page.dart';
import 'package:dappr/pages/favourite_page.dart';
import 'package:dappr/pages/setting_page.dart';
import 'package:dappr/pages/about_page.dart';
import 'package:dappr/welcome_page/welcome_page.dart'; // <--- THIS IMPORT IS CRUCIAL
// Based on image_bfd3d5.png, welcome_page.dart is directly under lib/welcome_page/
>>>>>>> Stashed changes

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1; // Starting on Recipes page

  final List<Widget> _bottomNavPages = [
<<<<<<< Updated upstream
    const HomePage(),
    const RecipeListPage(),
    const MealPlannerPage(),
    const TimerCookingPage(),
=======
    const RecipeListPage(),
    const MealPlannerPage(),
    const CookingTimerPage(),
>>>>>>> Stashed changes
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
                Navigator.pop(context);
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavouritePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.deepOrange),
              title: const Text('Settings', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () {
                Navigator.pop(context);
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
                Navigator.pop(context);
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
<<<<<<< Updated upstream
                // Navigate to AuthPage and clear navigation stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
=======
                // This is the line causing the error:
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()), // <--- Check this line
>>>>>>> Stashed changes
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
<<<<<<< Updated upstream
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
=======
>>>>>>> Stashed changes
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}