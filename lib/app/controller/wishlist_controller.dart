import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:getx/app/models/product.dart';
import 'package:getx/app/services/local_storage_service.dart';
import 'package:getx/app/utils/app_snackbar.dart';

class WishlistController extends GetxController {
  static const _storageKey = 'wishlist_products';
  final LocalStorageService _storage = Get.find<LocalStorageService>();
  final products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    _restoreWishlist();
  }

  bool contains(Product product) =>
      products.any((savedProduct) => savedProduct.id == product.id);

  Future<void> toggle(Product product) async {
    if (contains(product)) {
      if (await remove(product)) {
        AppSnackbar.show('Wishlist', 'Removed ${product.title}.');
      }
    } else {
      if (await add(product)) {
        AppSnackbar.show('Wishlist', 'Added ${product.title}.');
      }
    }
  }

  Future<bool> add(Product product) async {
    if (contains(product)) return true;
    products.add(product);
    return _saveWishlist();
  }

  Future<bool> remove(Product product) async {
    products.removeWhere((savedProduct) => savedProduct.id == product.id);
    return _saveWishlist();
  }

  void _restoreWishlist() {
    final savedProducts = _storage.read(_storageKey);
    if (savedProducts == null) return;

    try {
      final decoded = jsonDecode(savedProducts);
      if (decoded is! List) {
        throw const FormatException('Saved wishlist must be a list.');
      }
      products.assignAll(
        decoded.map(
          (product) => Product.fromStorageMap(
            Map<String, dynamic>.from(product as Map),
          ),
        ),
      );
    } on Object catch (error, stackTrace) {
      debugPrint('Could not restore wishlist: $error\n$stackTrace');
      AppSnackbar.show(
        'Storage error',
        'The saved wishlist could not be loaded.',
      );
    }
  }

  Future<bool> _saveWishlist() async {
    final contents = jsonEncode(
      products.map((product) => product.toStorageMap()).toList(),
    );
    try {
      await _storage.write(_storageKey, contents);
      return true;
    } on Object catch (error, stackTrace) {
      debugPrint('Could not save wishlist: $error\n$stackTrace');
      AppSnackbar.show('Storage error', 'Your wishlist could not be saved.');
      return false;
    }
  }
}
