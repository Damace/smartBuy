import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class VendorBankAccountDetailsController extends GetxController {
  // Bank account information
  final RxBool isVerified = true.obs;
  final RxString accountHolderName = 'John Doe'.obs;
  final RxString bankName = 'Global Tech Bank'.obs;
  final RxString accountNumber = '**** **** 5678'.obs;
  final RxString swiftCode = 'GTB0001234'.obs;

  void changeBankAccount() {
    Helpers.showInfo('change_bank_account_info'.tr);
  }

  String getAccountNumberMasked() {
    return accountNumber.value;
  }
}
