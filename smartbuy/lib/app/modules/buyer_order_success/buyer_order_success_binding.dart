import 'package:get/get.dart';
import 'buyer_order_success_controller.dart';

class BuyerOrderSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerOrderSuccessController>(
      () => BuyerOrderSuccessController(),
    );
  }
}
