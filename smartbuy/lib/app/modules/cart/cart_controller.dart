import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/cart_count.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class CartController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

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

  // ─── Load ────────────────────────────────────────────────────────────────────

  Future<void> loadCartItems() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.cart);
      final List raw = response.data['cart'] ?? [];
      cartItems.value = raw.map((c) => _cartItemFromJson(c)).toList();
      globalCartCount.value = response.data['total_items'] ?? cartItems.length;
    } catch (_) {
      cartItems.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSavedForLater() async {
    try {
      final response = await _apiProvider.get(ApiConstants.buyerWishlist);
      final data = response.data;
      final List raw = data['wishlist'] ?? data['data'] ?? [];
      savedForLater.value = raw.map<ProductModel>((w) {
        final p = w['product'] ?? w;
        return ProductModel(
          id: _toInt(p['id']),
          name: p['name'] ?? '',
          description: p['description'] ?? '',
          price: _toDouble(
            (p['sale_price'] != null &&
                    p['sale_price'].toString() != '0.00' &&
                    p['sale_price'].toString() != '0')
                ? p['sale_price']
                : p['price'],
          ),
          stock: p['stock'] ?? 0,
          image: p['primary_image'] ?? p['image'],
          category: '',
          categoryName: p['vendor']?['business_name'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }).toList();
    } catch (_) {
      savedForLater.value = [];
    }
  }

  // ─── Quantity ────────────────────────────────────────────────────────────────

  Future<void> incrementQuantity(int itemId) async {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index == -1) return;
    final item = cartItems[index];
    final newQty = item.quantity + 1;

    cartItems[index] = item.copyWith(quantity: newQty); // optimistic
    try {
      await _apiProvider.put(
        ApiConstants.updateCartItem.replaceAll('{id}', '$itemId'),
        data: {'quantity': newQty},
      );
    } catch (e) {
      cartItems[index] = item; // revert
      _showError(e);
    }
  }

  Future<void> decrementQuantity(int itemId) async {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index == -1) return;
    final item = cartItems[index];

    if (item.quantity <= 1) {
      removeItem(itemId);
      return;
    }

    final newQty = item.quantity - 1;
    cartItems[index] = item.copyWith(quantity: newQty); // optimistic
    try {
      await _apiProvider.put(
        ApiConstants.updateCartItem.replaceAll('{id}', '$itemId'),
        data: {'quantity': newQty},
      );
    } catch (e) {
      cartItems[index] = item; // revert
      _showError(e);
    }
  }

  // ─── Remove ──────────────────────────────────────────────────────────────────

  Future<void> removeItem(int itemId) async {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index == -1) return;
    final item = cartItems.removeAt(index); // optimistic

    try {
      await _apiProvider.delete(
        ApiConstants.removeFromCart.replaceAll('{id}', '$itemId'),
      );
      Get.snackbar(
        'removed'.tr,
        'item_removed_from_cart'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      cartItems.insert(index, item); // revert
      _showError(e);
    }
  }

  // ─── Save for later ──────────────────────────────────────────────────────────

  Future<void> saveForLater(CartItemModel item) async {
    if (item.product == null) return;

    // Optimistic update
    cartItems.removeWhere((c) => c.id == item.id);
    savedForLater.add(item.product!);

    try {
      await Future.wait([
        _apiProvider.post(
          ApiConstants.buyerWishlist,
          data: {'product_id': item.productId},
        ),
        _apiProvider.delete(
          ApiConstants.removeFromCart.replaceAll('{id}', '${item.id}'),
        ),
      ]);
      Get.snackbar(
        'item_saved'.tr,
        'item_saved_for_later'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Revert
      savedForLater.removeWhere((p) => p.id == item.product!.id);
      cartItems.add(item);
      _showError(e);
    }
  }

  Future<void> moveToCart(ProductModel product) async {
    savedForLater.removeWhere((p) => p.id == product.id); // optimistic

    try {
      final response = await _apiProvider.post(
        ApiConstants.addToCart,
        data: {'product_id': product.id, 'quantity': 1},
      );
      // Best-effort remove from wishlist
      try {
        await _apiProvider.delete(
          ApiConstants.buyerWishlist,
          data: {'product_id': product.id},
        );
      } catch (_) {}

      final itemData = response.data['item'];
      if (itemData != null) {
        cartItems.add(CartItemModel(
          id: _toInt(itemData['id']),
          productId: product.id,
          product: product,
          quantity: 1,
          price: product.price,
          discountPrice: product.discountPrice,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      } else {
        await loadCartItems();
      }
      Get.snackbar(
        'item_added'.tr,
        'item_moved_to_cart'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      savedForLater.add(product); // revert
      _showError(e);
    }
  }

  // ─── Coupon ──────────────────────────────────────────────────────────────────

  Future<void> applyCoupon() async {
    final code = couponController.text.trim();
    if (code.isEmpty) {
      Get.snackbar('error'.tr, 'enter_coupon_code'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      final response = await _apiProvider.post(
        ApiConstants.applyCoupon,
        data: {'code': code, 'subtotal': subtotal},
      );
      final data = response.data;
      appliedCoupon.value = code;
      discount.value =
          _toDouble(data['discount'] ?? data['discount_amount'] ?? 0);
      Get.snackbar('success'.tr, data['message'] ?? 'coupon_applied'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('error'.tr, e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void removeCoupon() {
    appliedCoupon.value = '';
    discount.value = 0.0;
    couponController.clear();
  }

  Future<void> clearCart() async {
    try {
      await _apiProvider.delete(ApiConstants.clearCart);
      cartItems.clear();
      appliedCoupon.value = '';
      discount.value = 0.0;
    } catch (_) {}
  }

  // ─── Checkout ────────────────────────────────────────────────────────────────

  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar('error'.tr, 'cart_is_empty'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.toNamed(Routes.BUYER_CHECKOUT);
  }

  // ─── Computed ────────────────────────────────────────────────────────────────

  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shipping => 0.0;

  double get total => subtotal + shipping - discount.value;

  int get cartItemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  CartItemModel _cartItemFromJson(Map<String, dynamic> c) {
    final product = ProductModel(
      id: _toInt(c['product_id']),
      name: c['name'] ?? '',
      description: '',
      price: _toDouble(c['price']),
      stock: c['max_quantity'] ?? 99,
      image: c['image'],
      category: '',
      categoryName: c['vendor_name'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return CartItemModel(
      id: _toInt(c['id']),
      productId: product.id,
      product: product,
      quantity: c['quantity'] is int ? c['quantity'] : 1,
      price: _toDouble(c['price']),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  void _showError(Object e) {
    Get.snackbar(
      'error'.tr,
      e.toString().replaceAll('Exception: ', ''),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
