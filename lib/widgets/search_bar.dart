import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const MySearchBar({super.key, required this.onSearch, required Color textColor});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.6)
                  : const Color.fromARGB(38, 255, 87, 34),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: onSearch,
          decoration: InputDecoration(
            hintText: 'Search recipes...',
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontFamily: 'Montserrat',
            ),
            prefixIcon: Icon(
              Icons.search,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: isDark ? Colors.white : Colors.black,
          ),
          cursorColor: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
