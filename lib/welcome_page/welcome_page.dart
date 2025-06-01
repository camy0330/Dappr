// lib/welcome_page/welcome_page.dart
import 'package:flutter/material.dart'; // Place 'dart:' imports before others
import 'package:dappr/homepage/auth_page.dart'; // Import the new AuthPage
// import 'package:lottie/lottie.dart'; // Uncomment if you use a Lottie animation for the taco

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orangeAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // If you have a Lottie animation for the taco, use this:
                // Lottie.asset(
                //   'assets/animations/dappr_logo_wrapped.json', // Ensure this path is correct
                //   width: 150,
                //   height: 150,
                //   fit: BoxFit.contain,
                // ),
                // Otherwise, use a placeholder icon:
                const Icon(
                  Icons.restaurant_menu, // Placeholder icon for the taco
                  size: 120,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Dappr', // Main title as in screenshot
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your Culinary Journey Starts Here', // Subtitle as in screenshot
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the AuthPage (Login/Sign Up)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Row( // Using a Row to include the arrow icon
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Click to Discover Recipes', // Button text as in screenshot
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward), // Arrow icon
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}