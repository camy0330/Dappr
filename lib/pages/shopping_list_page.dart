// lib/pages/shopping_list_page.dart
import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<String> _shoppingItems = [];
  final TextEditingController _itemController = TextEditingController();

  void _addItem() {
    final newItem = _itemController.text.trim();
    if (newItem.isNotEmpty) {
      setState(() {
        _shoppingItems.add(newItem);
      });
      _itemController.clear();
    }
  }

  void _removeItem(int index) {
    setState(() {
      _shoppingItems.removeAt(index);
    });
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // <--- ADDED AppBar for back button and title
        title: const Text('Shopping List', style: TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
        backgroundColor: Colors.deepOrange, // Consistent theme color
        iconTheme: const IconThemeData(color: Colors.white), // For the back arrow icon
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      labelText: 'Add new grocery item',
                      hintText: 'e.g., Milk, Eggs, Bread',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: const Icon(Icons.add_shopping_cart),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    ),
                    onSubmitted: (value) => _addItem(),
                    style: const TextStyle(fontFamily: 'Montserrat'), // Apply font
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: _shoppingItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'Your shopping list is empty!',
                          style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'Montserrat'), // Apply font
                        ),
                        Text(
                          'Add items to start your grocery list.',
                          style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Montserrat'), // Apply font
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _shoppingItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(
                            _shoppingItems[index],
                            style: const TextStyle(fontSize: 16.0, fontFamily: 'Montserrat'), // Apply font
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeItem(index),
                          ),
                          leading: const Icon(Icons.drag_indicator),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${_shoppingItems[index]} tapped!', style: const TextStyle(fontFamily: 'Montserrat'))), // Apply font
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}