import 'package:get/get.dart';

import 'package:getx/app/controller/product_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductController(), fenix: true);
  }
}
