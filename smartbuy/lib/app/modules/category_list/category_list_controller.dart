import 'package:SmartBuy/app/core/constants/api_constants.dart';
import 'package:SmartBuy/app/core/constants/cart_count.dart';
import 'package:SmartBuy/app/data/models/product_model.dart';
import 'package:SmartBuy/app/data/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryListController extends GetxController {
  RxString selectedFilter = 'All'.obs;
  RxBool isGrid = false.obs;
  RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;

  final ApiProvider _apiProvider = ApiProvider();

  RxBool isLoading = false.obs;

  RxString selectedCategory = ''.obs;

  /// All products (flattened)
  RxList<Map<String, dynamic>> allProducts = <Map<String, dynamic>>[].obs;

  /// Filtered products
  RxList<Map<String, dynamic>> filteredProducts = <Map<String, dynamic>>[].obs;

  final filters = ['All', 'Phones', 'Laptops', 'Audio', 'Wearables'];

  late String categoryName;
  late Future<List<ProductModel>> product;

  @override
  void onInit() {
    super.onInit();

    categoryName = Get.arguments ?? 'All';
    selectedCategory.value = categoryName;
    selectedFilter.value = 'All'; // Default filter chip
    loadVendorProducts();
  }

  Future<void> loadVendorProducts() async {
    isLoading.value = true;

    try {
      final response = await _apiProvider.get(ApiConstants.products);
      final data = response.data['data'] ?? response.data;

      if (data is List) {
        final List<Map<String, dynamic>> tempProducts = [];

        for (var p in data) {
          // Get category name from various possible fields
          String pCategory = '';
          if (p['category'] is Map) {
            pCategory = p['category']['name'] ?? '';
          } else if (p['category'] is String) {
            pCategory = p['category'];
          } else if (p['category_name'] != null) {
            pCategory = p['category_name'];
          }

          tempProducts.add({
            'id': p['id'].toString(),
            'name': p['name'] ?? '',
            'price':
                (p['sale_price'] != null &&
                    p['sale_price'].toString() != '0.00' &&
                    p['sale_price'].toString() != '0')
                ? _toDouble(p['sale_price'])
                : _toDouble(p['price']),
            'image': p['primary_image'] ?? p['image'] ?? '',
            'rating': _toDouble(p['rating']),
            'category': pCategory,
            'vendor_name': p['vendor']?['business_name'] ?? '',
          });
        }

        allProducts.assignAll(tempProducts);
        _filterProducts();
      }
    } catch (e) {
      debugPrint("Error loading products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _filterProducts() {
    // The base category is either what came from arguments or what is selected in chips
    // If chip is 'All', we filter by the initial categoryName (from arguments)
    // If chip is specific, we filter by that specific category

    final String activeFilter = selectedFilter.value == 'All'
        ? categoryName.toLowerCase().trim()
        : selectedFilter.value.toLowerCase().trim();

    if (activeFilter == 'all') {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(
        allProducts.where((p) {
          final pCat = (p['category'] ?? '').toString().toLowerCase().trim();
          return pCat == activeFilter;
        }).toList(),
      );
    }

    debugPrint(
      "Filter applied: $activeFilter, Results: ${filteredProducts.length}",
    );
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    _filterProducts();
  }

  void toggleLayout() {
    isGrid.value = !isGrid.value;
  }

  Future<void> addToCart(String productId) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.addToCart,
        data: {'product_id': int.tryParse(productId) ?? 0, 'quantity': 1},
      );
      globalCartCount.value =
          response.data['cart_count'] ?? (globalCartCount.value + 1);
      Get.snackbar(
        'Cart',
        'Item added to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
