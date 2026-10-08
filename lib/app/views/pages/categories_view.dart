import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx/app/constants/app_constants.dart';
import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/controller/product_controller.dart';
import 'package:getx/app/models/product.dart';
import 'package:getx/app/routes/app_routes.dart';
import 'package:getx/app/utils/app_snackbar.dart';
import 'package:getx/app/views/widgets/bottom_nav.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  static const _categories = [
    'beauty',
    'fragrances',
    'furniture',
    'groceries',
    'home-decoration',
    'kitchen-accessories',
    'laptops',
    'mens-shirts',
    'mens-shoes',
    'mens-watches',
    'mobile-accessories',
    'motorcycle',
    'skin-care',
    'smartphones',
    'sports-accessories',
    'sunglasses',
    'tablets',
    'tops',
    'vehicle',
    'womens-bags',
    'womens-dresses',
    'womens-jewellery',
    'womens-shoes',
    'womens-watches',
  ];

  int _selectedIndex = 0;

  String get _selectedCategory => _categories[_selectedIndex];

  String _displayName(String category) {
    return category
        .split('-')
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'CATEGORIES',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () =>
                AppSnackbar.show('Search', 'Search will be available soon'),
            icon: const Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            tooltip: 'Wishlist',
            onPressed: () => AppSnackbar.show('Wishlist', 'Coming soon'),
            icon: const Icon(Icons.favorite_border, color: Colors.black),
          ),
          Obx(
            () => Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  tooltip: 'Cart',
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                  ),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 5,
                    top: 4,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 17,
                        minHeight: 17,
                      ),
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppConstants.meeshoPink,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          SizedBox(
            width: 90,
            child: ColoredBox(
              color: AppConstants.scaffoldGrey,
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = index == _selectedIndex;

                  return _CategorySidebarTile(
                    label: _displayName(category),
                    category: category,
                    selected: isSelected,
                    onTap: () => setState(() => _selectedIndex = index),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
                    child: Text(
                      _displayName(_selectedCategory),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.meeshoPink,
                        ),
                      ),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppConstants.textGrey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.errorMessage.value,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: controller.fetchProducts,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final matchingProducts = controller.products
                      .where((product) => product.category == _selectedCategory)
                      .toList();

                  if (matchingProducts.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No products in this category'),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                    sliver: SliverGrid.builder(
                      itemCount: matchingProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 9,
                          ),
                      itemBuilder: (context, index) => _CategoryProductTile(
                        product: matchingProducts[index],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}

class _CategorySidebarTile extends StatelessWidget {
  final String label;
  final String category;
  final bool selected;
  final VoidCallback onTap;

  const _CategorySidebarTile({
    required this.label,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Obx(() {
      final products = controller.products.toList();
      final product =
          products.firstWhereOrNull((item) => item.category == category) ??
          products.firstOrNull;

      return InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 88),
          decoration: BoxDecoration(
            color: selected ? Colors.white : AppConstants.scaffoldGrey,
            border: Border(
              left: BorderSide(
                color: selected ? AppConstants.meeshoPink : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: product == null
                      ? Container(
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.category_outlined,
                            color: Colors.white,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: product.thumbnail,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey.shade300),
                          errorWidget: (context, url, error) =>
                              Container(color: Colors.grey.shade300),
                        ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? AppConstants.meeshoPink : Colors.black,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _CategoryProductTile extends StatelessWidget {
  final Product product;

  const _CategoryProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.productDetails, arguments: product),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox.expand(
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey.shade200),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
