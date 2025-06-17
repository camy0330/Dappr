// dappr/models/item.dart
class Item {
  final String name;
  final String quantity; // Changed to String to allow "1 kg", "5 pcs", etc.
  bool isBought;

  Item({
    required this.name,
    this.quantity = '1', // Default quantity to '1' if not specified
    this.isBought = false,
  });

  // A method to create a copy of the item with updated properties
  Item copyWith({String? name, String? quantity, bool? isBought}) {
    return Item(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isBought: isBought ?? this.isBought,
    );
  }
}
