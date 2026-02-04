import 'package:get/get.dart';
import 'vendor_add_product_controller.dart';

class VendorAddProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorAddProductController>(
      () => VendorAddProductController(),
    );
  }
}
