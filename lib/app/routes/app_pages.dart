import 'package:get/get.dart';

import 'package:getx/app/bindings/cart_binding.dart';
import 'package:getx/app/bindings/checkout_binding.dart';
import 'package:getx/app/bindings/home_binding.dart';
import 'package:getx/app/bindings/product_details_binding.dart';
import 'package:getx/app/views/pages/cart_view.dart';
import 'package:getx/app/views/pages/categories_view.dart';
import 'package:getx/app/views/pages/checkout_view.dart';
import 'package:getx/app/views/pages/home_view.dart';
import 'package:getx/app/views/pages/order_success_view.dart';
import 'package:getx/app/views/pages/product_details_view.dart';
import 'package:getx/app/views/pages/wishlist_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoriesView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistView(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: AppRoutes.orderSuccess,
      page: () => const OrderSuccessView(),
    ),
  ];
}
