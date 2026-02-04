import 'package:get/get.dart';
import 'vendor_orders_controller.dart';

class VendorOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorOrdersController>(
      () => VendorOrdersController(),
    );
  }
}
