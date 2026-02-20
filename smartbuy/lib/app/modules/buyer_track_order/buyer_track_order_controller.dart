import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';

class BuyerTrackOrderController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  late Map<String, dynamic> orderData;

  // Loading state
  final RxBool isLoading = false.obs;

  // Delivery information
  final RxString estimatedArrival = ''.obs;
  final RxString deliveryPartner = ''.obs;
  final RxDouble partnerRating = 0.0.obs;
  final RxString deliveryStatus = ''.obs;
  final RxString trackingNumber = ''.obs;
  final RxString carrier = ''.obs;

  // Order status timeline
  final RxList<Map<String, dynamic>> orderStatus = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    orderData = Get.arguments ?? {};
    fetchTrackingDetails();
  }

  Future<void> fetchTrackingDetails() async {
    isLoading.value = true;
    try {
      final orderId = orderData['id'];
      if (orderId == null) {
        _loadMockData();
        return;
      }

      final response = await _apiProvider.get(
        '${ApiConstants.buyerOrders}/$orderId/track',
      );
      final data = response.data;

      // Set tracking info
      trackingNumber.value = data['tracking_number'] ?? '';
      estimatedArrival.value = data['estimated_delivery'] ?? '';

      // Set delivery status
      final status = data['status'] ?? 'pending';
      deliveryStatus.value = _getDeliveryStatusLabel(status);

      // Set shipment info
      final shipment = data['shipment'];
      if (shipment != null) {
        carrier.value = shipment['carrier'] ?? '';
        deliveryPartner.value = shipment['partner'] ?? '';
        partnerRating.value = 4.5; // Default rating
      } else {
        deliveryPartner.value = 'N/A';
      }

      // Set tracking timeline
      final timeline = data['tracking_timeline'] as List? ?? [];
      orderStatus.value = timeline.map((t) {
        return <String, dynamic>{
          'title': t['title'] ?? '',
          'subtitle': t['time'] ?? '',
          'icon': _getStatusIcon(t['title'] ?? ''),
          'isCompleted': t['isCompleted'] ?? false,
          'isActive': t['isActive'] ?? false,
          'isCancelled': t['isCancelled'] ?? false,
        };
      }).toList();
    } catch (e) {
      _loadMockData();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  String _getDeliveryStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'PENDING';
      case 'processing':
        return 'PREPARING';
      case 'shipped':
        return 'ON ITS WAY';
      case 'delivered':
      case 'completed':
        return 'DELIVERED';
      case 'cancelled':
        return 'CANCELLED';
      default:
        return status.toUpperCase();
    }
  }

  IconData _getStatusIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('confirm') || lower.contains('placed') || lower.contains('order')) {
      return Icons.check_circle;
    } else if (lower.contains('process') || lower.contains('pack') || lower.contains('ready')) {
      return Icons.inventory_2;
    } else if (lower.contains('ship') || lower.contains('delivery') || lower.contains('transit')) {
      return Icons.local_shipping;
    } else if (lower.contains('deliver') || lower.contains('arrived') || lower.contains('destination')) {
      return Icons.location_on;
    } else if (lower.contains('cancel')) {
      return Icons.cancel;
    }
    return Icons.circle;
  }

  void _loadMockData() {
    estimatedArrival.value = '12:45 PM';
    deliveryPartner.value = 'Max Johnson';
    partnerRating.value = 4.5;
    deliveryStatus.value = 'ON ITS WAY';

    orderStatus.value = [
      {
        'title': 'Order Confirmed',
        'subtitle': 'Your order has been received at 10:30 AM',
        'icon': Icons.check_circle,
        'isCompleted': true,
      },
      {
        'title': 'Packed & Ready',
        'subtitle': 'Vendor has packed your order at 11:35 AM',
        'icon': Icons.inventory_2,
        'isCompleted': true,
      },
      {
        'title': 'Out for Delivery',
        'subtitle': 'Driver is 15 mins away from your location',
        'icon': Icons.local_shipping,
        'isActive': true,
      },
      {
        'title': 'Arrived at Destination',
        'subtitle': 'Expected by 12:45 PM',
        'icon': Icons.location_on,
        'isCompleted': false,
      },
    ];
  }

  void callDeliveryPartner() {
    Get.snackbar(
      'calling'.tr,
      '${'calling'.tr} ${deliveryPartner.value}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
