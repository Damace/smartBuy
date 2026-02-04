import 'package:get/get.dart';
import 'buyer_orders_controller.dart';

class BuyerOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerOrdersController>(
      () => BuyerOrdersController(),
    );
  }
}
