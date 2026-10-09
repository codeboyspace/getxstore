import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx/app/constants/app_constants.dart';
import 'package:getx/app/controller/wishlist_controller.dart';
import 'package:getx/app/routes/app_routes.dart';
import 'package:getx/app/utils/price_formatter.dart';
import 'package:getx/app/views/widgets/app_network_image.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: AppConstants.scaffoldGrey,
      appBar: AppBar(title: const Text('Wishlist')),
      body: Obx(() {
        if (wishlist.products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 56, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'Your wishlist is empty',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: wishlist.products.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final product = wishlist.products[index];
            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              child: ListTile(
                onTap: () =>
                    Get.toNamed(AppRoutes.productDetails, arguments: product),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: AppNetworkImage(
                    imageUrl: product.thumbnail,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(PriceFormatter.format(product.price)),
                trailing: IconButton(
                  tooltip: 'Remove from wishlist',
                  onPressed: () => wishlist.remove(product),
                  icon: const Icon(
                    Icons.favorite,
                    color: AppConstants.meeshoPink,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
