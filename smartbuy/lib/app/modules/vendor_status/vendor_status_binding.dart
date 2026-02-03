import 'package:get/get.dart';
import 'vendor_status_controller.dart';

class VendorStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorStatusController>(
      () => VendorStatusController(),
    );
  }
}
