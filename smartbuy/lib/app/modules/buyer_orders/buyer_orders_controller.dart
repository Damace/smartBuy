import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class BuyerOrdersController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString selectedFilter = 'all'.obs;
  final RxString searchQuery = ''.obs;

  // Sample orders data
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[
    {
      'id': 'SB-82910',
      'productName': 'Sony WH-1000XM5 Wireless Noise Canceling Headphones',
      'productImage': '🎧',
      'orderDate': 'Oct 24, 2023',
      'price': 348.00,
      'status': 'arriving_tomorrow',
      'statusColor': 'orange',
    },
    {
      'id': 'SB-82909',
      'productName': 'Mechanical Keyboard with RGB Backlights',
      'productImage': '⌨️',
      'orderDate': 'Oct 18, 2023',
      'price': 89.99,
      'status': 'delivered',
      'statusColor': 'green',
      'deliveredDate': 'Oct 20',
    },
    {
      'id': 'SB-8291',
      'productName': 'Smart Watch Series 8 - Midnight',
      'productImage': '⌚',
      'orderDate': 'Oct 12, 2023',
      'price': 399.00,
      'status': 'shipped',
      'statusColor': 'blue',
    },
    {
      'id': 'SB-8290',
      'productName': 'Portable Bluetooth Speaker',
      'productImage': '🔊',
      'orderDate': 'Oct 10, 2023',
      'price': 45.00,
      'status': 'cancelled',
      'statusColor': 'grey',
    },
  ].obs;

  // Filtered orders based on selected filter and search
  List<Map<String, dynamic>> get filteredOrders {
    var filtered = orders.where((order) {
      // Filter by status
      bool matchesFilter = false;
      switch (selectedFilter.value) {
        case 'all':
          matchesFilter = true;
          break;
        case 'ongoing':
          matchesFilter = order['status'] == 'arriving_tomorrow' ||
              order['status'] == 'shipped';
          break;
        case 'completed':
          matchesFilter = order['status'] == 'delivered';
          break;
        case 'cancelled':
          matchesFilter = order['status'] == 'cancelled';
          break;
      }

      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return matchesFilter &&
            (order['productName'].toString().toLowerCase().contains(query) ||
                order['id'].toString().toLowerCase().contains(query));
      }

      return matchesFilter;
    }).toList();

    return filtered;
  }

  // Get order count by status
  int get allCount => orders.length;
  int get ongoingCount => orders
      .where((o) =>
          o['status'] == 'arriving_tomorrow' || o['status'] == 'shipped')
      .length;
  int get completedCount =>
      orders.where((o) => o['status'] == 'delivered').length;
  int get cancelledCount =>
      orders.where((o) => o['status'] == 'cancelled').length;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void trackOrder(Map<String, dynamic> order) {
    Get.toNamed(Routes.BUYER_TRACK_ORDER, arguments: order);
  }

  void viewOrderDetails(Map<String, dynamic> order) {
    Get.toNamed(Routes.BUYER_ORDER_DETAILS, arguments: order);
  }

  void buyAgain(Map<String, dynamic> order) {
    Get.snackbar(
      'buy_again'.tr,
      '${'adding_to_cart'.tr}: ${order['productName']}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void viewCancellationDetails(Map<String, dynamic> order) {
    Get.snackbar(
      'cancellation_details'.tr,
      '${'order'.tr} ${order['id']} ${'was_cancelled'.tr}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
