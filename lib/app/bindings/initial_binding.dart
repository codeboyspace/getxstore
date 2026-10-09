import 'package:get/get.dart';

import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/controller/wishlist_controller.dart';
import 'package:getx/app/di/service_locator.dart';
import 'package:getx/app/services/local_storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CartController(storage: getIt<LocalStorageService>()),
      fenix: true,
    );
    Get.lazyPut(
      () => WishlistController(storage: getIt<LocalStorageService>()),
      fenix: true,
    );
  }
}
