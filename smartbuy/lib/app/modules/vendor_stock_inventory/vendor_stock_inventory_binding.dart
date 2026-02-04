import 'package:get/get.dart';
import 'vendor_stock_inventory_controller.dart';

class VendorStockInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorStockInventoryController>(
      () => VendorStockInventoryController(),
    );
  }
}
