import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';
import '../../routes/app_pages.dart';

class BuyerOrderSuccessController extends GetxController {

  final RxString orderId = ''.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxMap<String, dynamic> deliveryAddress = <String, dynamic>{}.obs;
  final RxString estimatedDelivery = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      orderId.value = Get.arguments['orderId'] ?? '#00000';
      totalAmount.value = Get.arguments['totalAmount'] ?? 0.0;
      deliveryAddress.value = Map<String, dynamic>.from(
        Get.arguments['deliveryAddress'] ?? {},
      );
      estimatedDelivery.value = Get.arguments['estimatedDelivery'] ?? '';
    }
  }

  void copyOrderId() {
    Clipboard.setData(ClipboardData(text: orderId.value));
    Helpers.showSuccess('order_id_copied'.tr);
  }

  void trackOrder() {
    Get.offAllNamed(Routes.BUYER_TRACK_ORDER, arguments: {
      'orderId': orderId.value,
    });
  }

  void continueShopping() {
    Get.offAllNamed(Routes.HOME);
  }
}
