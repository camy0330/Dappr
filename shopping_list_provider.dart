import 'package:flutter/material.dart';

// Your data model for a single item in the grocery list.
class GroceryItem {
  String name;
  // *** CRITICAL CHANGE HERE: quantity is now a String ***
  String quantity; // This will store "1 kilo", "5 pcs", "3 boxes", etc.
  bool isBought;

  GroceryItem({
    required this.name,
    required this.quantity, // Constructor now expects a String
    this.isBought = false,
  });
}

// Your provider class that manages the state of your shopping lists.
class ShoppingListProvider extends ChangeNotifier {
  // A map where keys are store names (String) and values are lists of GroceryItems.
  final Map<String, List<GroceryItem>> _storeItems = {};
  // Keeps track of the currently selected store for adding items.
  String? _selectedStore;

  // Getters to access the private data from outside the class.
  Map<String, List<GroceryItem>> get storeItems => _storeItems;
  String? get selectedStore => _selectedStore;

  // Adds a new store to the list.
  void addStore(String storeName) {
    // Trim whitespace and check if not empty and store doesn't already exist.
    final trimmedStoreName = storeName.trim();
    if (trimmedStoreName.isNotEmpty &&
        !_storeItems.containsKey(trimmedStoreName)) {
      _storeItems[trimmedStoreName] =
          []; // Initialize an empty list for the new store.
      _selectedStore =
          trimmedStoreName; // Automatically select the newly added store.
      notifyListeners(); // Notify widgets that depend on this provider to rebuild.
    }
  }

  // Removes a store and all its items.
  void removeStore(String storeName) {
    _storeItems.remove(storeName); // Remove the store from the map.
    if (_selectedStore == storeName) {
      _selectedStore = null; // If the removed store was selected, deselect it.
    }
    notifyListeners(); // Notify listeners.
  }

  // Selects a store to add items to. Can also be used to deselect (by passing null).
  void selectStore(String? storeName) {
    _selectedStore = storeName;
    notifyListeners(); // Notify listeners.
  }

  // *** CRITICAL CHANGE HERE: qty parameter is now a String ***
  // Adds an item to the currently selected store.
  void addItemToSelectedStore(String name, String qty) {
    if (_selectedStore == null || name.trim().isEmpty) {
      return; // Do nothing if no store is selected or item name is empty.
    }
    // Add the new GroceryItem with the provided name and String quantity.
    _storeItems[_selectedStore]!
        .add(GroceryItem(name: name.trim(), quantity: qty.trim()));
    notifyListeners(); // Notify listeners.
  }

  // Toggles the 'isBought' status of an item.
  void toggleBought(String store, int index) {
    if (_storeItems.containsKey(store) && index < _storeItems[store]!.length) {
      _storeItems[store]![index].isBought =
          !_storeItems[store]![index].isBought;
      notifyListeners(); // Notify listeners.
    }
  }

  // Removes a specific item from a store's list.
  void removeItem(String store, int index) {
    if (_storeItems.containsKey(store) && index < _storeItems[store]!.length) {
      _storeItems[store]!.removeAt(index);
      notifyListeners(); // Notify listeners.
    }
  }

  // Clears all stores and items.
  void clearAll() {
    _storeItems.clear();
    _selectedStore = null;
    notifyListeners(); // Notify listeners.
  }
}
