import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/app/constants/app_constants.dart';

import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/routes/app_routes.dart';
import 'package:getx/app/utils/app_snackbar.dart';

class CheckoutController extends GetxController {
  bool isPlacingOrder = false;

  Future<void> confirmAndPlaceOrder() async {
    if (isPlacingOrder) return;

    if (Get.find<CartController>().cartItems.isEmpty) {
      AppSnackbar.show('Checkout', 'Add an item to your cart first.');
      return;
    }

    final confirmed = await Get.dialog<bool>(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              elevation: 8,
              shadowColor: AppConstants.meeshoPink.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: AppConstants.meeshoPink,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Place your order?',
                        style: Theme.of(Get.context!).textTheme.titleLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Please confirm to place this order.',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppConstants.meeshoPink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Get.back(result: true),
                        child: const Text('Place Order'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;

    isPlacingOrder = true;
    update();
    try {
      await Get.find<CartController>().clearCart();
    } on Object catch (error, stackTrace) {
      debugPrint('Could not complete checkout: $error\n$stackTrace');
      isPlacingOrder = false;
      update();
      AppSnackbar.show(
        'Checkout failed',
        'Your cart could not be cleared. Please try again.',
      );
      return;
    }

    isPlacingOrder = false;
    update();
    AppSnackbar.show('Order placed', 'Your order was placed successfully.');
    Get.offAllNamed(AppRoutes.orderSuccess);
  }
}
