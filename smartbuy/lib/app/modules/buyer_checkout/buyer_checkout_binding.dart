import 'package:get/get.dart';
import 'buyer_checkout_controller.dart';

class BuyerCheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerCheckoutController>(
      () => BuyerCheckoutController(),
    );
  }
}
