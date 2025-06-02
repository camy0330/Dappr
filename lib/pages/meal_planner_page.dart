<<<<<<< Updated upstream
// lib/pages/meal_planner_page.dart
import 'package:flutter/material.dart';

class MealPlannerPage extends StatelessWidget {
  const MealPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Added Scaffold for AppBar and consistent background
      appBar: AppBar(
        title: const Text('Meal Planner', style: TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today, // Calendar icon as in screenshot
              size: 100,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 20),
            const Text(
              'Meal Planner', // Title as in screenshot
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Plan your delicious meals for the week!', // Subtitle as in screenshot
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Meal button tapped!')),
                );
              },
              icon: const Icon(Icons.add, size: 24),
              label: const Text('Add Meal', style: TextStyle(fontSize: 18, fontFamily: 'Montserrat')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
=======
// lib/pages/meal_planner_page.dart
import 'package:flutter/material.dart';

class MealPlannerPage extends StatelessWidget {
  const MealPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today,
              size: 80,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 20),
            const Text(
              'Meal Planner',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Plan your delicious meals for the week!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Future: Implement meal planning functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Meal Planning feature coming soon!')),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Meal', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
>>>>>>> Stashed changes
}