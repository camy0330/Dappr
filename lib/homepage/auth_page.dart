// lib/homepage/auth_page.dart
import 'package:flutter/material.dart'; // Place 'dart:' imports before others
import 'package:dappr/main_page.dart'; // Import MainPage for navigation after login

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Implement your login logic here
    // For now, just navigate to MainPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _handleSignUp() {
    // Implement your sign-up logic here
    // For now, just navigate to MainPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // No shadow
        iconTheme: const IconThemeData(color: Colors.white), // Back arrow color
      ),
      extendBodyBehindAppBar: true, // Extend body behind AppBar for full background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orangeAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Taco image/icon
                const Icon(
                  Icons.fastfood, // Placeholder icon for the taco
                  size: 100,
                  color: Colors.white,
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
                const SizedBox(height: 40),

                // Login/Sign Up Tabs
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelColor: Colors.deepOrange,
                    unselectedLabelColor: Colors.white,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                    tabs: const [
                      Tab(text: 'Login'),
                      Tab(text: 'Sign Up'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // TabBarView for Login/Sign Up forms
                Container(
                  height: 350, // Adjust height as needed
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLoginForm(),
                      _buildSignUpForm(),
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

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Login',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: const Icon(Icons.email, color: Colors.deepOrange),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontFamily: 'Montserrat'),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock, color: Colors.deepOrange),
              suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey), // Eye icon
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            obscureText: true,
            style: const TextStyle(fontFamily: 'Montserrat'),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
            ),
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
            ),
          ),
          const SizedBox(height: 20),
          // "Don't have an account? Sign Up" is handled by the TabBar
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: const Icon(Icons.email, color: Colors.deepOrange),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontFamily: 'Montserrat'),
          ),
          const SizedBox(height: 15),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Create a password',
              prefixIcon: const Icon(Icons.lock, color: Colors.deepOrange),
              suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            obscureText: true,
            style: const TextStyle(fontFamily: 'Montserrat'),
          ),
          const SizedBox(height: 15),
          TextField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Re-enter your password',
              prefixIcon: const Icon(Icons.lock, color: Colors.deepOrange),
              suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            obscureText: true,
            style: const TextStyle(fontFamily: 'Montserrat'),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _handleSignUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
            ),
          ),
        ],
      ),
    );
  }
}