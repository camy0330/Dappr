// dappr/providers/shopping_list_provider.dart
import 'package:flutter/material.dart';
import 'package:dappr/models/item.dart'; // Import your Item model

class ShoppingListProvider extends ChangeNotifier {
  // Map to store items: { 'Store Name': [Item1, Item2, ...] }
  final Map<String, List<Item>> _storeItems = {};
  Map<String, List<Item>> get storeItems => _storeItems;

  String? _selectedStore;
  String? get selectedStore => _selectedStore;

  void addStore(String storeName) {
    if (!_storeItems.containsKey(storeName)) {
      _storeItems[storeName] = [];
      _selectedStore = storeName; // Automatically select the new store
      notifyListeners();
    }
  }

  void removeStore(String storeName) {
    if (_storeItems.containsKey(storeName)) {
      _storeItems.remove(storeName);
      if (_selectedStore == storeName) {
        _selectedStore = null; // Deselect if the current store is removed
      }
      notifyListeners();
    }
  }

  void selectStore(String storeName) {
    _selectedStore = storeName;
    notifyListeners();
  }

  void addItemToSelectedStore(String itemName, String quantity) {
    if (_selectedStore != null) {
      _storeItems[_selectedStore]!
          .add(Item(name: itemName, quantity: quantity));
      notifyListeners();
    }
  }

  void removeItem(String storeName, int itemIndex) {
    if (_storeItems.containsKey(storeName)) {
      if (itemIndex >= 0 && itemIndex < _storeItems[storeName]!.length) {
        _storeItems[storeName]!.removeAt(itemIndex);
        notifyListeners();
      }
    }
  }

  void toggleBought(String storeName, int itemIndex) {
    if (_storeItems.containsKey(storeName)) {
      if (itemIndex >= 0 && itemIndex < _storeItems[storeName]!.length) {
        _storeItems[storeName]![itemIndex].isBought =
            !_storeItems[storeName]![itemIndex].isBought;
        notifyListeners();
      }
    }
  }

  // Method to update an existing item
  void updateItem(
      String storeName, int itemIndex, String newName, String newQuantity) {
    if (_storeItems.containsKey(storeName)) {
      if (itemIndex >= 0 && itemIndex < _storeItems[storeName]!.length) {
        _storeItems[storeName]![itemIndex] =
            _storeItems[storeName]![itemIndex].copyWith(
          name: newName,
          quantity: newQuantity,
        );
        notifyListeners();
      }
    }
  }

  // --- START OF FIX: Add clearAll method ---
  void clearAll() {
    _storeItems.clear(); // Clears all stores and their items
    _selectedStore = null; // Deselect any selected store
    notifyListeners(); // Notify all listening widgets of the change
  }
}
