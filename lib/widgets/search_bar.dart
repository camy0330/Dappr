import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String searchText;
  final ValueChanged<String> onChanged;
  final VoidCallback onSearchTap;

  const SearchBarWidget({
    super.key,
    required this.searchText,
    required this.onChanged,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Cari resipi...',
                  border: InputBorder.none,
                ),
                onChanged: onChanged,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.deepOrange),
              onPressed: onSearchTap,
            ),
          ],
        ),
      ),
    );
  }
}
