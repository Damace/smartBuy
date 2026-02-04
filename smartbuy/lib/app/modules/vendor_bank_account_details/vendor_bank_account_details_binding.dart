import 'package:get/get.dart';
import 'vendor_bank_account_details_controller.dart';

class VendorBankAccountDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorBankAccountDetailsController>(
      () => VendorBankAccountDetailsController(),
    );
  }
}
