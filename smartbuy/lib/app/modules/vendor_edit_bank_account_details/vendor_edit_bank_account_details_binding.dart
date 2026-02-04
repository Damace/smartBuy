import 'package:get/get.dart';
import 'vendor_edit_bank_account_details_controller.dart';

class VendorEditBankAccountDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorEditBankAccountDetailsController>(
      () => VendorEditBankAccountDetailsController(),
    );
  }
}
