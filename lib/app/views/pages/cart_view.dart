import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx/app/constants/app_constants.dart';
import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/models/cart_item.dart';
import 'package:getx/app/routes/app_routes.dart';
import 'package:getx/app/utils/app_snackbar.dart';
import 'package:getx/app/utils/price_formatter.dart';
import 'package:getx/app/views/widgets/app_network_image.dart';
import 'package:getx/app/views/widgets/quantity_stepper.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppConstants.scaffoldGrey,
      appBar: const _CartHeader(),
      body: Obx(() {
        if (cart.cartItems.isEmpty) {
          return const _EmptyCart();
        }
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _DeliveryAddress()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              sliver: SliverList.separated(
                itemCount: cart.cartItems.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) => _CartItemCard(
                  item: cart.cartItems[index],
                  controller: cart,
                ),
              ),
            ),
            SliverToBoxAdapter(child: _PriceDetails(controller: cart)),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cart.cartItems.isEmpty) return const SizedBox.shrink();
        return _StickyCheckoutBar(controller: cart);
      }),
    );
  }
}

class _CartHeader extends StatelessWidget implements PreferredSizeWidget {
  const _CartHeader();

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'CART',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Container(width: 50),
        ],
      ),
    );
  }
}

class _DeliveryAddress extends StatelessWidget {
  const _DeliveryAddress();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Color(0xFF2876C7), size: 21),
          const SizedBox(width: 7),
          const Expanded(
            child: Text(
              'Delivery at Kochi - 641035',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => AppSnackbar.show(
              'Delivery address',
              'Address selection is not available yet.',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Color(0xFF777777)),
              minimumSize: const Size(72, 34),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text('Change', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final CartController controller;

  const _CartItemCard({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final originalPrice = product.mrp * item.quantity;
    final currentPrice = product.price * item.quantity;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: AppNetworkImage(
                    imageUrl: product.thumbnail,
                    width: 80,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          Text(
                            PriceFormatter.format(currentPrice),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            PriceFormatter.format(originalPrice),
                            style: const TextStyle(
                              color: AppConstants.textGrey,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            '${product.discountPercentage.toStringAsFixed(0)}% Off',
                            style: const TextStyle(
                              color: AppConstants.meeshoGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Wrap(
                        spacing: 7,
                        runSpacing: 6,
                        children: [
                          QuantityStepper(
                            value: item.quantity,
                            onDecrease: () => controller.decreaseItem(item),
                            onIncrease: () => controller.increaseItem(item),
                            isDecreaseEnabled: item.quantity > 1,
                            isIncreaseEnabled:
                                item.quantity < item.product.stock,
                            height: 32,
                            buttonSize: 30,
                            iconSize: 15,
                            valueWidth: 30,
                            borderRadius: 5,
                            valueStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 15,
                            color: AppConstants.textGrey,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Estimated Delivery by Thursday, 15th Oct',
                              style: TextStyle(
                                color: AppConstants.textGrey,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          SizedBox(
            height: 44,
            child: Row(
              children: [
                Expanded(
                  child: _ItemAction(
                    icon: Icons.favorite_border,
                    label: 'Move to Wishlist',
                    onTap: () => controller.moveToWishlist(item),
                  ),
                ),
                Container(width: 1, height: 24, color: const Color(0xFFE0E0E0)),
                Expanded(
                  child: _ItemAction(
                    icon: Icons.close,
                    label: 'Remove',
                    onTap: () => controller.removeItem(item),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ItemAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox.expand(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 17, color: AppConstants.textGrey),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceDetails extends StatelessWidget {
  final CartController controller;

  const _PriceDetails({required this.controller});

  @override
  Widget build(BuildContext context) {
    final productPrice = controller.cartItems.fold<double>(
      0,
      (total, item) => total + item.product.mrp * item.quantity,
    );
    final discount = (productPrice - controller.subtotal).clamp(
      0,
      double.infinity,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details (${controller.itemCount} ${controller.itemCount == 1 ? 'Item' : 'Items'})',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          _PriceRow(
            label: 'Product Price',
            value: '+ ${PriceFormatter.format(productPrice)}',
          ),
          const SizedBox(height: 10),
          _PriceRow(
            label: 'Total Discounts',
            value: '- ${PriceFormatter.format(discount)}',
            color: AppConstants.meeshoGreen,
          ),
          const SizedBox(height: 10),
          _PriceRow(
            label: 'Delivery Charge',
            value: controller.deliveryCharge == 0
                ? 'Free'
                : '+ ${PriceFormatter.format(controller.deliveryCharge)}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFE0E0E0)),
          ),
          _PriceRow(
            label: 'Order Total',
            value: PriceFormatter.format(controller.grandTotal),
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool bold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: color ?? Colors.black,
      fontSize: 13,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}

class _StickyCheckoutBar extends StatelessWidget {
  final CartController controller;

  const _StickyCheckoutBar({required this.controller});

  void _showPriceDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          ),
          padding: const EdgeInsets.only(top: 18),
          child: _PriceDetails(controller: controller),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.7)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _showPriceDetails(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      PriceFormatter.format(controller.grandTotal),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'VIEW PRICE DETAILS',
                      style: TextStyle(
                        color: AppConstants.meeshoPink,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.checkout),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.meeshoPink,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 52,
            color: AppConstants.textGrey,
          ),
          const SizedBox(height: 12),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: Get.back,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppConstants.meeshoPink,
              side: const BorderSide(color: AppConstants.meeshoPink),
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}
