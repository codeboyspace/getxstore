import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toStorageMap() => {
    'product': product.toStorageMap(),
    'quantity': quantity,
  };

  factory CartItem.fromStorageMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromStorageMap(
        Map<String, dynamic>.from(map['product'] as Map),
      ),
      quantity: map['quantity'] as int,
    );
  }
}
