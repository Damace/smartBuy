import 'package:get/get.dart';
import '../../core/utils/helpers.dart';
import '../../routes/app_pages.dart';

class VendorBankAccountDetailsController extends GetxController {
  // Bank account information
  final RxBool isVerified = true.obs;
  final RxString accountHolderName = 'John Doe'.obs;
  final RxString bankName = 'Global Tech Bank'.obs;
  final RxString accountNumber = '**** **** 5678'.obs;
  final RxString swiftCode = 'GTB0001234'.obs;

  void changeBankAccount() {
    Get.toNamed(Routes.VENDOR_EDIT_BANK_ACCOUNT_DETAILS);
  }

  String getAccountNumberMasked() {
    return accountNumber.value;
  }
}
