// lib/models/shopping_item.dart
class ShoppingItem {
  final String name;
  final String quantity; // Changed to String to handle "1 kg", "5 pcs", etc.
  bool isBought;

  ShoppingItem({
    required this.name,
    required this.quantity,
    this.isBought = false,
  });

  // Optional: Add a copyWith method for immutability and easy updates
  ShoppingItem copyWith({
    String? name,
    String? quantity,
    bool? isBought,
  }) {
    return ShoppingItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isBought: isBought ?? this.isBought,
    );
  }
}