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
    // Navigate to edit product screen
    Get.toNamed(Routes.VENDOR_EDIT_PRODUCT, arguments: product);
  }

  void deleteProduct(Map<String, dynamic> product) {
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              color: Colors.red.shade600,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'delete_product'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'delete_product_confirmation_message'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                products.removeWhere((p) => p['id'] == product['id']);
                Get.back();
                Get.snackbar(
                  'success'.tr,
                  'product_deleted_successfully'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'delete_product'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(
                  color: Get.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
              child: Text(
                'cancel'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
