import 'package:get/get.dart';
import 'vendor_edit_product_controller.dart';

class VendorEditProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorEditProductController>(
      () => VendorEditProductController(),
    );
  }
}
