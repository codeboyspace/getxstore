import 'package:get/get.dart';

import 'package:getx/app/di/service_locator.dart';
import 'package:getx/app/controller/product_controller.dart';
import 'package:getx/app/services/api_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProductController(apiService: getIt<ApiService>()),
      fenix: true,
    );
  }
}
