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
│   │   ├── cart_controller.dart
│   │   ├── wishlist_controller.dart
│   │   └── checkout_controller.dart
│   ├── models/
│   │   ├── product.dart
│   │   └── cart_item.dart
│   └── routes/
│       ├── app_pages.dart
│       └── app_routes.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   └── local_storage_service.dart
│   └── views/
│       ├── pages/
│       │   ├── home_view.dart
│       │   ├── product_details_view.dart
│       │   ├── cart_view.dart
│       │   ├── wishlist_view.dart
│       │   ├── checkout_view.dart
│       │   └── order_success_view.dart
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
  - `WishlistController`: manages and persists saved products
  - `CheckoutController`: confirms checkout, clears the cart, and routes to success
  - `LocalStorageService`: reusable Hive-backed string CRUD service for app data
  - Hive stores JSON snapshots of cart items and wishlist products; the existing
    model serializers preserve product data without generated adapters.
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
  - `/wishlist`
  - `/checkout`
  - `/order-success`

  ## Local Persistence and Checkout

  - Hive is initialized and the `getx_store` box is opened before `runApp`.
  - Cart and wishlist state is restored by their GetX controllers and persisted
    after each change through `LocalStorageService`.
  - Cart actions and pricing stay in `CartController`; the UI observes its
    reactive state with `Obx`.
  - Wishlist changes use `WishlistController`; product-card and details-page
    heart buttons update reactively.
  - Checkout shows the cart summary and asks for confirmation before deleting
    persisted cart data. The checkout button uses `GetBuilder` for its
    non-reactive submission state; cart and wishlist use `Obx` for Rx state.
  - A successful order navigates to `/order-success`.

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
