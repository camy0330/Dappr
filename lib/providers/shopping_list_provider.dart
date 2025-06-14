import 'package:flutter/material.dart';

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

class ShoppingListProvider extends ChangeNotifier {
  final Map<String, List<GroceryItem>> _storeItems = {};
  String? _selectedStore;

  Map<String, List<GroceryItem>> get storeItems => _storeItems;
  String? get selectedStore => _selectedStore;

  void addStore(String storeName) {
    if (storeName.isNotEmpty && !_storeItems.containsKey(storeName)) {
      _storeItems[storeName] = [];
      _selectedStore = storeName;
      notifyListeners();
    }
  }

  void removeStore(String storeName) {
    _storeItems.remove(storeName);
    if (_selectedStore == storeName) _selectedStore = null;
    notifyListeners();
  }

  void selectStore(String storeName) {
    _selectedStore = storeName;
    notifyListeners();
  }

  void addItemToSelectedStore(String name, int qty) {
    if (_selectedStore == null || name.isEmpty) return;
    _storeItems[_selectedStore]!.add(GroceryItem(name: name, quantity: qty));
    notifyListeners();
  }

  void toggleBought(String store, int index) {
    _storeItems[store]![index].isBought = !_storeItems[store]![index].isBought;
    notifyListeners();
  }

  void removeItem(String store, int index) {
    _storeItems[store]!.removeAt(index);
    notifyListeners();
  }

  void clearAll() {
    _storeItems.clear();
    _selectedStore = null;
    notifyListeners();
  }
}
