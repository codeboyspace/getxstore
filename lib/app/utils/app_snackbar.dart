import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:getx/app/constants/app_constants.dart';

class AppSnackbar {
  static void show(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppConstants.meeshoPink,
      colorText: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 250),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }
}
