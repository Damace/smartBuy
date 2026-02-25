import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../core/themes/app_theme.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class VendorOrdersController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final RxString selectedFilter = 'pending'.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isActioning = false.obs;

  // Orders list
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  // Published products
  final RxBool isLoadingProducts = false.obs;
  final RxList<Map<String, dynamic>> publishedProducts =
      <Map<String, dynamic>>[].obs;

  // Status counts
  final RxInt pendingCount = 0.obs;
  final RxInt processingCount = 0.obs;
  final RxInt shippedCount = 0.obs;
  final RxInt completedCount = 0.obs;

  // Filtered orders based on selected filter and search
  List<Map<String, dynamic>> get filteredOrders {
    var filtered = orders.where((order) {
      bool matchesFilter = order['status'] == selectedFilter.value;

      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return matchesFilter &&
            (order['order_number'].toString().toLowerCase().contains(query) ||
                order['customer'].toString().toLowerCase().contains(query));
      }

      return matchesFilter;
    }).toList();

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    fetchPublishedProducts();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final queryParams = <String, dynamic>{};
      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      final response = await _apiProvider.get(
        ApiConstants.vendorOrders,
        queryParameters: queryParams,
      );
      final data = response.data;

      final ordersList = data['orders'] as List? ?? [];
      orders.value = ordersList.map((o) {
        final createdAt = DateTime.tryParse(o['created_at'] ?? '');
        return <String, dynamic>{
          'id': o['id'],
          'order_number': o['order_number'] ?? '#${o['id']}',
          'customer': o['customer'] ?? 'Unknown',
          'total': (o['total'] is num) ? o['total'].toDouble() : 0.0,
          'items': o['items_count'] ?? 0,
          'status': o['status'] ?? 'pending',
          'timestamp': _formatTimestamp(createdAt),
          'isPriority': false,
          'shipping_address': o['shipping_address'],
          'tracking_number': o['tracking_number'],
          'payment_status': o['payment_status'],
        };
      }).toList();

      final counts = data['counts'] ?? {};
      pendingCount.value = counts['pending'] ?? 0;
      processingCount.value = counts['processing'] ?? 0;
      shippedCount.value = counts['shipped'] ?? 0;
      completedCount.value = counts['completed'] ?? 0;
    } catch (e) {
      _loadMockData();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPublishedProducts() async {
    isLoadingProducts.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.vendorProducts);
      final data = response.data['data'] ?? response.data;
      if (data is List) {
        publishedProducts.value = data
            .where((p) {
              final status = p['status']?.toString() ?? '';
              final qty = p['quantity'];
              final q = qty is int ? qty : int.tryParse(qty.toString()) ?? 0;
              return status != 'draft' && status != 'pending' && q > 0;
            })
            .map((p) {
              final images = p['images'] as List? ?? [];
              final primary = images.isNotEmpty
                  ? images.firstWhere(
                      (i) => i['is_primary'] == true,
                      orElse: () => images.first,
                    )
                  : null;
              return <String, dynamic>{
                'id': p['id'].toString(),
                'name': p['name'] ?? '',
                'price': (p['price'] is String
                        ? double.tryParse(p['price'])
                        : p['price'] ?? 0)
                    .toDouble(),
                'stock': p['quantity'] ?? 0,
                'image': primary?['image_path'] ?? '',
                'category': p['category']?['name'] ?? '',
                'sku': p['sku'] ?? '',
              };
            })
            .toList()
            .cast<Map<String, dynamic>>();
      }
    } catch (e) {
      _loadMockPublishedProducts();
    } finally {
      isLoadingProducts.value = false;
    }
  }

  void _loadMockPublishedProducts() {
    publishedProducts.value = [
      {
        'id': 'prod_001',
        'name': 'Organic Wildflower Honey',
        'price': 24.99,
        'stock': 42,
        'image': '',
        'category': 'Food',
        'sku': 'SKU-001',
      },
      {
        'id': 'prod_004',
        'name': 'Glass Water Bottle 1L',
        'price': 15.50,
        'stock': 156,
        'image': '',
        'category': 'Kitchen',
        'sku': 'SKU-004',
      },
      {
        'id': 'prod_005',
        'name': 'Minimalist Desk Lamp',
        'price': 45.00,
        'stock': 8,
        'image': '',
        'category': 'Home',
        'sku': 'SKU-005',
      },
    ];
  }

  String _formatTimestamp(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'just_now'.tr;
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${'mins_ago'.tr}';
    if (diff.inHours < 24) return '${diff.inHours} ${'hours_ago'.tr}';
    if (diff.inDays < 7) return '${diff.inDays} ${'days_ago'.tr}';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _loadMockData() {
    orders.value = [
      {
        'id': 1,
        'order_number': '#SB-9921',
        'customer': 'Jane Doe',
        'total': 124.50,
        'items': 3,
        'status': 'pending',
        'timestamp': '2 mins ago',
        'isPriority': false,
      },
      {
        'id': 2,
        'order_number': '#SB-9844',
        'customer': 'Michael Ross',
        'total': 45.00,
        'items': 1,
        'status': 'pending',
        'timestamp': '15 mins ago',
        'isPriority': false,
      },
      {
        'id': 3,
        'order_number': '#SB-9830',
        'customer': 'Sarah Jenkins',
        'total': 210.99,
        'items': 5,
        'status': 'pending',
        'timestamp': '1 hour ago',
        'isPriority': false,
      },
      {
        'id': 4,
        'order_number': '#SB-9800',
        'customer': 'John Smith',
        'total': 89.99,
        'items': 2,
        'status': 'processing',
        'timestamp': '2 hours ago',
        'isPriority': false,
      },
      {
        'id': 5,
        'order_number': '#SB-9755',
        'customer': 'Emma Wilson',
        'total': 156.00,
        'items': 4,
        'status': 'processing',
        'timestamp': '3 hours ago',
        'isPriority': false,
      },
      {
        'id': 6,
        'order_number': '#SB-9688',
        'customer': 'David Brown',
        'total': 299.99,
        'items': 1,
        'status': 'shipped',
        'timestamp': '1 day ago',
        'isPriority': false,
      },
      {
        'id': 7,
        'order_number': '#SB-9601',
        'customer': 'Lisa Anderson',
        'total': 75.50,
        'items': 3,
        'status': 'completed',
        'timestamp': '2 days ago',
        'isPriority': false,
      },
    ];
    pendingCount.value =
        orders.where((o) => o['status'] == 'pending').length;
    processingCount.value =
        orders.where((o) => o['status'] == 'processing').length;
    shippedCount.value =
        orders.where((o) => o['status'] == 'shipped').length;
    completedCount.value =
        orders.where((o) => o['status'] == 'completed').length;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void acceptOrder(Map<String, dynamic> order) {
    Get.defaultDialog(
      title: 'accept_order'.tr,
      middleText:
          '${'accept_order_confirmation'.tr}\n\n${order['order_number']}',
      textConfirm: 'accept'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: AppTheme.primaryColor,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () async {
        Get.back();
        await _acceptOrderApi(order);
      },
    );
  }

  Future<void> _acceptOrderApi(Map<String, dynamic> order) async {
    isActioning.value = true;
    try {
      await _apiProvider.put(
        '${ApiConstants.vendorOrders}/${order['id']}/accept',
      );

      // Update local state
      final index = orders.indexWhere((o) => o['id'] == order['id']);
      if (index != -1) {
        orders[index]['status'] = 'processing';
        orders.refresh();
      }
      pendingCount.value = (pendingCount.value - 1).clamp(0, 999);
      processingCount.value = processingCount.value + 1;

      Helpers.showSuccess('order_accepted'.tr);
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isActioning.value = false;
    }
  }

  void rejectOrder(Map<String, dynamic> order) {
    Get.defaultDialog(
      title: 'reject_order'.tr,
      middleText:
          '${'reject_order_confirmation'.tr}\n\n${order['order_number']}',
      textConfirm: 'reject'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () async {
        Get.back();
        await _rejectOrderApi(order);
      },
    );
  }

  Future<void> _rejectOrderApi(Map<String, dynamic> order) async {
    isActioning.value = true;
    try {
      await _apiProvider.put(
        '${ApiConstants.vendorOrders}/${order['id']}/reject',
      );

      // Remove from local list
      orders.removeWhere((o) => o['id'] == order['id']);
      pendingCount.value = (pendingCount.value - 1).clamp(0, 999);

      Helpers.showSuccess('order_rejected'.tr);
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isActioning.value = false;
    }
  }

  void updateOrderStatus(Map<String, dynamic> order, String newStatus,
      {String? trackingNumber}) {
    final statusLabels = {
      'processing': 'processing'.tr,
      'shipped': 'shipped'.tr,
      'completed': 'completed'.tr,
    };

    Get.defaultDialog(
      title: 'update_status'.tr,
      middleText:
          '${'update_status_confirmation'.tr}\n\n${order['order_number']} → ${statusLabels[newStatus] ?? newStatus}',
      textConfirm: 'confirm'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: AppTheme.primaryColor,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () async {
        Get.back();
        await _updateStatusApi(order, newStatus,
            trackingNumber: trackingNumber);
      },
    );
  }

  Future<void> _updateStatusApi(
      Map<String, dynamic> order, String newStatus,
      {String? trackingNumber}) async {
    isActioning.value = true;
    try {
      final data = <String, dynamic>{'status': newStatus};
      if (trackingNumber != null && trackingNumber.isNotEmpty) {
        data['tracking_number'] = trackingNumber;
      }

      await _apiProvider.put(
        '${ApiConstants.vendorOrders}/${order['id']}/status',
        data: data,
      );

      final oldStatus = order['status'];
      // Update local state
      final index = orders.indexWhere((o) => o['id'] == order['id']);
      if (index != -1) {
        orders[index]['status'] = newStatus;
        if (trackingNumber != null) {
          orders[index]['tracking_number'] = trackingNumber;
        }
        orders.refresh();
      }

      // Update counts
      _decrementCount(oldStatus);
      _incrementCount(newStatus);

      Helpers.showSuccess('order_status_updated'.tr);
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isActioning.value = false;
    }
  }

  void _decrementCount(String status) {
    switch (status) {
      case 'pending':
        pendingCount.value = (pendingCount.value - 1).clamp(0, 999);
        break;
      case 'processing':
        processingCount.value = (processingCount.value - 1).clamp(0, 999);
        break;
      case 'shipped':
        shippedCount.value = (shippedCount.value - 1).clamp(0, 999);
        break;
      case 'completed':
        completedCount.value = (completedCount.value - 1).clamp(0, 999);
        break;
    }
  }

  void _incrementCount(String status) {
    switch (status) {
      case 'pending':
        pendingCount.value++;
        break;
      case 'processing':
        processingCount.value++;
        break;
      case 'shipped':
        shippedCount.value++;
        break;
      case 'completed':
        completedCount.value++;
        break;
    }
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
