import 'package:get/get.dart';

import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/di/service_locator.dart';
import 'package:getx/app/services/local_storage_service.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut(
        () => CartController(storage: getIt<LocalStorageService>()),
        fenix: true,
      );
    }
  }
}
