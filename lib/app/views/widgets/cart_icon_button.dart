import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx/app/constants/app_constants.dart';
import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/routes/app_routes.dart';

class CartIconButton extends StatelessWidget {
  final Color iconColor;
  final double iconSize;

  const CartIconButton({
    super.key,
    this.iconColor = Colors.black,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Obx(
      () => Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () => Get.toNamed(AppRoutes.cart),
            icon: Icon(
              Icons.shopping_cart_outlined,
              size: iconSize,
              color: iconColor,
            ),
          ),
          if (cart.itemCount > 0)
            Positioned(
              top: 2,
              right: 1,
              child: Container(
                constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppConstants.meeshoPink,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${cart.itemCount}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
