import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/cart_count.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> categories =
      <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> recommendedProducts =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> banners = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> vendorProducts =
      <Map<String, dynamic>>[].obs;
  final RxInt currentBannerIndex = 0.obs;
  final RxInt notificationCount = 2.obs;
  RxInt get cartCount => globalCartCount;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingVendorProducts = false.obs;

  final ApiProvider _apiProvider = ApiProvider();

  @override
  void onInit() {
    super.onInit();
    loadBanners();
    loadRecommendedProducts();
    loadVendorProducts();
    loadCartCount();
    _loadMockCategories();
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
                'subtitle': b['description'] ?? '',
                'image': b['image'] ?? '',
                'icon': 'local_offer',
                'link_url': b['link_url'] ?? '',
                'position': b['position'] ?? 'homepage',
              },
            )
            .toList();
        return;
      }
    } catch (e) {
      print("Error loading banners: $e");
    }

    banners.value = [
      {
        'id': '1',
        'title': 'Summer Sale',
        'subtitle': 'Up to 50% off on all items',
        'image': 'assets/images/banner_img4.PNG',
        'icon': 'local_offer',
        'link_url': '',
      },
      {
        'id': '2',
        'title': 'New Arrivals',
        'subtitle': 'Fresh products every week',
        'image': 'assets/images/banner_img2.PNG',
        'icon': 'new_releases',
        'link_url': '',
      },
      {
        'id': '3',
        'title': 'Free Shipping',
        'subtitle': 'On orders above \$50',
        'image': 'assets/images/banner_img1.PNG',
        'icon': 'local_shipping',
        'link_url': '',
      },
      {
        'id': '4',
        'title': 'Free Shipping',
        'subtitle': 'On orders above \$50',
        'image': 'assets/images/banner_img3.PNG',
        'icon': 'local_shipping',
        'link_url': '',
      },
    ];
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
            'description': p['description'] ?? '',
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

  void _loadMockCategories() {
    categories.value = [
      {'id': 'fashion',    'name': 'Fashion',     'icon': 'fashion',     'color': 0xFFE91E63},
      {'id': 'electronics','name': 'Electronics', 'icon': 'electronics', 'color': 0xFF2196F3},
      {'id': 'home',       'name': 'Home',        'icon': 'home',        'color': 0xFF4CAF50},
      {'id': 'beauty',     'name': 'Beauty',      'icon': 'beauty',      'color': 0xFFFF9800},
      {'id': 'grocery',    'name': 'Grocery',     'icon': 'grocery',     'color': 0xFF8BC34A},
      {'id': 'sports',     'name': 'Sports',      'icon': 'sports',      'color': 0xFF00BCD4},
      {'id': 'toys',       'name': 'Toys',        'icon': 'toys',        'color': 0xFFFFEB3B},
      {'id': 'books',      'name': 'Books',       'icon': 'books',       'color': 0xFF795548},
      {'id': 'automotive', 'name': 'Automotive',  'icon': 'automotive',  'color': 0xFF607D8B},
      {'id': 'health',     'name': 'Health',      'icon': 'health',      'color': 0xFFF44336},
      {'id': 'jewelry',    'name': 'Jewelry',     'icon': 'jewelry',     'color': 0xFF9C27B0},
      {'id': 'mobiles',    'name': 'Mobiles',     'icon': 'mobiles',     'color': 0xFF3F51B5},
      {'id': 'laptops',    'name': 'Laptops',     'icon': 'laptops',     'color': 0xFF009688},
      {'id': 'shoes',      'name': 'Shoes',       'icon': 'shoes',       'color': 0xFFFF5722},
      {'id': 'furniture',  'name': 'Furniture',   'icon': 'furniture',   'color': 0xFF673AB7},
      {'id': 'others',     'name': 'Others',      'icon': 'others',      'color': 0xFF9E9E9E},
    ];
  }

  void onCategoryTapped(String categoryId) {
    // Navigate to category tab via MainNavigationController
    try {
      final navController = Get.find<dynamic>();
      if (navController.runtimeType.toString().contains('MainNavigation')) {
        navController.changePage(1);
      }
    } catch (_) {
      // Fallback: category is already visible in bottom nav
    }
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

  void onBannerTapped() {
    // Navigate to category tab for deals
    try {
      final navController = Get.find<dynamic>();
      if (navController.runtimeType.toString().contains('MainNavigation')) {
        navController.changePage(1);
      }
    } catch (_) {}
  }

  void onSeeAllCategories() {
    try {
      final navController = Get.find<dynamic>();
      if (navController.runtimeType.toString().contains('MainNavigation')) {
        navController.changePage(1);
      }
    } catch (_) {}
  }

  void onSeeAllNewArrivals() {
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
      globalCartCount.value = response.data['total_items'] ?? 0;
    } catch (_) {
      globalCartCount.value = 0;
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

  void onAddToCartTapped(String productId) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.addToCart,
        data: {'product_id': int.tryParse(productId) ?? 0, 'quantity': 1},
      );
      globalCartCount.value =
          response.data['cart_count'] ?? (globalCartCount.value + 1);
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
}
