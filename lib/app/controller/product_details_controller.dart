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

  Future<void> addToCart() async {
    final cartController = Get.find<CartController>();
    final saved = await cartController.addToCart(product, quantity: qty.value);
    if (!saved) return;

    Get.back();
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      AppSnackbar.show('Added to Cart', product.title);
    });
  }
}
