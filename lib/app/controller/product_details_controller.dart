import 'package:get/get.dart';

import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/models/product.dart';
import 'package:getx/app/utils/app_snackbar.dart';

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

    Get.back();
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      AppSnackbar.show('Added to Cart', product.title);
    });
  }
}
