import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class SearchController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    // Start with empty or suggested products if needed
  }

  @override
  void onClose() {
    searchTextController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    _performSearch(query);
  }

  Future<void> _performSearch(String query) async {
    if (query.length < 2) return;
    
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(
        ApiConstants.searchProducts,
        queryParameters: {'q': query},
      );
      
      final data = response.data['data'] ?? response.data['products'] ?? response.data;
      
      if (data is List) {
        searchResults.assignAll(data.map((p) => <String, dynamic>{
          'id': p['id'].toString(),
          'name': p['name'] ?? '',
          'price': _toDouble(p['sale_price'] ?? p['price']),
          'image': p['primary_image'] ?? p['image'] ?? '',
          'rating': _toDouble(p['rating']),
          'vendor_name': p['vendor']?['business_name'] ?? '',
        }).toList());
      }
    } catch (e) {
      debugPrint("Search error: $e");
      // Fallback or empty list
    } finally {
      isLoading.value = false;
    }
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  void onProductTapped(String productId) {
    Get.toNamed(Routes.PRODUCT_DETAILS, arguments: {'id': productId});
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    searchResults.clear();
  }
}
