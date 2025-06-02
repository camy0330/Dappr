// lib/homepage/auth_page.dart
<<<<<<< Updated upstream
import 'package:dappr/main_page.dart'; // Assuming navigation to MainPage after auth
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Assuming you use Lottie animations
=======
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dappr/main_page.dart'; // Import MainPage

// No change needed for the back button logic, as Navigator.pop() is already there.
// The previous change in welcome_page.dart enables it to work.
>>>>>>> Stashed changes

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
<<<<<<< Updated upstream
  bool isLogin = true;
=======
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginForm = true; // true for Login, false for Sign Up

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
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
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70, // Changed to white70 to contrast with deep orange background
                  fontFamily: 'Montserrat',
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
                    color: Colors.black.withValues(alpha: 0.1), // FIX: Changed 'opacity' to 'alpha'
                    blurRadius: 10,
                    offset: Offset(0, 5),
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
                              backgroundColor: isLogin ? Colors.deepOrange : Colors.orange.withAlpha(26),
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
                              backgroundColor: isLogin ? Colors.orange.withAlpha(26) : Colors.deepOrange,
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
=======
      backgroundColor: Colors.orange, // Matches your screenshot
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(), // This pops to WelcomePage
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/dappr_logo_wrapped.json',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const Text(
                'Dappr',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Montserrat', // Using Montserrat
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Your Culinary Journey Starts Here',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontFamily: 'Montserrat', // Using Montserrat
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(51, 255, 255, 255), // Colors.white.withOpacity(0.2)
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isLoginForm = true;
                            });
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: _isLoginForm ? Colors.white : Colors.white70,
                                fontWeight: _isLoginForm ? FontWeight.bold : FontWeight.normal,
                                fontFamily: 'Montserrat'), // Using Montserrat
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isLoginForm = false;
                            });
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: !_isLoginForm ? Colors.white : Colors.white70,
                                fontWeight: !_isLoginForm ? FontWeight.bold : FontWeight.normal,
                                fontFamily: 'Montserrat'), // Using Montserrat
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _isLoginForm ? _buildLoginForm() : _buildSignUpForm(),
>>>>>>> Stashed changes
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< Updated upstream
=======

  Widget _buildLoginForm() {
    return Column(
      children: [
        const Text(
          'Login',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Montserrat', // Using Montserrat
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: const Icon(Icons.email, color: Colors.deepOrange),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontFamily: 'Montserrat'), // Using Montserrat
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock, color: Colors.deepOrange),
              suffixIcon: const Icon(Icons.remove_red_eye, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontFamily: 'Montserrat'), // Using Montserrat
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            // Implement actual login logic here
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'), // Using Montserrat
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            setState(() {
              _isLoginForm = false;
            });
          },
          child: const Text(
            "Don't have an account? Sign Up",
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'), // Using Montserrat
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
        const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Montserrat', // Using Montserrat
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Full Name',
              prefixIcon: const Icon(Icons.person, color: Colors.deepOrange),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontFamily: 'Montserrat'), // Using Montserrat
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: const Icon(Icons.email, color: Colors.deepOrange),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontFamily: 'Montserrat'), // Using Montserrat
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock, color: Colors.deepOrange),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontFamily: 'Montserrat'), // Using Montserrat
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock, color: Colors.deepOrange),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontFamily: 'Montserrat'), // Using Montserrat
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            // Implement actual sign-up logic here
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'), // Using Montserrat
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            setState(() {
              _isLoginForm = true;
            });
          },
          child: const Text(
            "Already have an account? Login",
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'), // Using Montserrat
          ),
        ),
      ],
    );
  }
>>>>>>> Stashed changes
}