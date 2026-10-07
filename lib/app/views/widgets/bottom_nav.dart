import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx/app/constants/app_constants.dart';
import 'package:getx/app/routes/app_routes.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  static const _items = [
    (Icons.home_outlined, 'Home'),
    (Icons.checkroom_outlined, 'Categories'),
    (Icons.inventory_2_outlined, 'My Orders'),
    (Icons.help_outline, 'Help'),
    (Icons.person_outline, 'Account'),
  ];

  void _onTap(int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      if (Get.currentRoute != AppRoutes.home) {
        Get.offNamed(AppRoutes.home);
      }
      return;
    }

    if (index == 1) {
      if (Get.currentRoute != AppRoutes.categories) {
        Get.toNamed(AppRoutes.categories);
      }
      return;
    }

    Get.snackbar(
      _items[index].$2,
      'Coming soon',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = index == currentIndex;
              final color = isActive
                  ? AppConstants.meeshoPink
                  : AppConstants.textGrey;

              return Expanded(
                child: InkWell(
                  onTap: () => _onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.$1, size: 24, color: color),
                      const SizedBox(height: 2),
                      Text(
                        item.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
