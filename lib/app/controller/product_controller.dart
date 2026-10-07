import 'package:get/get.dart';

import 'package:getx/app/models/product.dart';
import 'package:getx/app/services/api_service.dart';

class ProductController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final products = <Product>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedTab = 0.obs;
  final selectedCategory = ''.obs;

  List<String> get categories =>
      products
          .map((product) => product.category)
          .where((category) => category.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

  List<Product> get visibleProducts {
    if (selectedTab.value != 1 || selectedCategory.value.isEmpty) {
      return products;
    }

    return products
        .where((product) => product.category == selectedCategory.value)
        .toList();
  }

  void selectTab(int index) {
    selectedTab.value = index;
    if (index != 1) selectedCategory.value = '';
  }

  void selectCategory(String category) {
    selectedCategory.value = selectedCategory.value == category ? '' : category;
  }

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiService.fetchProducts();
      products.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
      products.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
