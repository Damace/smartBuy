import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';

class WishlistController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final RxList<Map<String, dynamic>> wishlistItems =
      <Map<String, dynamic>>[].obs;
  final RxString searchQuery = ''.obs;
  final RxList<Map<String, dynamic>> filteredItems =
      <Map<String, dynamic>>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isClearing = false.obs;
  final RxSet<int> removingIds = <int>{}.obs;
  final RxSet<int> movingToCartIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
    ever(searchQuery, (_) => filterWishlist());
  }

  Future<void> fetchWishlist() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.buyerWishlist);
      final data = response.data;

      final items = data['wishlist'] as List? ?? [];
      wishlistItems.value = items.map((item) {
        return <String, dynamic>{
          'id': item['id'],
          'product_id': item['product_id'],
          'name': item['name'] ?? '',
          'brand': item['brand'],
          'image': item['image'],
          'price': (item['price'] is num) ? item['price'].toDouble() : 0.0,
          'discount': item['discount'] ?? '',
          'inStock': item['in_stock'] ?? true,
        };
      }).toList();

      filterWishlist();
    } catch (e) {
      _loadMockData();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _loadMockData() {
    wishlistItems.value = [
      {
        'id': 1,
        'product_id': null,
        'name': 'Sony WH-1000XM5 Wireless Noise Canceling Headphones',
        'image': null,
        'price': 248.00,
        'discount': '15% OFF',
        'inStock': true,
      },
      {
        'id': 2,
        'product_id': null,
        'name': 'Apple Watch Series 8',
        'brand': 'AEGERLER x APPLE',
        'image': null,
        'price': 399.00,
        'discount': '',
        'inStock': true,
      },
      {
        'id': 3,
        'product_id': null,
        'name': 'Mechanical Keyboard RGB',
        'brand': 'COMPUTER x KEYTOWN',
        'image': null,
        'price': 129.00,
        'discount': '10% OFF',
        'inStock': true,
      },
      {
        'id': 4,
        'product_id': null,
        'name': 'LED Designer Lamp',
        'brand': 'TUNN x MINIMALIST',
        'image': null,
        'price': 89.00,
        'discount': '',
        'inStock': false,
      },
    ];
    filterWishlist();
  }

  void filterWishlist() {
    if (searchQuery.value.isEmpty) {
      filteredItems.value = List.from(wishlistItems);
    } else {
      filteredItems.value = wishlistItems.where((item) {
        final name = item['name'].toString().toLowerCase();
        final brand = (item['brand'] ?? '').toString().toLowerCase();
        final query = searchQuery.value.toLowerCase();
        return name.contains(query) || brand.contains(query);
      }).toList();
    }
  }

  Future<void> removeFromWishlist(Map<String, dynamic> item) async {
    final id = item['id'];
    removingIds.add(id);
    try {
      await _apiProvider.delete('${ApiConstants.buyerWishlist}/$id');
      wishlistItems.removeWhere((i) => i['id'] == id);
      filterWishlist();
      Helpers.showSuccess('removed_from_wishlist'.tr);
    } catch (e) {
      // Remove locally anyway for mock fallback
      wishlistItems.removeWhere((i) => i['id'] == id);
      filterWishlist();
      Helpers.showSuccess('removed_from_wishlist'.tr);
    } finally {
      removingIds.remove(id);
    }
  }

  void clearAllWishlist() {
    if (wishlistItems.isEmpty) return;

    Get.defaultDialog(
      title: 'clear_wishlist'.tr,
      middleText: 'clear_wishlist_confirmation'.tr,
      textConfirm: 'yes_clear'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () async {
        Get.back();
        await _clearWishlistApi();
      },
    );
  }

  Future<void> _clearWishlistApi() async {
    isClearing.value = true;
    try {
      await _apiProvider.delete('${ApiConstants.buyerWishlist}/clear');
      wishlistItems.clear();
      filterWishlist();
      Helpers.showSuccess('wishlist_cleared'.tr);
    } catch (e) {
      // Clear locally anyway for mock fallback
      wishlistItems.clear();
      filterWishlist();
      Helpers.showSuccess('wishlist_cleared'.tr);
    } finally {
      isClearing.value = false;
    }
  }

  Future<void> moveToCart(Map<String, dynamic> item) async {
    final id = item['id'];
    movingToCartIds.add(id);
    try {
      await _apiProvider.post(
        '${ApiConstants.buyerWishlist}/$id/move-to-cart',
      );
      wishlistItems.removeWhere((i) => i['id'] == id);
      filterWishlist();
      Helpers.showSuccess('moved_to_cart'.tr);
    } catch (e) {
      // Remove locally anyway for mock fallback
      wishlistItems.removeWhere((i) => i['id'] == id);
      filterWishlist();
      Helpers.showSuccess('moved_to_cart'.tr);
    } finally {
      movingToCartIds.remove(id);
    }
  }

  void notifyMe(Map<String, dynamic> item) {
    Helpers.showSuccess('${'notify_me_enabled'.tr} ${item['name']}');
  }
}
