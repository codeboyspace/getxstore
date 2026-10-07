import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/models/product.dart';

class ProductDetailsController extends GetxController {
  final Product product;

  ProductDetailsController({required this.product});

  final qty = 1.obs;

  void increment() => qty.value++;

  void decrement() {
    if (qty.value > 1) {
      qty.value--;
    }
  }

  void addToCart() {
    final cartController = Get.find<CartController>();
    cartController.addToCart(product, quantity: qty.value);

    Get.snackbar(
      'Added to Cart',
      product.title,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );

    Get.back();
  }
}
