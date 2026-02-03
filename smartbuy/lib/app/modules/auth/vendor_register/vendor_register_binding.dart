import 'package:get/get.dart';
import 'vendor_register_controller.dart';

class VendorRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorRegisterController>(() => VendorRegisterController());
  }
}
