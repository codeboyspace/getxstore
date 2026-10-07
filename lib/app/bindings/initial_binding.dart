import 'package:get/get.dart';

import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/services/api_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    Get.lazyPut(() => CartController(), fenix: true);
  }
}
