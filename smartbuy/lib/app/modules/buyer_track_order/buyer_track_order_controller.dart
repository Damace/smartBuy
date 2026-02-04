import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerTrackOrderController extends GetxController {
  late Map<String, dynamic> orderData;

  // Delivery information
  final RxString estimatedArrival = '12:45 PM'.obs;
  final RxString deliveryPartner = 'Max Johnson'.obs;
  final RxDouble partnerRating = 4.5.obs;
  final RxString deliveryStatus = 'ON ITS WAY'.obs;

  // Order status timeline
  final RxList<Map<String, dynamic>> orderStatus = <Map<String, dynamic>>[
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
      'subtitle': 'Alex is 15 mins away from your location',
      'icon': Icons.local_shipping,
      'isActive': true,
    },
    {
      'title': 'Arrived at Destination',
      'subtitle': 'Expected by 12:45 PM',
      'icon': Icons.location_on,
      'isCompleted': false,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Get order data from navigation arguments
    orderData = Get.arguments ?? {};

    // Load tracking details
    loadTrackingDetails();
  }

  void loadTrackingDetails() {
    // Load real-time tracking information
    // This would typically fetch from API
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
