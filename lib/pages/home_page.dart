// lib/pages/home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 80, color: Colors.deepOrange),
          SizedBox(height: 20),
          Text(
            "Welcome to the Home Page!",
            style: TextStyle(fontSize: 24, fontFamily: 'Montserrat'),
            textAlign: TextAlign.center,
          ),
          Text(
            "This is where you can put your main content.",
            style: TextStyle(fontSize: 16, fontFamily: 'Montserrat', color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
