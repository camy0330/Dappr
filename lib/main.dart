// lib/main.dart
// Import the pages that will be used in routes
import 'package:dappr/pages/about_page.dart';
import 'package:dappr/pages/setting_page.dart';
import 'package:dappr/pages/timer_cooking_page.dart'; // Corrected import for timer_cooking_page.dart
import 'package:dappr/providers/favorite_provider.dart';
import 'package:dappr/theme_notifier.dart'; // Import your ThemeNotifier
import 'package:dappr/welcome_page/welcome_page.dart'; // Ensure this path is correct
import 'package:flutter/material.dart';
import 'package:logger/logger.dart'; // Keep logger import if you are using the package
import 'package:provider/provider.dart';

var logger = Logger(); // Keep logger initialization if you use it

void main() {
  runApp(
    MultiProvider( // Use MultiProvider to manage multiple providers
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()), // Add ThemeNotifier
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer listens to changes in ThemeNotifier and rebuilds MaterialApp when themeMode changes
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Dappr Recipe App', // From Updated upstream
          // Define your light theme
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Montserrat', // Ensure this font is correctly loaded in pubspec.yaml
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            brightness: Brightness.light, // Explicitly define light theme brightness
            // Add other light theme specific properties here if needed
          ),
          // Define your dark theme
          darkTheme: ThemeData(
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Montserrat',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white, // Or a suitable color for dark mode app bar
            ),
            brightness: Brightness.dark, // Explicitly define dark theme brightness
            scaffoldBackgroundColor: Colors.grey[900], // Dark background for scaffold
            cardColor: Colors.grey[850], // Darker card background
            textTheme: const TextTheme( // Made const
              bodyLarge: TextStyle(color: Colors.white), // Default text color for dark mode
              bodyMedium: TextStyle(color: Colors.white70),
              titleLarge: TextStyle(color: Colors.white),
              // Add other text styles as needed for dark mode
            ),
            // Add other dark theme specific properties here
          ),
          themeMode: themeNotifier.themeMode, // Use the theme mode from ThemeNotifier
          home: const WelcomePage(), // Using WelcomePage as the initial route
          debugShowCheckedModeBanner: false, // From Stashed changes (good practice)
          // Define your app's routes
          routes: {
            '/about': (context) => const AboutPage(),
            '/timer': (context) => const TimerCookingPage(),
            '/settings': (context) => const SettingPage(),
            // Add other routes as needed
          },
        );
      },
    );
  }
}
