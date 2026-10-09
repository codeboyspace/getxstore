import 'package:get/get.dart';

import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/models/product.dart';
import 'package:getx/app/routes/app_routes.dart';
import 'package:getx/app/utils/app_snackbar.dart';

class ProductDetailsController extends GetxController {
  final Product product;

  ProductDetailsController({required this.product});

  final qty = 1.obs;

  int get availableQuantity {
    final cartController = Get.find<CartController>();
    final cartQuantity = cartController.cartItems
        .where((item) => item.product.id == product.id)
        .fold<int>(0, (sum, item) => sum + item.quantity);

    return (product.stock - cartQuantity).clamp(0, product.stock);
  }

  bool get canIncrease => qty.value < availableQuantity;

  void increment() {
    if (!canIncrease) {
      final itemLabel = availableQuantity == 1 ? 'item' : 'items';
      AppSnackbar.show(
        'Stock limit reached',
        'Only $availableQuantity $itemLabel available for this product.',
      );
      return;
    }

    qty.value++;
  }

  void decrement() {
    if (qty.value > 1) {
      qty.value--;
    }
  }

  Future<void> addToCart() async {
    if (availableQuantity <= 0) {
      AppSnackbar.show('Out of stock', '${product.title} is not available.');
      return;
    }

    if (qty.value > availableQuantity) {
      qty.value = availableQuantity;
      AppSnackbar.show(
        'Stock limit reached',
        'Only $availableQuantity ${availableQuantity == 1 ? 'item' : 'items'} available for this product.',
      );
      return;
    }

    final cartController = Get.find<CartController>();
    final saved = await cartController.addToCart(product, quantity: qty.value);
    if (!saved) return;

    Get.back();
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      AppSnackbar.showWithAction(
        'Added to Cart',
        product.title,
        actionLabel: 'View Cart',
        onAction: () => Get.toNamed(AppRoutes.cart),
      );
    });
  }
}
