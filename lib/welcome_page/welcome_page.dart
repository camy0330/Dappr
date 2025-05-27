import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dappr/welcome_page/welcome_page_styles.dart';
import 'package:dappr/welcome_page/welcome_page_widgets.dart'; // Keep this import for AuthForm
import 'package:dappr/home_page.dart'; // Import your actual home page

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _showAuthForms = false;
  bool _isLogin = true; // True for login, false for signup

  void _handleReveal() {
    setState(() {
      _showAuthForms = true;
    });
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _handleAuthSubmit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLogin ? 'Logged in successfully!' : 'Signed up successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: WelcomePageStyles.backgroundGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/dappr_logo_wrapped.json',
                  height: 200,
                  repeat: true,
                  reverse: false,
                  animate: true,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Dappr',
                  style: WelcomePageStyles.headlineStyle,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your Culinary Journey Starts Here',
                  style: WelcomePageStyles.subheadlineStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                if (!_showAuthForms)
                  // Replaced AnimatedSlideToReveal with a GestureDetector for click
                  GestureDetector(
                    onTap: _handleReveal, // Now it's just a click!
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((255 * 0.2).round()),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26, // Using a built-in opacity variant for simplicity
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Column( // Added const here
                        mainAxisSize: MainAxisSize.min, // Added to prevent column from taking full height
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 50,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Click to Discover Recipes', // Changed text
                            style: WelcomePageStyles.buttonTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  AuthForm(
                    title: _isLogin ? 'Login' : 'Sign Up',
                    buttonText: _isLogin ? 'Login' : 'Sign Up',
                    onSubmit: _handleAuthSubmit,
                    onToggle: _toggleAuthMode,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}