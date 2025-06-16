import 'dart:math';

import 'package:dappr/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipePuzzleGame extends StatefulWidget {
  final Recipe recipe;
  final bool useSteps; // true = steps puzzle, false = ingredients puzzle

  const RecipePuzzleGame({
    super.key,
    required this.recipe,
    this.useSteps = true,
  });

  @override
  State<RecipePuzzleGame> createState() => _RecipePuzzleGameState();
}

class _RecipePuzzleGameState extends State<RecipePuzzleGame> {
  late List<String> correctList;
  late List<String> shuffledList;

  @override
  void initState() {
    super.initState();
    correctList = widget.useSteps ? widget.recipe.steps : widget.recipe.ingredients;
    shuffledList = List<String>.from(correctList);
    shuffledList.shuffle(Random());
  }

  void resetGame() {
    setState(() {
      shuffledList = List<String>.from(correctList); // Re-initialize from correctList for a full reset
      shuffledList.shuffle(Random());
    });
  }

  void checkOrder() {
    bool isCorrect = true;
    for (int i = 0; i < correctList.length; i++) {
      if (shuffledList[i] != correctList[i]) {
        isCorrect = false;
        break;
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? '🎉 Correct!' : '❌ Try Again'),
        content: Text(isCorrect
            ? 'Great job! You arranged it perfectly.'
            : 'Oops! The order is not correct.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isCorrect) {
                // Optionally reset the game or navigate back if correct
                // For now, just dismiss the dialog
                resetGame(); // Auto-reset for new attempt or next puzzle
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark mode
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Choose text color based on mode for contrast
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // Darker grey for dark mode cards
    final Color dragHandleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.useSteps ? "Steps" : "Ingredients"} Puzzle',
            style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Arrange the ${widget.useSteps ? "steps" : "ingredients"} for:\n${widget.recipe.title}',
              textAlign: TextAlign.center,
              style: TextStyle( // Use textColor here
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Colors.deepOrange, // This can remain deepOrange as it's a title
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = shuffledList.removeAt(oldIndex);
                  shuffledList.insert(newIndex, item);
                });
              },
              children: [
                for (int i = 0; i < shuffledList.length; i++)
                  Card(
                    key: ValueKey(shuffledList[i]),
                    margin: const EdgeInsets.only(bottom: 8.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: cardBackgroundColor, // Apply dynamic card background
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      title: Text(
                        '${i + 1}. ${shuffledList[i]}',
                        style: TextStyle(fontSize: 16, fontFamily: 'Montserrat', color: textColor), // Apply dynamic text color
                      ),
                      leading: Icon(Icons.drag_handle, color: dragHandleColor), // Apply dynamic icon color
                      // tileColor: Colors.deepOrange.shade50, // Removed or adjusted if cardBackgroundColor is set
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: resetGame,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text("Reset", style: TextStyle(fontFamily: 'Montserrat', fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: checkOrder,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: const Text("Check", style: TextStyle(fontFamily: 'Montserrat', fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}