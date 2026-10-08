import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx/app/constants/app_constants.dart';
import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/controller/checkout_controller.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppConstants.scaffoldGrey,
      appBar: AppBar(title: const Text('Checkout')),
      body: Obx(() {
        if (cart.cartItems.isEmpty) {
          return const Center(child: Text('Your cart is empty.'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...cart.cartItems.map(
              (item) => Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(item.product.title),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Text(
                    '₹${(item.product.price * item.quantity).toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _SummaryRow(label: 'Subtotal', value: cart.subtotal),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: 'Delivery charge',
                      value: cart.deliveryCharge,
                      freeIfZero: true,
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: 'Total',
                      value: cart.grandTotal,
                      emphasize: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: GetBuilder<CheckoutController>(
          builder: (controller) => SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: controller.isPlacingOrder
                  ? null
                  : controller.confirmAndPlaceOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.meeshoPink,
                foregroundColor: Colors.white,
              ),
              child: controller.isPlacingOrder
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Place Order'),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool freeIfZero;
  final bool emphasize;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.freeIfZero = false,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: emphasize ? 16 : 14,
      fontWeight: emphasize ? FontWeight.w700 : FontWeight.w400,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          freeIfZero && value == 0 ? 'Free' : '₹${value.toStringAsFixed(0)}',
          style: style,
        ),
      ],
    );
  }
}
