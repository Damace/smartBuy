import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class VendorProductsController extends GetxController {
  final RxString selectedFilter = 'all'.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Product list
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[
    {
      'id': 'prod_001',
      'name': 'Organic Wildflower Honey',
      'price': 24.99,
      'stock': 42,
      'status': 'in_stock',
      'image': 'honey',
    },
    {
      'id': 'prod_002',
      'name': 'Pro Wireless Headphones',
      'price': 89.00,
      'stock': 0,
      'status': 'out_of_stock',
      'image': 'headphones',
    },
    {
      'id': 'prod_003',
      'name': 'Smartwatch Series 7',
      'price': 199.00,
      'stock': 0,
      'status': 'draft',
      'image': 'watch',
    },
    {
      'id': 'prod_004',
      'name': 'Glass Water Bottle 1L',
      'price': 15.50,
      'stock': 156,
      'status': 'in_stock',
      'image': 'bottle',
    },
    {
      'id': 'prod_005',
      'name': 'Minimalist Desk Lamp',
      'price': 45.00,
      'stock': 8,
      'status': 'in_stock',
      'image': 'lamp',
    },
  ].obs;

  // Filtered products based on selected filter and search
  List<Map<String, dynamic>> get filteredProducts {
    var filtered = products.where((product) {
      // Filter by status
      bool matchesFilter = false;
      switch (selectedFilter.value) {
        case 'all':
          matchesFilter = true;
          break;
        case 'in_stock':
          matchesFilter = product['status'] == 'in_stock';
          break;
        case 'out_of_stock':
          matchesFilter = product['status'] == 'out_of_stock';
          break;
        case 'drafts':
          matchesFilter = product['status'] == 'draft';
          break;
      }

      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return matchesFilter &&
            (product['name'].toString().toLowerCase().contains(query) ||
                product['id'].toString().toLowerCase().contains(query));
      }

      return matchesFilter;
    }).toList();

    return filtered;
  }

  // Get product count by status
  int get allCount => products.length;
  int get inStockCount =>
      products.where((p) => p['status'] == 'in_stock').length;
  int get outOfStockCount =>
      products.where((p) => p['status'] == 'out_of_stock').length;
  int get draftsCount => products.where((p) => p['status'] == 'draft').length;

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void addNewProduct() {
    Get.toNamed(Routes.VENDOR_ADD_PRODUCT);
  }

  void editProduct(Map<String, dynamic> product) {
    // Navigate to edit product screen (placeholder for now)
    Get.snackbar(
      'edit_product'.tr,
      '${'editing'.tr}: ${product['name']}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void deleteProduct(Map<String, dynamic> product) {
    Get.defaultDialog(
      title: 'delete_product'.tr,
      middleText: '${'delete_product_confirmation'.tr}\n\n${product['name']}',
      textConfirm: 'delete'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () {
        products.removeWhere((p) => p['id'] == product['id']);
        Get.back();
        Get.snackbar(
          'success'.tr,
          'product_deleted'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
