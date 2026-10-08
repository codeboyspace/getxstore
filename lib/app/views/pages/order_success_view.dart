import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx/app/constants/app_constants.dart';
import 'package:getx/app/routes/app_routes.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 88,
                color: AppConstants.meeshoGreen,
              ),
              const SizedBox(height: 20),
              const Text(
                'Order placed successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Thank you for shopping with us.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Get.offAllNamed(AppRoutes.home),
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
