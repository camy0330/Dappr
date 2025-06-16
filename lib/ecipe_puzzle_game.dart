import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dappr/models/recipe.dart';

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
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.useSteps ? "Steps" : "Ingredients"} Puzzle'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            widget.recipe.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ReorderableListView(
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
                    child: ListTile(
                      title: Text(shuffledList[i]),
                      leading: const Icon(Icons.drag_handle),
                    ),
                  )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: resetGame,
                icon: const Icon(Icons.refresh),
                label: const Text("Reset"),
              ),
              ElevatedButton.icon(
                onPressed: checkOrder,
                icon: const Icon(Icons.check_circle),
                label: const Text("Check"),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
