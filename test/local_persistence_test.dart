import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:getx/app/controller/cart_controller.dart';
import 'package:getx/app/controller/wishlist_controller.dart';
import 'package:getx/app/models/product.dart';
import 'package:getx/app/services/local_storage_service.dart';

void main() {
  late Directory hiveDirectory;
  late Box<String> box;

  setUpAll(() async {
    hiveDirectory = Directory.systemTemp.createTempSync('getx_persistence_');
    Hive.init(hiveDirectory.path);
    box = await Hive.openBox<String>('getx_store');
  });

  setUp(() async {
    Get.testMode = true;
    await box.clear();
    Get.put(LocalStorageService(box));
  });

  tearDown(() async {
    Get.reset();
    Get.testMode = false;
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('cart is restored from Hive after controller recreation', () async {
    final cart = Get.put(CartController());
    await cart.addToCart(_product, quantity: 2);

    await Get.delete<CartController>();
    final restoredCart = Get.put(CartController());

    expect(restoredCart.cartItems, hasLength(1));
    expect(restoredCart.cartItems.single.product.title, _product.title);
    expect(restoredCart.cartItems.single.product.price, _product.price);
    expect(restoredCart.cartItems.single.quantity, 2);
  });

  test('wishlist is restored from Hive after controller recreation', () async {
    final wishlist = Get.put(WishlistController());
    expect(await wishlist.add(_product), isTrue);

    await Get.delete<WishlistController>();
    final restoredWishlist = Get.put(WishlistController());

    expect(restoredWishlist.products, hasLength(1));
    expect(restoredWishlist.products.single.title, _product.title);
  });

  test('clearing cart removes both reactive and persisted cart data', () async {
    final cart = Get.put(CartController());
    await cart.addToCart(_product);

    await cart.clearCart();

    expect(cart.cartItems, isEmpty);
    expect(box.get('cart_items'), isNull);
  });
}

final _product = Product(
  id: 1,
  title: 'Test product',
  description: 'A product for persistence tests.',
  category: 'test',
  price: 15.5,
  discountPercentage: 10,
  rating: 4.5,
  stock: 7,
  brand: 'Test brand',
  thumbnail: 'https://example.com/product.jpg',
  images: const ['https://example.com/product.jpg'],
  reviews: [Review(rating: 5, comment: 'Good', reviewerName: 'Tester')],
);
