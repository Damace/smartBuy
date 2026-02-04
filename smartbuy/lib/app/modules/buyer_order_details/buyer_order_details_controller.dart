import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class BuyerOrderDetailsController extends GetxController {
  late Map<String, dynamic> orderData;

  // Tracking status
  final RxList<Map<String, dynamic>> trackingStatus = <Map<String, dynamic>>[
    {
      'title': 'Ordered',
      'time': 'Oct 12, 10:30 AM',
      'isCompleted': true,
    },
    {
      'title': 'Shipped',
      'time': 'Oct 13, 5:15 PM',
      'isCompleted': true,
    },
    {
      'title': 'Out for Delivery',
      'time': 'Today, 08:00 AM',
      'isCompleted': false,
      'isActive': true,
    },
    {
      'title': 'Delivered',
      'time': 'Expected by 5:00 PM',
      'isCompleted': false,
    },
  ].obs;

  // Shipping address
  final RxString shippingName = 'Johnathan Doe'.obs;
  final RxString shippingAddress =
      '6391 Elgin St. Celina, Apt 401\nNew York, NY 10001\nUnited States'.obs;

  // Payment details
  final RxString paymentMethod = 'Visa ending in 4242'.obs;
  final RxString paymentDate = 'Due 02/26'.obs;

  @override
  void onInit() {
    super.onInit();
    // Get order data from navigation arguments
    orderData = Get.arguments ?? {};

    // Load order details
    loadOrderDetails();
  }

  void loadOrderDetails() {
    // Load detailed order information
    // This would typically fetch from API
  }

  void buyItAgain() {
    Get.snackbar(
      'buy_it_again'.tr,
      '${'adding_to_cart'.tr}: ${orderData['productName'] ?? ''}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void downloadInvoice() {
    Get.snackbar(
      'download_invoice'.tr,
      'downloading_invoice_for_order'.tr + ' ${orderData['id'] ?? ''}',
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
