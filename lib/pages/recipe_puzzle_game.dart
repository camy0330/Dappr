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
  // Use late final for correctList as it's initialized once and never changes
  late final List<String> correctList;
  late List<String> shuffledList;

  // Key for the ReorderableListView to allow it to be reset completely if needed
  // Not strictly necessary for current reset logic but good for more complex resets.
  // final GlobalKey<ReorderableListViewState> _reorderableListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializePuzzle();
  }

  // Extracted initialization logic into a private method for clarity
  void _initializePuzzle() {
    correctList = widget.useSteps ? widget.recipe.steps : widget.recipe.ingredients;
    // Create a new list instance to avoid modifying the original recipe data
    shuffledList = List<String>.from(correctList)..shuffle(Random());
  }

  void resetGame() {
    setState(() {
      // Re-initialize from correctList for a full reset and re-shuffle
      shuffledList = List<String>.from(correctList)..shuffle(Random());
    });
    // Optional: Show a toast or snackbar to confirm reset
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Puzzle reset!'),
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  void checkOrder() {
    bool isCorrect = true;
    for (int i = 0; i < correctList.length; i++) {
      if (shuffledList[i] != correctList[i]) {
        isCorrect = false;
        break;
      }
    }

    // Dismiss the current dialog if any, before showing a new one
    // This prevents multiple dialogs from stacking if checkOrder is called rapidly
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          isCorrect ? '🎉 Correct!' : '❌ Try Again',
          style: TextStyle(
            color: isCorrect ? Colors.green : Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          isCorrect
              ? 'Great job! You arranged it perfectly.'
              : 'Oops! The order is not correct. Keep trying!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dismiss the dialog
              if (isCorrect) {
                // Optionally navigate back or show a "next puzzle" option
                // For now, auto-reset for a new attempt
                resetGame();
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
    // Determine if the current theme is dark mode for dynamic colors
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors based on theme for better differentiation
    final Color primaryTextColor = isDarkMode ? Colors.white : Colors.black87;
    final Color secondaryTextColor = isDarkMode ? Colors.grey[300]! : Colors.grey[700]!;
    final Color cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // Darker for dark mode cards
    final Color cardBorderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!; // Subtle border
    final Color dragHandleColor = isDarkMode ? Colors.grey[500]! : Colors.grey[600]!;
    final Color scaffoldBackgroundColor = isDarkMode ? Colors.grey[900]! : Colors.grey[100]!; // Light grey background

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor, // Apply dynamic scaffold background
      appBar: AppBar(
        title: Text(
          '${widget.useSteps ? "Steps" : "Ingredients"} Puzzle',
          style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white), // AppBar title remains white
        ),
        // REMOVE backgroundColor: Colors.deepOrange,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent], // Your desired gradient colors
              begin: Alignment.topLeft, // Start of the gradient (adjust as needed)
              end: Alignment.bottomRight, // End of the gradient (adjust as needed)
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // AppBar icons remain white
        elevation: 4, // Add a subtle shadow to the app bar
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // Slightly more horizontal padding
            child: Text(
              'Arrange the ${widget.useSteps ? "steps" : "ingredients"} for:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18, // Slightly reduced font size for subtitle
                fontWeight: FontWeight.w600, // Medium bold
                fontFamily: 'Montserrat',
                color: secondaryTextColor, // Use a contrasting color for this prompt text
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Text(
              widget.recipe.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24, // Larger for the recipe title
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Colors.deepOrange, // Recipe title remains deepOrange
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ReorderableListView(
              // key: _reorderableListKey, // Uncomment if using GlobalKey for full list reset
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
                    key: ValueKey(shuffledList[i]), // Ensure unique keys for ReorderableListView
                    margin: const EdgeInsets.only(bottom: 10.0), // Increased bottom margin for better separation
                    elevation: 4, // Slightly increased elevation for more pop
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // More rounded corners
                      side: BorderSide(color: cardBorderColor, width: 1), // Add a subtle border
                    ),
                    color: cardBackgroundColor, // Apply dynamic card background
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0), // Increased padding
                      title: Text(
                        '${i + 1}. ${shuffledList[i]}', // Display number and text
                        style: TextStyle(
                          fontSize: 17, // Slightly larger font for list items
                          fontFamily: 'Montserrat',
                          color: primaryTextColor, // Apply dynamic text color
                          height: 1.4, // Increased line height for better readability
                        ),
                      ),
                      leading: Icon(
                        Icons.drag_indicator, // More modern drag handle icon
                        color: dragHandleColor, // Apply dynamic icon color
                        size: 28, // Slightly larger icon
                      ),
                      // Using a trailing icon can also be an option for drag handles if preferred
                      // trailing: Icon(Icons.drag_handle, color: dragHandleColor),
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
                    label: const Text(
                      "Reset",
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14), // Increased vertical padding
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5, // Add elevation to buttons
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: checkOrder,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: const Text(
                      "Check",
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14), // Increased vertical padding
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5, // Add elevation to buttons
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