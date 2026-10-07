import 'package:get/get.dart';

import 'package:getx/app/models/cart_item.dart';
import 'package:getx/app/models/product.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;

  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => cartItems.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  double get deliveryCharge => subtotal > 500 ? 0 : 40;

  double get grandTotal => subtotal + deliveryCharge;

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex == -1) {
      cartItems.add(CartItem(product: product, quantity: quantity));
      return;
    }

    final currentItem = cartItems[existingIndex];
    cartItems[existingIndex] = currentItem.copyWith(
      quantity: currentItem.quantity + quantity,
    );
  }

  void increaseItem(CartItem item) {
    final index = cartItems.indexWhere(
      (cartItem) => cartItem.product.id == item.product.id,
    );
    if (index == -1) return;

    final current = cartItems[index];
    cartItems[index] = current.copyWith(quantity: current.quantity + 1);
  }

  void decreaseItem(CartItem item) {
    final index = cartItems.indexWhere(
      (cartItem) => cartItem.product.id == item.product.id,
    );
    if (index == -1) return;

    final current = cartItems[index];
    if (current.quantity <= 1) {
      cartItems.removeAt(index);
      return;
    }

    cartItems[index] = current.copyWith(quantity: current.quantity - 1);
  }

  void removeItem(CartItem item) {
    cartItems.removeWhere((cartItem) => cartItem.product.id == item.product.id);
  }
}
