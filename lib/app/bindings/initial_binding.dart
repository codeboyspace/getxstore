import 'package:get/get.dart';

import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/controller/wishlist_controller.dart';
import 'package:getx/app/services/api_service.dart';
import 'package:getx/app/services/local_storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    Get.put(
      LocalStorageService(Hive.box<String>('getx_store')),
      permanent: true,
    );
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => WishlistController(), fenix: true);
  }
}
