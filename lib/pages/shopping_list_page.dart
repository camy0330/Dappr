import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dappr/providers/shopping_list_provider.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepOrange;
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);
    final TextEditingController _storeController = TextEditingController();
    final TextEditingController _itemNameController = TextEditingController();
    final TextEditingController _itemQtyController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Shopping List',
            style: TextStyle(fontFamily: 'Montserrat')),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add Store Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _storeController,
                    decoration: InputDecoration(
                      labelText: 'Add Grocery Store',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.store),
                    ),
                    style: const TextStyle(fontFamily: 'Montserrat'),
                    onSubmitted: (_) {
                      shoppingListProvider.addStore(_storeController.text.trim());
                      _storeController.clear();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    shoppingListProvider.addStore(_storeController.text.trim());
                    _storeController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // List of Stores and Items
            if (shoppingListProvider.storeItems.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    'No stores added yet.',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              )
            else
              ...shoppingListProvider.storeItems.entries.map((entry) {
                final storeName = entry.key;
                final items = entry.value;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Store name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              storeName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: Color.fromARGB(255, 87, 82, 81),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                shoppingListProvider.removeStore(storeName);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Add item form for this store
                        if (shoppingListProvider.selectedStore == storeName)
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: TextField(
                                  controller: _itemNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Item name',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  onSubmitted: (_) {
                                    shoppingListProvider.addItemToSelectedStore(
                                      _itemNameController.text.trim(),
                                      int.tryParse(_itemQtyController.text.trim()) ?? 1,
                                    );
                                    _itemNameController.clear();
                                    _itemQtyController.clear();
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: _itemQtyController,
                                  decoration: InputDecoration(
                                    labelText: 'Qty',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (_) {
                                    shoppingListProvider.addItemToSelectedStore(
                                      _itemNameController.text.trim(),
                                      int.tryParse(_itemQtyController.text.trim()) ?? 1,
                                    );
                                    _itemNameController.clear();
                                    _itemQtyController.clear();
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  shoppingListProvider.addItemToSelectedStore(
                                    _itemNameController.text.trim(),
                                    int.tryParse(_itemQtyController.text.trim()) ?? 1,
                                  );
                                  _itemNameController.clear();
                                  _itemQtyController.clear();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Icon(Icons.add),
                              ),
                            ],
                          )
                        else
                          TextButton(
                            onPressed: () {
                              shoppingListProvider.selectStore(storeName);
                              _itemNameController.clear();
                              _itemQtyController.clear();
                            },
                            child: const Text('Add Items',
                                style: TextStyle(fontFamily: 'Montserrat')),
                          ),

                        const SizedBox(height: 10),

                        // Items list
                        if (items.isEmpty)
                          const Text(
                            'No items yet.',
                            style: TextStyle(
                                color: Colors.grey, fontFamily: 'Montserrat'),
                          )
                        else
                          ...items.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;

                            return ListTile(
                              leading: Checkbox(
                                value: item.isBought,
                                onChanged: (_) =>
                                    shoppingListProvider.toggleBought(storeName, index),
                                activeColor: primaryColor,
                              ),
                              title: Text(
                                item.name,
                                style: TextStyle(
                                  decoration: item.isBought
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              subtitle: Text(
                                'Quantity: 
