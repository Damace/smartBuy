import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> recommendedProducts =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> banners = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> vendorProducts = <Map<String, dynamic>>[].obs;
  final RxInt currentBannerIndex = 0.obs;
  final RxInt notificationCount = 2.obs;
  final RxInt cartCount = 2.obs;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingVendorProducts = false.obs;

  final ApiProvider _apiProvider = ApiProvider();

  @override
  void onInit() {
    super.onInit();
    loadBanners();
    loadCategories();
    loadRecommendedProducts();
    loadVendorProducts();
    loadCartCount();
  }

  void loadBanners() {
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

  void loadCategories() async {
    try {
      final response = await _apiProvider.get(ApiConstants.categories);
      final List<dynamic> data = response.data['data'] ?? response.data;
      if (data.isNotEmpty) {
        categories.value = data
            .map((c) => <String, dynamic>{
                  'id': c['id'].toString(),
                  'name': c['name'] ?? '',
                  'icon': (c['icon'] ?? c['name'] ?? '').toString().toLowerCase(),
                  'color': _getCategoryColor(c['name'] ?? ''),
                })
            .toList()
            .cast<Map<String, dynamic>>();
        return;
      }
    } catch (_) {}
    // Fallback to mock data
    _loadMockCategories();
  }

  void loadRecommendedProducts() async {
    isLoadingProducts.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.products);
      final data = response.data['data'] ?? response.data;
      if (data is List && data.isNotEmpty) {
        recommendedProducts.value = data
            .map((p) => <String, dynamic>{
                  'id': p['id'].toString(),
                  'name': p['name'] ?? '',
                  'price': (p['sale_price'] != null &&
                          p['sale_price'].toString() != '0.00' &&
                          p['sale_price'].toString() != '0')
                      ? _toDouble(p['sale_price'])
                      : _toDouble(p['price']),
                  'originalPrice': (p['sale_price'] != null &&
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
                })
            .toList()
            .cast<Map<String, dynamic>>();
        isLoadingProducts.value = false;
        return;
      }
    } catch (_) {}
    // Fallback to mock data
    _loadMockProducts();
    isLoadingProducts.value = false;
  }

  void loadVendorProducts() async {
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
            'price': (p['sale_price'] != null &&
                    p['sale_price'].toString() != '0.00' &&
                    p['sale_price'].toString() != '0')
                ? _toDouble(p['sale_price'])
                : _toDouble(p['price']),
            'originalPrice': (p['sale_price'] != null &&
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
    _loadMockVendorProducts();
    isLoadingVendorProducts.value = false;
  }

  void _loadMockVendorProducts() {
    vendorProducts.value = [
      {
        'vendorId': '1',
        'vendorName': 'TechZone Electronics',
        'products': [
          {'id': '1', 'name': 'Wireless Pro Headphones', 'price': 199.00, 'originalPrice': null, 'image': 'headphones', 'rating': 4.5, 'vendorName': 'TechZone Electronics'},
          {'id': '5', 'name': 'Smart Watch Pro', 'price': 299.00, 'originalPrice': 349.00, 'image': 'default', 'rating': 4.3, 'vendorName': 'TechZone Electronics'},
        ],
      },
      {
        'vendorId': '2',
        'vendorName': 'Fashion Hub',
        'products': [
          {'id': '2', 'name': 'Premium Leather Jacket', 'price': 250.00, 'originalPrice': null, 'image': 'jacket', 'rating': 4.8, 'vendorName': 'Fashion Hub'},
          {'id': '4', 'name': 'Ultra Light Running Shoes', 'price': 100.00, 'originalPrice': 140.00, 'image': 'shoes', 'rating': 4.7, 'vendorName': 'Fashion Hub'},
        ],
      },
      {
        'vendorId': '3',
        'vendorName': 'Home Essentials',
        'products': [
          {'id': '3', 'name': 'Barista Coffee Maker', 'price': 85.00, 'originalPrice': null, 'image': 'coffee', 'rating': 4.2, 'vendorName': 'Home Essentials'},
        ],
      },
    ];
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  int _getCategoryColor(String name) {
    switch (name.toLowerCase()) {
      case 'fashion':
        return 0xFFEF8D32;
      case 'electronics':
        return 0xFF6C5CE7;
      case 'home':
        return 0xFF00B894;
      case 'beauty':
        return 0xFFFF6B9D;
      case 'sports':
        return 0xFF0984E3;
      default:
        return 0xFF636E72;
    }
  }

  void _loadMockCategories() {
    categories.value = [
      {'id': '1', 'name': 'Fashion', 'icon': 'fashion', 'color': 0xFFEF8D32},
      {
        'id': '2',
        'name': 'Electronics',
        'icon': 'electronics',
        'color': 0xFF6C5CE7,
      },
      {'id': '3', 'name': 'Home', 'icon': 'home', 'color': 0xFF00B894},
      {'id': '4', 'name': 'Beauty', 'icon': 'beauty', 'color': 0xFFFF6B9D},
    ];
  }

  void _loadMockProducts() {
    recommendedProducts.value = [
      {
        'id': '1',
        'name': 'Wireless Pro Headphones',
        'price': 199.00,
        'originalPrice': null,
        'rating': 4.5,
        'ratingCount': 234,
        'image': 'headphones',
        'badge': 'Hot Sale',
      },
      {
        'id': '2',
        'name': 'Premium Leather Jacket',
        'price': 250.00,
        'originalPrice': null,
        'rating': 4.8,
        'ratingCount': 1483,
        'image': 'jacket',
        'badge': null,
      },
      {
        'id': '3',
        'name': 'Barista Coffee Maker',
        'price': 85.00,
        'originalPrice': null,
        'rating': 4.2,
        'ratingCount': 12,
        'image': 'coffee',
        'badge': null,
      },
      {
        'id': '4',
        'name': 'Ultra Light Running Shoes',
        'price': 100.00,
        'originalPrice': 140.00,
        'rating': 4.7,
        'ratingCount': 856,
        'image': 'shoes',
        'badge': 'Hot Sale',
      },
      {
        'id': '5',
        'name': 'Wireless Pro Headphones',
        'price': 199.00,
        'originalPrice': null,
        'rating': 4.5,
        'ratingCount': 234,
        'image': 'headphones',
        'badge': 'Hot Sale',
      },
      {
        'id': '6',
        'name': 'Premium Leather Jacket',
        'price': 250.00,
        'originalPrice': null,
        'rating': 4.8,
        'ratingCount': 1483,
        'image': 'jacket',
        'badge': null,
      },
      {
        'id': '7',
        'name': 'Barista Coffee Maker',
        'price': 85.00,
        'originalPrice': null,
        'rating': 4.2,
        'ratingCount': 12,
        'image': 'coffee',
        'badge': null,
      },
      {
        'id': '8',
        'name': 'Ultra Light Running Shoes',
        'price': 100.00,
        'originalPrice': 140.00,
        'rating': 4.7,
        'ratingCount': 856,
        'image': 'shoes',
        'badge': 'Hot Sale',
      },
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
    // Navigate to category tab (which has search)
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
      cartCount.value = response.data['total_items'] ?? 0;
    } catch (_) {
      cartCount.value = 0;
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
        data: {
          'product_id': int.tryParse(productId) ?? 0,
          'quantity': 1,
        },
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
}
