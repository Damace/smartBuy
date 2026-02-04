import 'package:get/get.dart';
import 'vendor_home_controller.dart';

class VendorHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorHomeController>(
      () => VendorHomeController(),
    );
  }
}
