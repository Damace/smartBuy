import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';

class BuyerOrderDetailsController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  late Map<String, dynamic> orderData;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isCancelling = false.obs;

  // Order details
  final RxMap<String, dynamic> orderDetails = <String, dynamic>{}.obs;

  // Tracking status
  final RxList<Map<String, dynamic>> trackingStatus = <Map<String, dynamic>>[].obs;

  // Shipping address
  final RxString shippingName = ''.obs;
  final RxString shippingAddress = ''.obs;

  // Payment details
  final RxString paymentMethod = ''.obs;
  final RxString paymentStatus = ''.obs;

  // Order items
  final RxList<Map<String, dynamic>> orderItems = <Map<String, dynamic>>[].obs;

  // Price breakdown
  final RxDouble subtotal = 0.0.obs;
  final RxDouble tax = 0.0.obs;
  final RxDouble shippingCost = 0.0.obs;
  final RxDouble discount = 0.0.obs;
  final RxDouble total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    orderData = Get.arguments ?? {};
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    isLoading.value = true;
    try {
      final orderId = orderData['id'];
      if (orderId == null) {
        _loadFromArguments();
        return;
      }

      final response = await _apiProvider.get(
        '${ApiConstants.buyerOrders}/$orderId',
      );
      final data = response.data['order'];

      orderDetails.value = Map<String, dynamic>.from(data);

      // Parse tracking timeline
      final timeline = data['tracking_timeline'] as List? ?? [];
      trackingStatus.value = timeline.map((t) {
        return <String, dynamic>{
          'title': t['title'] ?? '',
          'time': t['time'] ?? '',
          'isCompleted': t['isCompleted'] ?? false,
          'isActive': t['isActive'] ?? false,
          'isCancelled': t['isCancelled'] ?? false,
        };
      }).toList();

      // Parse shipping address
      final shippingAddr = data['shipping_address'];
      if (shippingAddr is Map) {
        shippingName.value = shippingAddr['name'] ?? '';
        final parts = <String>[];
        if (shippingAddr['address'] != null) parts.add(shippingAddr['address']);
        if (shippingAddr['city'] != null) parts.add(shippingAddr['city']);
        if (shippingAddr['state'] != null) parts.add(shippingAddr['state']);
        if (shippingAddr['postal_code'] != null) parts.add(shippingAddr['postal_code']);
        if (shippingAddr['country'] != null) parts.add(shippingAddr['country']);
        shippingAddress.value = parts.join(', ');
      } else if (shippingAddr is String) {
        shippingAddress.value = shippingAddr;
      } else {
        shippingName.value = 'N/A';
        shippingAddress.value = 'N/A';
      }

      // Payment details
      paymentMethod.value = data['payment_method'] ?? 'N/A';
      paymentStatus.value = data['payment_status'] ?? 'N/A';

      // Order items
      final items = data['items'] as List? ?? [];
      orderItems.value = items.map((item) {
        return <String, dynamic>{
          'product_name': item['product_name'] ?? '',
          'product_image': item['product_image'],
          'quantity': item['quantity'] ?? 1,
          'price': (item['price'] is num) ? item['price'].toDouble() : 0.0,
          'total': (item['total'] is num) ? item['total'].toDouble() : 0.0,
        };
      }).toList();

      // Price breakdown
      subtotal.value = (data['subtotal'] is num) ? data['subtotal'].toDouble() : 0.0;
      tax.value = (data['tax'] is num) ? data['tax'].toDouble() : 0.0;
      shippingCost.value = (data['shipping_cost'] is num) ? data['shipping_cost'].toDouble() : 0.0;
      discount.value = (data['discount'] is num) ? data['discount'].toDouble() : 0.0;
      total.value = (data['total'] is num) ? data['total'].toDouble() : 0.0;
    } catch (e) {
      _loadFromArguments();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _loadFromArguments() {
    // Fallback to data passed from orders list
    orderDetails.value = Map<String, dynamic>.from(orderData);
    total.value = (orderData['price'] is num) ? orderData['price'].toDouble() : 0.0;
    subtotal.value = total.value;

    shippingName.value = 'Johnathan Doe';
    shippingAddress.value = '6391 Elgin St. Celina, Apt 401\nNew York, NY 10001\nUnited States';
    paymentMethod.value = 'Visa ending in 4242';
    paymentStatus.value = 'paid';

    // Build mock timeline based on status
    final status = orderData['status'] ?? 'pending';
    trackingStatus.value = _buildMockTimeline(status);
  }

  List<Map<String, dynamic>> _buildMockTimeline(String status) {
    switch (status) {
      case 'pending':
        return [
          {'title': 'Order Placed', 'time': orderData['orderDate'] ?? '', 'isCompleted': true},
          {'title': 'Processing', 'time': 'Waiting for vendor', 'isCompleted': false, 'isActive': true},
          {'title': 'Shipped', 'time': 'Pending', 'isCompleted': false},
          {'title': 'Delivered', 'time': 'Expected soon', 'isCompleted': false},
        ];
      case 'processing':
        return [
          {'title': 'Order Placed', 'time': orderData['orderDate'] ?? '', 'isCompleted': true},
          {'title': 'Processing', 'time': 'Vendor is preparing', 'isCompleted': true},
          {'title': 'Shipped', 'time': 'Pending', 'isCompleted': false, 'isActive': true},
          {'title': 'Delivered', 'time': 'Expected soon', 'isCompleted': false},
        ];
      case 'shipped':
        return [
          {'title': 'Order Placed', 'time': orderData['orderDate'] ?? '', 'isCompleted': true},
          {'title': 'Processing', 'time': 'Completed', 'isCompleted': true},
          {'title': 'Shipped', 'time': 'In transit', 'isCompleted': false, 'isActive': true},
          {'title': 'Delivered', 'time': 'Expected soon', 'isCompleted': false},
        ];
      case 'delivered':
      case 'completed':
        return [
          {'title': 'Order Placed', 'time': orderData['orderDate'] ?? '', 'isCompleted': true},
          {'title': 'Processing', 'time': 'Completed', 'isCompleted': true},
          {'title': 'Shipped', 'time': 'Completed', 'isCompleted': true},
          {'title': 'Delivered', 'time': orderData['deliveredDate'] ?? 'Delivered', 'isCompleted': true},
        ];
      case 'cancelled':
        return [
          {'title': 'Order Placed', 'time': orderData['orderDate'] ?? '', 'isCompleted': true},
          {'title': 'Cancelled', 'time': orderData['cancelled_reason'] ?? 'Order was cancelled', 'isCompleted': true, 'isCancelled': true},
        ];
      default:
        return [];
    }
  }

  void cancelOrder() {
    final status = orderDetails['status'] ?? orderData['status'];
    if (status != 'pending' && status != 'processing') {
      Helpers.showError('order_cannot_be_cancelled'.tr);
      return;
    }

    Get.defaultDialog(
      title: 'cancel_order'.tr,
      middleText: '${'cancel_order_confirmation'.tr}\n\n${orderData['order_number'] ?? ''}',
      textConfirm: 'cancel_order'.tr,
      textCancel: 'go_back'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () async {
        Get.back();
        await _cancelOrderApi();
      },
    );
  }

  Future<void> _cancelOrderApi() async {
    isCancelling.value = true;
    try {
      final orderId = orderData['id'];
      await _apiProvider.put(
        '${ApiConstants.buyerOrders}/$orderId/cancel',
      );

      orderDetails['status'] = 'cancelled';
      orderData['status'] = 'cancelled';
      trackingStatus.value = _buildMockTimeline('cancelled');

      Helpers.showSuccess('order_cancelled_successfully'.tr);
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isCancelling.value = false;
    }
  }

  void buyItAgain() {
    Get.snackbar(
      'buy_it_again'.tr,
      '${'adding_to_cart'.tr}: ${orderData['product_name'] ?? orderData['productName'] ?? ''}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void downloadInvoice() {
    Get.snackbar(
      'download_invoice'.tr,
      '${'downloading_invoice_for_order'.tr} ${orderData['order_number'] ?? orderData['id'] ?? ''}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void getHelp() {
    Get.snackbar(
      'help'.tr,
      'contacting_customer_support'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
