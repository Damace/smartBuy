import 'package:get/get.dart';
import 'vendor_products_controller.dart';

class VendorProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorProductsController>(
      () => VendorProductsController(),
    );
  }
}
