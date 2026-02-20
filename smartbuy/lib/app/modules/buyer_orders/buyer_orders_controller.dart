import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class BuyerOrdersController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  final TextEditingController searchController = TextEditingController();
  final RxString selectedFilter = 'all'.obs;
  final RxString searchQuery = ''.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Orders data
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  // Status counts
  final RxInt allCount = 0.obs;
  final RxInt ongoingCount = 0.obs;
  final RxInt completedCount = 0.obs;
  final RxInt cancelledCount = 0.obs;

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
          matchesFilter = order['status'] == 'pending' ||
              order['status'] == 'processing' ||
              order['status'] == 'shipped';
          break;
        case 'completed':
          matchesFilter = order['status'] == 'delivered' ||
              order['status'] == 'completed';
          break;
        case 'cancelled':
          matchesFilter = order['status'] == 'cancelled';
          break;
      }

      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return matchesFilter &&
            (order['product_name']
                    .toString()
                    .toLowerCase()
                    .contains(query) ||
                order['order_number']
                    .toString()
                    .toLowerCase()
                    .contains(query));
      }

      return matchesFilter;
    }).toList();

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.buyerOrders);
      final data = response.data;

      final ordersList = data['orders'] as List? ?? [];
      orders.value = ordersList.map((o) {
        return <String, dynamic>{
          'id': o['id'],
          'order_number': o['order_number'] ?? '#${o['id']}',
          'product_name': o['product_name'] ?? 'Unknown Product',
          'product_image': o['product_image'],
          'items_count': o['items_count'] ?? 1,
          'orderDate': o['order_date'] ?? '',
          'price': (o['price'] is num) ? o['price'].toDouble() : 0.0,
          'status': o['status'] ?? 'pending',
          'display_status': o['display_status'] ?? o['status'],
          'tracking_number': o['tracking_number'],
          'vendor_name': o['vendor_name'],
          'cancelled_reason': o['cancelled_reason'],
          'deliveredDate': o['delivered_at'],
        };
      }).toList();

      final counts = data['counts'] ?? {};
      allCount.value = counts['all'] ?? 0;
      ongoingCount.value = counts['ongoing'] ?? 0;
      completedCount.value = counts['completed'] ?? 0;
      cancelledCount.value = counts['cancelled'] ?? 0;
    } catch (e) {
      _loadMockData();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _loadMockData() {
    orders.value = [
      {
        'id': 1,
        'order_number': 'SB-82910',
        'product_name': 'Sony WH-1000XM5 Wireless Noise Canceling Headphones',
        'product_image': null,
        'items_count': 1,
        'orderDate': 'Oct 24, 2023',
        'price': 348.00,
        'status': 'shipped',
        'display_status': 'shipped',
      },
      {
        'id': 2,
        'order_number': 'SB-82909',
        'product_name': 'Mechanical Keyboard with RGB Backlights',
        'product_image': null,
        'items_count': 1,
        'orderDate': 'Oct 18, 2023',
        'price': 89.99,
        'status': 'delivered',
        'display_status': 'delivered',
        'deliveredDate': 'Oct 20',
      },
      {
        'id': 3,
        'order_number': 'SB-8291',
        'product_name': 'Smart Watch Series 8 - Midnight',
        'product_image': null,
        'items_count': 1,
        'orderDate': 'Oct 12, 2023',
        'price': 399.00,
        'status': 'processing',
        'display_status': 'processing',
      },
      {
        'id': 4,
        'order_number': 'SB-8290',
        'product_name': 'Portable Bluetooth Speaker',
        'product_image': null,
        'items_count': 1,
        'orderDate': 'Oct 10, 2023',
        'price': 45.00,
        'status': 'cancelled',
        'display_status': 'cancelled',
      },
    ];
    allCount.value = orders.length;
    ongoingCount.value = orders
        .where((o) =>
            o['status'] == 'pending' ||
            o['status'] == 'processing' ||
            o['status'] == 'shipped')
        .length;
    completedCount.value = orders
        .where(
            (o) => o['status'] == 'delivered' || o['status'] == 'completed')
        .length;
    cancelledCount.value =
        orders.where((o) => o['status'] == 'cancelled').length;
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
      '${'adding_to_cart'.tr}: ${order['product_name']}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void cancelOrder(Map<String, dynamic> order) {
    Get.defaultDialog(
      title: 'cancel_order'.tr,
      middleText:
          '${'cancel_order_confirmation'.tr}\n\n${order['order_number']}',
      textConfirm: 'cancel_order'.tr,
      textCancel: 'go_back'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () async {
        Get.back();
        await _cancelOrderApi(order);
      },
    );
  }

  Future<void> _cancelOrderApi(Map<String, dynamic> order) async {
    try {
      await _apiProvider.put(
        '${ApiConstants.buyerOrders}/${order['id']}/cancel',
      );

      // Update local state
      final index = orders.indexWhere((o) => o['id'] == order['id']);
      if (index != -1) {
        orders[index]['status'] = 'cancelled';
        orders[index]['display_status'] = 'cancelled';
        orders.refresh();
      }

      allCount.value = orders.length;
      ongoingCount.value = orders
          .where((o) =>
              o['status'] == 'pending' ||
              o['status'] == 'processing' ||
              o['status'] == 'shipped')
          .length;
      cancelledCount.value =
          orders.where((o) => o['status'] == 'cancelled').length;

      Helpers.showSuccess('order_cancelled_successfully'.tr);
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    }
  }

  void viewCancellationDetails(Map<String, dynamic> order) {
    Get.toNamed(Routes.BUYER_ORDER_DETAILS, arguments: order);
  }
}
