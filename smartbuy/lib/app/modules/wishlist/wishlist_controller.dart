import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class WishlistController extends GetxController {
  final RxList<Map<String, dynamic>> wishlistItems = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'Sony WH-1000XM5 Wireless Noise Canceling Headphones',
      'image': 'assets/images/headphones.png',
      'price': 248.00,
      'discount': '15% OFF',
      'inStock': true,
    },
    {
      'id': '2',
      'name': 'Apple Watch Series 8',
      'brand': 'AEGERLER x APPLE',
      'image': 'assets/images/watch.png',
      'price': 399.00,
      'discount': '',
      'inStock': true,
    },
    {
      'id': '3',
      'name': 'Mechanical Keyboard RGB',
      'brand': 'COMPUTER x KEYTOWN',
      'image': 'assets/images/keyboard.png',
      'price': 129.00,
      'discount': '10% OFF',
      'inStock': true,
    },
    {
      'id': '4',
      'name': 'LED Designer Lamp',
      'brand': 'TUNN x MINIMALIST',
      'image': 'assets/images/lamp.png',
      'price': 89.00,
      'discount': '',
      'inStock': false,
    },
  ].obs;

  final RxString searchQuery = ''.obs;
  final RxList<Map<String, dynamic>> filteredItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredItems.value = wishlistItems;

    // Listen to search query changes
    ever(searchQuery, (_) => filterWishlist());
  }

  void filterWishlist() {
    if (searchQuery.value.isEmpty) {
      filteredItems.value = wishlistItems;
    } else {
      filteredItems.value = wishlistItems.where((item) {
        final name = item['name'].toString().toLowerCase();
        final brand = (item['brand'] ?? '').toString().toLowerCase();
        final query = searchQuery.value.toLowerCase();
        return name.contains(query) || brand.contains(query);
      }).toList();
    }
  }

  void removeFromWishlist(Map<String, dynamic> item) {
    wishlistItems.remove(item);
    filterWishlist();
    Helpers.showSuccess('removed_from_wishlist'.tr);
  }

  void clearAllWishlist() {
    if (wishlistItems.isEmpty) return;

    Get.defaultDialog(
      title: 'clear_wishlist'.tr,
      middleText: 'clear_wishlist_confirmation'.tr,
      textConfirm: 'yes_clear'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Get.theme.colorScheme.onPrimary,
      onConfirm: () {
        wishlistItems.clear();
        filterWishlist();
        Get.back();
        Helpers.showSuccess('wishlist_cleared'.tr);
      },
    );
  }

  void moveToCart(Map<String, dynamic> item) {
    // Remove from wishlist
    wishlistItems.remove(item);
    filterWishlist();

    // Show success message
    Helpers.showSuccess('moved_to_cart'.tr);
  }

  void notifyMe(Map<String, dynamic> item) {
    Helpers.showSuccess('${'notify_me_enabled'.tr} ${item['name']}');
  }
}
