import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class CategoryController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxList<Map<String, dynamic>> subcategories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxList<String> searchSuggestions = <String>[].obs;

  final RxBool isLoadingCategories = false.obs;
  final RxBool isLoadingSubcategories = false.obs;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool isSearchActive = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedSortBy = 'latest'.obs;

  final searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  // --- Categories ---

  void loadCategories() async {
    isLoadingCategories.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.categories);
      final List<dynamic> data = response.data['data'] ?? response.data;
      if (data.isNotEmpty) {
        categories.value = data
            .map((c) => <String, dynamic>{
                  'id': c['id'].toString(),
                  'name': c['name'] ?? '',
                  'icon': _getCategoryIcon(c['icon'] ?? c['name'] ?? ''),
                  'color': _getCategoryColor(c['name'] ?? ''),
                  'image': c['image'],
                  'childrenCount': c['children_count'] ?? 0,
                  'productsCount': c['products_count'] ?? 0,
                })
            .toList()
            .cast<Map<String, dynamic>>();
        if (categories.isNotEmpty) {
          loadSubcategories(0);
          loadCategoryProducts(categories[0]['id']);
        }
        isLoadingCategories.value = false;
        return;
      }
    } catch (_) {}
    _loadMockCategories();
    isLoadingCategories.value = false;
  }

  void loadSubcategories(int categoryIndex) async {
    selectedCategoryIndex.value = categoryIndex;
    if (categoryIndex >= categories.length) return;

    final categoryId = categories[categoryIndex]['id'];
    isLoadingSubcategories.value = true;

    try {
      final response = await _apiProvider.get(
        '/categories/$categoryId/subcategories',
      );
      final List<dynamic> data = response.data['data'] ?? [];
      if (data.isNotEmpty) {
        subcategories.value = data
            .map((c) => <String, dynamic>{
                  'id': c['id'].toString(),
                  'name': c['name'] ?? '',
                  'icon': _getCategoryIcon(c['icon'] ?? c['name'] ?? ''),
                  'color': _getSubcategoryColor(data.indexOf(c)),
                  'image': c['image'],
                  'productsCount': c['products_count'] ?? 0,
                  'subtitle': '${c['products_count'] ?? 0} ${'products_count'.tr}',
                })
            .toList()
            .cast<Map<String, dynamic>>();
        isLoadingSubcategories.value = false;
        return;
      }
    } catch (_) {}

    _loadMockSubcategories(categoryId);
    isLoadingSubcategories.value = false;
  }

  void loadCategoryProducts(String categoryId) async {
    isLoadingProducts.value = true;
    try {
      final response = await _apiProvider.get(
        ApiConstants.products,
        queryParameters: {
          'category_id': categoryId,
          'sort_by': selectedSortBy.value,
          'per_page': 20,
        },
      );
      final data = response.data['data'] ?? response.data;
      if (data is List) {
        products.value = data
            .map((p) => <String, dynamic>{
                  'id': p['id'].toString(),
                  'name': p['name'] ?? '',
                  'price': _toDouble(
                    (p['sale_price'] != null &&
                            p['sale_price'].toString() != '0.00' &&
                            p['sale_price'].toString() != '0')
                        ? p['sale_price']
                        : p['price'],
                  ),
                  'originalPrice': (p['sale_price'] != null &&
                          p['sale_price'].toString() != '0.00' &&
                          p['sale_price'].toString() != '0')
                      ? _toDouble(p['price'])
                      : null,
                  'rating': _toDouble(p['rating']),
                  'image': p['primary_image'],
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

  // --- Search ---

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      isSearchActive.value = false;
      searchResults.clear();
      searchSuggestions.clear();
      return;
    }

    isSearchActive.value = true;
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) async {
    if (query.length < 2) return;
    isSearching.value = true;

    try {
      final response = await _apiProvider.get(
        '/products/search',
        queryParameters: {'q': query},
      );
      final data = response.data;

      if (data['products'] != null) {
        searchResults.value = (data['products'] as List)
            .map((p) => <String, dynamic>{
                  'id': p['id'].toString(),
                  'name': p['name'] ?? '',
                  'price': _toDouble(
                    (p['sale_price'] != null &&
                            p['sale_price'].toString() != '0.00' &&
                            p['sale_price'].toString() != '0')
                        ? p['sale_price']
                        : p['price'],
                  ),
                  'originalPrice': (p['sale_price'] != null &&
                          p['sale_price'].toString() != '0.00' &&
                          p['sale_price'].toString() != '0')
                      ? _toDouble(p['price'])
                      : null,
                  'rating': _toDouble(p['rating']),
                  'image': p['primary_image'],
                  'vendorName': p['vendor'] != null
                      ? p['vendor']['business_name'] ?? ''
                      : '',
                  'categoryName': p['category'] != null
                      ? p['category']['name'] ?? ''
                      : '',
                })
            .toList()
            .cast<Map<String, dynamic>>();
      }

      if (data['suggestions'] != null) {
        searchSuggestions.value =
            List<String>.from(data['suggestions'] ?? []);
      }
    } catch (_) {
      // Fallback: filter products locally
      final lowerQuery = query.toLowerCase();
      searchResults.value = products
          .where((p) =>
              p['name'].toString().toLowerCase().contains(lowerQuery) ||
              (p['vendorName'] ?? '').toString().toLowerCase().contains(lowerQuery))
          .toList();
    }
    isSearching.value = false;
  }

  void onSuggestionTapped(String suggestion) {
    searchTextController.text = suggestion;
    searchQuery.value = suggestion;
    searchFocusNode.unfocus();
    _performSearch(suggestion);
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    isSearchActive.value = false;
    searchResults.clear();
    searchSuggestions.clear();
    searchFocusNode.unfocus();
  }

  void activateSearch() {
    isSearchActive.value = true;
    searchFocusNode.requestFocus();
  }

  // --- Navigation ---

  void selectCategory(int index) {
    if (selectedCategoryIndex.value != index) {
      selectedCategoryIndex.value = index;
      loadSubcategories(index);
      loadCategoryProducts(categories[index]['id']);
    }
  }

  void onSubcategoryTapped(String subcategoryId) {
    loadCategoryProducts(subcategoryId);
  }

  void onProductTapped(String productId) {
    Get.toNamed(Routes.PRODUCT_DETAILS, arguments: {'id': productId});
  }

  void onViewAllTapped() {
    if (categories.isNotEmpty) {
      loadCategoryProducts(categories[selectedCategoryIndex.value]['id']);
    }
  }

  void onSortChanged(String sortBy) {
    selectedSortBy.value = sortBy;
    if (categories.isNotEmpty) {
      loadCategoryProducts(categories[selectedCategoryIndex.value]['id']);
    }
  }

  // --- Helpers ---

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'fashion':
        return Icons.checkroom;
      case 'home':
        return Icons.home;
      case 'beauty':
        return Icons.face;
      case 'groceries':
        return Icons.shopping_basket;
      case 'toys':
        return Icons.toys;
      case 'sports':
        return Icons.sports_basketball;
      case 'mobiles':
      case 'phones':
        return Icons.phone_android;
      case 'laptops':
        return Icons.laptop;
      case 'audio':
        return Icons.headphones;
      case 'cameras':
        return Icons.camera_alt;
      case 'wearables':
        return Icons.watch;
      case 'gaming':
        return Icons.sports_esports;
      case 'furniture':
        return Icons.weekend;
      case 'kitchen':
        return Icons.kitchen;
      case 'skincare':
        return Icons.face_retouching_natural;
      case 'fitness':
        return Icons.fitness_center;
      default:
        return Icons.category;
    }
  }

  int _getCategoryColor(String name) {
    switch (name.toLowerCase()) {
      case 'electronics':
        return 0xFF6C5CE7;
      case 'fashion':
        return 0xFFEF8D32;
      case 'home':
        return 0xFF00B894;
      case 'beauty':
        return 0xFFFF6B9D;
      case 'groceries':
        return 0xFF00CEC9;
      case 'toys':
        return 0xFFE17055;
      case 'sports':
        return 0xFF0984E3;
      default:
        return 0xFF636E72;
    }
  }

  int _getSubcategoryColor(int index) {
    const colors = [0xFF4ECDC4, 0xFF95E1D3, 0xFF6C5CE7, 0xFF2D3436, 0xFFFF6B6B, 0xFF4834D4];
    return colors[index % colors.length];
  }

  // --- Mock Data Fallback ---

  void _loadMockCategories() {
    categories.value = [
      {'id': '1', 'name': 'Electronics', 'icon': Icons.devices, 'color': 0xFF6C5CE7, 'childrenCount': 6, 'productsCount': 0},
      {'id': '2', 'name': 'Fashion', 'icon': Icons.checkroom, 'color': 0xFFEF8D32, 'childrenCount': 4, 'productsCount': 0},
      {'id': '3', 'name': 'Home', 'icon': Icons.home, 'color': 0xFF00B894, 'childrenCount': 4, 'productsCount': 0},
      {'id': '4', 'name': 'Beauty', 'icon': Icons.face, 'color': 0xFFFF6B9D, 'childrenCount': 4, 'productsCount': 0},
      {'id': '5', 'name': 'Sports', 'icon': Icons.sports_basketball, 'color': 0xFF0984E3, 'childrenCount': 4, 'productsCount': 0},
    ];
    if (categories.isNotEmpty) {
      _loadMockSubcategories('1');
    }
  }

  void _loadMockSubcategories(String categoryId) {
    switch (categoryId) {
      case '1':
        subcategories.value = [
          {'id': '1-1', 'name': 'Mobiles', 'subtitle': 'Phones & Tablets', 'icon': Icons.phone_android, 'color': 0xFF4ECDC4},
          {'id': '1-2', 'name': 'Laptops', 'subtitle': 'Computing', 'icon': Icons.laptop, 'color': 0xFF95E1D3},
          {'id': '1-3', 'name': 'Audio', 'subtitle': 'Headphones & Speakers', 'icon': Icons.headphones, 'color': 0xFF6C5CE7},
          {'id': '1-4', 'name': 'Cameras', 'subtitle': 'Photography', 'icon': Icons.camera_alt, 'color': 0xFF2D3436},
        ];
        break;
      case '2':
        subcategories.value = [
          {'id': '2-1', 'name': "Men's Clothing", 'subtitle': 'Shirts, Pants', 'icon': Icons.checkroom, 'color': 0xFF4ECDC4},
          {'id': '2-2', 'name': "Women's Clothing", 'subtitle': 'Dresses, Tops', 'icon': Icons.woman, 'color': 0xFF95E1D3},
          {'id': '2-3', 'name': 'Shoes', 'subtitle': 'Footwear', 'icon': Icons.directions_run, 'color': 0xFF6C5CE7},
          {'id': '2-4', 'name': 'Accessories', 'subtitle': 'Bags, Jewelry', 'icon': Icons.shopping_bag, 'color': 0xFF2D3436},
        ];
        break;
      default:
        subcategories.value = [];
    }
  }
}
