// lib/homepage/auth_page.dart
import 'package:dappr/main_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Extend the body behind the AppBar/status bar for the gradient
      extendBodyBehindAppBar: true,

      // The main content of the Scaffold. It's wrapped in a Container
      // to apply the gradient background across the entire page.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orangeAccent], // Your desired gradient colors
            begin: Alignment.topCenter, // Start gradient from top
            end: Alignment.bottomCenter, // End gradient at bottom
          ),
        ),
        // Center the content and allow it to scroll if it overflows
        child: Center(
          child: SingleChildScrollView(
            // Add top padding to account for the status bar height,
            // so content doesn't get hidden under it when extendBodyBehindAppBar is true.
            // Added extra 20.0 for more visual spacing from the top.
            padding: EdgeInsets.fromLTRB(
              24.0, // Left padding
              MediaQuery.of(context).padding.top + 20.0, // Top padding (status bar + extra)
              24.0, // Right padding
              0,    // Bottom padding (can be adjusted if needed, currently 0 for flexible scroll)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              children: [
                // Lottie animation at the top
                Lottie.asset(
                  'assets/animations/dappr_logo_wrapped.json', // Path to your Lottie file
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                  // Error builder for debugging if Lottie asset fails to load
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 150,
                      height: 150,
                      color: Colors.red.shade900, // Visual cue for asset loading failure
                      alignment: Alignment.center,
                      child: const Text(
                        'Lottie asset failed to load. Check pubspec.yaml and path.',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20), // Spacer
                // "Dappr" Text
                const Text(
                  'Dappr',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 247, 247, 247), // Custom white color
                    fontFamily: 'Montserrat', // Consistent font family
                  ),
                ),
                const SizedBox(height: 10), // Spacer
                // Subtitle Text
                Text(
                  'Your Culinary Journey Starts Here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Pure white for maximum contrast
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30), // Spacer
                // The white "card" container for login/signup form
                Container(
                  padding: const EdgeInsets.all(24.0), // Inner padding for the card content
                  decoration: BoxDecoration(
                    color: Colors.white, // White background for the form area
                    borderRadius: BorderRadius.circular(20), // Rounded corners for the card
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(26, 0, 0, 0), // Subtle shadow for depth
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Login/SignUp Toggle Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = true; // Set to login mode
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isLogin ? Colors.deepOrange : const Color.fromARGB(26, 255, 165, 0),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0, // No elevation for these toggle buttons
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isLogin ? Colors.white : Colors.deepOrange, // Text color changes with selection
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16), // Spacer between buttons
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = false; // Set to sign up mode
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isLogin ? const Color.fromARGB(26, 255, 165, 0) : Colors.deepOrange,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0, // No elevation for these toggle buttons
                              ),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isLogin ? Colors.deepOrange : Colors.white, // Text color changes with selection
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30), // Spacer
                      // "Login" / "Sign Up" Heading within the card
                      Text(
                        isLogin ? 'Login' : 'Sign Up',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87, // Dark text on white background
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 20), // Spacer
                      // Email Input Field
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email, color: Colors.deepOrange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none, // No border line
                          ),
                          filled: true,
                          fillColor: Colors.grey[200], // Light grey background for input fields
                          floatingLabelBehavior: FloatingLabelBehavior.never, // Label stays inside
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16), // Spacer
                      // Password Input Field
                      TextField(
                        obscureText: true, // Hides input text
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock, color: Colors.deepOrange),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.visibility_off, color: Colors.grey),
                            onPressed: () {
                             
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                      const SizedBox(height: 30), // Spacer
                      // Main Action Button (Login/Sign Up)
                      ElevatedButton(
                        onPressed: () {
                          // Simulate successful authentication and navigate to MainPage
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MainPage()),
                            (Route<dynamic> route) => false, // Clears all previous routes
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange, // Solid deep orange button
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isLogin ? 'Login' : 'Sign Up',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Spacer
                      // Toggle Text Button (Don't have an account?/Already have an account?)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin; // Toggle form type
                          });
                        },
                        child: Text(
                          isLogin ? "Don't have an account? Sign Up" : "Already have an account? Login",
                          style: const TextStyle(
                            color: Colors.deepOrange, // Deep orange text
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // AppBar for status bar control, made transparent
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar background is transparent
        elevation: 0, // No shadow under the AppBar
        // The 'leading' property (for the back button) is intentionally removed
        // or commented out to prevent the back button from appearing.
      ),
    );
  }
}