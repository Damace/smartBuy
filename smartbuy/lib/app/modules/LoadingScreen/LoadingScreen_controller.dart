import 'package:SmartBuy/app/core/constants/api_constants.dart';
import 'package:SmartBuy/app/data/providers/api_provider.dart';
import 'package:SmartBuy/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoadingScreenController extends GetxController {
  final RxList<String> categories = <String>[].obs;

  final RxList<Map<String, dynamic>> recommendedProducts =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> banners = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> vendorProducts =
      <Map<String, dynamic>>[].obs;
  final RxInt currentBannerIndex = 0.obs;
  final RxInt notificationCount = 2.obs;
  final RxInt cartCount = 2.obs;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingVendorProducts = false.obs;

  final ApiProvider _apiProvider = ApiProvider();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadBanners();
    loadRecommendedProducts();
    loadVendorProducts();
    loadCartCount();
    _loadMockCategories();
  }

  void _loadMockCategories() {
    categories.value = [
      'Fashion',
      'Electronics',
      'Home',
      'Beauty',
      'Grocery',
      'Sports',
      'Toys',
      'Books',
      'Automotive',
      'Health',
      'Jewelry',
      'Baby',
      'Furniture',
      'Mobiles',
      'Laptops',
      'Shoes',
      'Others',
    ];
  }

  void onSeeAllNewArrivals() {
    try {
      final navController = Get.find<dynamic>();
      if (navController.runtimeType.toString().contains('MainNavigation')) {
        navController.changePage(1);
      }
    } catch (_) {}
  }

  void onBannerTapped() {
    // Navigate to category tab for deals
    try {
      final navController = Get.find<dynamic>();
      if (navController.runtimeType.toString().contains('MainNavigation')) {
        navController.changePage(1);
      }
    } catch (_) {}
  }

  void onProductTapped(String productId) {
    Get.toNamed(Routes.PRODUCT_DETAILS, arguments: {'id': productId});
  }

  void onNotificationTapped() {
    Get.toNamed(Routes.BUYER_MESSAGES_INBOX);
  }

  void onCartTapped() {
    Get.toNamed(Routes.CART);
  }

  void onSearchTapped() {
    Get.toNamed(Routes.SEARCH);
  }

  void onSeeAllCategories() {
    try {
      final navController = Get.find<dynamic>();
      if (navController.runtimeType.toString().contains('MainNavigation')) {
        navController.changePage(1);
      }
    } catch (_) {}
  }

  void loadCartCount() async {
    try {
      final response = await _apiProvider.get(ApiConstants.cart);
      cartCount.value = response.data['total_items'] ?? 0;
    } catch (_) {
      cartCount.value = 0;
    }
  }

  void loadRecommendedProducts() async {
    isLoadingProducts.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.products);
      final data = response.data['data'] ?? response.data;
      if (data is List && data.isNotEmpty) {
        recommendedProducts.value = data
            .map(
              (p) => <String, dynamic>{
                'id': p['id'].toString(),
                'name': p['name'] ?? '',
                'price':
                    (p['sale_price'] != null &&
                        p['sale_price'].toString() != '0.00' &&
                        p['sale_price'].toString() != '0')
                    ? _toDouble(p['sale_price'])
                    : _toDouble(p['price']),
                'originalPrice':
                    (p['sale_price'] != null &&
                        p['sale_price'].toString() != '0.00' &&
                        p['sale_price'].toString() != '0')
                    ? _toDouble(p['price'])
                    : null,
                'rating': _toDouble(p['rating']),
                'ratingCount': p['total_reviews'] ?? 0,
                'image': p['primary_image'] ?? 'default',
                'badge': p['is_featured'] == true ? 'Hot Sale' : null,
                'vendorName': p['vendor'] != null
                    ? p['vendor']['business_name'] ?? ''
                    : '',
              },
            )
            .toList()
            .cast<Map<String, dynamic>>();
        isLoadingProducts.value = false;
        return;
      }
    } catch (_) {}
    // Fallback to mock data
    // _loadMockProducts();
    isLoadingProducts.value = false;
  }

  void loadBanners() async {
    try {
      final response = await _apiProvider.get(ApiConstants.banners);
      final data = response.data['data'] ?? response.data;
      if (data is List && data.isNotEmpty) {
        banners.value = data
            .map(
              (b) => <String, dynamic>{
                'id': b['id'].toString(),
                'title': b['title'] ?? '',
                'subtitle': b['subtitle'] ?? '',
                'image': b['image'] ?? '',
                'icon': b['icon'] ?? 'local_offer',
                'link_type': b['link_type'] ?? '',
                'link_id': b['link_id']?.toString() ?? '',
              },
            )
            .toList();
        return;
      }
    } catch (e) {
      print("Error loading banners: $e");
    }

    // Fallback to mock data if API fails or is empty
    banners.value = [
      {
        'id': '1',
        'title': '20% Off',
        'subtitle': 'On all furniture items',
        'icon': 'chair',
      },
      {
        'id': '2',
        'title': '30% Off',
        'subtitle': 'Electronics sale',
        'icon': 'electronics',
      },
      {
        'id': '3',
        'title': 'Free Shipping',
        'subtitle': 'On orders above \$50',
        'icon': 'shipping',
      },
    ];
  }

  Future<void> loadVendorProducts() async {
    isLoadingVendorProducts.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.products);
      final data = response.data['data'] ?? response.data;
      if (data is List && data.isNotEmpty) {
        // Group products by vendor
        final Map<String, Map<String, dynamic>> vendorMap = {};
        for (var p in data) {
          final vendorName = p['vendor'] != null
              ? (p['vendor']['business_name'] ?? 'Unknown Vendor')
              : 'Unknown Vendor';
          final vendorId = p['vendor_id']?.toString() ?? '0';

          if (!vendorMap.containsKey(vendorId)) {
            vendorMap[vendorId] = {
              'vendorId': vendorId,
              'vendorName': vendorName,
              'products': <Map<String, dynamic>>[],
            };
          }

          (vendorMap[vendorId]!['products'] as List<Map<String, dynamic>>).add({
            'id': p['id'].toString(),
            'name': p['name'] ?? '',
            'price':
                (p['sale_price'] != null &&
                    p['sale_price'].toString() != '0.00' &&
                    p['sale_price'].toString() != '0')
                ? _toDouble(p['sale_price'])
                : _toDouble(p['price']),
            'originalPrice':
                (p['sale_price'] != null &&
                    p['sale_price'].toString() != '0.00' &&
                    p['sale_price'].toString() != '0')
                ? _toDouble(p['price'])
                : null,
            'image': p['primary_image'] ?? 'default',
            'rating': _toDouble(p['rating']),
            'vendorName': vendorName,
          });
        }

        vendorProducts.value = vendorMap.values
            .where((v) => (v['products'] as List).isNotEmpty)
            .toList()
            .cast<Map<String, dynamic>>();
        isLoadingVendorProducts.value = false;
        Get.toNamed(Routes.HOME);
        return;
      }
    } catch (_) {}
    // Fallback mock
    // _loadMockVendorProducts();
    isLoadingVendorProducts.value = false;
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  void onAddToCartTapped(String productId) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.addToCart,
        data: {'product_id': int.tryParse(productId) ?? 0, 'quantity': 1},
      );
      cartCount.value = response.data['cart_count'] ?? (cartCount.value + 1);
      Get.snackbar(
        'cart'.tr,
        'item_added'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'cart'.tr,
        'cart_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void onWishlistTapped(String productId) async {
    try {
      await _apiProvider.post(
        ApiConstants.buyerWishlist,
        data: {'product_id': int.tryParse(productId) ?? 0},
      );
      Get.snackbar(
        'wishlist'.tr,
        'item_saved'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // 409 means already in wishlist
      final message = e.toString().contains('already')
          ? 'already_in_wishlist'.tr
          : 'wishlist_error'.tr;
      Get.snackbar(
        'wishlist'.tr,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
