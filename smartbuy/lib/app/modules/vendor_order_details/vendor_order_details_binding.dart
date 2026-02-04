import 'package:get/get.dart';
import 'vendor_order_details_controller.dart';

class VendorOrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorOrderDetailsController>(
      () => VendorOrderDetailsController(),
    );
  }
}
