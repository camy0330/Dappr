// lib/main.dart
// Import the pages that will be used in routes
import 'package:dappr/pages/about_page.dart';
import 'package:dappr/pages/setting_page.dart';
import 'package:dappr/pages/timer_cooking_page.dart';
import 'package:dappr/providers/favorite_provider.dart';
import 'package:dappr/providers/rating_provider.dart';
import 'package:dappr/theme_notifier.dart';
import 'package:dappr/welcome_page/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

var logger = Logger();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => RatingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Dappr Recipe App',
          // Define your light theme
          theme: ThemeData(
            useMaterial3: true, // Enable Material 3
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Montserrat',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            brightness: Brightness.light,

            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              secondary: Colors.amber,
              onSecondary: Colors.black,
              surface: Colors.white, // Color for surfaces like cards, dialogs
              onSurface: Colors.black87, // Color for content on surface
              // 'background' and 'onBackground' are deprecated; use 'surface' and 'onSurface'
              // or rely on ThemeData.scaffoldBackgroundColor for the main screen background.
              error: Colors.red,
              onError: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.white, // Explicitly set scaffold background for light theme
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 96, color: Colors.black87),
              headlineMedium: TextStyle(fontSize: 32, color: Colors.black87),
              titleLarge: TextStyle(fontSize: 18, color: Colors.black87),
              bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
              bodyMedium: TextStyle(color: Colors.black54),
              bodySmall: TextStyle(fontSize: 12, color: Colors.black45),
              labelLarge: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          // Define your dark theme
          darkTheme: ThemeData(
            useMaterial3: true, // Enable Material 3
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Montserrat',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            brightness: Brightness.dark,

            colorScheme: ColorScheme.dark(
              primary: Colors.deepOrange.shade700,
              onPrimary: Colors.white,
              secondary: Colors.amberAccent,
              onSecondary: Colors.black,
              surface: Colors.grey.shade800, // Color for surfaces like cards, dialogs in dark theme
              onSurface: Colors.white70, // Color for content on surface in dark theme
              // 'background' and 'onBackground' are deprecated; use 'surface' and 'onSurface'
              // or rely on ThemeData.scaffoldBackgroundColor for the main screen background.
              error: Colors.red.shade400,
              onError: Colors.black,
            ),
            scaffoldBackgroundColor: Colors.grey.shade900, // Explicitly set scaffold background for dark theme
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 96, color: Colors.white70),
              headlineMedium: TextStyle(fontSize: 32, color: Colors.white70),
              titleLarge: TextStyle(fontSize: 18, color: Colors.white70),
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
              bodySmall: TextStyle(fontSize: 12, color: Colors.white38),
              labelLarge: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          themeMode: themeNotifier.themeMode,
          home: const WelcomePage(),
          debugShowCheckedModeBanner: false,
          routes: {
            '/about': (context) => const AboutPage(),
            '/timer': (context) => const TimerCookingPage(),
            '/settings': (context) => const SettingPage(),
          },
        );
      },
    );
  }
}
