import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> recommendedProducts =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> banners = <Map<String, dynamic>>[].obs;
  final RxInt currentBannerIndex = 0.obs;
  final RxInt notificationCount = 2.obs;
  final RxInt cartCount = 2.obs;
  final RxBool isLoadingProducts = false.obs;

  final ApiProvider _apiProvider = ApiProvider();

  @override
  void onInit() {
    super.onInit();
    loadBanners();
    loadCategories();
    loadRecommendedProducts();
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
                  'price': (p['price'] is String
                          ? double.tryParse(p['price'])
                          : p['price'] ?? 0)
                      .toDouble(),
                  'originalPrice': p['sale_price'] != null &&
                          p['sale_price'].toString() != '0.00' &&
                          p['sale_price'].toString() != '0'
                      ? (p['price'] is String
                              ? double.tryParse(p['price'])
                              : p['price'] ?? 0)
                          .toDouble()
                      : null,
                  'rating': (p['rating'] is String
                          ? double.tryParse(p['rating'])
                          : p['rating'] ?? 0)
                      .toDouble(),
                  'ratingCount': p['total_reviews'] ?? 0,
                  'image': p['primary_image'] ?? 'default',
                  'badge': p['is_featured'] == true ? 'Hot Sale' : null,
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
    // Navigate to category details or filter products
    Get.snackbar('Category', 'Category $categoryId tapped');
  }

  void onProductTapped(String productId) {
    Get.toNamed(Routes.PRODUCT_DETAILS, arguments: {'id': productId});
  }

  void onNotificationTapped() {
    // Switch to notification tab
    // This will be handled by MainNavigationController
  }

  void onCartTapped() {
    // Navigate to cart
    Get.snackbar('Cart', 'Cart tapped');
  }

  void onSearchTapped() {
    // Navigate to search screen
    Get.snackbar('Search', 'Search tapped');
  }

  void onBannerTapped() {
    // Navigate to offer details
    Get.snackbar('Offer', 'Limited time offer tapped');
  }
}
