// lib/welcome_page/welcome_page.dart
<<<<<<< Updated upstream
import 'package:dappr/homepage/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie
=======
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dappr/homepage/auth_page.dart'; // Ensure this path is correct
>>>>>>> Stashed changes

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
<<<<<<< Updated upstream
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
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Dappr',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your Culinary Journey Starts Here',
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
=======
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, // Matches your screenshot
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/dappr_logo_wrapped.json',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
>>>>>>> Stashed changes
            ),
            const SizedBox(height: 20),
            const Text(
              'Dappr',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Montserrat', // Using Montserrat
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your Culinary Journey Starts Here',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
                fontFamily: 'Montserrat', // Using Montserrat
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Changed from pushReplacement to push to allow going back
                Navigator.push( // <--- IMPORTANT CHANGE HERE
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()), // Your Login/SignUp page
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
                  Icon(Icons.arrow_forward),
                  SizedBox(width: 10),
                  Text(
                    'Click to Discover Recipes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}