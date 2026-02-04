import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorStorePreviewController extends GetxController {
  final RxString selectedTab = 'products'.obs;
  final TextEditingController searchController = TextEditingController();

  final storeName = 'SmartBuy Official Store';
  final rating = 4.8;
  final followers = '12k';
  final location = 'New York, USA';

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Organic Coffee Beans',
      'price': 24.99,
      'rating': 4.5,
      'image': '☕',
    },
    {
      'name': 'Wireless Headphones',
      'price': 89.99,
      'rating': 4.7,
      'image': '🎧',
    },
    {
      'name': 'Smart Watch Series 5',
      'price': 199.00,
      'rating': 4.6,
      'image': '⌚',
    },
    {
      'name': 'Genuine Leather Wallet',
      'price': 45.00,
      'rating': 4.8,
      'image': '👛',
    },
  ];

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  void editStore() {
    Get.snackbar(
      'Edit Store',
      'Edit store feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
