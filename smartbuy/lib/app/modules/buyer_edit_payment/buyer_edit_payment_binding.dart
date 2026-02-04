import 'package:get/get.dart';
import 'buyer_edit_payment_controller.dart';

class BuyerEditPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerEditPaymentController>(
      () => BuyerEditPaymentController(),
    );
  }
}
