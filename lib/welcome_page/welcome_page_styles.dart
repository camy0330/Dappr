import 'package:flutter/material.dart';

class WelcomePageStyles {
  static const Color primaryYellow = Color(0xFFFFC107); // Amber
  static const Color primaryOrange = Color(0xFFFB8C00); // Orange 700

  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryYellow, primaryOrange],
  );

  static const TextStyle headlineStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 2.0,
    // fontFamily: 'Montserrat', // Uncomment if you add the font in pubspec.yaml
  );

  static const TextStyle subheadlineStyle = TextStyle(
    fontSize: 20,
    color: Colors.white70,
    // fontFamily: 'Roboto', // Uncomment if you add the font in pubspec.yaml
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const ButtonStyle roundedButtonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.deepOrange),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
    ),
    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
  );
}