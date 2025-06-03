// lib/welcome_page/welcome_page.dart
import 'package:dappr/homepage/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie

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
                // Use Lottie animation here
                Lottie.asset(
                  'assets/animations/dappr_logo_wrapped.json', // Your Lottie file path
                  width: 150, // Smaller width for better fit with gradient
                  height: 150, // Smaller height
                  fit: BoxFit.contain, // Use contain to ensure animation fits
                ),
                const SizedBox(height: 20),
                const Text(
                  'Dappr',
                  style: TextStyle(
                    fontSize: 38, // Slightly smaller font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your Culinary Journey Starts Here',
                  textAlign: TextAlign.center, // Ensure text is centered
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push( // Use push to allow navigating back to welcome page
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Click to Discover Recipes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward),
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
