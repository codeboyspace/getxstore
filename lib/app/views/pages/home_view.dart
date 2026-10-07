import 'dart:async';
import 'dart:math' as math;
import 'package:zo_animated_border/zo_animated_border.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx/app/constants/app_constants.dart';
import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/controller/product_controller.dart';
import 'package:getx/app/models/product.dart';
import 'package:getx/app/routes/app_routes.dart';
import 'package:getx/app/views/widgets/bottom_nav.dart';
import 'package:getx/app/views/widgets/product_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Get.find<ProductController>();
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppConstants.scaffoldGrey,
      body: RefreshIndicator(
        onRefresh: products.fetchProducts,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _StoreHeader(cart: cart)),
            const SliverToBoxAdapter(child: _SearchBar()),
            const SliverToBoxAdapter(child: _FirstOrderBanner()),
            const SliverToBoxAdapter(child: _TrustBadges()),
            SliverToBoxAdapter(child: _FeaturedSection(controller: products)),
            SliverToBoxAdapter(
              child: Obx(
                () => _BestPriceCarousel(products: products.products.toList()),
              ),
            ),
            const SliverToBoxAdapter(child: _BlockbusterBanner()),
            SliverPersistentHeader(
              pinned: true,
              delegate: _FilterBarDelegate(
                child: _FilterBar(
                  onCategoryTap: () {
                    Get.toNamed(AppRoutes.categories);
                  },
                ),
              ),
            ),
            _ProductGridSliver(controller: products),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}

class _StoreHeader extends StatelessWidget {
  final CartController cart;

  const _StoreHeader({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 33, 12, 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppConstants.scaffoldGrey,
            child: Icon(Icons.person_outline, color: AppConstants.textGrey),
          ),
          const SizedBox(width: 5),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello',
                  style: TextStyle(color: AppConstants.textGrey, fontSize: 12),
                ),
                Text(
                  "let's shop!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Wishlist',
            onPressed: () => Get.snackbar('Wishlist', 'Coming soon'),
            icon: const Icon(Icons.favorite_border, size: 24),
          ),
          Obx(
            () => Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  tooltip: 'Cart',
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                  icon: const Icon(Icons.shopping_cart_outlined, size: 24),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    top: 2,
                    right: 1,
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
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: TextField(
        readOnly: true,
        onTap: () => Get.snackbar('Search', 'Search will be available soon'),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppConstants.scaffoldGrey,
          hintText: 'Search by Keyword or Product ID',
          hintStyle: const TextStyle(
            color: AppConstants.textGrey,
            fontSize: 13,
          ),
          prefixIcon: const Icon(Icons.search, color: AppConstants.textGrey),
          suffixIcon: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mic_none, color: AppConstants.textGrey),
              SizedBox(width: 12),
              Icon(Icons.camera_alt_outlined, color: AppConstants.textGrey),
              SizedBox(width: 12),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class _FirstOrderBanner extends StatelessWidget {
  const _FirstOrderBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppConstants.meeshoGreen,
            Colors.white,
            AppConstants.meeshoGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upto',
                    style: TextStyle(
                      color: AppConstants.meeshoGreen,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '₹60 OFF',
                    style: TextStyle(
                      color: AppConstants.meeshoGreen,
                      fontSize: 22,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'on 1st order',
                    style: TextStyle(
                      color: AppConstants.meeshoGreen,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.card_giftcard,
              size: 42,
              color: AppConstants.meeshoGreen,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.favorite, size: 20, color: Color(0xFFE84555)),
          ],
        ),
      ),
    );
  }
}

class _TrustBadges extends StatelessWidget {
  const _TrustBadges();

  @override
  Widget build(BuildContext context) {
    const borderAnimationDuration = Duration(seconds: 5);

    return ZoMultiColorBorder(
      key: const ValueKey(borderAnimationDuration),
      borderRadius: 10,
      strokeWidth: 2,
      //glowOpacity: 0.25,
      ///glowSpread: 2,
      animationDuration: borderAnimationDuration,
      colors: const [Colors.white, AppConstants.meeshoPink],
      child: Container(
        //margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Expanded(
              child: _TrustItem(
                icon: Icons.assignment_return_outlined,
                lines: ['7 Days', 'Easy Return'],
                underlineSecond: true,
              ),
            ),
            SizedBox(height: 38, child: VerticalDivider(width: 1)),
            Expanded(
              child: _TrustItem(
                icon: Icons.payments_outlined,
                lines: ['Cash on', 'Delivery'],
              ),
            ),
            SizedBox(height: 38, child: VerticalDivider(width: 1)),
            Expanded(
              child: _TrustItem(
                icon: Icons.local_offer_outlined,
                lines: ['Lowest', 'Price'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final List<String> lines;
  final bool underlineSecond;

  const _TrustItem({
    required this.icon,
    required this.lines,
    this.underlineSecond = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppConstants.meeshoPink, size: 21),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              lines[0],
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            Text(
              lines[1],
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                decoration: underlineSecond ? TextDecoration.underline : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  final ProductController controller;

  const _FeaturedSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = controller.products;
      if (products.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Featured',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            _FeaturedRow(products: products.take(3).toList()),
            const SizedBox(height: 8),
            _FeaturedRow(products: products.skip(3).take(4).toList()),
          ],
        ),
      );
    });
  }
}

class _FeaturedRow extends StatelessWidget {
  final List<Product> products;

  const _FeaturedRow({required this.products});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: products.map((product) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: AspectRatio(
              aspectRatio: 0.75,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey.shade300),
                      errorWidget: (context, url, error) =>
                          Container(color: Colors.grey.shade300),
                    ),
                    Positioned(
                      left: 5,
                      bottom: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _BestPriceCarousel extends StatefulWidget {
  final List<Product> products;

  const _BestPriceCarousel({required this.products});

  @override
  State<_BestPriceCarousel> createState() => _BestPriceCarouselState();
}

class _BestPriceCarouselState extends State<_BestPriceCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  Timer? _timer;
  int _page = 0;

  int get _pageCount => math.max(1, (widget.products.length / 3).ceil());

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || _pageCount < 2 || !_pageController.hasClients) return;
      _page = (_page + 1) % _pageCount;
      _pageController.animateToPage(
        _page,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _pageCount,
        itemBuilder: (context, pageIndex) {
          final start = pageIndex * 3;
          final pageProducts = widget.products.skip(start).take(3).toList();
          return Container(
            margin: const EdgeInsets.fromLTRB(5, 4, 5, 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFDDF4EF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 78,
                  child: Text(
                    'BEST\nPRICE',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF147C6C),
                    ),
                  ),
                ),
                ...pageProducts.map(
                  (product) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        imageUrl: product.thumbnail,
                        width: 52,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey.shade300),
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const CircleAvatar(
                  radius: 19,
                  backgroundColor: AppConstants.meeshoPink,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BlockbusterBanner extends StatelessWidget {
  const _BlockbusterBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106,
      margin: const EdgeInsets.fromLTRB(12, 1, 12, 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4D071B), Color(0xFF8E1A35), Color(0xFF520A20)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MEGA BLOCKBUSTER SALE',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'UPTO 80% OFF + EXTRA 35% OFF',
                  maxLines: 2,
                  style: TextStyle(
                    color: Color(0xFFFFD35A),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'OCT',
                  style: TextStyle(
                    color: Color(0xFFD63A42),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '09',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          const CircleAvatar(
            radius: 17,
            backgroundColor: Color(0xFFFF9E32),
            child: Icon(Icons.arrow_forward, color: Colors.white, size: 19),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final VoidCallback onCategoryTap;

  const _FilterBar({required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _FilterAction(
            label: '↕  Sort',
            onTap: () => Get.snackbar(
              'Sort',
              'Sorting options coming soon',
              colorText: Colors.white,
              backgroundColor: AppConstants.meeshoPink,
            ),
          ),
          const _FilterDivider(),
          _FilterAction(label: 'Category ⌄', onTap: onCategoryTap),
          const _FilterDivider(),
          _FilterAction(
            label: 'Gender ⌄',
            onTap: () => Get.snackbar(
              'Gender',
              'Gender filters coming soon',
              colorText: Colors.white,
              backgroundColor: AppConstants.meeshoPink,
            ),
          ),
          const _FilterDivider(),
          _FilterAction(
            label: '≡  Filters',
            onTap: () => Get.snackbar(
              'Filters',
              'Filters coming soon',
              colorText: Colors.white,
              backgroundColor: AppConstants.meeshoPink,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 45,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterDivider extends StatelessWidget {
  const _FilterDivider();

  @override
  Widget build(BuildContext context) =>
      Container(height: 22, width: 0.5, color: const Color(0xFFD8D8D8));
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const _FilterBarDelegate({required this.child});

  @override
  double get minExtent => 45;

  @override
  double get maxExtent => 45;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  bool shouldRebuild(covariant _FilterBarDelegate oldDelegate) =>
      child != oldDelegate.child;
}

class _ProductGridSliver extends StatelessWidget {
  final ProductController controller;

  const _ProductGridSliver({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: CircularProgressIndicator(color: AppConstants.meeshoPink),
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppConstants.textGrey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.fetchProducts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if (controller.products.isEmpty) {
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: Text('No products found')),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.all(8),
        sliver: SliverGrid.builder(
          itemCount: controller.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) =>
              ProductCard(product: controller.products[index]),
        ),
      );
    });
  }
}
