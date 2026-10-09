import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:getx/app/models/cart_item.dart';
import 'package:getx/app/models/product.dart';
import 'package:getx/app/services/local_storage_service.dart';
import 'package:getx/app/utils/app_snackbar.dart';
import 'wishlist_controller.dart';

class CartController extends GetxController {
  static const _storageKey = 'cart_items';
  final LocalStorageService _storage;

  CartController({required LocalStorageService storage}) : _storage = storage;

  final cartItems = <CartItem>[].obs;

  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => cartItems.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  double get deliveryCharge => subtotal > 500 ? 0 : 40;

  double get grandTotal => subtotal + deliveryCharge;

  @override
  void onInit() {
    super.onInit();
    _restoreCart();
  }

  void _restoreCart() {
    final savedItems = _storage.read(_storageKey);
    if (savedItems == null) return;

    try {
      final decoded = jsonDecode(savedItems);
      if (decoded is! List) {
        throw const FormatException('Saved cart must be a list.');
      }
      cartItems.assignAll(
        decoded.map(
          (item) =>
              CartItem.fromStorageMap(Map<String, dynamic>.from(item as Map)),
        ),
      );
    } on Object catch (error, stackTrace) {
      debugPrint('Could not restore cart: $error\n$stackTrace');
      AppSnackbar.show('Storage error', 'The saved cart could not be loaded.');
    }
  }

  int availableStockFor(Product product) {
    final currentQuantity = cartItems
        .where((item) => item.product.id == product.id)
        .fold<int>(0, (sum, item) => sum + item.quantity);

    return (product.stock - currentQuantity).clamp(0, product.stock);
  }

  Future<bool> addToCart(Product product, {int quantity = 1}) async {
    if (quantity < 1) return false;

    final availableStock = availableStockFor(product);
    if (quantity > availableStock) {
      final itemLabel = availableStock == 1 ? 'item' : 'items';
      AppSnackbar.show(
        'Stock limit reached',
        'Only $availableStock $itemLabel available for this product.',
      );
      return false;
    }

    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex == -1) {
      cartItems.add(CartItem(product: product, quantity: quantity));
    } else {
      final currentItem = cartItems[existingIndex];
      final totalQuantity = currentItem.quantity + quantity;
      if (totalQuantity > product.stock) {
        final itemLabel = product.stock == 1 ? 'item' : 'items';
        AppSnackbar.show(
          'Stock limit reached',
          'Only ${product.stock} $itemLabel available in stock.',
        );
        return false;
      }
      cartItems[existingIndex] = currentItem.copyWith(quantity: totalQuantity);
    }
    return _saveCart();
  }

  Future<void> increaseItem(CartItem item) async {
    final index = cartItems.indexWhere(
      (cartItem) => cartItem.product.id == item.product.id,
    );
    if (index == -1) return;

    final current = cartItems[index];
    if (current.quantity >= item.product.stock) {
      final itemLabel = item.product.stock == 1 ? 'item' : 'items';
      AppSnackbar.show(
        'Stock limit reached',
        'Only ${item.product.stock} $itemLabel available for this product.',
      );
      return;
    }

    cartItems[index] = current.copyWith(quantity: current.quantity + 1);
    await _saveCart();
  }

  Future<void> decreaseItem(CartItem item) async {
    final index = cartItems.indexWhere(
      (cartItem) => cartItem.product.id == item.product.id,
    );
    if (index == -1) return;

    final current = cartItems[index];
    if (current.quantity <= 1) {
      cartItems.removeAt(index);
    } else {
      cartItems[index] = current.copyWith(quantity: current.quantity - 1);
    }
    await _saveCart();
  }

  Future<void> removeItem(CartItem item) async {
    cartItems.removeWhere((cartItem) => cartItem.product.id == item.product.id);
    await _saveCart();
  }

  Future<void> moveToWishlist(CartItem item) async {
    final saved = await Get.find<WishlistController>().add(item.product);
    if (!saved) return;
    await removeItem(item);
  }

  Future<void> clearCart() async {
    await _storage.delete(_storageKey);
    cartItems.clear();
  }

  Future<bool> _saveCart() async {
    final contents = jsonEncode(
      cartItems.map((item) => item.toStorageMap()).toList(),
    );
    try {
      await _storage.write(_storageKey, contents);
      return true;
    } on Object catch (error, stackTrace) {
      debugPrint('Could not save cart: $error\n$stackTrace');
      AppSnackbar.show('Storage error', 'Your cart could not be saved.');
      return false;
    }
  }
}
