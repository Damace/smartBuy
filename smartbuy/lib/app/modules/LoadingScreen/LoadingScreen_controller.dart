import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class LoadingScreenController extends GetxController {
  final storage = GetStorage();
  final ApiProvider _apiProvider = ApiProvider();
  final Connectivity _connectivity = Connectivity();

  // Connection state
  final RxBool isConnected = false.obs;
  final RxBool hasNoConnection = false.obs;
  final RxBool isRetrying = false.obs;

  // Steps: each map has 'label' (translation key) and 'state': waiting|loading|done|failed
  final RxList<Map<String, dynamic>> steps = <Map<String, dynamic>>[].obs;

  // Pre-loaded data (used by HomeController after navigation)
  final RxList<String> categories = <String>[].obs;
  final RxList<Map<String, dynamic>> recommendedProducts =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> banners = <Map<String, dynamic>>[].obs;
  final RxInt cartCount = 0.obs;
  final RxInt notificationCount = 0.obs;

  // Legacy observables kept for HomeView compatibility
  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingVendorProducts = false.obs;
  final RxList<Map<String, dynamic>> vendorProducts =
      <Map<String, dynamic>>[].obs;
  final RxInt currentBannerIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initSteps();
    _start();
  }

  // ── Steps management ────────────────────────────────────────────────────────

  void _initSteps() {
    steps.value = [
      {'label': 'step_checking_connection', 'state': 'waiting'},
      {'label': 'step_loading_categories', 'state': 'waiting'},
      {'label': 'step_loading_products', 'state': 'waiting'},
      {'label': 'step_loading_banners', 'state': 'waiting'},
    ];
    hasNoConnection.value = false;
  }

  void _setStep(int index, String state) {
    if (index >= steps.length) return;
    final updated = List<Map<String, dynamic>>.from(steps);
    updated[index] = {...updated[index], 'state': state};
    steps.value = updated;
  }

  // ── Initialization sequence ─────────────────────────────────────────────────

  Future<void> _start() async {
    _initSteps();

    // Step 0 — Network connectivity
    _setStep(0, 'loading');
    await Future.delayed(const Duration(milliseconds: 300));
    final connected = await _checkNetwork();
    if (!connected) {
      _setStep(0, 'failed');
      hasNoConnection.value = true;
      return;
    }
    isConnected.value = true;
    _setStep(0, 'done');

    // Step 1 — Categories
    _setStep(1, 'loading');
    await _loadCategories();
    _setStep(1, 'done');

    // Step 2 — Products
    _setStep(2, 'loading');
    await _loadProducts();
    _setStep(2, 'done');

    // Step 3 — Banners
    _setStep(3, 'loading');
    await _loadBanners();
    _setStep(3, 'done');

    // Brief pause so the user sees all green ticks
    await Future.delayed(const Duration(milliseconds: 500));
    _navigate();
  }

  // ── Network check ───────────────────────────────────────────────────────────

  Future<bool> _checkNetwork() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet);
    } catch (_) {
      return false;
    }
  }

  // ── Data loaders ────────────────────────────────────────────────────────────

  Future<void> _loadCategories() async {
    try {
      final response = await _apiProvider.get(ApiConstants.categories);
      final data = response.data['data'] ?? response.data;
      if (data is List && data.isNotEmpty) {
        categories.value =
            data.map((c) => c['name']?.toString() ?? '').toList();
        return;
      }
    } catch (_) {}
    categories.value = [
      'Fashion', 'Electronics', 'Home', 'Beauty',
      'Grocery', 'Sports', 'Toys', 'Books',
    ];
  }

  Future<void> _loadProducts() async {
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
                  'image': p['primary_image'] ?? '',
                  'badge': p['is_featured'] == true ? 'Hot Sale' : null,
                  'vendorName': p['vendor'] != null
                      ? p['vendor']['business_name'] ?? ''
                      : '',
                })
            .toList()
            .cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    isLoadingProducts.value = false;
  }

  Future<void> _loadBanners() async {
    try {
      final response = await _apiProvider.get(ApiConstants.banners);
      final data = response.data['data'] ?? response.data;
      if (data is List && data.isNotEmpty) {
        banners.value = data
            .map((b) => <String, dynamic>{
                  'id': b['id'].toString(),
                  'title': b['title'] ?? '',
                  'subtitle': b['subtitle'] ?? '',
                  'image': b['image'] ?? '',
                  'icon': b['icon'] ?? 'local_offer',
                  'link_type': b['link_type'] ?? '',
                  'link_id': b['link_id']?.toString() ?? '',
                })
            .toList();
        return;
      }
    } catch (_) {}
    banners.value = [
      {'id': '1', 'title': '20% Off', 'subtitle': 'On all furniture', 'icon': 'chair'},
      {'id': '2', 'title': '30% Off', 'subtitle': 'Electronics sale', 'icon': 'devices'},
      {
        'id': '3',
        'title': 'Free Shipping',
        'subtitle': 'On orders above KES 500',
        'icon': 'local_shipping',
      },
    ];
  }

  // ── Navigation ──────────────────────────────────────────────────────────────

  void _navigate() {
    final token = storage.read(AppConstants.storageKeyToken);
    final userData = storage.read(AppConstants.storageKeyUser);
    if (token != null) {
      final userType = (userData is Map) ? userData['role'] : null;
      if (userType == 'vendor') {
        Get.offNamed(Routes.VENDOR_HOME);
      } else {
        Get.offNamed(Routes.HOME);
      }
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }

  // ── Retry ───────────────────────────────────────────────────────────────────

  Future<void> retry() async {
    isRetrying.value = true;
    await _start();
    isRetrying.value = false;
  }

  // ── Legacy helpers (HomeView compatibility) ─────────────────────────────────

  void onSeeAllNewArrivals() {
    try {
      final navController = Get.find<dynamic>();
      if (navController.runtimeType.toString().contains('MainNavigation')) {
        navController.changePage(1);
      }
    } catch (_) {}
  }

  void onBannerTapped() => onSeeAllNewArrivals();
  void onProductTapped(String productId) =>
      Get.toNamed(Routes.PRODUCT_DETAILS, arguments: {'id': productId});
  void onNotificationTapped() => Get.toNamed(Routes.BUYER_MESSAGES_INBOX);
  void onCartTapped() => Get.toNamed(Routes.CART);
  void onSearchTapped() => Get.toNamed(Routes.SEARCH);
  void onSeeAllCategories() => onSeeAllNewArrivals();

  void loadCartCount() async {
    try {
      final response = await _apiProvider.get(ApiConstants.cart);
      cartCount.value = response.data['total_items'] ?? 0;
    } catch (_) {}
  }

  void onAddToCartTapped(String productId) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.addToCart,
        data: {'product_id': int.tryParse(productId) ?? 0, 'quantity': 1},
      );
      cartCount.value = response.data['cart_count'] ?? (cartCount.value + 1);
      Get.snackbar('cart'.tr, 'item_added'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    } catch (_) {
      Get.snackbar('cart'.tr, 'cart_error'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  void onWishlistTapped(String productId) async {
    try {
      await _apiProvider.post(
        ApiConstants.buyerWishlist,
        data: {'product_id': int.tryParse(productId) ?? 0},
      );
      Get.snackbar('wishlist'.tr, 'item_saved'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    } catch (e) {
      final message = e.toString().contains('already')
          ? 'already_in_wishlist'.tr
          : 'wishlist_error'.tr;
      Get.snackbar('wishlist'.tr, message,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
