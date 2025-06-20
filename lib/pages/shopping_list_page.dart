// ignore_for_file: deprecated_member_use

import 'package:dappr/models/item.dart';
import 'package:dappr/providers/shopping_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _storeController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemQtyController = TextEditingController();

  @override
  void dispose() {
    _storeController.dispose();
    _itemNameController.dispose();
    _itemQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Shopping List',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        centerTitle: true,
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Store',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _storeController,
                    decoration: InputDecoration(
                      labelText: 'Store Name',
                      labelStyle: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontFamily: 'Montserrat',
                      ),
                      hintText: 'e.g., Tesco, AEON',
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      prefixIcon: Icon(Icons.store, color: colorScheme.primary),
                      filled: true,
                      fillColor: theme.cardColor,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: colorScheme.onSurface,
                    ),
                    onSubmitted: (_) =>
                        _addStore(context.read<ShoppingListProvider>()),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () =>
                      _addStore(context.read<ShoppingListProvider>()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(15),
                    elevation: 3,
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Divider(color: theme.dividerColor, thickness: 1.0, height: 1),
            const SizedBox(height: 20),
            Text(
              'Your Shopping Lists',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 15),
            if (shoppingListProvider.storeItems.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    'No stores added yet. Start by adding a new grocery store!',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              )
            else
              ...shoppingListProvider.storeItems.entries.map((entry) {
                final storeName = entry.key;
                final items = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    shadowColor: colorScheme.primary.withOpacity(0.15),
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Store name and delete button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  storeName,
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_forever,
                                    color: colorScheme.error, size: 28),
                                onPressed: () {
                                  _showDeleteStoreConfirmation(
                                      context,
                                      context.read<ShoppingListProvider>(),
                                      storeName);
                                },
                                tooltip: 'Delete this store and all its items',
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // Add item form/button for this store
                          if (shoppingListProvider.selectedStore == storeName)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: TextField(
                                        controller: _itemNameController,
                                        decoration: InputDecoration(
                                          labelText: 'Item Name',
                                          labelStyle: TextStyle(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.7),
                                            fontFamily: 'Montserrat',
                                          ),
                                          hintText: 'e.g., Apple',
                                          hintStyle: TextStyle(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.5),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: theme.dividerColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: colorScheme.primary,
                                              width: 2,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: theme.colorScheme.surface,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 12),
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: colorScheme.onSurface,
                                        ),
                                        onSubmitted: (_) => _addItem(context
                                            .read<ShoppingListProvider>()),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        controller: _itemQtyController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: 'Qty/Unit',
                                          labelStyle: TextStyle(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.7),
                                            fontFamily: 'Montserrat',
                                          ),
                                          hintText: 'e.g., 1 kg, 5 pcs',
                                          hintStyle: TextStyle(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.5),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: theme.dividerColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: colorScheme.primary,
                                              width: 2,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: theme.colorScheme.surface,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 12),
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: colorScheme.onSurface,
                                        ),
                                        onSubmitted: (_) => _addItem(context
                                            .read<ShoppingListProvider>()),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () => _addItem(
                                          context.read<ShoppingListProvider>()),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorScheme.primary,
                                        foregroundColor: colorScheme.onPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        elevation: 3,
                                      ),
                                      child:
                                          const Icon(Icons.add_shopping_cart),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                              ],
                            )
                          else
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () {
                                  context
                                      .read<ShoppingListProvider>()
                                      .selectStore(storeName);
                                  _itemNameController.clear();
                                  _itemQtyController.clear();
                                },
                                icon: Icon(Icons.add_shopping_cart,
                                    color: colorScheme.primary),
                                label: Text(
                                  'Add Items to this List',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          // List of items for this store
                          if (items.isEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'No items added to this store yet.',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Column(
                                  children: [
                                    Divider(
                                        height: 1, color: theme.dividerColor),
                                    ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 4),
                                      leading: Checkbox(
                                        value: item.isBought,
                                        onChanged: (_) => context
                                            .read<ShoppingListProvider>()
                                            .toggleBought(storeName, index),
                                        activeColor: colorScheme.primary,
                                        checkColor: colorScheme.onPrimary,
                                        side: BorderSide(
                                            color: colorScheme.onSurface,
                                            width: 1.5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                      title: Text(
                                        item.name,
                                        style: textTheme.bodyLarge?.copyWith(
                                          decoration: item.isBought
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor:
                                              colorScheme.onSurface,
                                          decorationThickness: 2.0,
                                          fontFamily: 'Montserrat',
                                          color: item.isBought
                                              ? colorScheme.onSurface
                                                  .withOpacity(0.5)
                                              : colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Qty: ${item.quantity}',
                                        style: textTheme.bodySmall?.copyWith(
                                          fontFamily: 'Montserrat',
                                          color: colorScheme.onSurface
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: colorScheme.primary,
                                                size: 24),
                                            onPressed: () {
                                              _showEditItemDialog(
                                                  context,
                                                  context.read<
                                                      ShoppingListProvider>(),
                                                  storeName,
                                                  index,
                                                  item);
                                            },
                                            tooltip: 'Edit item',
                                          ),
                                          IconButton(
                                            icon: Icon(
                                                Icons.remove_circle_outline,
                                                color: colorScheme.error,
                                                size: 24),
                                            onPressed: () =>
                                                _showDeleteItemConfirmation(
                                                    context,
                                                    context.read<
                                                        ShoppingListProvider>(),
                                                    storeName,
                                                    index),
                                            tooltip: 'Remove item',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods ---

  void _addStore(ShoppingListProvider provider) {
    if (_storeController.text.trim().isNotEmpty) {
      provider.addStore(_storeController.text.trim());
      _storeController.clear();
    } else {
      _showSnackBar(
          'Please enter a store name.', Theme.of(context).colorScheme.error);
    }
  }

  void _addItem(ShoppingListProvider provider) {
    if (provider.selectedStore == null) {
      _showSnackBar(
          'Please select a store first.', Theme.of(context).colorScheme.error);
      return;
    }
    if (_itemNameController.text.trim().isEmpty) {
      _showSnackBar(
          'Please enter an item name.', Theme.of(context).colorScheme.error);
      return;
    }

    final String quantityText = _itemQtyController.text.trim();
    provider.addItemToSelectedStore(
      _itemNameController.text.trim(),
      quantityText.isNotEmpty ? quantityText : '1',
    );
    _itemNameController.clear();
    _itemQtyController.clear();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Confirmation dialog for deleting a store
  Future<void> _showDeleteStoreConfirmation(BuildContext context,
      ShoppingListProvider provider, String storeName) async {
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Delete Store?',
              style: TextStyle(
                  fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
          content: Text(
              'Are you sure you want to delete "$storeName" and all its items?',
              style: TextStyle(fontFamily: 'Montserrat')),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(
                      fontFamily: 'Montserrat', color: Colors.grey[600])),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Delete',
                  style: TextStyle(fontFamily: 'Montserrat')),
              onPressed: () {
                provider.removeStore(storeName);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Confirmation dialog for deleting an item
  Future<void> _showDeleteItemConfirmation(BuildContext context,
      ShoppingListProvider provider, String storeName, int index) async {
    final item = provider.storeItems[storeName]![index];
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Delete Item?',
              style: TextStyle(
                  fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
          content: Text(
              'Are you sure you want to delete "${item.name}" from "$storeName"?',
              style: TextStyle(fontFamily: 'Montserrat')),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(
                      fontFamily: 'Montserrat', color: Colors.grey[600])),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Delete',
                  style: TextStyle(fontFamily: 'Montserrat')),
              onPressed: () {
                provider.removeItem(storeName, index);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Dialog for editing an item
  Future<void> _showEditItemDialog(
      BuildContext context,
      ShoppingListProvider provider,
      String storeName,
      int index,
      Item currentItem) async {
    final TextEditingController _editItemNameController =
        TextEditingController(text: currentItem.name);
    final TextEditingController _editItemQtyController =
        TextEditingController(text: currentItem.quantity);
    final colorScheme = Theme.of(context).colorScheme;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Edit Item',
              style: TextStyle(
                  fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editItemNameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  labelStyle: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontFamily: 'Montserrat'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                style: TextStyle(
                    fontFamily: 'Montserrat', color: colorScheme.onSurface),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _editItemQtyController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Quantity/Unit',
                  labelStyle: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontFamily: 'Montserrat'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                style: TextStyle(
                    fontFamily: 'Montserrat', color: colorScheme.onSurface),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(
                      fontFamily: 'Montserrat', color: Colors.grey[600])),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _editItemNameController.dispose();
                _editItemQtyController.dispose();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Update',
                  style: TextStyle(fontFamily: 'Montserrat')),
              onPressed: () {
                final String newName = _editItemNameController.text.trim();
                final String newQuantity = _editItemQtyController.text.trim();

                if (newName.isEmpty) {
                  _showSnackBar(
                      'Item name cannot be empty.', colorScheme.error);
                  return;
                }

                provider.updateItem(storeName, index, newName,
                    newQuantity.isNotEmpty ? newQuantity : '1');
                Navigator.of(dialogContext).pop();
                _showSnackBar(
                    'Item updated successfully!', colorScheme.secondary);
                _editItemNameController.dispose();
                _editItemQtyController.dispose();
              },
            ),
          ],
        );
      },
    );
  }
}
