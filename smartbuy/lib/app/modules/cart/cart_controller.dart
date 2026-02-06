import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import '../../routes/app_pages.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxList<ProductModel> savedForLater = <ProductModel>[].obs;
  final couponController = TextEditingController();
  final RxString appliedCoupon = ''.obs;
  final RxDouble discount = 0.0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
    loadSavedForLater();
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }

  void loadCartItems() {
    // Mock data - replace with API call
    cartItems.value = [
      CartItemModel(
        id: 1,
        productId: 1,
        product: ProductModel(
          id: 1,
          name: 'Elite Wireless ANC',
          description: 'Premium wireless headphones with active noise cancellation',
          price: 349.00,
          discountPrice: null,
          stock: 50,
          image: 'headphones',
          categoryId: 1,
          categoryName: 'Electronics',
          rating: 4.8,
          reviewsCount: 128,
          isFeatured: true,
          isNewArrival: false,
          isBestSeller: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        quantity: 1,
        price: 349.00,
        discountPrice: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CartItemModel(
        id: 2,
        productId: 2,
        product: ProductModel(
          id: 2,
          name: 'Mechanical Keyboard K2',
          description: 'RGB mechanical gaming keyboard',
          price: 99.00,
          discountPrice: null,
          stock: 30,
          image: 'keyboard',
          categoryId: 1,
          categoryName: 'Electronics',
          rating: 4.6,
          reviewsCount: 89,
          isFeatured: false,
          isNewArrival: true,
          isBestSeller: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        quantity: 1,
        price: 99.00,
        discountPrice: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CartItemModel(
        id: 3,
        productId: 3,
        product: ProductModel(
          id: 3,
          name: 'Ergonomic Wireless Mouse',
          description: 'Comfortable wireless mouse for productivity',
          price: 59.00,
          discountPrice: null,
          stock: 100,
          image: 'mouse',
          categoryId: 1,
          categoryName: 'Electronics',
          rating: 4.4,
          reviewsCount: 56,
          isFeatured: false,
          isNewArrival: false,
          isBestSeller: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        quantity: 2,
        price: 59.00,
        discountPrice: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  void loadSavedForLater() {
    // Mock data - replace with API call
    savedForLater.value = [
      ProductModel(
        id: 4,
        name: 'Pro Watch Series 7',
        description: 'Advanced smartwatch with health tracking',
        price: 399.00,
        discountPrice: null,
        stock: 25,
        image: 'watch',
        categoryId: 1,
        categoryName: 'Electronics',
        rating: 4.7,
        reviewsCount: 234,
        isFeatured: true,
        isNewArrival: true,
        isBestSeller: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 5,
        name: 'Bluetooth Speaker Mini',
        description: 'Portable wireless speaker with premium sound',
        price: 79.00,
        discountPrice: null,
        stock: 60,
        image: 'speaker',
        categoryId: 1,
        categoryName: 'Electronics',
        rating: 4.5,
        reviewsCount: 145,
        isFeatured: false,
        isNewArrival: false,
        isBestSeller: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  void incrementQuantity(int itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final item = cartItems[index];
      cartItems[index] = item.copyWith(quantity: item.quantity + 1);
    }
  }

  void decrementQuantity(int itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final item = cartItems[index];
      if (item.quantity > 1) {
        cartItems[index] = item.copyWith(quantity: item.quantity - 1);
      }
    }
  }

  void removeItem(int itemId) {
    cartItems.removeWhere((item) => item.id == itemId);
    Get.snackbar(
      'removed'.tr,
      'item_removed_from_cart'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void saveForLater(CartItemModel item) {
    if (item.product != null) {
      savedForLater.add(item.product!);
      cartItems.removeWhere((cartItem) => cartItem.id == item.id);
      Get.snackbar(
        'item_saved'.tr,
        'item_saved_for_later'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void moveToCart(ProductModel product) {
    // Create a new cart item from the saved product
    final newCartItem = CartItemModel(
      id: DateTime.now().millisecondsSinceEpoch,
      productId: product.id,
      product: product,
      quantity: 1,
      price: product.price,
      discountPrice: product.discountPrice,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    cartItems.add(newCartItem);
    savedForLater.removeWhere((p) => p.id == product.id);
    Get.snackbar(
      'item_added'.tr,
      'item_moved_to_cart'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void applyCoupon() {
    final code = couponController.text.trim();
    if (code.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'enter_coupon_code'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    // Mock coupon validation - replace with API call
    if (code.toUpperCase() == 'SAVE10') {
      appliedCoupon.value = code;
      discount.value = subtotal * 0.10; // 10% discount
      Get.snackbar(
        'success'.tr,
        'coupon_applied'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } else {
      Get.snackbar(
        'error'.tr,
        'invalid_coupon'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  void removeCoupon() {
    appliedCoupon.value = '';
    discount.value = 0.0;
    couponController.clear();
  }

  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'cart_is_empty'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // Navigate to checkout screen
    Get.toNamed(Routes.BUYER_CHECKOUT);
  }

  double get subtotal {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get shipping {
    return 0.0; // Free shipping
  }

  double get total {
    return subtotal + shipping - discount.value;
  }

  int get cartItemCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
