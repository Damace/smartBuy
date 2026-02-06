import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class BuyerOrderSuccessController extends GetxController {
  late String orderId;
  late double totalAmount;
  late Map<String, dynamic> deliveryAddress;
  late String estimatedDelivery;

  @override
  void onInit() {
    super.onInit();
    // Get arguments from navigation
    if (Get.arguments != null) {
      orderId = Get.arguments['orderId'] ?? '#00000';
      totalAmount = Get.arguments['totalAmount'] ?? 0.0;
      deliveryAddress = Get.arguments['deliveryAddress'] ?? {};
      estimatedDelivery = Get.arguments['estimatedDelivery'] ?? '';
    }
  }

  void trackOrder() {
    // Navigate to track order screen
    Get.offAllNamed(Routes.BUYER_TRACK_ORDER, arguments: {
      'orderId': orderId,
    });
  }

  void continueShopping() {
    // Navigate back to home
    Get.offAllNamed(Routes.HOME);
  }
}
