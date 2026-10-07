import 'package:get/get.dart';

import 'package:getx/app/controller/product_details_controller.dart';
import 'package:getx/app/models/product.dart';

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final product = Get.arguments as Product;
    Get.put(ProductDetailsController(product: product));
  }
}
