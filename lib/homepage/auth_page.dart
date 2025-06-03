// lib/homepage/auth_page.dart
import 'package:dappr/main_page.dart'; // Assuming navigation to MainPage after auth
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Assuming you use Lottie animations

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
      backgroundColor: const Color.fromARGB(255, 255, 140, 25), // Changed to solid deep orange for consistency with WelcomePage
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove AppBar shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back arrow
          onPressed: () {
            Navigator.pop(context); // Go back to WelcomePage
          },
        ),
        // Adding a title here if you want "Dappr" in the AppBar for AuthPage
        // title: const Text('Dappr', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat')),
      ),
      body: Center(
        child: SingleChildScrollView(
          // Padding for the entire scrollable area, adjusted for top space due to transparent AppBar
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie animation at the top, outside the white card
              Lottie.asset(
                'assets/animations/dappr_logo_wrapped.json', // Your Lottie file path
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                // Add errorBuilder for debugging if Lottie fails to load
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 150,
                    height: 150,
                    color: Colors.red.shade900, // Strong red for error visibility
                    alignment: Alignment.center,
                    child: const Text(
                      'Lottie asset failed to load. Check pubspec.yaml and path.',
                      style: TextStyle(color: Colors.white, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Dappr Text
              const Text(
                'Dappr',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 247, 247, 247), // Your custom white color
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle Text
              Text(
                'Your Culinary Journey Starts Here',
                textAlign: TextAlign.center, // Added for better presentation
                style: TextStyle(
                  fontSize: 18, // Increased font size for more attention
                  color: Colors.white, // Changed to pure white for maximum contrast
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold, // Make it bold
                ),
              ),
              const SizedBox(height: 30),
              // The white "card" container for login/signup form
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the form
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(26, 0, 0, 0), // FIX: Replaced Colors.black.withOpacity(0.1)
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ), // BoxShadow
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
                                isLogin = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLogin ? Colors.deepOrange : const Color.fromARGB(26, 255, 165, 0), // Colors.orange.withAlpha(26) (alpha from 0.1 opacity)
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0, // Remove elevation for a flatter look
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: isLogin ? Colors.white : Colors.deepOrange, // White text when selected, DeepOrange when not
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLogin = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLogin ? const Color.fromARGB(26, 255, 165, 0) : Colors.deepOrange, // Colors.orange.withAlpha(26)
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0, // Remove elevation for a flatter look
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                color: isLogin ? Colors.deepOrange : Colors.white, // DeepOrange text when selected, White when not
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // "Login" / "Sign Up" Heading within the card
                    Text(
                      isLogin ? 'Login' : 'Sign Up',
                      style: const TextStyle(
                        fontSize: 28, // Adjusted font size for the heading
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Dark text color for heading on white background
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email Input
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email, color: Colors.deepOrange),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        floatingLabelBehavior: FloatingLabelBehavior.never, // Keeps label inside the input field
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    // Password Input
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock, color: Colors.deepOrange),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility_off, color: Colors.grey),
                          onPressed: () {
                            // Toggle password visibility - functionality not changed
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        floatingLabelBehavior: FloatingLabelBehavior.never, // Keeps label inside the input field
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Login/Sign Up Button (main action button)
                    ElevatedButton(
                      onPressed: () {
                        // Simulate successful login/signup and navigate to main page
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const MainPage()),
                          (Route<dynamic> route) => false,
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
                    const SizedBox(height: 20),
                    // Toggle Text Button
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin; // Toggle form
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
    );
  }
}
