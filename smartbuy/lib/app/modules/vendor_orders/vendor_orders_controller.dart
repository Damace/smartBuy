import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';
import '../../core/themes/app_theme.dart';
import '../../routes/app_pages.dart';

class VendorOrdersController extends GetxController {
  final RxString selectedFilter = 'pending'.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Orders list
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[
    {
      'id': '#SB-9921',
      'customer': 'Jane Doe',
      'total': 124.50,
      'items': 3,
      'status': 'pending',
      'timestamp': '2 mins ago',
      'isPriority': false,
    },
    {
      'id': '#SB-9844',
      'customer': 'Michael Ross',
      'total': 45.00,
      'items': 1,
      'status': 'pending',
      'timestamp': '15 mins ago',
      'isPriority': false,
    },
    {
      'id': '#SB-9830',
      'customer': 'Sarah Jenkins',
      'total': 210.99,
      'items': 5,
      'status': 'pending',
      'timestamp': '1 hour ago',
      'isPriority': false,
    },
    {
      'id': '#SB-9701',
      'customer': 'Alex Thompson',
      'product': 'Smart Watch Series X',
      'address': '742 Evergreen Terrace, Springfield',
      'total': 199.00,
      'items': 1,
      'status': 'pending',
      'timestamp': '30 mins ago',
      'isPriority': true,
      'image': 'watch',
    },
    {
      'id': '#SB-9800',
      'customer': 'John Smith',
      'total': 89.99,
      'items': 2,
      'status': 'processing',
      'timestamp': '2 hours ago',
      'isPriority': false,
    },
    {
      'id': '#SB-9755',
      'customer': 'Emma Wilson',
      'total': 156.00,
      'items': 4,
      'status': 'processing',
      'timestamp': '3 hours ago',
      'isPriority': false,
    },
    {
      'id': '#SB-9688',
      'customer': 'David Brown',
      'total': 299.99,
      'items': 1,
      'status': 'shipped',
      'timestamp': '1 day ago',
      'isPriority': false,
    },
    {
      'id': '#SB-9601',
      'customer': 'Lisa Anderson',
      'total': 75.50,
      'items': 3,
      'status': 'completed',
      'timestamp': '2 days ago',
      'isPriority': false,
    },
  ].obs;

  // Filtered orders based on selected filter and search
  List<Map<String, dynamic>> get filteredOrders {
    var filtered = orders.where((order) {
      // Filter by status
      bool matchesFilter = order['status'] == selectedFilter.value;

      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return matchesFilter &&
            (order['id'].toString().toLowerCase().contains(query) ||
                order['customer'].toString().toLowerCase().contains(query));
      }

      return matchesFilter;
    }).toList();

    return filtered;
  }

  // Get order count by status
  int get pendingCount =>
      orders.where((o) => o['status'] == 'pending').length;
  int get processingCount =>
      orders.where((o) => o['status'] == 'processing').length;
  int get shippedCount => orders.where((o) => o['status'] == 'shipped').length;
  int get completedCount =>
      orders.where((o) => o['status'] == 'completed').length;

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void acceptOrder(Map<String, dynamic> order) {
    Get.defaultDialog(
      title: 'accept_order'.tr,
      middleText: '${'accept_order_confirmation'.tr}\n\n${order['id']}',
      textConfirm: 'accept'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: AppTheme.primaryColor,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () {
        // Update order status
        final index = orders.indexWhere((o) => o['id'] == order['id']);
        if (index != -1) {
          orders[index]['status'] = 'processing';
          orders.refresh();
        }
        Get.back();
        Helpers.showSuccess('order_accepted'.tr);
      },
    );
  }

  void rejectOrder(Map<String, dynamic> order) {
    Get.defaultDialog(
      title: 'reject_order'.tr,
      middleText: '${'reject_order_confirmation'.tr}\n\n${order['id']}',
      textConfirm: 'reject'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () {
        orders.removeWhere((o) => o['id'] == order['id']);
        Get.back();
        Helpers.showSuccess('order_rejected'.tr);
      },
    );
  }

  void viewOrderDetails(Map<String, dynamic> order) {
    Get.toNamed(
      Routes.VENDOR_ORDER_DETAILS,
      arguments: order,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
