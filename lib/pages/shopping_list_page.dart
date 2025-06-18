import 'package:dappr/models/item.dart'; // IMPORTANT: Make sure this path is correct and the file exists!
import 'package:dappr/providers/shopping_list_provider.dart'; // Make sure this path is correct
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
  final TextEditingController _itemQtyController =
      TextEditingController(); // This will now accept any text

  // --- Modern and Elegant Color Scheme (Accessible by all methods) ---
  static const Color primaryOrange = Color(0xFFE65100);
  static const Color darkText = Color(0xFF212121);
  static const Color mediumText = Color(0xFF616161);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor =
      Color(0xFF388E3C); // Green for success feedback

  @override
  void dispose() {
    _storeController.dispose();
    _itemNameController.dispose();
    _itemQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This line uses Provider.of without `listen: false`. This is correct here
    // because this `build` method needs to re-run and redraw the UI whenever
    // the ShoppingListProvider's state changes (e.g., a new store is added,
    // an item is checked, etc.).
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text(
          'Shopping List',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        // Ensure icons are white for better visibility on the gradient
        iconTheme: const IconThemeData(color: Colors.white),
        // Add flexibleSpace for the gradient
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepOrange,
                Colors.orangeAccent
              ], // Your desired gradient colors
              begin: Alignment.topLeft, // Start of the gradient
              end: Alignment.bottomRight, // End of the gradient
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Add Store Section ---
            Text(
              'Add New Store',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: darkText,
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
                          color: mediumText, fontFamily: 'Montserrat'),
                      hintText: 'e.g., Tesco, AEON',
                      // ignore: deprecated_member_use
                      hintStyle: TextStyle(color: mediumText.withOpacity(0.6)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryOrange, width: 2),
                      ),
                      prefixIcon: Icon(Icons.store, color: primaryOrange),
                      filled: true,
                      fillColor: cardColor,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                    ),
                    style: TextStyle(fontFamily: 'Montserrat', color: darkText),
                    // Use context.read for state modification calls
                    onSubmitted: (_) =>
                        _addStore(context.read<ShoppingListProvider>()),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  // Use context.read for state modification calls
                  onPressed: () =>
                      _addStore(context.read<ShoppingListProvider>()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(15),
                    elevation: 3,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 30),
            Divider(color: dividerColor, thickness: 1.0, height: 1),
            const SizedBox(height: 20),

            // --- List of Stores and Items Section ---
            Text(
              'Your Shopping Lists',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: darkText,
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
                    style: TextStyle(
                      fontSize: 16,
                      color: mediumText,
                      fontFamily: 'Montserrat',
                      fontStyle: FontStyle.italic,
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
                    // ignore: deprecated_member_use
                    shadowColor: primaryOrange.withOpacity(0.15),
                    color: cardColor,
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
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: primaryOrange,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_forever,
                                    color: errorColor, size: 28),
                                onPressed: () {
                                  // Use context.read for state modification calls
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
                                              color: mediumText,
                                              fontFamily: 'Montserrat'),
                                          hintText: 'e.g., Apple',
                                          hintStyle: TextStyle(
                                              color:
                                                  // ignore: deprecated_member_use
                                                  mediumText.withOpacity(0.6)),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:
                                                BorderSide(color: dividerColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: primaryOrange, width: 2),
                                          ),
                                          filled: true,
                                          fillColor: lightBackground,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 12),
                                        ),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: darkText),
                                        // Use context.read for state modification calls
                                        onSubmitted: (_) => _addItem(context
                                            .read<ShoppingListProvider>()),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        controller: _itemQtyController,
                                        // Keyboard type to text to allow units like "1 kilo"
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: 'Qty/Unit',
                                          labelStyle: TextStyle(
                                              color: mediumText,
                                              fontFamily: 'Montserrat'),
                                          hintText: 'e.g., 1 kg, 5 pcs',
                                          hintStyle: TextStyle(
                                              color:
                                                  // ignore: deprecated_member_use
                                                  mediumText.withOpacity(0.6)),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:
                                                BorderSide(color: dividerColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: primaryOrange, width: 2),
                                          ),
                                          filled: true,
                                          fillColor: lightBackground,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 12),
                                        ),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: darkText),
                                        // Use context.read for state modification calls
                                        onSubmitted: (_) => _addItem(context
                                            .read<ShoppingListProvider>()),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      // Use context.read for state modification calls
                                      onPressed: () => _addItem(
                                          context.read<ShoppingListProvider>()),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryOrange,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        elevation: 3,
                                      ),
                                      child: const Icon(Icons.add_shopping_cart,
                                          color: Colors.white),
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
                                  // Use context.read for state modification calls
                                  context
                                      .read<ShoppingListProvider>()
                                      .selectStore(storeName);
                                  _itemNameController.clear();
                                  _itemQtyController.clear();
                                },
                                icon: Icon(Icons.add_shopping_cart,
                                    color: primaryOrange),
                                label: Text(
                                  'Add Items to this List',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: primaryOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
                                style: TextStyle(
                                    color: mediumText,
                                    fontFamily: 'Montserrat',
                                    fontStyle: FontStyle.italic),
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
                                    Divider(height: 1, color: dividerColor),
                                    ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 4),
                                      leading: Checkbox(
                                        value: item.isBought,
                                        // Use context.read for state modification calls
                                        onChanged: (_) => context
                                            .read<ShoppingListProvider>()
                                            .toggleBought(storeName, index),
                                        activeColor: primaryOrange,
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                            color: mediumText, width: 1.5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                      title: Text(
                                        item.name,
                                        style: TextStyle(
                                          decoration: item.isBought
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor:
                                              darkText, // For better visibility
                                          decorationThickness:
                                              2.0, // For better visibility
                                          fontFamily: 'Montserrat',
                                          color: item.isBought
                                              ? mediumText
                                              : darkText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Qty: ${item.quantity}',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: mediumText,
                                            fontSize: 14),
                                      ),
                                      // *** START OF CHANGES FOR EDITING: Replaced single trailing button with a Row ***
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // Important to keep row compact
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: primaryOrange, size: 24),
                                            onPressed: () {
                                              // Call the dialog to edit the item
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
                                                color: errorColor,
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
                                      // *** END OF CHANGES FOR EDITING ***
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
      _showSnackBar('Please enter a store name.', errorColor);
    }
  }

  void _addItem(ShoppingListProvider provider) {
    if (provider.selectedStore == null) {
      _showSnackBar('Please select a store first.', errorColor);
      return;
    }
    if (_itemNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter an item name.', errorColor);
      return;
    }

    final String quantityText = _itemQtyController.text.trim();
    provider.addItemToSelectedStore(
      _itemNameController.text.trim(),
      quantityText.isNotEmpty
          ? quantityText
          : '1', // Default to '1' if quantity field is empty
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
                  backgroundColor: errorColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Delete',
                  style:
                      TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
              onPressed: () {
                provider.removeStore(storeName); // Provider method call
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
                  backgroundColor: errorColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Delete',
                  style:
                      TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
              onPressed: () {
                provider.removeItem(storeName, index); // Provider method call
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // *** START OF NEW METHOD: Dialog for editing an item ***
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
                  labelStyle:
                      TextStyle(color: mediumText, fontFamily: 'Montserrat'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryOrange, width: 2),
                  ),
                  filled: true,
                  fillColor: lightBackground,
                ),
                style: TextStyle(fontFamily: 'Montserrat', color: darkText),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _editItemQtyController,
                keyboardType: TextInputType.text, // Allow any text for quantity
                decoration: InputDecoration(
                  labelText: 'Quantity/Unit',
                  labelStyle:
                      TextStyle(color: mediumText, fontFamily: 'Montserrat'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryOrange, width: 2),
                  ),
                  filled: true,
                  fillColor: lightBackground,
                ),
                style: TextStyle(fontFamily: 'Montserrat', color: darkText),
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
                  backgroundColor: primaryOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Update',
                  style:
                      TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
              onPressed: () {
                final String newName = _editItemNameController.text.trim();
                final String newQuantity = _editItemQtyController.text.trim();

                if (newName.isEmpty) {
                  _showSnackBar('Item name cannot be empty.', errorColor);
                  return;
                }

                // Call the updateItem method on the provider
                provider.updateItem(storeName, index, newName,
                    newQuantity.isNotEmpty ? newQuantity : '1');
                Navigator.of(dialogContext).pop();
                _showSnackBar('Item updated successfully!', successColor);
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
