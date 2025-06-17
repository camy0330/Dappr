// lib/pages/setting_page.dart
import 'package:dappr/pages/about_page.dart'; // Assuming you have an AboutPage
import 'package:dappr/providers/favorite_provider.dart';
import 'package:dappr/providers/rating_provider.dart'; // Correctly imported
import 'package:dappr/providers/shopping_list_provider.dart';
import 'package:dappr/theme_notifier.dart'; // Import your ThemeNotifier
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isSoundEnabled = true; // Default state for notification sound
  bool _isDarkModeEnabled = false; // State for theme mode switch

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoundEnabled = prefs.getBool('setting_notification_sound') ?? true;
      // Initialize _isDarkModeEnabled based on current themeMode from ThemeNotifier
      _isDarkModeEnabled =
          Provider.of<ThemeNotifier>(context, listen: false).themeMode == ThemeMode.dark;
    });
  }

  Future<void> _toggleSound(bool value) async {
    setState(() {
      _isSoundEnabled = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setting_notification_sound', value);
    // You might want to notify the timer page about this change if it's running
    // For now, it will just load this preference when the timer page is initialized.
  }

  Future<void> _toggleTheme(bool value) async {
    setState(() {
      _isDarkModeEnabled = value;
    });
    Provider.of<ThemeNotifier>(context, listen: false).toggleTheme(value);
  }

  Future<void> _clearAllData() async {
    // Show confirmation dialog before clearing
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Clear Data', style: TextStyle(fontFamily: 'Montserrat')),
          content: const Text(
              'Are you sure you want to clear all app data (including saved timer states and favorites)? This action cannot be undone.',
              style: TextStyle(fontFamily: 'Montserrat')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(fontFamily: 'Montserrat', color: Colors.deepOrange)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Use red for destructive action
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Clear', style: TextStyle(fontFamily: 'Montserrat')),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clears all key-value pairs

      // Reset local states to default after clearing
      setState(() {
        _isSoundEnabled = true;
        _isDarkModeEnabled = false; // Reset theme to light/system default
      });

      // Also reset theme in ThemeNotifier to system default
      Provider.of<ThemeNotifier>(context, listen: false).setSystemTheme();

      // Call the new public method to clear favorites
      Provider.of<FavoriteProvider>(context, listen: false).clearAllFavorites();
      // Clear shopping list
      Provider.of<ShoppingListProvider>(context, listen: false).clearAll();
      // Clear user ratings
      // This line is now correct because clearAllRatings() exists in RatingProvider
      Provider.of<RatingProvider>(context, listen: false).clearAllRatings();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All data cleared!', style: TextStyle(fontFamily: 'Montserrat')),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent], // Your gradient colors
              begin: Alignment.topLeft, // Adjust the start direction as needed
              end: Alignment.bottomRight, // Adjust the end direction as needed
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Mode Setting
          SwitchListTile(
            title: const Text('Dark Mode', style: TextStyle(fontFamily: 'Montserrat')),
            subtitle: const Text('Toggle between light and dark themes', style: TextStyle(fontFamily: 'Montserrat')),
            value: _isDarkModeEnabled,
            onChanged: _toggleTheme,
            activeColor: Colors.deepOrange,
          ),
          const Divider(),
          // Notification Sound Setting
          SwitchListTile(
            title: const Text('Notification Sound', style: TextStyle(fontFamily: 'Montserrat')),
            subtitle: const Text('Enable or disable timer completion sound', style: TextStyle(fontFamily: 'Montserrat')),
            value: _isSoundEnabled,
            onChanged: _toggleSound,
            activeColor: Colors.deepOrange,
          ),
          const Divider(),
          // About Page Link
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.deepOrange),
            title: const Text('About Dappr', style: TextStyle(fontFamily: 'Montserrat')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          const Divider(),
          // Placeholder for Privacy Policy
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: Colors.deepOrange),
            title: const Text('Privacy Policy', style: TextStyle(fontFamily: 'Montserrat')),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy Policy page coming soon!', style: TextStyle(fontFamily: 'Montserrat')),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(),
          const SizedBox(height: 20),
          // Clear All Data Button
          ElevatedButton.icon(
            onPressed: _clearAllData,
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            label: const Text(
              'Clear All Data',
              style: TextStyle(fontSize: 16, fontFamily: 'Montserrat', color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'App Version: 1.0.0', // You might get this from package_info_plus in a real app
              style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Montserrat'),
            ),
          ),
        ],
      ),
    );
  }
}