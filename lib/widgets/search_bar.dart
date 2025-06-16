// lib/widgets/search_bar.dart
import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const MySearchBar({super.key, required this.onSearch});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  // Optional: If you want to debounce the input within the MySearchBar widget itself,
  // you'd add a Timer here and debounce the onChanged callback.
  // For simplicity, we'll assume the parent (RecipeFilterPage) handles debouncing if needed.

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search recipes',
          hintText: 'e.g., chicken pasta #dinner',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          prefixIcon: Icon(Icons.search),
          suffixIcon: Icon(Icons.clear), // Optional: Add a clear button
        ),
        onChanged: widget.onSearch, // Pass the input directly to the parent's handler
        // You could also implement debouncing here:
        // onChanged: (value) {
        //   if (_debounce?.isActive ?? false) _debounce!.cancel();
        //   _debounce = Timer(const Duration(milliseconds: 300), () {
        //     widget.onSearch(value);
        //   });
        // },
      ),
    );
  }
}