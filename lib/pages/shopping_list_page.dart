import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class GroceryItem {
  String name;
  int quantity;
  bool isBought;

  GroceryItem({
    required this.name,
    required this.quantity,
    this.isBought = false,
  });
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _storeController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemQtyController = TextEditingController();

  // Key: Store name, Value: List of grocery items
  final Map<String, List<GroceryItem>> _storeItems = {};

  String? _selectedStore;

  void _addStore() {
    final storeName = _storeController.text.trim();
    if (storeName.isNotEmpty && !_storeItems.containsKey(storeName)) {
      setState(() {
        _storeItems[storeName] = [];
        _selectedStore = storeName;
      });
      _storeController.clear();
    }
  }

  void _addItemToSelectedStore() {
    if (_selectedStore == null) return;
    final name = _itemNameController.text.trim();
    final qty = int.tryParse(_itemQtyController.text.trim()) ?? 1;

    if (name.isEmpty) return;

    setState(() {
      _storeItems[_selectedStore]!.add(GroceryItem(name: name, quantity: qty));
    });

    _itemNameController.clear();
    _itemQtyController.clear();
  }

  void _toggleBought(String store, int index) {
    setState(() {
      _storeItems[store]![index].isBought =
          !_storeItems[store]![index].isBought;
    });
  }

  void _removeItem(String store, int index) {
    setState(() {
      _storeItems[store]!.removeAt(index);
    });
  }

  @override
  void dispose() {
    _storeController.dispose();
    _itemNameController.dispose();
    _itemQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepOrange;

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
                    onSubmitted: (_) => _addStore(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addStore,
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
            if (_storeItems.isEmpty)
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
              ..._storeItems.entries.map((entry) {
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
                                setState(() {
                                  _storeItems.remove(storeName);
                                  if (_selectedStore == storeName)
                                    _selectedStore = null;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Add item form for this store
                        if (_selectedStore == storeName)
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
                                  onSubmitted: (_) => _addItemToSelectedStore(),
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
                                  onSubmitted: (_) => _addItemToSelectedStore(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _addItemToSelectedStore,
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
                              setState(() {
                                _selectedStore = storeName;
                                _itemNameController.clear();
                                _itemQtyController.clear();
                              });
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
                                    _toggleBought(storeName, index),
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
                                'Quantity: ${item.quantity}',
                                style:
                                    const TextStyle(fontFamily: 'Montserrat'),
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeItem(storeName, index),
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
