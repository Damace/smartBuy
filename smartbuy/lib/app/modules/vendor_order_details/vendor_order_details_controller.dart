import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class VendorOrderDetailsController extends GetxController {
  final RxString orderStatus = 'processing'.obs;

  // Order data (passed from previous screen or fetched from API)
  late Map<String, dynamic> order;

  @override
  void onInit() {
    super.onInit();
    // Get order data from arguments
    order = Get.arguments ?? _getDefaultOrder();
    orderStatus.value = order['status'] ?? 'processing';
  }

  Map<String, dynamic> _getDefaultOrder() {
    return {
      'id': '#SB-10293',
      'date': 'Oct 26, 2023',
      'status': 'processing',
      'customer': {
        'name': 'Jane Doe',
        'badge': 'Top Buyer',
        'orderCount': 42,
        'shippingAddress': '123 Apple St, Cupertino, CA 95014',
        'phone': '+1(555) 012-3456',
        'avatar': '',
      },
      'items': [
        {
          'name': 'Wireless Noise-Canceling Headphones',
          'color': 'Space Gray',
          'size': 'One Size',
          'quantity': 2,
          'price': 299.00,
          'image': 'headphones',
        },
        {
          'name': 'Braided USB-C to USB-C Cable',
          'length': '2m',
          'material': 'Nylon',
          'quantity': 1,
          'price': 24.00,
          'image': 'cable',
        },
      ],
      'subtotal': 622.00,
      'shipping': 15.00,
      'shippingMethod': 'Express Delivery (2-day)',
    };
  }

  double get total => order['subtotal'] + order['shipping'];

  void updateOrderStatus() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'update_order_status'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...[
              {'label': 'mark_as_packed'.tr, 'value': 'packed'},
              {'label': 'mark_as_shipped'.tr, 'value': 'shipped'},
              {'label': 'mark_as_delivered'.tr, 'value': 'delivered'},
              {'label': 'mark_as_completed'.tr, 'value': 'completed'},
            ].map((status) => ListTile(
                  title: Text(status['label']!),
                  trailing: orderStatus.value == status['value']
                      ? const Icon(Icons.check, color: Color(0xFFFF8C42))
                      : null,
                  onTap: () {
                    orderStatus.value = status['value']!;
                    Get.back();
                    Helpers.showSuccess('order_status_updated'.tr);
                  },
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void messageCustomer() {
    Helpers.showSuccess('message_feature_coming_soon'.tr);
  }

  void printShippingLabel() {
    Helpers.showSuccess('printing_shipping_label'.tr);
  }

  void generateInvoice() {
    Helpers.showSuccess('generating_invoice'.tr);
  }

  void showMoreOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.print),
              title: Text('print_order'.tr),
              onTap: () {
                Get.back();
                printShippingLabel();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: Text('download_invoice'.tr),
              onTap: () {
                Get.back();
                generateInvoice();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: Text('cancel_order'.tr),
              onTap: () {
                Get.back();
                _showCancelOrderDialog();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCancelOrderDialog() {
    Get.defaultDialog(
      title: 'cancel_order'.tr,
      middleText: 'cancel_order_confirmation'.tr,
      textConfirm: 'yes_cancel'.tr,
      textCancel: 'no_keep'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        Get.back();
        Helpers.showSuccess('order_cancelled'.tr);
      },
    );
  }
}
