import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> recommendedProducts = <Map<String, dynamic>>[].obs;
  final RxInt notificationCount = 2.obs;
  final RxInt cartCount = 2.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadRecommendedProducts();
  }

  void loadCategories() {
    // Mock data - replace with API call
    categories.value = [
      {
        'id': '1',
        'name': 'Fashion',
        'icon': 'fashion',
        'color': 0xFFEF8D32,
      },
      {
        'id': '2',
        'name': 'Electronics',
        'icon': 'electronics',
        'color': 0xFF6C5CE7,
      },
      {
        'id': '3',
        'name': 'Home',
        'icon': 'home',
        'color': 0xFF00B894,
      },
      {
        'id': '4',
        'name': 'Beauty',
        'icon': 'beauty',
        'color': 0xFFFF6B9D,
      },
    ];
  }

  void loadRecommendedProducts() {
    // Mock data - replace with API call
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
    ];
  }

  void onCategoryTapped(String categoryId) {
    // Navigate to category details or filter products
    Get.snackbar('Category', 'Category $categoryId tapped');
  }

  void onProductTapped(String productId) {
    // Navigate to product details
    Get.snackbar('Product', 'Product $productId tapped');
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
