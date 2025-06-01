// lib/pages/meal_planner_page.dart
import 'package:flutter/material.dart';

class MealPlannerPage extends StatelessWidget {
  const MealPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center( // No Scaffold here as it's part of MainPage's body
      child: Text(
        "Meal Planner Page (Under Construction)",
        style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
        textAlign: TextAlign.center,
      ),
    );
  }
}