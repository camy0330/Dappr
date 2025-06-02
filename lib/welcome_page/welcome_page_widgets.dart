import 'package:dappr/welcome_page/welcome_page_styles.dart';
import 'package:flutter/material.dart';

// AnimatedSlideToReveal class and its state class have been removed,
// as the functionality is now directly handled in welcome_page.dart.

class AuthForm extends StatefulWidget {
  final String title;
  final String buttonText;
  final VoidCallback onSubmit;
  final VoidCallback onToggle; // To switch between login/signup

  const AuthForm({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onSubmit,
    required this.onToggle,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: WelcomePageStyles.headlineStyle.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email, color: WelcomePageStyles.primaryOrange),
            fillColor: Colors.white.withAlpha((255 * 0.9).round()),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock, color: WelcomePageStyles.primaryOrange),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: WelcomePageStyles.primaryOrange,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            fillColor: Colors.white.withAlpha((255 * 0.9).round()),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: widget.onSubmit,
          style: WelcomePageStyles.roundedButtonStyle,
          child: Text(widget.buttonText, style: WelcomePageStyles.buttonTextStyle),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: widget.onToggle,
          child: Text(
            widget.title == 'Login' ? 'Don\'t have an account? Sign Up' : 'Already have an account? Login',
            style: WelcomePageStyles.buttonTextStyle.copyWith(fontSize: 16, color: Colors.white70),
          ),
        ),
      ],
    );
  }
}