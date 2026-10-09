import 'package:get/get.dart';

import 'package:getx/app/services/api_service.dart';
import 'package:getx/app/models/product.dart';

enum ProductSortOption {
  relevance('Relevance'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  rating('Top Rated');

  const ProductSortOption(this.label);

  final String label;
}

class ProductController extends GetxController {
  final ApiService _apiService;

  ProductController({required ApiService apiService})
    : _apiService = apiService;

  final products = <Product>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedTab = 0.obs;
  final selectedCategory = ''.obs;
  final sortOption = ProductSortOption.relevance.obs;
  int _requestId = 0;

  List<String> get categories =>
      products
          .map((product) => product.category)
          .where((category) => category.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

  List<Product> get visibleProducts {
    var result = products.toList();
    if (selectedTab.value == 1 && selectedCategory.value.isNotEmpty) {
      result = result
          .where((product) => product.category == selectedCategory.value)
          .toList();
    }
    switch (sortOption.value) {
      case ProductSortOption.relevance:
        break;
      case ProductSortOption.priceLowToHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
      case ProductSortOption.priceHighToLow:
        result.sort((a, b) => b.price.compareTo(a.price));
      case ProductSortOption.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return result;
  }

  void selectTab(int index) {
    selectedTab.value = index;
    if (index != 1) selectedCategory.value = '';
  }

  void selectCategory(String category) {
    selectedCategory.value = selectedCategory.value == category ? '' : category;
  }

  void setSortOption(ProductSortOption option) {
    sortOption.value = option;
  }

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    final requestId = ++_requestId;
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiService.fetchProducts();
      if (requestId != _requestId) return;
      products.assignAll(result);
    } catch (e) {
      if (requestId != _requestId) return;
      errorMessage.value = e.toString();
      products.clear();
    } finally {
      if (requestId == _requestId) isLoading.value = false;
    }
  }

}
