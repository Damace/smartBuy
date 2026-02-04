import 'package:get/get.dart';
import 'vendor_store_preview_controller.dart';

class VendorStorePreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorStorePreviewController>(
      () => VendorStorePreviewController(),
    );
  }
}
