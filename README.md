# GetxStore

A Flutter + GetX mini e-commerce app for Day 1 of the internship assessment. It loads products from DummyJSON, shows a Meesho-inspired product grid, supports product details, and manages cart state with reactive GetX updates.

## Tech Stack
- Flutter
- Dart
- GetX
- http
- cached_network_image
- DummyJSON API

## Project Structure
```text
lib/
├── main.dart
├── app/
│   ├── bindings/
│   │   ├── initial_binding.dart
│   │   ├── home_binding.dart
│   │   ├── product_details_binding.dart
│   │   └── cart_binding.dart
│   ├── constants/
│   │   └── app_constants.dart
│   ├── controller/
│   │   ├── product_controller.dart
│   │   ├── product_details_controller.dart
│   │   └── cart_controller.dart
│   ├── models/
│   │   ├── product.dart
│   │   └── cart_item.dart
│   └── routes/
│       ├── app_pages.dart
│       └── app_routes.dart
│   ├── services/
│   │   └── api_service.dart
│   └── views/
│       ├── pages/
│       │   ├── home_view.dart
│       │   ├── product_details_view.dart
│       │   └── cart_view.dart
│       └── widgets/
│           └── product_card.dart
└── core/
  ├── themes/
  ├── utils/
  └── constants/
```

- `main.dart`: app bootstrap and route startup
- `app/bindings/`: GetX dependency registration for the app and screens
- `app/controller/`: reactive product, details, and cart business logic
- `app/models/`: product, review, and cart data models
- `app/routes/`: named route paths and page registration
- `app/services/`: DummyJSON HTTP client
- `app/views/pages/`: home, product details, and cart screens
- `app/views/widgets/`: reusable product listing widgets
- `core/`: shared theme, utility, and constants support

## GetX Implementation Summary
- Controllers used:
  - `ProductController`: fetches products from DummyJSON and exposes `products`, `isLoading`, and `errorMessage`
  - `ProductDetailsController`: holds quantity and handles Add to Cart
  - `CartController`: manages cart items, item count, subtotal, delivery, and total
- Reactive state:
  - `products = <Product>[].obs`
  - `isLoading = false.obs`
  - `errorMessage = ''.obs`
  - `qty = 1.obs`
  - `cartItems = <CartItem>[].obs`
- Dependency injection:
  - `Get.put(ApiService())`
  - `Get.lazyPut(() => ProductController())`
  - `Get.lazyPut(() => CartController(), fenix: true)`
  - `Get.find<CartController>()` inside product details flow
- Navigation:
  - `/home`
  - `/product-details`
  - `/cart`

## Add-to-Cart Flow
1. User taps a product card on the home screen.
2. The app navigates to the details screen with the selected product.
3. User adjusts quantity in `ProductDetailsController.qty`.
4. On tap of “Add to Cart”, the UI calls `Get.find<CartController>().addToCart(product, quantity: qty.value)`.
5. `CartController` checks whether the `product.id` already exists in `cartItems`.
6. If it is new, it appends a `CartItem`; if it already exists, it updates quantity with `copyWith`.
7. Because `cartItems` is `.obs`, any `Obx` watching it automatically rebuilds the cart badge, totals, and cart list.
8. `Get.snackbar` confirms the action and the screen closes with `Get.back()`.

## How to Run
```bash
flutter pub get
flutter run
```

## Day 1 Scope Note
Hive persistence, wishlist, and checkout are implemented on Day 2.

---

## Key Review Answer

The Add-to-Cart flow works like this:

- User taps the Add to Cart button from the product details screen.
- The UI calls `Get.find<CartController>().addToCart(product, quantity: qty.value)`.
- In `CartController`, the code checks whether `product.id` is already in `cartItems`.
- If new, it adds a `CartItem`; if existing, it updates quantity using `copyWith`.
- Because `cartItems` is an observable `.obs` list, every `Obx` watching it rebuilds automatically.
- That updates the cart icon badge, cart list, and totals.
- Finally, `Get.snackbar` shows the success message and `Get.back()` returns to the previous screen.
