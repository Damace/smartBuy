import 'package:get/get.dart';
import 'buyer_saved_payment_controller.dart';

class BuyerSavedPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerSavedPaymentController>(
      () => BuyerSavedPaymentController(),
    );
  }
}
